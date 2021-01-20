#include <stdio.h>
#include <stdlib.h>
#include "mandel.h"
#include "writepng.h"
#include <omp.h>



int
main(int argc, char *argv[]) {

    int   width, height;
    int	  max_iter;
    int   *image;

    width    = 2601;
    height   = 2601;
    max_iter = 400;

    //    dim3 image= dim3(width, height);
    // command line argument sets the dimensions of the image
    if ( argc == 2 ) width = height = atoi(argv[1]);

    
    //    image = (int *)malloc( width * height * sizeof(int));
    cudaMalloc((void**)&image, width*height);
    if ( image == NULL ) {
       fprintf(stderr, "memory allocation failed!\n");
       return(1);
    }

    mandel<<<1,1>>>(width, height, image, max_iter);

    writepng<<1,1>>("mandelbrot.png", image, width, height);

    return(0);
}