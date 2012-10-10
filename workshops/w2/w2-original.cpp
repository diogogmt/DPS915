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
    int dotProduct = 0;

    clock_t cb, ce;
    float randf = 1.0f / (float) RAND_MAX;

    float * v = new float[n];
    float * w = new float[n];

    float * r = new float[n]; // result

    float * a = new float[n * n];
    float * b = new float[n * n];

    float * c = new float[n * n]; // result

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
        c[k] = 0;
        k++;
      }
      // v[i] = rand() * randf;
      // w[i] = rand() * randf;
      v[i] = 2;
      w[i] = 2;
      r[i] = 0;
    }
    ce = clock();
    cout << "initialization complete - took " << double(ce - cb) / CLOCKS_PER_SEC << " secs" << endl;
    cout << endl;

    // vector-vector - dot product of v and w
    cb = clock();
    // insert code to calculate dot product here
    for (int i = 0; i < n; i++) {
      dotProduct += w[i] * v[i];
    }

    cout << "dotProduct: " << dotProduct << endl;
    ce = clock();
    cout << "vector-vector operation complete - took " << double(ce - cb) / CLOCKS_PER_SEC << " secs" << endl;
    cout << endl;

    // vector-matrix - product of v and a
    cb = clock();
    // insert code to calculate product here

    for (int i = 0; i < n; i++) {
      float sum = 0.0f;
      for (int j = 0; j < n; j++) {
        // a[row number * number of rows + col number]
        sum += a[i * n + j] * v[j];
      }
      r[i] = sum;
    }

    // didn't work
    // for (int i,j = 0; i < n*n; i++) {
    //   r[j] += v[j] * a[i];
    //   !((i+1) % 2) ? j = 0 : j++;
    // }

    ce = clock();
    cout << "vector-matrix operation complete - took " << double(ce - cb) / CLOCKS_PER_SEC << " secs" << endl;

    k = 0;
    cout << setprecision(6) << fixed;
    cout << setw(5) << 1 << ':';
    for (int i = 0; i < n; i++) {
      cout << setw(10) << r[i] << ' ';
    }
    cout << endl << endl;

    // matrix-matrix - product of a and b
    cb = clock();
    // insert code to calculate product here
    
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        float sum = 0.0f;
        for (int k = 0; k < n; k++) {
          sum = sum + a[i * n + k] * b[k * n + j];
        }
        c[i * n + j] = sum;
      }
    }

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