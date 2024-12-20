#include <unordered_map>
#include <iostream>
#include <chrono>
#include "main.cuh"

void cpu_storage_update(std::unordered_map<int, int>& state_map, int size) {
    for (int i = 0; i < size; ++i) {
        state_map[i] = i * 2;
    }
}

int test_cpu() {
    std::unordered_map<int, int> state_map;
    const int size = 1'000'000;

    auto start = std::chrono::high_resolution_clock::now();
    cpu_storage_update(state_map, size);
    auto end = std::chrono::high_resolution_clock::now();

    std::cout << "CPU Execution Time: "
              << std::chrono::duration<double, std::milli>(end - start).count()
              << " ms\n";

    return 0;
}
