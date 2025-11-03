use std::sync::{Arc, Mutex};
use std::thread;

pub fn parallel_map<T, U, F>(items: Vec<T>, num_threads: usize, f: F) -> Vec<U>
where
    T: Send + Clone + 'static,
    U: Send + std::fmt::Debug + 'static,
    F: Fn(T) -> U + Send + Sync + 'static,
{
    if items.is_empty() || num_threads == 0 {
        return Vec::new();
    }

    let chunk_size = (items.len() + num_threads - 1) / num_threads;
    let f = Arc::new(f);
    let results = Arc::new(Mutex::new(Vec::with_capacity(items.len())));

    let mut handles = Vec::new();

    for (_chunk_idx, chunk) in items.chunks(chunk_size).enumerate() {
        let chunk = chunk.to_vec();
        let f = Arc::clone(&f);
        let results = Arc::clone(&results);

        let handle = thread::spawn(move || {
            let mut local_results = Vec::with_capacity(chunk.len());
            for item in chunk {
                local_results.push(f(item));
            }
            let mut results = results.lock().unwrap();
            results.extend(local_results);
        });

        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    Arc::try_unwrap(results).unwrap().into_inner().unwrap()
}

pub fn parallel_for_each<T, F>(items: Vec<T>, num_threads: usize, f: F)
where
    T: Send + Clone + 'static,
    F: Fn(T) + Send + Sync + 'static,
{
    if items.is_empty() || num_threads == 0 {
        return;
    }

    let chunk_size = (items.len() + num_threads - 1) / num_threads;
    let f = Arc::new(f);
    let mut handles = Vec::new();

    for chunk in items.chunks(chunk_size) {
        let chunk = chunk.to_vec();
        let f = Arc::clone(&f);

        let handle = thread::spawn(move || {
            for item in chunk {
                f(item);
            }
        });

        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }
}

pub fn parallel_reduce<T, U, M, R>(
    items: Vec<T>,
    num_threads: usize,
    identity: U,
    map: M,
    reduce: R,
) -> U
where
    T: Send + Clone + 'static,
    U: Send + Clone + std::fmt::Debug + 'static,
    M: Fn(T) -> U + Send + Sync + 'static,
    R: Fn(U, U) -> U + Send + Sync + Clone + 'static,
{
    if items.is_empty() {
        return identity;
    }

    if num_threads == 0 || items.len() == 1 {
        return items.into_iter().map(map).fold(identity, reduce);
    }

    let chunk_size = (items.len() + num_threads - 1) / num_threads;
    let map = Arc::new(map);
    let reduce_fn = Arc::new(reduce.clone());
    let results = Arc::new(Mutex::new(Vec::new()));

    let mut handles = Vec::new();

    for chunk in items.chunks(chunk_size) {
        let chunk = chunk.to_vec();
        let map = Arc::clone(&map);
        let reduce_fn = Arc::clone(&reduce_fn);
        let results = Arc::clone(&results);
        let identity = identity.clone();

        let handle = thread::spawn(move || {
            let local_result = chunk
                .into_iter()
                .map(|item| map(item))
                .fold(identity, |acc, x| reduce_fn(acc, x));

            results.lock().unwrap().push(local_result);
        });

        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    let results = Arc::try_unwrap(results).unwrap().into_inner().unwrap();
    results.into_iter().fold(identity, reduce)
}

pub struct WorkQueue<T> {
    items: Arc<Mutex<Vec<T>>>,
}

impl<T> WorkQueue<T> {
    pub fn new(items: Vec<T>) -> Self {
        Self {
            items: Arc::new(Mutex::new(items)),
        }
    }

    pub fn pop(&self) -> Option<T> {
        self.items.lock().unwrap().pop()
    }

    pub fn push(&self, item: T) {
        self.items.lock().unwrap().push(item);
    }

    pub fn len(&self) -> usize {
        self.items.lock().unwrap().len()
    }

    pub fn is_empty(&self) -> bool {
        self.items.lock().unwrap().is_empty()
    }
}

impl<T> Clone for WorkQueue<T> {
    fn clone(&self) -> Self {
        Self {
            items: Arc::clone(&self.items),
        }
    }
}

pub fn parallel_work<T, F>(queue: WorkQueue<T>, num_threads: usize, worker: F)
where
    T: Send + 'static,
    F: Fn(T) + Send + Sync + 'static,
{
    if num_threads == 0 {
        return;
    }

    let worker = Arc::new(worker);
    let mut handles = Vec::new();

    for _ in 0..num_threads {
        let queue = queue.clone();
        let worker = Arc::clone(&worker);

        let handle = thread::spawn(move || {
            while let Some(item) = queue.pop() {
                worker(item);
            }
        });

        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }
}

pub fn parallel_filter<T, F>(items: Vec<T>, num_threads: usize, predicate: F) -> Vec<T>
where
    T: Send + Clone + std::fmt::Debug + 'static,
    F: Fn(&T) -> bool + Send + Sync + 'static,
{
    if items.is_empty() || num_threads == 0 {
        return Vec::new();
    }

    let chunk_size = (items.len() + num_threads - 1) / num_threads;
    let predicate = Arc::new(predicate);
    let results = Arc::new(Mutex::new(Vec::new()));

    let mut handles = Vec::new();

    for chunk in items.chunks(chunk_size) {
        let chunk = chunk.to_vec();
        let predicate = Arc::clone(&predicate);
        let results = Arc::clone(&results);

        let handle = thread::spawn(move || {
            let filtered: Vec<T> = chunk.into_iter().filter(|item| predicate(item)).collect();
            results.lock().unwrap().extend(filtered);
        });

        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    Arc::try_unwrap(results).unwrap().into_inner().unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parallel_map() {
        let items: Vec<i32> = (0..100).collect();
        let results = parallel_map(items, 4, |x| x * 2);
        assert_eq!(results.len(), 100);
    }

    #[test]
    fn test_parallel_reduce() {
        let items: Vec<i32> = (1..=100).collect();
        let sum = parallel_reduce(items, 4, 0, |x| x, |acc, x| acc + x);
        assert_eq!(sum, 5050);
    }

    #[test]
    fn test_parallel_filter() {
        let items: Vec<i32> = (0..100).collect();
        let evens = parallel_filter(items, 4, |&x| x % 2 == 0);
        assert_eq!(evens.len(), 50);
    }

    #[test]
    fn test_work_queue() {
        let queue = WorkQueue::new(vec![1, 2, 3, 4, 5]);
        assert_eq!(queue.len(), 5);
        assert_eq!(queue.pop(), Some(5));
        assert_eq!(queue.len(), 4);
    }
}
