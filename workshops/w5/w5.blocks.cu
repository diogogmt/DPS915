// Dot Product - Workshop 5
// w5.shared.cu

#include <iostream>
#include <cstdlib>
#include <ctime>
// CUDA header file
#include <cuda_runtime.h>
#include "cuPrintf.cu"
using namespace std;


#define imin(a, b) (a < b ? a : b)

void init(float*, int);

const int ntpb = 256; // number of threads per block

// CUDA kernel code
__global__ void dotProduct (float* da, float* db, float* dc, int n) {
  // cuPrintf("__global__ dotProduct\n");
  __shared__ float s_results[ntpb];
  int tid = threadIdx.x;
  int i = blockIdx.x * blockDim.x + tid;
  float temp = 0;
  if (i < n) {
    temp = da[i] * db[i];
  }
  s_results[tid] = temp;

  __syncthreads();
  for (int stride = 1; stride < blockDim.x; stride *= 2) {
    // cuPrintf("########## stride %d ##########\n", stride);
    if (tid % (2 * stride) == 0 && tid + stride < blockDim.x) {
      s_results[tid] += s_results[tid + stride];
      // cuPrintf("s_results[%d] += s_results[%d] = %f\n", tid, tid + stride, s_results[tid + stride]);
     }
    __syncthreads();
  }

  if (tid == 0) {
    // cuPrintf("s_results[0]: %f\n", s_results[0]);
    dc[blockIdx.x] = s_results[0];
    // cuPrintf("dc[%d]: %f\n", blockIdx.x, dc[blockIdx.x]);
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
  int nbpg = imin(32, (n + ntpb - 1) / ntpb);

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

  dim3 block(ntpb,1,1);
  dim3 grid(nbpg,1,1);

  cout << "number of blocks per grid: " << nbpg << endl;
  cout << "number of threads per block: " << ntpb << endl;

  // calculate the dot product on the device
  dotProduct<<<grid, block>>>(da, db, dc, n);

  cudaPrintfDisplay(stdout, true);
  cudaPrintfEnd();

  // copy the result from the device to the host dc -> hc
  cudaMemcpy(hc, dc, n * sizeof(float), cudaMemcpyDeviceToHost);

  float dx = 0;
  for (int i = 0; i < nbpg; i++) {
    dx += hc[i];
  }
  // dot product on the host
  float hx = 0;
  for (int i = 0; i < n; i++) {
    hx += ha[i] * hb[i];
  }

  // compare results
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
  }
}