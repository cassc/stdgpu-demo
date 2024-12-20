# required cmake version
cmake_minimum_required(VERSION 3.12)
project(stdgpu-demo LANGUAGES CXX CUDA)

# cpp version
set(CMAKE_CXX_STANDARD 20)

# enable cuda
enable_language(CUDA)
set(CMAKE_CUDA_ARCHITECTURES 75 80 86)

# specify the stdgpu path
set(STDGPU_INCLUDE_DIR "/home/garfield/projects/stotko/stdgpu/bin/include")
set(STDGPU_LIB_DIR "/home/garfield/projects/stotko/stdgpu/bin/lib")

include_directories(${STDGPU_INCLUDE_DIR})
add_library(stdgpu STATIC IMPORTED)
set_target_properties(stdgpu PROPERTIES IMPORTED_LOCATION ${STDGPU_LIB_DIR}/libstdgpu.a)


add_executable(stdgpu-demo src/main.cu src/cpu.cu src/gpu.cu)
target_link_libraries(stdgpu-demo PUBLIC stdgpu)
