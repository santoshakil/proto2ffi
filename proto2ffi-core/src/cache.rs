use std::collections::HashMap;
use std::sync::{Arc, RwLock};
use std::time::{Duration, Instant};

pub struct Cache<K, V> {
    store: Arc<RwLock<HashMap<K, CacheEntry<V>>>>,
    ttl: Duration,
    max_size: usize,
}

struct CacheEntry<V> {
    value: V,
    expires_at: Instant,
    access_count: usize,
    last_access: Instant,
}

impl<K, V> Cache<K, V>
where
    K: Eq + std::hash::Hash + Clone,
    V: Clone,
{
    pub fn new(ttl: Duration, max_size: usize) -> Self {
        Self {
            store: Arc::new(RwLock::new(HashMap::new())),
            ttl,
            max_size,
        }
    }

    pub fn get(&self, key: &K) -> Option<V> {
        let mut store = self.store.write().ok()?;

        if let Some(entry) = store.get_mut(key) {
            if entry.expires_at > Instant::now() {
                entry.access_count += 1;
                entry.last_access = Instant::now();
                return Some(entry.value.clone());
            } else {
                store.remove(key);
            }
        }

        None
    }

    pub fn insert(&self, key: K, value: V) -> bool {
        let mut store = match self.store.write() {
            Ok(guard) => guard,
            Err(_) => return false,
        };

        if store.len() >= self.max_size {
            self.evict_lru(&mut store);
        }

        let entry = CacheEntry {
            value,
            expires_at: Instant::now() + self.ttl,
            access_count: 0,
            last_access: Instant::now(),
        };

        store.insert(key, entry);
        true
    }

    pub fn remove(&self, key: &K) -> Option<V> {
        self.store.write().ok()?.remove(key).map(|e| e.value)
    }

    pub fn clear(&self) {
        if let Ok(mut store) = self.store.write() {
            store.clear();
        }
    }

    pub fn size(&self) -> usize {
        self.store.read().map(|s| s.len()).unwrap_or(0)
    }

    pub fn cleanup_expired(&self) -> usize {
        let mut store = match self.store.write() {
            Ok(guard) => guard,
            Err(_) => return 0,
        };

        let now = Instant::now();
        let before = store.len();

        store.retain(|_, entry| entry.expires_at > now);

        before - store.len()
    }

    fn evict_lru(&self, store: &mut HashMap<K, CacheEntry<V>>) {
        if let Some(lru_key) = store
            .iter()
            .min_by_key(|(_, entry)| (entry.access_count, entry.last_access))
            .map(|(k, _)| k.clone())
        {
            store.remove(&lru_key);
        }
    }

    pub fn stats(&self) -> CacheStats {
        let store = match self.store.read() {
            Ok(guard) => guard,
            Err(_) => return CacheStats::default(),
        };

        let now = Instant::now();
        let mut expired = 0;
        let mut total_accesses = 0;

        for entry in store.values() {
            if entry.expires_at <= now {
                expired += 1;
            }
            total_accesses += entry.access_count;
        }

        CacheStats {
            size: store.len(),
            expired,
            avg_access_count: if store.is_empty() {
                0.0
            } else {
                total_accesses as f64 / store.len() as f64
            },
        }
    }
}

impl<K, V> Clone for Cache<K, V> {
    fn clone(&self) -> Self {
        Self {
            store: Arc::clone(&self.store),
            ttl: self.ttl,
            max_size: self.max_size,
        }
    }
}

#[derive(Debug, Clone, Default)]
pub struct CacheStats {
    pub size: usize,
    pub expired: usize,
    pub avg_access_count: f64,
}

pub struct LruCache<K, V> {
    map: HashMap<K, (V, usize)>,
    access_order: Vec<K>,
    max_size: usize,
    generation: usize,
}

impl<K, V> LruCache<K, V>
where
    K: Eq + std::hash::Hash + Clone,
{
    pub fn new(max_size: usize) -> Self {
        Self {
            map: HashMap::new(),
            access_order: Vec::new(),
            max_size,
            generation: 0,
        }
    }

    pub fn get(&mut self, key: &K) -> Option<&V> {
        if let Some((value, gen)) = self.map.get_mut(key) {
            self.generation += 1;
            *gen = self.generation;
            Some(value)
        } else {
            None
        }
    }

    pub fn insert(&mut self, key: K, value: V) {
        if self.map.len() >= self.max_size && !self.map.contains_key(&key) {
            self.evict_lru();
        }

        self.generation += 1;
        self.map.insert(key, (value, self.generation));
    }

    pub fn remove(&mut self, key: &K) -> Option<V> {
        self.map.remove(key).map(|(v, _)| v)
    }

    pub fn clear(&mut self) {
        self.map.clear();
        self.access_order.clear();
        self.generation = 0;
    }

    pub fn len(&self) -> usize {
        self.map.len()
    }

    pub fn is_empty(&self) -> bool {
        self.map.is_empty()
    }

    fn evict_lru(&mut self) {
        if let Some((lru_key, _)) = self.map.iter().min_by_key(|(_, (_, gen))| gen) {
            let lru_key = lru_key.clone();
            self.map.remove(&lru_key);
        }
    }
}
