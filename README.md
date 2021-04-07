# Instant-OpenCV-for-iOS-Sample
The sample code files for *Instant OpenCV for iOS*.

## Unzip/Download OpenCV Releases

Just unzip framework at local path: `Library/OpenCV/Releases/3.0.0-ios/opencv2.framework.zip`
or download opencv V3.0.0 iOS pack from [OpenCV official website](https://opencv.org/releases/).


## Building OpenCV for iOS from sources (Advanced)

There is no source code for this recipe, as we're going to build OpenCV. You will need a Git command-line client, CMake (Version 2.8.11 or higher), and Python 2.7 installed. Usually, Python is already installed on Mac OS, but the CMake tool needs to be downloaded from http://cmake.org. And, you don't need an iOS device, because the compilation is done on a host computer (so-called cross-compilation).

### Download [CMake](https://cmake.org) and install to path: `/Applications/CMake.app`

### Add CMake to the PATH:
```
% export PATH=/Applications/CMake.app/Contents/bin:$PATH
```

### Check CMake version:
```
% cmake --version
cmake version 3.20.0

CMake suite maintained and supported by Kitware (kitware.com/cmake).
```

The following are the steps required to get your custom OpenCV build:

1. Create a new directory and clone OpenCV's source code repository there.

2. Check out the proper Git branch or tag.

3. Create a symbolic link to Xcode.

4. Run the Python script to build the iOS framework.

5. Update your project(s) to link to a new framework.

6. Modify the OpenCV code and rebuild the framework if needed.

Let's implement the described steps:

1. Almost all operations in this recipe should be executed on the Terminal. So, create a new Terminal window and create a new working directory for our experiments:
```
$ mkdir ~/<working_directory>
$ cd <working_directory>
```
2. Then we need to clone OpenCV sources, and we'll use the GitHub repository for that:
```
$ git clone https://github.com/opencv/opencv.git
```
3. When complete, we have to check out the branch or tag, which we're going to use as a starting point. Let's imagine we want to build the latest state of the 4.5.2 branch, which is used for the OpenCV 4.5.2 releases' preparation:
```
$ cd opencv
$ git checkout 4.5.2
```
4. Now, let's create a symbolic link to Xcode, so the build script can see the compiler, header files, and so on:
```
$ cd /
$ sudo ln -s /Applications/Xcode.app/Contents/Developer Xcode_Developer
```
5. We're now ready to build the framework. Please be patient, because it will take a while. OpenCV is going to be built in three different configurations, and it may take a couple of minutes:
```
$ cd ~/<working_directory>
$ python opencv/platforms/ios/build_framework.py build_ios
```
6. After the process is complete, your framework will be available at `~/<my_working_ directory>/build_ios/opencv2.framework`. You can now add this framework to your Xcode projects, as we did before. When rebuilt, your projects will use this new version of OpenCV.

7. If you want to change something in OpenCV, you can edit its code and rerun the script. If that is possible, unchanged binaries from the previous build will be used, and the compilation will be faster than it was the first time.

## Tips
#### How to Install For Command Line Use
CMake -> Tools -> How to Install For Command Line Use

```
One may add CMake to the PATH:
 PATH="/Applications/CMake.app/Contents/bin":"$PATH"
Or, to install symlinks to '/usr/local/bin', run:
 sudo "/Applications/CMake.app/Contents/bin/cmake-gui" --install
Or, to install symlinks to another directory, run:
 sudo "/Applications/CMake.app/Contents/bin/cmake-gui" --install=/path/to/bin
```

#### cmake 兼容性问题

从 cmake 3.19 版本开始，`Xcode generator` 会尝试默认启用 Xcode 的 New Build System

对于部分不支持new build system 的项目，会出现下面的警告或者报错：
```
CMake Error in 3rdparty/zlib/CMakeLists.txt:
  The custom command generating

    /Users/gavinxiang/Downloads/opencv/build_ios/build/iPhoneOS-armv7/modules/world/opencl_kernels_core.cpp

  is attached to multiple targets:

    opencv_world_object
    opencv_world

  but none of these is a common dependency of the other(s).  This is not
  allowed by the Xcode "new build system".


CMake Generate step failed.  Build files cannot be regenerated correctly.
('Child returned:', 1)
```
#### [兼容性解决方案](https://cmake.org/cmake/help/v3.19/generator/Xcode.html#xcode-build-system-selection)

为了避免报错，我们可以通过添加参数 `-T buildsystem=1`

```
Xcode
Generate Xcode project files.

This supports Xcode 5.0 and above.

Toolset and Build System Selection
By default Xcode is allowed to select its own default toolchain. The CMAKE_GENERATOR_TOOLSET option may be set, perhaps via the cmake(1) -T option, to specify another toolset.

This generator supports toolset specification using one of these forms:

toolset
toolset[,key=value]*
key=value[,key=value]*
The toolset specifies the toolset name. The selected toolset name is provided in the CMAKE_XCODE_PLATFORM_TOOLSET variable.

The key=value pairs form a comma-separated list of options to specify generator-specific details of the toolset selection. Supported pairs are:

buildsystem=<variant>
Specify the buildsystem variant to use. See the CMAKE_XCODE_BUILD_SYSTEM variable for allowed values.

For example, to select the original build system under Xcode 12, run cmake(1) with the option -T buildsystem=1.
```

