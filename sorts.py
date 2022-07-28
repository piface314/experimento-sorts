from time import time

def quicksort(v):
    def sort(l, r):
        if r - l < 1:
            return
        m = (v[l] >> 1) + (v[r] >> 1)
        i, j = l, r
        while True:
            while i <= r and v[i] < m:
                i += 1
            while l <= j and v[j] > m:
                j -= 1
            if i > j:
                break
            v[i], v[j] = v[j], v[i]
            i += 1
            j -= 1
        sort(l, j)
        sort(i, r)
    sort(0, len(v)-1)

def heapsort(v):
    n = len(v)
    aux = None
    i = n // 2
    while True:
        if i > 0:
            i -= 1
            aux = v[i]
        else:
            n -= 1
            if n <= 0:
                break
            aux = v[n]
            v[n] = v[0]
        parent, child = i, i*2 + 1
        while child < n:
            if child+1 < n and v[child+1] > v[child]:
                child += 1
            if v[child] > aux:
                v[parent] = v[child]
                parent = child
                child = parent*2 + 1
            else:
                break
        v[parent] = aux


def radixsort_lsd(v):
    base = 10
    b = [0 for _ in v]
    m = max(v)
    exp = 1
    n = len(v)
    
    while m//exp > 0:
        bucket = [0 for _ in range(base)]
        for x in v:
            bucket[(x // exp) % base] += 1
        for i in range(1, base):
            bucket[i] += bucket[i-1]
        for i in range(n-1, -1, -1):
            j = (v[i] // exp) % base
            bucket[j] -= 1
            b[bucket[j]] = v[i]
        for i, x in enumerate(b):
            v[i] = x
        exp *= base

def radixsort_msd(v):
    def sort(b, l, r):
        if r - l < 1 or b < 0:
            return
        i, j = l, r
        while True:
            while i <= r and ((v[i] >> b) & 1) == 0:
                i += 1
            while l <= j and((v[j] >> b) & 1) == 1:
                j -= 1
            if i > j:
                break
            v[i], v[j] = v[j], v[i]
            i += 1
            j -= 1
        sort(b-1, l, j)
        sort(b-1, i, r)
    m = max(v)
    b = m.bit_length()
    sort(b-1, 0, len(v)-1)

if __name__ == "__main__":
    n = 100
    size = 10000
    with open('vectors', 'rb') as f:
        vs = [[int.from_bytes(f.read(4), 'little') for _ in range(size)]
            for _ in range(n)]
    algs = [("quick", quicksort), ("heap", heapsort), ("radixlsd", radixsort_lsd), ("radixmsd", radixsort_msd)]
    print("algorithm,language,sample,time")
    for alg, sort in algs:
        for i, v in enumerate(vs):
            t0 = time()
            sort(v)
            tf = time()
            print(f'{alg},python,{i},{tf-t0}')