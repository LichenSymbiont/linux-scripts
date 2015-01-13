RM    = rm -f
SHELL = /bin/sh

CXXFLAGS= -O2 -Os
CXX=g++	#gcc, tcc, etc

#Simple listing of things to be included: (why do people write more complex makefiles!?)
INCS= -I.
LIB= 

SRCS= $(wildcard *.cxx)

OBJS= $(subst .cxx,.o,$(SRCS) )
OUT= $(subst .o,,$(OBJS) )

%.o: %.cxx
	$(CXX) $(CXXFLAGS) -c $< $(INCZ) -o $@

%: %.o
	@echo "*** Compiling $<..."
	$(CXX) $(CXXFLAGS) -Wall $< -o $@ $(LIB)

build: $(OUT)
	@echo "*** All done! Good luck! ***"


clean:
	@$(RM) *.o
