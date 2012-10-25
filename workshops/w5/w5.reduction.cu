// Dot Product - Workshop 5
// w5.reduction.cu

#include <iostream>
#include <cstdlib>
#include <ctime>
// CUDA header file
#include <cuda_runtime.h>
#include "cuPrintf.cu"
using namespace std;

void init(float*, int);

// CUDA kernel code
__global__ void dotProduct (float* da, float* db, float* dc) {
  // cuPrintf("__global__ dotProduct\n");
  int tid = threadIdx.x;
  dc[tid] = da[tid] * db[tid];

  __syncthreads();
  for (int stride = 1; stride < blockDim.x; stride *= 2) {
    // cuPrintf("########## stride %d ##########\n", stride);
    if (tid % (2 * stride) == 0 && tid + stride < blockDim.x) {
      dc[tid] += dc[tid + stride];
      // cuPrintf("dc[%d] += dc[%d] = %f\n", tid, tid + stride, dc[tid + stride]);
     }
    __syncthreads();
  }
}

int main(int argc, char** argv) {
  // interpret command-line arguments
  if (argc != 2) {
    cerr << "**invalid number of arguments**" << endl;
    return 1;
  }
  int n = atoi(argv[1]);
  srand((unsigned)time(NULL));

  // host vectors
  float* ha = new float[n];
  float* hb = new float[n];
  float* hc = new float[1];
  init(ha, n);
  init(hb, n);

  // device vectors (da[n], db[n], dc[n])
  float* da;
  float* db;
  float* dc;

  cudaMalloc((void**)&da, n * sizeof(float));
  cudaMalloc((void**)&db, n * sizeof(float));
  cudaMalloc((void**)&dc, n * sizeof(float));

  // copy from the host to the device ha -> da, hb -> db
  cudaMemcpy(da, ha, n * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(db, hb, n * sizeof(float), cudaMemcpyHostToDevice);

  cudaPrintfInit();

  // calculate the dot product on the device
  dotProduct<<<1, n>>>(da, db, dc);

  cudaPrintfDisplay(stdout, true);
  cudaPrintfEnd();

  // copy the result from the device to the host dc -> hc
  cudaMemcpy(hc, dc, n * sizeof(float), cudaMemcpyDeviceToHost);

  float dx = hc[0];
  // dot product on the host
  float hx = 0;
  for (int i = 0; i < n; i++) {
    hx += ha[i] * hb[i];
  }

  // compare the results
  cout << "Device = " << dx << " Host = " << hx << endl;

  // free device memory

  cudaFree(da);
  cudaFree(db);
  cudaFree(dc);

  // free host memory
  delete [] ha;
  delete [] hb;
  delete [] hc;


  return 0;
}

void init(float* a, int n) {
  float f = 1.0f / RAND_MAX;
  for (int i = 0; i < n; i++) {
    a[i] = ::rand() * f; // [0.0f 1.0f]
    // a[i] = 2; // [0.0f 1.0f]

  }
}