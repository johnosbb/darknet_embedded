cmake_minimum_required(VERSION 3.10)

project(Darknet)

# Check for custom compile definitions for uClibc and musl
if(USE_UCLIBC)
    message(STATUS "Building with uClibc support")
    add_definitions(-DUSE_UCLIBC)
endif()

if(USE_MUSL)
    message(STATUS "Building with musl support")
    add_definitions(-DUSE_MUSL)
endif()


# Set C and C++ flags
set(CMAKE_C_FLAGS "-Wall -Wfatal-errors -Wno-unused-result -Wno-unknown-pragmas -fPIC -rdynamic")
set(CMAKE_CXX_FLAGS "-std=c++11 -Wall -Wfatal-errors -Wno-unused-result -Wno-unknown-pragmas -fPIC -rdynamic")

# CUDA flags
set(CUDA_ARCH_FLAGS "")
if(NOT DEFINED CMAKE_CUDA_FLAGS)
    set(CMAKE_CUDA_FLAGS "-Ofast")
endif()

# Options for features
option(USE_CPP "Use C++" OFF)
option(DEBUG "Debug build" OFF)
option(GPU "Use GPU" OFF)
option(CUDNN "Use cuDNN" OFF)
option(CUDNN_HALF "Use cuDNN Half Precision" OFF)
option(AVX "Use AVX optimization" OFF)
option(OPENMP "Use OpenMP" OFF)
option(LIBSO "Build as shared library" ON)
option(ZED_CAMERA "Enable ZED Camera support" OFF)
option(ZED_CAMERA_v2_8 "Use ZED SDK 2.x" OFF)

# CUDA paths
set(CUDA_INCLUDE_DIR /usr/local/cuda/include)
set(CUDA_LIB_DIR /usr/local/cuda/lib64)

# Include directories
include_directories(${CMAKE_SOURCE_DIR}/include ${CMAKE_SOURCE_DIR}/3rdparty/stb/include)

# Collect source files
file(GLOB CORE_SOURCES
    ${CMAKE_SOURCE_DIR}/src/*.c
    ${CMAKE_SOURCE_DIR}/src/*.cpp
    ${CMAKE_SOURCE_DIR}/src/*.cu
)

# Exclude yolo_console_dll.cpp and darknet.c from the library sources
list(FILTER CORE_SOURCES EXCLUDE REGEX ".*yolo_console_dll.cpp$")
list(FILTER CORE_SOURCES EXCLUDE REGEX ".*darknet.c$")

# Build the library (shared or static based on LIBSO option)
if(LIBSO)
    add_library(darknet SHARED ${CORE_SOURCES})
    target_compile_definitions(darknet PRIVATE -DLIB_EXPORTS)
else()
    add_library(darknet STATIC ${CORE_SOURCES})
endif()

# Link CUDA, CUDNN, etc., to the library
if(GPU)
    set(CUDA_ARCH_FLAGS "-gencode arch=compute_50,code=[sm_50,compute_50] -gencode arch=compute_52,code=[sm_52,compute_52] -gencode arch=compute_61,code=[sm_61,compute_61]")
    include_directories(${CUDA_INCLUDE_DIR})
    link_directories(${CUDA_LIB_DIR})
    target_compile_definitions(darknet PRIVATE -DGPU)
    target_link_libraries(darknet cuda cudart cublas curand)
endif()

if(CUDNN)
    target_compile_definitions(darknet PRIVATE -DCUDNN)
    include_directories("/usr/local/cudnn/include")
    link_directories("/usr/local/cudnn/lib64")
    target_link_libraries(darknet cudnn)
endif()

if(AVX)
    target_compile_options(darknet PRIVATE -mavx -mavx2 -msse3 -msse4.1 -msse4.2 -msse4a)
endif()

if(OPENMP)
    find_package(OpenMP REQUIRED)
    target_compile_options(darknet PRIVATE ${OpenMP_CXX_FLAGS})
    target_link_libraries(darknet PRIVATE OpenMP::OpenMP_CXX)
endif()

if(ZED_CAMERA)
    include_directories("/usr/local/zed/include")
    link_directories("/usr/local/zed/lib")
    target_compile_definitions(darknet PRIVATE -DZED_STEREO)
    if(ZED_CAMERA_v2_8)
        target_link_libraries(darknet zed)
    endif()
endif()

# Add the executable for darknet.c
add_executable(darknet_cli ${CMAKE_SOURCE_DIR}/src/darknet.c)
target_link_libraries(darknet_cli darknet)

# Add the executable for yolo_console_dll.cpp
add_executable(yolo_console ${CMAKE_SOURCE_DIR}/src/yolo_console_dll.cpp)
target_link_libraries(yolo_console darknet)

# Set the output directories for executables
set_target_properties(darknet_cli PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set_target_properties(yolo_console PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

# Set debug flags if DEBUG option is on
if(DEBUG)
    set(CMAKE_BUILD_TYPE Debug)
    set(CMAKE_C_FLAGS_DEBUG "-O0 -g")
    set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g")
endif()

# Install targets (optional)
install(TARGETS darknet_cli yolo_console DESTINATION bin)


# Install the shared library (if created, e.g., libdarknet.so)
if(TARGET darknet)
    install(TARGETS darknet
            LIBRARY DESTINATION lib
            ARCHIVE DESTINATION lib)
endif()

# Install the darknet.h header file
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/include/darknet.h DESTINATION include)


