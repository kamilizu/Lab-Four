#include <stdio.h>
#include <stdlib.h>

/* Declaration of the assembly function
 * Parameters:
 *   arr  -> passed in %rdi (pointer to integer array)
 *   n    -> passed in %rsi (number of elements)
 * Returns:
 *   sum  -> returned in %eax
 */
extern long sum_array(int *arr, long n);

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <datafile>\n", argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        fprintf(stderr, "Error: cannot open file '%s'\n", argv[1]);
        return 1;
    }

    /* First line contains the number of data points */
    int n;
    if (fscanf(fp, "%d", &n) != 1 || n <= 0) {
        fprintf(stderr, "Error: invalid data count in file\n");
        fclose(fp);
        return 1;
    }

    /* Allocate array and read each value */
    int *arr = (int *)malloc(n * sizeof(int));
    if (!arr) {
        fprintf(stderr, "Error: memory allocation failed\n");
        fclose(fp);
        return 1;
    }

    for (int i = 0; i < n; i++) {
        if (fscanf(fp, "%d", &arr[i]) != 1) {
            fprintf(stderr, "Error: expected %d values, only read %d\n", n, i);
            free(arr);
            fclose(fp);
            return 1;
        }
    }
    fclose(fp);

    /* Call assembly function: array ptr in %rdi, count in %rsi */
    long result = sum_array(arr, (long)n);

    printf("Sum of %d integers: %ld\n", n, result);

    free(arr);
    return 0;
}
