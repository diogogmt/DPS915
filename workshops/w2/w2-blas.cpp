// Linear Algebra - Workshop 2
// w2.cpp
#include <iostream>
#include <iomanip>
#include <vector>
#include <cmath>
#include <ctime>
#include <cstdlib>
extern "C" {
#include <gsl/gsl_cblas.h>
}
using namespace std;
#define WIDTH 5

int main(int argc, char * * argv) {
  time_t ts, te;
  ts = time(nullptr);

  if (argc == 2) {
    int k, n = atoi(argv[1]);

    clock_t cb, ce;
    float randf = 1.0f / (float) RAND_MAX;

    float * v = new float[n];
    float * w = new float[n];

    float * r = new float[n];

    float * a = new float[n * n];
    float * b = new float[n * n];

    float * c = new float[n * n];

    srand(time(nullptr));

    // initialization
    cb = clock();
    k = 0;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        // a[k] = rand() * randf;
        // b[k] = rand() * randf;
        a[k] = 2;
        b[k] = 2;
        k++;
      }
      // v[i] = rand() * randf;
      // w[i] = rand() * randf;
      v[i] = 2;
      w[i] = 2;
    }
    ce = clock();
    cout << "initialization complete - took " << double(ce - cb) / CLOCKS_PER_SEC << " secs" << endl;
    cout << endl;

    // vector-vector - dot product of v and w


    cb = clock();
    // insert code to calculate dot product here
    float dotProduct = cblas_sdot(
    n, //const int N,
    v, //const float *X,
    0, //const int incX,
    w, //const float *Y,
    0 //const int incY
    );

    ce = clock();
    cout << "dotProduct: " << dotProduct << endl;
    cout << "vector-vector operation complete - took " << double(ce - cb) / CLOCKS_PER_SEC << " secs" << endl;
    cout << endl;

    // vector-matrix - product of v and a
    cb = clock();
    // insert code to calculate product here
    cblas_sgemv(
      CblasRowMajor, //const enum CBLAS_ORDER    order,
      CblasNoTrans, //const enum CBLAS_TRANSPOSE    TransA,
      n, //const int   M,
      n, //const int   N,
      1.0, //const float   alpha,
      a, //const float *   A,
      n, //const int   lda,
      v, //const float *   X,
      1, //const int   incX,
      1.0 ,//const float   beta,
      r, //float *   Y,
      1 //const int   incY   
    );   
    ce = clock();
    cout << "vector-matrix operation complete - took " << double(ce - cb) / CLOCKS_PER_SEC << " secs" << endl;

    k = 0;
    cout << setprecision(6) << fixed;
    cout << setw(5) << 1 << ':';
    for (int i = 0; i < n; i++) {
      cout << setw(10) << r[i] << ' ';
    }
    cout << endl;
    cout << endl;

    // matrix-matrix - product of a and b
    cb = clock();
    // insert code to calculate product here
    cblas_sgemm(
      CblasRowMajor, // const enum CBLAS_ORDER    Order,
      CblasNoTrans, // const enum CBLAS_TRANSPOSE    TransA,
      CblasNoTrans, // const enum CBLAS_TRANSPOSE    TransB,
      n, //const int   M,
      n ,//const int   N,
      n, //const int   K,
      1.0, //const float   alpha,
      a, //const float *   A,
      n, //const int   lda,
      b, //const float *   B,
      n, //const int   ldb,
      1.0, //const float   beta,
      c, //float *   C,
      n //const int   ldc  
    );
    ce = clock();
    cout << "matrix-matrix operation complete - took " << double(ce - cb) / CLOCKS_PER_SEC << " secs" << endl;

    k = 0;
    cout << setprecision(6) << fixed;
    for (int i = 0; i < n; i++) {
      cout << setw(5) << i + 1 << ':';
      for (int j = 0; j < n; j++) {
        cout << setw(10) << c[k++] << ' ';
        if (j % WIDTH == WIDTH - 1) cout << endl << setw(5) << i + 1 << ':';
      }
      cout << endl;
    }
    cout << endl;


    delete[] a;
    delete[] b;
    delete[] c;
    delete[] v;
    delete[] w;
    delete [] r;
  } else cout << "** dimension is missing **" << endl;

  // elapsed time
  te = time(nullptr);
  cout << setprecision(0);
  cout << "Elapsed time : " << difftime(te, ts) << endl;
}