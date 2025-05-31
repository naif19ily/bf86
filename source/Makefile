#  ______  ______  _____   ____  
# |      >|   ___|<  -  > /   /_ 
# |     < |   ___|/  _  \|   _  |
# |______>|___|   \_____/|______|

objs = main.o data.o interpreter.o
flags =
assb = as
name = bf86

all: $(name)

$(name): $(objs)
	ld	-o $(name) $(objs)
%.o: %.asm
	$(assb)	$< -o $@
clean:
	rm	-f $(objs) $(name) && clear

