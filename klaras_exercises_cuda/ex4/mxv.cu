#include <stdio.h>

__global__ void mxv(int m, int n, double *a, double *b, double *c){
	printf("Have we at least entered the function?\n");
	int index,j;
	index = threadIdx.x + blockIdx.x*blockDim.x;
	double sum;
	sum = 0.0;
	if(index<m){
		for (j=0; j<n; j++){
		    sum += a[m*j + index]*b[j];
		}
	c[index] = sum;
	}
} 