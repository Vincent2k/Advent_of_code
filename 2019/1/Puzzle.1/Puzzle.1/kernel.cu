
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

	cudaMalloc((void**)&dev_input, 100 * sizeof(int));
	cudaMalloc((void**)&dev_output, 100 * sizeof(int));

	cudaMemcpy(dev_input, input, 100 * sizeof(int), cudaMemcpyHostToDevice);

	addKernel<<<1, 100>>>(dev_output, dev_input);
	cudaDeviceSynchronize();

	cudaMemcpy(output, dev_output, 100 * sizeof(int), cudaMemcpyDeviceToHost);

	cudaFree(dev_input);
	cudaFree(dev_output);
}
