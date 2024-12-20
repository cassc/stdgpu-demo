# Benchmark stdgpu

## Build stdgpu


``` bash
git clone https://github.com/stotko/stdgpu
cd stdgpu
mkdir build
cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=bin
cmake --install build --config Release
```

## test unordered_map

``` bash
cmake -S . -B build -DSTDGPU_PATH={path-to-stotko-stdgpu/bin}
cmake --build build
./build/stdgpu-demo

CPU Execution Time: 216.336 ms
GPU Execution Time: 0.967936 ms
```

# Emacs configuration

In `.dir-locals.el`:

``` common-lisp
((nil . ((ccls-initialization-options
          .
          (:clang (:extraArgs ["-I{stotko-stdgpu-bin}/include" ;; UPDATE
                               "-I/opt/cuda/include" ;; UPDATE
                               ])))
         (eval . (setq flycheck-clang-include-path
                       '("{stotko-stdgpu-bin}/include"
                         "/opt/cuda/include"))))))
```
