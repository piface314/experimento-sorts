local function printv(v)
    for i, x in ipairs(v) do
        io.write(x, " ")
    end
    print()
end

local function quicksort(v)
    local function sort(l, r)
        if r - l < 1 then
            return
        end
        local m = (v[l] >> 1) + (v[r] >> 1)
        local i, j = l, r
        while true do
            while i <= r and v[i] < m do
                i = i + 1
            end
            while l <= j and v[j] > m do
                j = j - 1
            end
            if i > j then
                break
            end
            v[i], v[j] = v[j], v[i]
            i = i + 1
            j = j - 1
        end
        sort(l, j)
        sort(i, r)
    end
    sort(1, #v)
end

local function heapsort(v)
    local n = #v
    local aux, parent, child
    local i = n // 2
    repeat
        if i > 0 then
            aux = v[i]
            parent, child = i, 2 * i
            i = i - 1
        else
            aux = v[n]
            v[n] = v[1]
            n = n - 1
            parent, child = 1, 2
        end
        while child <= n do
            if child+1 <= n and v[child+1] > v[child] then
                child = child + 1
            end
            if v[child] > aux then
                v[parent] = v[child]
                parent = child
                child = parent*2
            else
                break
            end
        end
        v[parent] = aux
    until n == 0
end

local function radixsort_lsd(v)
    local base = 10
    local b = {}
    local m = math.max(table.unpack(v))
    local exp = 1
    local n = #v
    local bucket = {}
    
    while m//exp > 0 do
        for i = 1, base do bucket[i] = 0 end
        for _, x in ipairs(v) do
            local i = (x // exp) % base + 1
            bucket[i] = bucket[i] + 1
        end
        for i = 2, base do
            bucket[i] = bucket[i] + bucket[i-1]
        end
        for i = n, 1, -1 do
            local j = (v[i] // exp) % base + 1
            bucket[j] = bucket[j] - 1
            b[bucket[j]+1] = v[i]
        end
        for i = 1, n do
            v[i] = b[i]
        end
        exp = exp * base
    end
end

local function radixsort_msd(v)
    local function sort(b, l, r)
        if r - l < 1 or b < 0 then
            return
        end
        local i, j = l, r
        while true do
            while i <= r and ((v[i] >> b) & 1) == 0 do
                i = i + 1
            end
            while l <= j and ((v[j] >> b) & 1) == 1 do
                j = j - 1
            end
            if i > j then
                break
            end
            v[i], v[j] = v[j], v[i]
            i = i + 1
            j = j - 1
        end
        sort(b-1, l, j)
        sort(b-1, i, r)
    end
    local m = math.max(table.unpack(v))
    local b = 1
    while m > 1 do
        b = b + 1
        m = m >> 1
    end
    sort(b-1, 1, #v)
end

local n = 100
local size = 10000
local f = io.open('vectors', 'rb')
if not f then return end
local vs = {}
for i = 1, n do
    vs[i] = {}
    for j = 1, size do
        local b0, b1, b2, b3 = f:read(4):byte(1,4)
        vs[i][j] = b0 + (b1 << 8) + (b2 << 16) + (b3 << 24)
    end
end
local algs = {"quick", "heap", "radixlsd", "radixmsd"}
local sorts = {quicksort, heapsort, radixsort_lsd, radixsort_msd}
print("algorithm,language,sample,time")
for a, sort in ipairs(sorts) do
    for i, v in ipairs(vs) do
        local t0 = os.clock()
        sort(vs[i])
        local tf = os.clock()
        print(("%s,lua,%d,%f"):format(algs[a], i-1, tf-t0))
    end
end