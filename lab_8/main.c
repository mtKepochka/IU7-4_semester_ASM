#include <stdio.h>
#include <sys/time.h>
#include <math.h>
#include <stdlib.h>

#define OK 0

#define REPEATS 10000

unsigned long long cur_ms_gettimeofday()
{
    struct timeval timeval;
    gettimeofday(&timeval, NULL);

    return (timeval.tv_sec * 1000000 + timeval.tv_usec);
}

double getCsumdouble(double a, double b)
{
    return a + b;
}

double getCmuldouble(double a, double b)
{
    return a * b;
}

double getAsumdouble(double a, double b)
{
    double res;
    __asm__(
    "fld %1\n"
    "fld %2\n"
    "faddp\n"
    "fstp %0"
    : "=m" (res)
    : "m" (a), "m" (b)
    );
    return res;
}

double getAmuldouble(double a, double b)
{
    double res;
    __asm__ (
    "fld %1\n"
    "fld %2\n"
    "fmulp\n"
    "fstp %0"
    : "=m" (res)
    : "m" (a), "m" (b)
    );
    return res;
}

float getCsumfloat(float a, float b)
{
    return a + b;
}

float getCmulfloat(float a, float b)
{
    return a * b;
}

float getAsumfloat(float a, float b)
{
    float res;
    __asm__(
    "fld %1\n"
    "fld %2\n"
    "faddp\n"
    "fstp %0"
    : "=m" (res)
    : "m" (a), "m" (b)
    );
    return res;
}

float getAmulfloat(float a, float b)
{
    float res;
    __asm__ (
    "fld %1\n"
    "fld %2\n"
    "fmulp\n"
    "fstp %0"
    : "=m" (res)
    : "m" (a), "m" (b)
    );
    return res;
}

double func(double x) {
  double res = 0;
  static const int seven = 7;

  asm(".intel_syntax noprefix  \n\t" // STACK:
      "fld %1                  \n\t" // x
      "fld %1                  \n\t" // x, x
      "fmulp                   \n\t" // x^2
      "fld %1                  \n\t" // x, x^2
      "fmulp                   \n\t" // x^3
      "fild %2                 \n\t" // 7, x^3
      "faddp                   \n\t" // 7 + x^3
      "fcos                    \n\t" // cos(x^3 + 7)
      "fstp %0                 \n\t" // записать в операнд значение из ST и
                                     // вытолкнуть это значение из стека
      : "=m"(res)         // на выход
      : "m"(x), "m"(seven) // на вход
      : "eax"             //
  );

  return res;
}

double func2(double x)
{
    return sin(x*x + 5 * x);
}

/*
double method_chord(double x_prev, double x_curr, double e)
{
    double x_next = 0;
    double tmp;

    do
    {
        tmp = x_next;
        x_next = x_curr - f(x_curr) * (x_prev - x_curr) / (f(x_prev) - f(x_curr));
        x_prev = x_curr;
        x_curr = tmp;
    } while (abs(x_next - x_curr) > e);

    return x_next;
}
*/

double find_root(double (*f)(double), double x_prev, double x_curr, size_t iterations) {
    double x_next = 0;
    double tmp;
    double eps = 0.001;

    do
    {
        tmp = x_next;
        double f_curr, f_prev;
        f_curr = f(x_curr);
        f_prev = f(x_prev);

        __asm__ (
        "fld %2\n"
        "fld %1\n"
        "fsubp\n"
        "fld %4\n"
        "fld %3\n"
        "fsubp\n"
        "fdivp\n"
        "fld %3\n"
        "fmulp\n"
        "fld %1\n"
        "fsubrp\n"
        "fstp %0"
        : "=m" (x_next)
        : "m" (x_curr), "m" (x_prev), "m" (f_curr), "m" (f_prev)
        );

        x_prev = x_curr;
        x_curr = tmp;
        iterations--;
    } while (fabs(x_next - x_curr) > eps && iterations > 0);

    return x_next;
}

int main(void)
{
    unsigned long long start_time = 0;
    unsigned long long end_time = 0;
    float a = 2.3e38;
    float b = 1.1e38;
    start_time = 0;
    end_time = 0;
    for (int i = 0; i < REPEATS; i++)
    {
        start_time += cur_ms_gettimeofday();
        getAsumfloat(a, b);
        end_time += cur_ms_gettimeofday();
    }
    printf("Asm float sum: %lf\n", (end_time - start_time) / (REPEATS * 1.0));

    start_time = 0;
    end_time = 0;
    for (int i = 0; i < REPEATS; i++)
    {
        start_time += cur_ms_gettimeofday();
        getCsumfloat(a, b);
        end_time += cur_ms_gettimeofday();
    }
    printf("C float sum: %lf\n", (end_time - start_time) / (REPEATS * 1.0));

    start_time = 0;
    end_time = 0;
    for (int i = 0; i < REPEATS; i++)
    {
        start_time += cur_ms_gettimeofday();
        getAsumdouble(a, b);
        end_time += cur_ms_gettimeofday();
    }
    printf("Asm double sum: %lf\n", (end_time - start_time) / (REPEATS * 1.0));

    start_time = 0;
    end_time = 0;
    for (int i = 0; i < REPEATS; i++)
    {
        start_time += cur_ms_gettimeofday();
        getCsumdouble(a, b);
        end_time += cur_ms_gettimeofday();
    }
    printf("C double sum: %lf\n", (end_time - start_time) / (REPEATS * 1.0));

    start_time = 0;
    end_time = 0;
    for (int i = 0; i < REPEATS; i++)
    {
        start_time += cur_ms_gettimeofday();
        getAmulfloat(a, b);
        end_time += cur_ms_gettimeofday();
    }
    printf("Asm float mul: %lf\n", (end_time - start_time) / (REPEATS * 1.0));

    start_time = 0;
    end_time = 0;
    for (int i = 0; i < REPEATS; i++)
    {
        start_time += cur_ms_gettimeofday();
        getCmulfloat(a, b);
        end_time += cur_ms_gettimeofday();
    }
    printf("C float mul: %lf\n", (end_time - start_time) / (REPEATS * 1.0));

    start_time = 0;
    end_time = 0;
    for (int i = 0; i < REPEATS; i++)
    {
        start_time += cur_ms_gettimeofday();
        getAmuldouble(a, b);
        end_time += cur_ms_gettimeofday();
    }
    printf("Asm double mul: %lf\n", (end_time - start_time) / (REPEATS * 1.0));

    start_time = 0;
    end_time = 0;
    for (int i = 0; i < REPEATS; i++)
    {
        start_time += cur_ms_gettimeofday();
        getCmuldouble(a, b);
        end_time += cur_ms_gettimeofday();
    }
    printf("C double mul: %lf\n", (end_time - start_time) / (REPEATS * 1.0));

    double fpuPi;

    __asm__(
        "fldpi\n"
        "fstp %0\n"
        : "=m" (fpuPi)
    );

    printf("Sin value PI: %lf %lf %lf\n", sin(3.14), sin(3.141596), sin(fpuPi));
    printf("Sin value PI/2: %.20lf %.20lf %.20lf\n", sin(3.14 / 2), sin(3.141596 / 2), sin(fpuPi / 2));

    //cos(x^3 + 7)
    //хорд

    double s, e;
    size_t iters;
    printf("input start x: ");
    scanf("%lf", &s);
    printf("input end x: ");
    scanf("%lf", &e);
    printf("input iteration count: ");
    scanf("%zu", &iters);

    double root = find_root(func, s, e, iters);
    printf("Root x: %lf\nRoot: %lf\n", root, func(root));


    return OK;
}