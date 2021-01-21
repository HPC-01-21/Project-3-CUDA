extern "C"
{

#include <stdio.h>

#define BLOCK_SIZE 16

__global__ 
void
matmultgpu3_colwise(int m, int n, int k, double *A, double *B, double *C) {
    // Bad one
 double Cvalue1 = 0.0, 
        Cvalue2 = 0.0;

  int col = 2*(blockIdx.x*blockDim.x+threadIdx.x);
  int row=blockIdx.y*blockDim.y+threadIdx.y;
  
  int e;

  if ((row < m) && (col < (n - 1))) {
    for(e=0;e<k;++e) {
        Cvalue1 += A[row*k+e]*B[e*n+col];
        Cvalue2 += A[row*k+e]*B[e*n+col+1];
    }
        
    C[row*n+col]=Cvalue1;
    C[row*n+col+1]=Cvalue2;
  }

  else if ((row < m) && (col == (n - 1))) {
    for(e=0;e<k;++e)
        Cvalue1+=A[row*k+e]*B[e*n+col];
        
        C[row*n+col]=Cvalue1;
  }
	
}

__global__ 
void
matmultgpu3_rowwise(int m, int n, int k, double *A, double *B, double *C) {
    // This is the good one!!!
    	
 double Cvalue1 = 0.0, 
        Cvalue2 = 0.0;

  int col = blockIdx.x*blockDim.x+threadIdx.x;
  int row = 2*(blockIdx.y*blockDim.y+threadIdx.y);
  
  int e;

  if ((row < m-1) && (col < n)) {
    for(e=0;e<k;++e) {
        Cvalue1 += A[row*k+e]*B[e*n+col];
        Cvalue2 += A[(row+1)*k+e]*B[e*n+col];
    }
        
    C[row*n+col]=Cvalue1;
    C[(row+1)*n+col]=Cvalue2;
  }

  else if ((row == m -1) && (col < n)) {
    for(e=0;e<k;++e)
        Cvalue1+=A[row*k+e]*B[e*n+col];
        
        C[row*n+col]=Cvalue1;
  }
	
}



void matmult_gpu3(int m, int n, int k, double *A, double *B, double *C){

  double *d_A, *d_B, *d_C;

  int blocky;
  int sizeA = m * k *sizeof(double);
  int sizeB = k * n *sizeof(double);
  int sizeC = m * n *sizeof(double);

  // Allocate memory on the device
  cudaMalloc((void**)&d_A, sizeA);
  cudaMalloc((void**)&d_B, sizeB);
  cudaMalloc((void**)&d_C, sizeC);

  // Copy the values over
  cudaMemcpy(d_A, A, sizeA, cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, B, sizeB, cudaMemcpyHostToDevice);

  // Declare the number of threads
  dim3 numOfThreadsPerBlock;
  numOfThreadsPerBlock.x = BLOCK_SIZE;
  numOfThreadsPerBlock.y = BLOCK_SIZE;


  // Initializing for colwise
//   blocky = (n+numOfThreadsPerBlock.x-1)/(numOfThreadsPerBlock.x);
//   dim3 numOfBlocks;
//     numOfBlocks.x = (blocky+1)/2;
//   numOfBlocks.y = (m+numOfThreadsPerBlock.y-1)/(numOfThreadsPerBlock.y);

  // Initializing for rowwise
  blocky = (m+numOfThreadsPerBlock.y-1)/(numOfThreadsPerBlock.y);
  dim3 numOfBlocks;
    numOfBlocks.x = (n+numOfThreadsPerBlock.x-1)/(numOfThreadsPerBlock.x);
  numOfBlocks.y = (blocky+1)/2;

  matmultgpu3_rowwise<<<numOfBlocks, numOfThreadsPerBlock>>>(m, n, k, d_A, d_B, d_C);
  cudaDeviceSynchronize();

  cudaMemcpy(C, d_C, sizeC, cudaMemcpyDeviceToHost);

  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);
}
}