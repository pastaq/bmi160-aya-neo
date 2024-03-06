#!/bin/bash
DRIVER_PATH=$1

# Get the kernel version in a way that works for chroot
KERNEL_VERSION=$(cat /proc/version | cut -d " " -f 3)
vers=(${KERNEL_VERSION//./ }) # split kernel version into individual elements
major="${vers[0]}"
minor="${vers[1]}"
version="$major.$minor" # recombine as needed
subverstr=(${vers[2]//-/ })
subver="${subverstr[0]}"

KERNEL_FILE="linux-${version}.${subver}.tar.xz"
KERNEL_SOURCE="https://mirrors.edge.kernel.org/pub/linux/kernel/v$major.x/$KERNEL_FILE"
if [ ! -f "${KERNEL_FILE}" ]; then
	echo "Downloading kernel source $KERNEL_SOURCE for $KERNEL_VERSION"
	curl $KERNEL_SOURCE -o $KERNEL_FILE
fi

echo "Extracting original source"
tar -xvf $KERNEL_FILE linux-$version.$subver/$DRIVER_PATH --xform=s,linux-$version.$subver/$DRIVER_PATH,.,

echo "Applying patch to kernel $KERNEL_VERSION $DRIVER_PATH"
for i in $(ls *.patch); do
	patch <$i
done
