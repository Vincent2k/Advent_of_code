
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <iostream>
#include <iomanip>
#include <fstream>

#include <stdio.h>

cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size);
void doCudaComputation(int* input, int* output);
int doComputationOutput2(int input);

void readFile(int* input);

__global__ void addKernel(int *output, const int *input)
{
	int i = blockIdx.x * blockDim.x + threadIdx.x;

	int x = input[i] / 3;
	output[i] = x - 2;
}

int main()
{
	int* input = new int[100];
	int* output = new int[100];

	readFile(input);
	doCudaComputation(input, output);

	int sum = 0;

	for (int i = 0; i < 100; ++i) {
		sum += output[i];
	}

	int sum2 = 0;

	for (int i = 0; i < 100; ++i) {
		sum2 += doComputationOutput2(output[i]);
	}

	printf("Sum: %d\n", sum);
	printf("Sum2: %d\n", sum2);

    return 0;
}


int doComputationOutput2(int input) {
	int x = input / 3;

	if (x != 0 && x - 2 > 0) {
		return input + doComputationOutput2(x - 2);
	}
	else {
		return input;
	}
}


void readFile(int* input) {
	int mass = 0;
	int compt = 0;
	std::ifstream inFile;

	inFile.open("input.txt");

	while (inFile >> mass) {
		input[compt] = mass;
		compt++;
	}
}

void doCudaComputation(int *input, int *output) {
	int *dev_input = nullptr;
	int *dev_output = nullptr;
	cudaError_t cudaStatus;
	
	cudaSetDevice(0);

	cudaStatus = cudaMalloc((void**)&dev_input, 100 * sizeof(int));
	cudaStatus = cudaMalloc((void**)&dev_output, 100 * sizeof(int));


	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");

	}
	cudaMemcpy(dev_input, input, 100 * sizeof(int), cudaMemcpyHostToDevice);

	addKernel<<<1, 100>>>(dev_output, dev_input);
	cudaDeviceSynchronize();

	cudaMemcpy(output, dev_output, 100 * sizeof(int), cudaMemcpyDeviceToHost);

	cudaFree(dev_input);
	cudaFree(dev_output);
}

//// Helper function for using CUDA to add vectors in parallel.
//cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size)
//{
//    int *dev_a = 0;
//    int *dev_b = 0;
//    int *dev_c = 0;
//    cudaError_t cudaStatus;
//
//    // Choose which GPU to run on, change this on a multi-GPU system.
//    cudaStatus = cudaSetDevice(0);
//    if (cudaStatus != cudaSuccess) {
//        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
//        goto Error;
//    }
//
//    // Allocate GPU buffers for three vectors (two input, one output)    .
//    cudaStatus = cudaMalloc((void**)&dev_c, size * sizeof(int));
//    if (cudaStatus != cudaSuccess) {
//        fprintf(stderr, "cudaMalloc failed!");
//        goto Error;
//    }
//
//    cudaStatus = cudaMalloc((void**)&dev_a, size * sizeof(int));
//    if (cudaStatus != cudaSuccess) {
//        fprintf(stderr, "cudaMalloc failed!");
//        goto Error;
//    }
//
//    cudaStatus = cudaMalloc((void**)&dev_b, size * sizeof(int));
//    if (cudaStatus != cudaSuccess) {
//        fprintf(stderr, "cudaMalloc failed!");
//        goto Error;
//    }
//
//    // Copy input vectors from host memory to GPU buffers.
//    cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
//    if (cudaStatus != cudaSuccess) {
//        fprintf(stderr, "cudaMemcpy failed!");
//        goto Error;
//    }
//
//    cudaStatus = cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);
//    if (cudaStatus != cudaSuccess) {
//        fprintf(stderr, "cudaMemcpy failed!");
//        goto Error;
//    }
//
//    // Launch a kernel on the GPU with one thread for each element.
//    addKernel<<<1, size>>>(dev_c, dev_a, dev_b);
//
//    // Check for any errors launching the kernel
//    cudaStatus = cudaGetLastError();
//    if (cudaStatus != cudaSuccess) {
//        fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
//        goto Error;
//    }
//    
//    // cudaDeviceSynchronize waits for the kernel to finish, and returns
//    // any errors encountered during the launch.
//    cudaStatus = cudaDeviceSynchronize();
//    if (cudaStatus != cudaSuccess) {
//        fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
//        goto Error;
//    }
//
//    // Copy output vector from GPU buffer to host memory.
//    cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);
//    if (cudaStatus != cudaSuccess) {
//        fprintf(stderr, "cudaMemcpy failed!");
//        goto Error;
//    }
//
//Error:
//    cudaFree(dev_c);
//    cudaFree(dev_a);
//    cudaFree(dev_b);
//    
//    return cudaStatus;
//}
