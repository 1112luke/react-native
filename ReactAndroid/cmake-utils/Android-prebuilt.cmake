# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

# This configuration provides access to most common React Native prebuilt .so files
# to avoid recompiling each of the libraries outside of ReactAndroid NDK compilation.
# Hosting app's/library's CMakeLists.txt can include this Android-prebuilt.cmake file to
# get access to those libraries to depend on.
# NOTES:
# * Currently, it assumes building React Native from source.
# * Not every .so is listed here (yet).
# * Static libs are not covered here (yet).

cmake_minimum_required(VERSION 3.13)
set(CMAKE_VERBOSE_MAKEFILE on)

# FIRST_PARTY_NDK_DIR contains vendored source code from other FB frameworks
# like Yoga, FBJNI, etc.
set(FIRST_PARTY_NDK_DIR ${REACT_ANDROID_DIR}/src/main/jni/first-party)
# THIRD_PARTY_NDK_DIR is where we're downloading third-party native
# frameworks such as libevent, boost, etc.
set(THIRD_PARTY_NDK_DIR ${REACT_ANDROID_BUILD_DIR}/third-party-ndk)
# REACT_ANDROID_SRC_DIR is the root of ReactAndroid source code (Java & JNI)
set(REACT_ANDROID_SRC_DIR ${REACT_ANDROID_DIR}/src/main)
# REACT_COMMON_DIR is the root of ReactCommon source code (C++ only)
set(REACT_COMMON_DIR ${REACT_ANDROID_DIR}/../ReactCommon)
# REACT_GENERATED_SRC_DIR is the folder where the codegen for rncore will output
set(REACT_GENERATED_SRC_DIR ${REACT_ANDROID_BUILD_DIR}/generated/source)
# REACT_NDK_EXPORT_DIR is the folder where the .so will be copied for being inported
# in the local project by the packageReactDebugNdkLibs/packageReactReleaseNdkLibs
set(REACT_NDK_EXPORT_DIR ${PROJECT_BUILD_DIR}/react-ndk/exported)

## folly_runtime
add_library(folly_runtime SHARED IMPORTED GLOBAL)
set_target_properties(folly_runtime
        PROPERTIES
        IMPORTED_LOCATION
        ${REACT_NDK_EXPORT_DIR}/${ANDROID_ABI}/libfolly_runtime.so)
target_include_directories(folly_runtime
        INTERFACE
        ${THIRD_PARTY_NDK_DIR}/boost/boost_1_76_0
        ${THIRD_PARTY_NDK_DIR}/double-conversion
        ${THIRD_PARTY_NDK_DIR}/folly)
target_compile_options(folly_runtime
        INTERFACE
        -DFOLLY_NO_CONFIG=1
        -DFOLLY_HAVE_CLOCK_GETTIME=1
        -DFOLLY_HAVE_MEMRCHR=1
        -DFOLLY_USE_LIBCPP=1
        -DFOLLY_MOBILE=1
        -DFOLLY_HAVE_XSI_STRERROR_R=1)

## fbjni
add_subdirectory(${FIRST_PARTY_NDK_DIR}/fbjni fbjni_build)
