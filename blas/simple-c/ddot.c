#include <stdio.h>
#include <stdlib.h>
#ifdef USE_MKL
    #define USING_MKL   1
    #define USING_CBLAS 0
    #include <mkl.h>
#else
    #define USING_MKL   0
    #define USING_CBLAS 1
    #include <cblas.h>
#endif
int main()
{

   double a;
   double x[2] = { 2.0, 4.0 };
   double y[2] = { 0.25, 0.125 };

   a = cblas_ddot(2, x, 1, y, 1);

   printf("Using MKL:   %5s\n", USING_MKL ? "true " : "false");
   printf("Using CBLAS: %5s\n", USING_CBLAS ? "true " : "false");
   printf("dot product of [2.0 4.0] and [1/4 1/8]:\n%.2f\n", a);
   
   return 0;
}
