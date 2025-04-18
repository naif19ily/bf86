objs = main.o data.o interpreter.o fpx86.o
flags =
assb = as
name = bfint

all: $(name)

$(name): $(objs)
	ld	-o $(name) $(objs)
%.o: %.s
	$(assb)	$< -o $@
clean:
	rm	-f $(objs) $(name) && clear

