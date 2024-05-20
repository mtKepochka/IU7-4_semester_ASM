#include <iostream>
#include <emmintrin.h>

using namespace std;

double mul_sse(double *sa, double *sb, int n)
{
    double tmp = 0;
	double res = 0;

    __float128 *a = (__float128 *)sa;
    __float128 *b = (__float128 *)sb;
    for (size_t i = 0; i < n; i += sizeof(__float128) / sizeof(double), a++, b++)
    {
		if (i + 1 == n)
		tmp = 0;
        __asm__(
            "movapd xmm0, %1\n"
            "movapd xmm1, %2\n"
            "mulpd xmm0, xmm1\n"
            "haddpd xmm0, xmm0\n"
            "movsd %0, xmm0\n"
            : "=m"(tmp)
            : "m"(*a), "m"(*b)
            : "xmm0", "xmm1");
        res += tmp;
		//cout << tmp << endl;
    }

    return res;
}

int main(void)
{
	int l, m, n;
	int l1, m1, n1;
	cout << "INPUT L: ";
	cin >> l;
	cout << "INPUT M: ";
	cin >> m;
	cout << "INPUT N: ";
	cin >> n;
	l1 = l;
	n1 = n;
	m1 = m;
	if (l % 2 != 0)
		l1 = l + 1;
	if (m % 2 != 0)
		m1 = m + 1;
	if (n % 2 != 0)
		n1 = n + 1;
	double a[l1][m1];
	double b[m1][n1];
	double b_transpose[n1][m1];
	double res[l1][n1];

	for (int i = 0; i < l1; i++)
		for (int j = 0; j < m1; j++)
			a[i][j] = 0;
	for (int i = 0; i < m1; i++)
		for (int j = 0; j < n1; j++)
			b[i][j] = 0;
	for (int i = 0; i < n1; i++)
		for (int j = 0; j < m1; j++)
			b_transpose[i][j] = 0;
	for (int i = 0; i < l1; i++)
		for (int j = 0; j < n1; j++)
			res[i][j] = 0;

	for (int i = 0; i < l; i++)
		for (int j = 0; j < m; j++)
			cin >> a[i][j];

	for (int i = 0; i < m; i++)
		for (int j = 0; j < n; j++)
			cin >> b[i][j];

	for (int i = 0; i < m; i++)
		for (int j = 0; j < n; j++)
			b_transpose[j][i] =  b[i][j];
	
	for (int i = 0; i < l; i++)
	{
		for (int j = 0; j < n; j++)
		{
			//cout << i << " " << j << endl;
			res[i][j] = mul_sse(a[i], b_transpose[j], m);
		}
	}
	cout << "ANSWER: \n";
	for (int i = 0; i < l; i++)
	{
		for (int j = 0; j < n; j++)
			cout << res[i][j] << " ";
		cout << endl;
	}

	return 0;
}