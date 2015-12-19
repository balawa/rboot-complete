#
# Makefile for rBoot sample project
# https://github.com/raburton/esp8266
#

# use wifi settings from environment or hard code them here
WIFI_SSID ?= "WIFI SSID"
WIFI_PWD  ?= "password"

#SDK_BASE   ?= /opt/esp-open-sdk/sdk
#SDK_BASE ?= C:\Espressif\ESP8266_SDK
#XTENSA_BINDIR ?= C:\Espressif\xtensa-lx106-elf\bin

SDK_LIBDIR  = lib
SDK_INCDIR  = include

ESPTOOL2     ?= ../esptool2/esptool2
FW_SECTS      = .text .data .rodata
FW_USER_ARGS  = -quiet -bin -boot2

ifndef XTENSA_BINDIR
CC := xtensa-lx106-elf-gcc
LD := xtensa-lx106-elf-gcc
else
CC := $(addprefix $(XTENSA_BINDIR)/,xtensa-lx106-elf-gcc)
LD := $(addprefix $(XTENSA_BINDIR)/,xtensa-lx106-elf-gcc)
endif

BUILD_DIR = build
FIRMW_DIR = firmware

SDK_BASE := $(subst \,/,$(addprefix /,$(subst :,,$(SDK_BASE))))

SDK_LIBDIR := $(addprefix $(SDK_BASE)/,$(SDK_LIBDIR))
SDK_INCDIR := $(addprefix -I$(SDK_BASE)/,$(SDK_INCDIR))

LIBS    = c gcc hal phy net80211 lwip wpa main pp
CFLAGS  = -Os -g -O2 -Wpointer-arith -Wundef -Werror -Wno-implicit -Wl,-EL -fno-inline-functions -nostdlib -mlongcalls  -mtext-section-literals  -D__ets__ -DICACHE_FLASH
LDFLAGS = -nostdlib -Wl,--no-check-sections -u call_user_start -Wl,-static

SRC		:= $(wildcard *.c)
OBJ		:= $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRC))
LIBS		:= $(addprefix -l,$(LIBS))

ifneq ($(WIFI_SSID), "")
	CFLAGS += -DWIFI_SSID=\"$(WIFI_SSID)\"
endif
ifneq ($(WIFI_PWD), "")
	CFLAGS += -DWIFI_PWD=\"$(WIFI_PWD)\"
endif

PORT ?= COM7
ROM0_LOC ?=  0x02000
ROM1_LOC ?=  0x82000
FLASH_OPTS = --port $(COM7) write_flash 

ifeq ($(SPI_SIZE), 256K)
	FLASH_OPTS += -fs 2m
	ROM1_LOC ?=  0x22000
else ifeq ($(SPI_SIZE), 512K)
	FLASH_OPTS += -fs 4m
	ROM1_LOC ?=  0x42000
else ifeq ($(SPI_SIZE), 1M)
	FLASH_OPTS += -fs 8m
else ifeq ($(SPI_SIZE), 2M)
	FLASH_OPTS += -fs 16m
else ifeq ($(SPI_SIZE), 4M)
	FLASH_OPTS += -fs 32m
endif

.SECONDARY:
.PHONY: all clean

C_FILES = $(wildcard *.c)
O_FILES = $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_FILES))

all: $(BUILD_DIR) $(FIRMW_DIR) $(FIRMW_DIR)/rom0.bin $(FIRMW_DIR)/rom1.bin

$(BUILD_DIR)/%.o: %.c %.h
	@echo "CC $<"
	@$(CC) -I. $(SDK_INCDIR) $(CFLAGS) -o $@ -c $<

$(BUILD_DIR)/%.elf: $(O_FILES)
	@echo "LD $(notdir $@)"
	@$(LD) -L$(SDK_LIBDIR) -T$(notdir $(basename $@)).ld $(LDFLAGS) -Wl,--start-group $(LIBS) $^ -Wl,--end-group -o $@

$(FIRMW_DIR)/%.bin: $(BUILD_DIR)/%.elf
	@echo "FW $(notdir $@)"
	@$(ESPTOOL2) $(FW_USER_ARGS) $^ $@ $(FW_SECTS)

$(BUILD_DIR):
	@mkdir -p $@

$(FIRMW_DIR):
	@mkdir -p $@

flash:
	@echo "Flashing the firmware"
	$(SDK_BASE)/../utils/esptool  $(FLASH_OPTS) -fs 4m 0x0000 ../rboot/firmware/rboot.bin $(ROM0_LOC) firmware/rom0.bin $(ROM1_LOC) firmware/rom1.bin

clean:
	@echo "RM $(BUILD_DIR) $(FIRMW_DIR)"
	@rm -rf $(BUILD_DIR)
	@rm -rf $(FIRMW_DIR)
