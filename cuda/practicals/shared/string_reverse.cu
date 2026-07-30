#include <cstdlib>
#include <cstdio>
#include <iostream>

#include "util.hpp"



// ======================================================
//              Start own code
// ======================================================

/**
 * @brief Kernel that reverses a string of length n in place
 * 
 */
__global__ void reverse_string(char* str, int n) {
    extern __shared__ char buffer[];

    int i = threadIdx.x + blockIdx.x * blockDim.x;

    if(i < n) {
        buffer[i] = str[i];

        __syncthreads();

        str[n - 1 - i] = buffer[i];
    }
}

// ======================================================
//              End own code
// ======================================================



int main(int argc, char** argv) {
    // check that the user has passed a string to reverse
    if(argc<2) {
        std::cout << "useage : ./string_reverse \"string to reverse\"\n" << std::endl;
        exit(0);
    }

    // determine the length of the string, and copy in to buffer
    auto n = strlen(argv[1]);
    auto string = malloc_managed<char>(n+1);
    std::copy(argv[1], argv[1]+n, string);
    string[n] = 0; // add null terminator

    std::cout << "string to reverse:\n" << string << "\n";

    // ======================================================
    //              Start own code
    // ======================================================

    int block_size = 32;
    int num_blocks = (n + block_size - 1) / block_size;

    reverse_string<<<num_blocks, block_size, n>>>(string, n);

    // ======================================================
    //              End own code
    // ======================================================

    // print reversed string
    cudaDeviceSynchronize();
    std::cout << "reversed string:\n" << string << "\n";

    // free memory
    cudaFree(string);

    return 0;
}

