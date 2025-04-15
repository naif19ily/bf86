objs = main.o data.o
flags =
assb = as
name = bfint

all: $(name)

$(name): $(objs)
	ld	-o $(name) $(objs)
%.o: %.s
	$(assb)	$< -o $@
clean:
	rm	-f $(objs) $(name)
