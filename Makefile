#                __
#               / _)
#      _.----._/ /      dc0x13
#     /         /       part of `bf864` project.
#  __/ (  | (  |        Mar 10 2025
# /__.-'|_|--|_|

objs = main.o error.o fprintf.o interpreter.o
exec = bf

all: $(exec)

$(exec): $(objs)
	ld	-o $(exec) $(objs)
%.o: %.s
	as	-o $@ $<
clean:
	rm	-f $(objs) $(exec)
