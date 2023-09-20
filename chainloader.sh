
set -e

ELF=zig-out/bin/kernel8.elf
PKT=kernel.pkt
PORT=/dev/ttyUSB0

# Extract kernel
printf "HOST: Extracting .kernel section\n"
aarch64-linux-gnu-objcopy -O binary --only-section=.kernel $ELF $PKT

# Get kernel size
SIZE=$(wc -c < $PKT)
printf "HOST: Kernel section size: 0x%.16x\n" $SIZE

# Configure serial port
printf "HOST: Configuring serial port %s\n" $PORT
stty -F $PORT 115200 cs8 -cstopb -parenb

# Convert size to hex, reverse hexdump and send to USB
printf "0: %.16x" $SIZE \
    | sed -E 's/0: (..)(..)(..)(..)(..)(..)(..)(..)/0: \8\7\6\5\4\3\2\1/' \
    | xxd -r -g0 > $PORT

# Send kernel packet
printf "HOST: Sending packet...\n"
cat $PKT > $PORT
printf "HOST: Done!\n"
