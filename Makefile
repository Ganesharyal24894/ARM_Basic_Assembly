PROJECT_NAME = test
SRC_DIR = src
BUILD_DIR = mybuild
INTERFACE = stlink

OUTPUT = $(BUILD_DIR)/$(PROJECT_NAME)

LINKER_FLAGS = -T stm32f4_linker.ld  --Map $(OUTPUT).map

all : flash

build : $(SRC_DIR)/$(PROJECT_NAME).s | $(BUILD_DIR)
	 arm-none-eabi-as -g -c $(SRC_DIR)/$(PROJECT_NAME).s -o $(OUTPUT).o
	 arm-none-eabi-ld $(OUTPUT).o -o $(OUTPUT).elf $(LINKER_FLAGS)

flash : build
	openocd -f interface/$(INTERFACE).cfg -f target/stm32f4x.cfg -c "program $(OUTPUT).elf verify reset exit"

gdb : flash
	openocd -f interface/$(INTERFACE).cfg -f target/stm32f4x.cfg

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

clean :
	rm -r $(BUILD_DIR) || true
