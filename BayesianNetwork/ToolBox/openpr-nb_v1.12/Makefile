CXX ?= g++
CFLAGS = -Wall -Wconversion -O3 -fPIC

all: nb_learn nb_classify

nb_learn: nb_learn.cpp NB.o
	$(CXX) $(CFLAGS) nb_learn.cpp NB.o -o nb_learn -lm
nb_classify: nb_classify.cpp NB.o
	$(CXX) $(CFLAGS) nb_classify.cpp NB.o -o nb_classify -lm
clean:
	rm -f NB.o nb_learn nb_classify
