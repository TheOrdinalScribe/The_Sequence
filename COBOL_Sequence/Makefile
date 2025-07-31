# Makefile for The Sequence COBOL implementation

CC = cobc
CFLAGS = -x -std=cobol2014
TARGET = sequence
SOURCE = SEQUENCE.COB

.PHONY: all clean install run

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(CC) $(CFLAGS) $(SOURCE) -o $(TARGET)

clean:
	rm -f $(TARGET) $(TARGET).exe *.o

install: $(TARGET)
	cp $(TARGET) /usr/local/bin/

run: $(TARGET)
	./$(TARGET)

# Alternative compilation targets for different COBOL compilers
gnucobol: $(SOURCE)
	cobc -x $(SOURCE) -o $(TARGET)

microfocus: $(SOURCE)
	cob -x $(SOURCE) -o $(TARGET)

help:
	@echo "Available targets:"
	@echo "  all       - Compile the program (default)"
	@echo "  clean     - Remove compiled files"
	@echo "  run       - Compile and run the program"
	@echo "  gnucobol  - Compile with GnuCOBOL specifically"
	@echo "  help      - Show this help message"