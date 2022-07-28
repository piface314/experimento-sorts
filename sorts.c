#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

typedef unsigned int Key;


void swap(Key *v, int i, int j) {
    Key s = v[i];
    v[i] = v[j];
    v[j] = s;
}

void quicksort_r(Key *v, int l, int r) {
    if (r - l < 1)
        return;
    Key m = (v[l] >> 1) + (v[r] >> 1);
    int i = l, j = r;
    while (1) {
        while (i <= r && v[i] < m)
            ++i;
        while (l <= j && v[j] > m)
            --j;
        if (i > j)
            break;
        swap(v, i, j);
        ++i, --j;
    }
    quicksort_r(v, l, j);
    quicksort_r(v, i, r);
}

void quicksort(int n, Key *v) {
    quicksort_r(v, 0, n-1);
}

void heapsort(int n, Key *v) {
    Key aux;
    int i = n / 2, parent, child;
    while (1) {
        if (i > 0)
            aux = v[--i];
        else {
            n--;
            if (n <= 0)
                break;
            aux = v[n];
            v[n] = v[0];
        }
        parent = i, child = i*2 + 1;
        while (child < n) {
            if (child + 1 < n && v[child+1] > v[child])
                child++;
            if (v[child] > aux) {
                v[parent] = v[child];
                parent = child;
                child = parent*2 + 1;
            } else
                break;
        }
        v[parent] = aux;
    }
}

void radixsort_lsd(int n, Key *v) {
    Key *b;
    Key max = v[0];
    unsigned long long exp = 1;

    b = calloc(n, sizeof(Key));

    for (int i = 1; i < n; i++)
        if (v[i] > max)
            max = v[i];


    while (max/exp > 0) {
        Key bucket[10] = { 0 };
        for (int i = 0; i < n; i++)
            bucket[(v[i] / exp) % 10]++;
        for (int i = 1; i < 10; i++)
            bucket[i] += bucket[i - 1];
        for (int i = n - 1; i >= 0; i--)
            b[--bucket[(v[i] / exp) % 10]] = v[i];
        for (int i = 0; i < n; i++)
            v[i] = b[i];
        exp *= 10;
    }

    free(b);
}

void radixsort_msd_r(Key *v, int b, int l, int r) {
    if (r - l < 1 || b < 0)
        return;
    int i = l, j = r;
    while (1) {
        while (i <= r && ((v[i] >> b) & 1) == 0)
            ++i;
        while (l <= j && ((v[j] >> b) & 1) == 1)
            --j;
        if (i > j)
            break;
        swap(v, i, j);
        ++i, --j;
    }
    radixsort_msd_r(v, b-1, l, j);
    radixsort_msd_r(v, b-1, i, r);
}

void radixsort_msd(int n, Key *v) {
    Key max = v[0];
    int b = 1;
    for (int i = 1; i < n; i++)
        if (v[i] > max)
            max = v[i];
    while (max > 1)
        b++, max >>= 1;
    radixsort_msd_r(v, b-1, 0, n-1);
}

Key *read(const char *fp, int n, int size) {
    FILE *f = fopen(fp, "rb");
    Key *x = malloc(sizeof(Key) * n * size);
    fread(x, sizeof(Key), n * size, f);
    return x;
}

int main(int argc, char const *argv[]) {
    int n = 100, size = 10000;
    int total = n * size;
    Key *vs = read("vectors", 100, 10000);
    Key *vs_copy = malloc(sizeof(Key) * total);

    void (*sorts[4])(int, Key*) = {quicksort, heapsort, radixsort_lsd, radixsort_msd};
    char algs[4][20] = {"quick", "heap", "radixlsd", "radixmsd"};
    printf("algorithm,language,sample,time\n");
    for (int a = 0; a < 4; ++a) {
        void (*sort)(int, Key*) = sorts[a];
        memcpy(vs_copy, vs, sizeof(Key) * total);
        for (int i = 0; i < n; ++i) {
            clock_t start = clock();
            sort(size, vs_copy + (i * size));
            clock_t end = clock();
            double seconds = (double)(end - start) / CLOCKS_PER_SEC;
            printf("%s,c,%d,%lf\n", algs[a], i, seconds);
        }
    }
    return 0;
}
