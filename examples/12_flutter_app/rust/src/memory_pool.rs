use std::collections::VecDeque;

pub struct MemoryPool {
    blocks: VecDeque<Block>,
    block_size: usize,
    allocated_bytes: u64,
    total_capacity: usize,
}

struct Block {
    data: Vec<u8>,
    used: usize,
}

impl MemoryPool {
    pub fn new(block_size: usize, initial_blocks: usize) -> Self {
        let mut blocks = VecDeque::with_capacity(initial_blocks);
        for _ in 0..initial_blocks {
            blocks.push_back(Block {
                data: vec![0u8; block_size],
                used: 0,
            });
        }

        Self {
            blocks,
            block_size,
            allocated_bytes: 0,
            total_capacity: block_size * initial_blocks,
        }
    }

    pub fn allocate(&mut self, size: usize) -> Option<usize> {
        if size > self.block_size {
            self.allocated_bytes += size as u64;
            return Some(size);
        }

        for block in &mut self.blocks {
            if block.used + size <= block.data.len() {
                let offset = block.used;
                block.used += size;
                self.allocated_bytes += size as u64;
                return Some(offset);
            }
        }

        let new_block = Block {
            data: vec![0u8; self.block_size],
            used: size,
        };
        self.allocated_bytes += size as u64;
        self.total_capacity += self.block_size;
        let offset = 0;
        self.blocks.push_back(new_block);
        Some(offset)
    }

    pub fn deallocate(&mut self, size: usize) {
        self.allocated_bytes = self.allocated_bytes.saturating_sub(size as u64);
    }

    pub fn allocated(&self) -> u64 {
        self.allocated_bytes
    }

    pub fn compact(&mut self) {
        let min_blocks = 10;

        while self.blocks.len() > min_blocks {
            if let Some(block) = self.blocks.back() {
                if block.used == 0 {
                    self.blocks.pop_back();
                    self.total_capacity -= self.block_size;
                } else {
                    break;
                }
            } else {
                break;
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_allocation() {
        let mut pool = MemoryPool::new(1024, 10);
        assert!(pool.allocate(100).is_some());
        assert_eq!(pool.allocated(), 100);
    }

    #[test]
    fn test_deallocation() {
        let mut pool = MemoryPool::new(1024, 10);
        pool.allocate(100);
        pool.deallocate(50);
        assert_eq!(pool.allocated(), 50);
    }

    #[test]
    fn test_compact() {
        let mut pool = MemoryPool::new(1024, 100);
        pool.allocate(100);
        pool.compact();
        assert!(pool.blocks.len() >= 10);
    }
}
