// Profile a Serial Application - Workshop 1
 // w1.cpp

 #include <iostream>
 #include <iomanip>
 #include <cstdlib>
 #include <ctime>

#define nullptr NULL

 using namespace std;

 void init(float** a, int n) {
     float f = 1.0f / RAND_MAX;
     for (int i = 0; i < n; i++)
         for (int j = 0; j < n; j++)
             a[i][j] = rand() * f;
 }

 void add(float** a, float** b, float** c, int n) {
     for (int i = 0; i < n; i++)
         for (int j = 0; j < n; j++)
             c[i][j] = a[i][j] + 3.0f * b[i][j];
 }

 void multiply(float** a, float** b, float** c, int n) {
     for (int i = 0; i < n; i++)
         for (int j = 0; j < n; j++) {
             float sum = 0.0f;
             for (int k = 0; k < n; k++)
                 sum += a[i][k] * b[k][j];
             c[i][j] = sum;
         }
 }

 int main(int argc, char* argv[]) {
     // start timing
     time_t ts, te;
     ts = time(nullptr);

     // interpret command-line arguments
     if (argc != 3) {
         cerr << "**invalid number of arguments**" << endl;
         return 1;
     }
     int n  = atoi(argv[1]);   // size of matrices
     int nr = atoi(argv[2]);   // number of runs

     float** a = new float*[n];
     for (int i = 0; i < n; i++)
        a[i] = new float[n];
     float** b = new float*[n];
     for (int i = 0; i < n; i++)
        b[i] = new float[n];
     float** c = new float*[n];
     for (int i = 0; i < n; i++)
        c[i] = new float[n];
     srand(time(nullptr));
     init(a, n);
     init(b, n);

     for (int i = 0; i < nr; i++) {
         add(a, b, c, n);
         multiply(a, b, c, n);
     }

     for (int i = 0; i < n; i++)
        delete [] a[i];
     delete [] a;
     for (int i = 0; i < n; i++)
        delete [] b[i];
     delete [] b;
     for (int i = 0; i < n; i++)
        delete [] c[i];
     delete [] c;

     // elapsed time
     te = time(nullptr);
     cout << setprecision(0);
     cout << "Elapsed time : " << difftime(te, ts) << endl;
 }
