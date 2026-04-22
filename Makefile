CC      = gcc
AS      = gcc
CFLAGS  = -Wall -Wextra -g -no-pie
TARGET  = lab4

.PHONY: all clean run

all: $(TARGET)

# Compile C driver
main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

# Assemble the .s file
sum_array.o: sum_array.s
	$(AS) $(CFLAGS) -c sum_array.s -o sum_array.o

# Link everything together
$(TARGET): main.o sum_array.o
	$(CC) $(CFLAGS) -o $(TARGET) main.o sum_array.o

# Convenience target — run with the provided data file
run: $(TARGET)
	./$(TARGET) data.txt

clean:
	rm -f *.o $(TARGET)
