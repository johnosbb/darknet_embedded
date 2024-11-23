./cleanMe.sh
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=ToolChain_Files/stm32_toolchain.cmake .
make VERBOSE=1
