
all: data.csv

data.csv: c.data.csv python.data.csv lua.data.csv
	./merge_data c.data.csv python.data.csv lua.data.csv

c.data.csv: sorts vectors
	./sorts > c.data.csv

lua.data.csv: sorts.lua vectors
	lua5.3 sorts.lua > lua.data.csv

python.data.csv: sorts.py vectors
	python3 sorts.py > python.data.csv

sorts: sorts.c
	gcc sorts.c -Wall -o sorts -g

vectors: gen_vectors
	./gen_vectors
