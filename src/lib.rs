use wasm_bindgen::prelude::*;
use noise::{NoiseFn, Perlin};

// When the `wee_alloc` feature is enabled, use `wee_alloc` as the global
// allocator. This makes the WASM binary smaller.
#[cfg(feature = "wee_alloc")]
#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;

#[wasm_bindgen]
pub struct WorldGenerator {
    perlin: Perlin,
}

#[wasm_bindgen]
impl WorldGenerator {
    #[wasm_bindgen(constructor)]
    pub fn new(seed: u32) -> Self {
        // Initialize the Perlin noise generator with a specific seed
        Self {
            perlin: Perlin::new(seed),
        }
    }

    /// Generates a 1D array representing the 2D height map of a chunk.
    /// cx, cz: Chunk coordinates
    /// size: The width/depth of the chunk (usually 16)
    pub fn generate_chunk_heights(&self, cx: i32, cz: i32, size: i32) -> Vec<f32> {
        let mut heights = Vec::with_capacity((size * size) as usize);
        
        for z in 0..size {
            for x in 0..size {
                // Calculate world coordinates
                let wx = (cx * size + x) as f64;
                let wz = (cz * size + z) as f64;
                
                // Layered noise for more natural terrain
                let freq = 0.05;
                let d = self.perlin.get([wx * freq, wz * freq]) * 10.0;
                let d2 = self.perlin.get([wx * 0.2, wz * 0.2]) * 2.0;
                
                // Final height calculation (base height + noise)
                let h = 15.0 + d + d2;
                heights.push(h as f32);
            }
        }
        heights
    }
}