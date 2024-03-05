#!/bin/bash
echo $1

BMI160_PATH=$1

KERNEL_VERSION=$(uname -r)
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
	wget $KERNEL_SOURCE
fi

echo "Extracting original source"
tar -xvf linux-$version.$subver.tar.* linux-$version.$subver/$BMI160_PATH --xform=s,linux-$version.$subver/$BMI160_PATH,.,

echo "Applying patch to kernel $KERNEL_VERSION $BMI160_PATH"
for i in $(ls *.patch); do
	patch <$i
done
