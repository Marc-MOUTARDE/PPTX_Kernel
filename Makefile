CC = clang -target x86_64-unknown-none
AS = clang -target x86_64-unknown-none
LD = ld.lld

CFLAGS = -W -Wall -Wextra -pedantic -std=c89

PPTX_INPUT = iso_27001.pptx
PPTX_OUTPUT = boot_iso_27001.pptx

SRC_DIR = ./kernel
BIN = 'Info'

SRC_C = $(wildcard $(SRC_DIR)/*.c)
SRC_S = $(wildcard $(SRC_DIR)/*.s)
OBJ = $(SRC_C:.c=.c.o) $(SRC_S:.s=.s.o)

all: $(PPTX_OUTPUT)

clean:
	rm -rf _rels docProps '[Content_Types].xml' ppt
	rm -rf $(PPTX_OUTPUT)
	rm -rf $(OBJ)
	rm -rf $(BIN) $(BIN).tmp

$(PPTX_OUTPUT): $(PPTX_INPUT) $(BIN)
	unzip $(PPTX_INPUT)
	dd if=$(BIN).tmp of=$(BIN) bs=1 skip=34 count=478
	zip -r -X -Z store $@ $(BIN) '[Content_Types].xml' 'ppt' '_rels' 'docProps'

$(BIN): $(OBJ)
	$(LD) -n -o $@.tmp $^ -T $(SRC_DIR)/linker.ld --oformat=binary

%.c.o: %.c
	$(CC) -o $@ -c $^ $(CFLAGS)

%.s.o: %.s
	$(AS) -o $@ -c $^