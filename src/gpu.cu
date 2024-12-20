#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/sort.h>
#include <thrust/transform_reduce.h>
#include <stdgpu/unordered_map.cuh>
#include <cuda_runtime.h>
#include "main.cuh"


__global__ void gpu_storage_update(stdgpu::unordered_map<int, int> state_map, int size) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < size) {
        state_map.emplace(idx, idx * 2);
    }
}

struct int_pair_plus
{
    STDGPU_HOST_DEVICE stdgpu::pair<ull, ull>
    operator()(const stdgpu::pair<ull, ull>& lhs, const stdgpu::pair<ull, ull>& rhs) const
    {
        return { lhs.first + rhs.first, lhs.second + rhs.second };
    }
};

int test_gpu() {
    const int size = 1'000'000;

    // GPU unordered map
    stdgpu::unordered_map<int, int> state_map = stdgpu::unordered_map<int, int>::createDeviceObject(size);

    // GPU timing
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);
    gpu_storage_update<<<(size + 255) / 256, 256>>>(state_map, size);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float elapsedTime;
    cudaEventElapsedTime(&elapsedTime, start, stop);
    std::cout << "GPU Execution Time: " << elapsedTime << " ms\n";

      // Verify results using thrust
    // Create device vectors to store keys and values
    thrust::device_vector<int> d_keys(size);
    thrust::device_vector<int> d_values(size);


    auto range_map = state_map.device_range();
    stdgpu::pair<ull, ull> sum =
            thrust::reduce(range_map.begin(), range_map.end(), stdgpu::pair<ull, ull>(0, 0), int_pair_plus());

    assert(999999000000 == sum.second);

    return 0;
}
