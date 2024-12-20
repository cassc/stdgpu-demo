# required cmake version
cmake_minimum_required(VERSION 3.12)
project(stdgpu-demo LANGUAGES CXX CUDA)

# cpp version
set(CMAKE_CXX_STANDARD 20)

# enable cuda
enable_language(CUDA)
set(CMAKE_CUDA_ARCHITECTURES 75 80 86)

# specify the stdgpu path
set(STDGPU_PATH "/opt/stdgpu/bin" CACHE PATH "Path to the stdgpu library")
set(STDGPU_INCLUDE_DIR ${STDGPU_PATH}/include)
set(STDGPU_LIB_DIR ${STDGPU_PATH}/lib)

if (NOT EXISTS ${STDGPU_INCLUDE_DIR})
    message(FATAL_ERROR "STDGPU include directory not found at ${STDGPU_INCLUDE_DIR}")
endif()

if (NOT EXISTS ${STDGPU_LIB_DIR})
    message(FATAL_ERROR "STDGPU library directory not found at ${STDGPU_LIB_DIR}")
endif()

include_directories(${STDGPU_INCLUDE_DIR})
add_library(stdgpu STATIC IMPORTED)
set_target_properties(stdgpu PROPERTIES IMPORTED_LOCATION ${STDGPU_LIB_DIR}/libstdgpu.a)

add_executable(stdgpu-demo src/main.cu src/cpu.cu src/gpu.cu)
target_link_directories(stdgpu-demo PRIVATE ${STDGPU_LIB_DIR})
target_link_libraries(stdgpu-demo PRIVATE stdgpu)
