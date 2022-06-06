BASE_NAME := bmi160_i2c
KERNEL_SOURCE_DIR = /lib/modules/`uname -r`/build

obj-m := bmi160_i2c.o

all: modules

clean modules modules_install:
	$(MAKE) -C $(KERNEL_SOURCE_DIR) M=$(PWD) $@

install: modules_install
