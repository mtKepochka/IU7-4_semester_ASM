#include <stdio.h>

#define MAX_LEN 130

extern void __asm__strncpy(char *dst, char *src, int len);

int main() {
	char src[MAX_LEN] = "Test string for funny lab";
	char dst[MAX_LEN];

	int shift = 3;
    int len = 0;

	__asm__ __volatile__ (
		"lea %%rdi, [%1]\n\t"
		"mov %%ecx, 128\n\t"
		"xor %%eax, %%eax\n\t"
		"repne scasb\n\t"
		"mov %%eax, 128\n\t"
		"sub %%eax, %%ecx\n\t"
		"dec %%eax\n\t"
		"mov %0, %%eax\n\t"
		: "=r" (len)
		: "r" (src)
		: "ecx", "eax", "rdi"
	);

	printf("LEN: %d\n", len);
	printf("SRC BEFORE: %s\n", src);
	__asm__strncpy(src + shift, src, len);
	printf("SRC AFTER: %s\n", src);
	printf("DST AFTER: %s\n", src + shift);

	return 0;
}