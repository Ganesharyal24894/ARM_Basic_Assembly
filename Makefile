PROJECT_NAME = test
SRC_DIR = src
BUILD_DIR = build

OUTPUT = $(BUILD_DIR)/$(PROJECT_NAME).elf

all : flash

build : $(OUTPUT)

$(OUTPUT) : $(SRC_DIR)/$(PROJECT_NAME).s | $(BUILD_DIR)
	 arm-none-eabi-as -g $(SRC_DIR)/$(PROJECT_NAME).s -o $(BUILD_DIR)/$(PROJECT_NAME).o
	 arm-none-eabi-ld $(BUILD_DIR)/$(PROJECT_NAME).o -o $(BUILD_DIR)/$(PROJECT_NAME).elf -Ttext=0x08000000

flash : $(OUTPUT)
	openocd -f interface/stlink-v2.cfg -f target/stm32f4x.cfg -c "program $^ verify reset exit"

gdb : flash
	openocd -f interface/stlink-v2.cfg -f target/stm32f4x.cfg

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

clean :
	rm -r $(BUILD_DIR) | true
