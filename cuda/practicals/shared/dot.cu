#include <iostream>

#include <cuda.h>

#include "util.hpp"

// host implementation of dot product
double dot_host(const double *x, const double* y, int n) {
    double sum = 0;
    for(auto i=0; i<n; ++i) {
        sum += x[i]*y[i];
    }
    return sum;
}



// ======================================================
//              Start own code
// ======================================================

/**
 * @brief Compute ceil(log2(x))
 * 
 */
__device__ __forceinline__ int ilog2(unsigned int x) {
    return (x <= 1) ? 0 : 32 - __clz(x - 1);
}

/**
 * @brief Dot product kernel
 * 
 */
template <int THREADS> __global__ void dot_gpu_kernel(
    const double *x, const double* y, double *result, int n
) {
    __shared__ double buffer[1024];

    // Compute idx
    int i = threadIdx.x + blockIdx.x * blockDim.x;

    // Compute products
    if(i < n) {
        buffer[i] = x[i] * y[i];
    } else {
        buffer[i] = 0;
    }

    // Wait for entire buffer to be written
    __syncthreads();

    // Compute the sum
    int log_n = ilog2(n);
    int iters = log_n - ilog2(i + 1);

    for(int j = 0; j < log_n; j++) {
        if(j < iters) {
            buffer[i] += buffer[i + (1 << (log_n - j - 1))];
        }

        __syncthreads();
    }

    // Thread zero writes the result
    if(i == 0) {
        *result = buffer[0];
    }
}

// ======================================================
//              End own code
// ======================================================



double dot_gpu(const double *x, const double* y, int n) {
    static double* result = malloc_managed<double>(1);

    // ======================================================
    //              Start own code
    // ======================================================

    // TODO call dot product kernel
    constexpr int block_size = 1024;
    int num_blocks = (n + block_size - 1) / block_size;

    dot_gpu_kernel<block_size><<<num_blocks, block_size>>>(x, y, result, n);

    // ======================================================
    //              End own code
    // ======================================================

    cudaDeviceSynchronize();
    return *result;
}

int main(int argc, char** argv) {
    size_t pow = read_arg(argc, argv, 1, 4);
    size_t n = (1 << pow);

    auto size_in_bytes = n * sizeof(double);

    std::cout << "dot product CUDA of length n = " << n
              << " : " << size_in_bytes*1e-9 << "MB\n";

    auto x_h = malloc_host<double>(n, 2.);
    auto y_h = malloc_host<double>(n);
    for(auto i=0; i<n; ++i) {
        y_h[i] = rand()%10;
    }

    auto x_d = malloc_device<double>(n);
    auto y_d = malloc_device<double>(n);

    // copy initial conditions to device
    copy_to_device<double>(x_h, x_d, n);
    copy_to_device<double>(y_h, y_d, n);

    auto result   = dot_gpu(x_d, y_d, n);
    auto expected = dot_host(x_h, y_h, n);
    printf("expected %f got %f\n", (float)expected, (float)result);

    return 0;
}

