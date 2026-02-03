cmake_minimum_required(VERSION 3.24)
project(foosdk LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(FetchContent)
FetchContent_Declare(
        foobar_sdk
        URL https://www.foobar2000.org/downloads/SDK-2024-12-03.7z
        URL_HASH SHA256=d1f8bfa5250a1bc33eefd583991c1149f174adb8fbb3cf2ade62daebc328df14
)
FetchContent_MakeAvailable(foobar_sdk)
FetchContent_Declare(
        wtl
        URL https://sourceforge.net/projects/wtl/files/latest/download
        OVERRIDE_FIND_PACKAGE
)
FetchContent_MakeAvailable(wtl)
add_library(wtl INTERFACE)
target_include_directories(wtl INTERFACE
        "$<BUILD_INTERFACE:${wtl_SOURCE_DIR}/Include>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/wtl>"
)
set(FOOSDK_ROOT "${foobar_sdk_SOURCE_DIR}")
if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    enable_language(OBJCXX)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DDEBUG=1")
    set(CMAKE_OBJCXX_FLAGS_DEBUG "${CMAKE_OBJCXX_FLAGS_DEBUG} -DDEBUG=1")
elseif (NOT CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(FATAL_ERROR "Target OS is not Windows or Mac")
endif ()
include(GNUInstallDirs)
include(Sources)
if (MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP /wd4302 /wd4838 /wd4996 /d2notypeopt")
endif ()

function(_foosdk_install target)
    if(TARGET ${target})
        install(
                TARGETS ${target}
                EXPORT foosdkTargets ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
                LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
                RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
                INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        )
    endif()
endfunction()

foreach(tgt IN ITEMS pfc foosdk foosdk_component_client foosdk_helpers foosdk_helpers_mac foosdk_ppui foosdk_shared wtl)
    _foosdk_install(${tgt})
endforeach()

install(
        TARGETS foo_sample LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
install(
        EXPORT foosdkTargets NAMESPACE foosdk::
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/foosdk
)
install(DIRECTORY
        "${foobar_sdk_SOURCE_DIR}/pfc"
        "${foobar_sdk_SOURCE_DIR}/foobar2000"
        "${foobar_sdk_SOURCE_DIR}/libPPUI"
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
)

install(DIRECTORY "${wtl_SOURCE_DIR}/Include/"
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/wtl
)