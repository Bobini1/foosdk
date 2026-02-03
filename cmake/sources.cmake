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

set(FLAGS)
if (WIN32)
    set(WINVER 0x0601 CACHE STRING "Target Windows version")
    set(FLAGS
            _UNICODE
            UNICODE
            STRICT
            WINVER=${WINVER}
            _WIN32_WINNT=${WINVER}
    )
endif ()
set(_foosdk_glob_root "${foobar_sdk_SOURCE_DIR}")

function(_foosdk_glob out_var)
    file(GLOB _globbed CONFIGURE_DEPENDS LIST_DIRECTORIES FALSE RELATIVE "${_foosdk_glob_root}" ${ARGN})
    list(SORT _globbed)
    list(TRANSFORM _globbed PREPEND "${_foosdk_glob_root}/")
    set(${out_var} "${_globbed}" PARENT_SCOPE)
endfunction()

_foosdk_glob(PFC_SOURCES
        "${_foosdk_glob_root}/pfc/*.c"
        "${_foosdk_glob_root}/pfc/*.cpp"
)
if (APPLE)
    _foosdk_glob(PFC_SOURCES_MAC
            "${_foosdk_glob_root}/pfc/*.m"
            "${_foosdk_glob_root}/pfc/*.mm"
    )
    list(APPEND PFC_SOURCES ${PFC_SOURCES_MAC})
endif ()

add_library(pfc STATIC ${PFC_SOURCES})
target_include_directories(pfc PUBLIC
        "$<BUILD_INTERFACE:${_foosdk_glob_root}>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)
target_compile_definitions(pfc PUBLIC ${FLAGS})
if (APPLE)
    target_link_libraries(pfc PUBLIC "$<LINK_LIBRARY:FRAMEWORK,Foundation>")
endif ()

_foosdk_glob(COMPONENT_CLIENT_SOURCES
        "${_foosdk_glob_root}/foobar2000/foobar2000_component_client/*.c"
        "${_foosdk_glob_root}/foobar2000/foobar2000_component_client/*.cpp"
)
add_library(foosdk_component_client STATIC ${COMPONENT_CLIENT_SOURCES})
target_include_directories(foosdk_component_client PUBLIC
        "$<BUILD_INTERFACE:${_foosdk_glob_root}/foobar2000>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/foobar2000>"
)
target_link_libraries(foosdk_component_client PUBLIC pfc)

_foosdk_glob(SDK_SOURCES
        "${_foosdk_glob_root}/foobar2000/SDK/*.c"
        "${_foosdk_glob_root}/foobar2000/SDK/*.cpp"
)
if (APPLE)
    _foosdk_glob(SDK_SOURCES_MAC
            "${_foosdk_glob_root}/foobar2000/SDK/*.m"
            "${_foosdk_glob_root}/foobar2000/SDK/*.mm"
    )
    list(APPEND SDK_SOURCES ${SDK_SOURCES_MAC})
endif ()
add_library(foosdk STATIC ${SDK_SOURCES})
target_include_directories(foosdk PUBLIC
        "$<BUILD_INTERFACE:${_foosdk_glob_root}/foobar2000>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/foobar2000>"
)
target_link_libraries(foosdk PUBLIC pfc foosdk_component_client)

_foosdk_glob(SDK_HELPERS_SOURCES
        "${_foosdk_glob_root}/foobar2000/helpers/*.c"
        "${_foosdk_glob_root}/foobar2000/helpers/*.cpp"
)
if (APPLE)
    list(REMOVE_ITEM SDK_HELPERS_SOURCES
            "${_foosdk_glob_root}/foobar2000/helpers/inplace_edit.cpp"
            "${_foosdk_glob_root}/foobar2000/helpers/WindowPositionUtils.cpp"
            "${_foosdk_glob_root}/foobar2000/helpers/CTableEditHelper-Legacy.cpp"
            "${_foosdk_glob_root}/foobar2000/helpers/ui_element_helpers.cpp"
            "${_foosdk_glob_root}/foobar2000/helpers/image_load_save.cpp"
    )
endif ()
add_library(foosdk_helpers STATIC ${SDK_HELPERS_SOURCES})
target_include_directories(foosdk_helpers PUBLIC
        "$<BUILD_INTERFACE:${_foosdk_glob_root}/foobar2000/helpers>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/foobar2000/helpers>"
)
target_link_libraries(foosdk_helpers PUBLIC pfc foosdk)
if (WIN32)
    target_link_libraries(foosdk_helpers PUBLIC wtl)
endif ()

if (APPLE)
    _foosdk_glob(SDK_HELPERS_MAC_SOURCES
            "${_foosdk_glob_root}/foobar2000/helpers-mac/*.m"
            "${_foosdk_glob_root}/foobar2000/helpers-mac/*.mm"
    )
    add_library(foosdk_helpers_mac STATIC ${SDK_HELPERS_MAC_SOURCES})
    target_include_directories(foosdk_helpers_mac PUBLIC
            "$<BUILD_INTERFACE:${_foosdk_glob_root}/foobar2000/helpers-mac>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/foobar2000/helpers-mac>"
    )
    target_link_libraries(foosdk_helpers_mac PUBLIC foosdk_helpers)
endif ()

if (WIN32)
    _foosdk_glob(PPUI_SOURCES
            "${_foosdk_glob_root}/libPPUI/*.c"
            "${_foosdk_glob_root}/libPPUI/*.cpp"
    )
    add_library(foosdk_ppui STATIC ${PPUI_SOURCES})
    target_include_directories(foosdk_ppui PUBLIC
            "$<BUILD_INTERFACE:${_foosdk_glob_root}/libPPUI>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/libPPUI>"
    )
    target_link_libraries(foosdk_ppui PUBLIC pfc wtl)
endif ()

_foosdk_glob(SAMPLE_SOURCES
        "${_foosdk_glob_root}/foobar2000/foo_sample/*.c"
        "${_foosdk_glob_root}/foobar2000/foo_sample/*.cpp"
)
_foosdk_glob(SHARED_SOURCES
        "${_foosdk_glob_root}/foobar2000/shared/*.c"
        "${_foosdk_glob_root}/foobar2000/shared/*.cpp"
)
if (APPLE)
    _foosdk_glob(SHARED_SOURCES_MACOS
            "${_foosdk_glob_root}/foobar2000/shared/*.m"
            "${_foosdk_glob_root}/foobar2000/shared/*.mm"
    )
    # There is so few of them that it's easier to just list them explicitly
    set(SHARED_SOURCES
            "${_foosdk_glob_root}/foobar2000/shared/audio_math.cpp"
            "${_foosdk_glob_root}/foobar2000/shared/shared-nix.cpp"
            "${_foosdk_glob_root}/foobar2000/shared/stdafx.cpp"
            "${_foosdk_glob_root}/foobar2000/shared/utf8.cpp"
    )
    list(APPEND SHARED_SOURCES ${SHARED_SOURCES_MACOS})
elseif (WIN32)
    list(REMOVE_ITEM SHARED_SOURCES "${_foosdk_glob_root}/foobar2000/shared/shared-nix.cpp")
endif ()
add_library(foosdk_shared SHARED ${SHARED_SOURCES})
target_compile_definitions(foosdk_shared PRIVATE SHARED_EXPORTS)
target_link_libraries(foosdk_shared PRIVATE pfc)
if (WIN32)
    target_link_libraries(foosdk_shared PRIVATE DbgHelp Comctl32 UxTheme)
elseif (APPLE)
    target_link_libraries(foosdk_shared PRIVATE "$<LINK_LIBRARY:FRAMEWORK,AppKit>")
    target_link_libraries(foosdk_shared PRIVATE foosdk)
endif ()
if (WIN32)
    _foosdk_glob(SAMPLE_SOURCES_WINDOWS
            "${_foosdk_glob_root}/foobar2000/foo_sample/*.rc"
    )
    list(APPEND SAMPLE_SOURCES ${SAMPLE_SOURCES_WINDOWS})
elseif (APPLE)
    _foosdk_glob(SAMPLE_SOURCES_MACOS
            "${_foosdk_glob_root}/foobar2000/foo_sample/*.m"
            "${_foosdk_glob_root}/foobar2000/foo_sample/*.mm"
            "${_foosdk_glob_root}/foobar2000/foo_sample/*.xib")
    list(APPEND SAMPLE_SOURCES ${SAMPLE_SOURCES_MACOS})
endif ()
target_include_directories(foosdk_shared PUBLIC
        "$<BUILD_INTERFACE:${_foosdk_glob_root}/foobar2000/shared>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/foobar2000/shared>"
)
add_library(foo_sample MODULE ${SAMPLE_SOURCES})
target_include_directories(foo_sample PUBLIC
        "$<BUILD_INTERFACE:${_foosdk_glob_root}/foobar2000/foo_sample>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/foobar2000/foo_sample>"
)
target_link_libraries(foo_sample PRIVATE foosdk foosdk_helpers foosdk_shared)
if (APPLE)
    set_target_properties(foo_sample PROPERTIES BUNDLE ON BUNDLE_EXTENSION component)
    target_link_libraries(foo_sample PRIVATE "$<LINK_LIBRARY:FRAMEWORK,Cocoa>")
    target_link_libraries(foo_sample PRIVATE foosdk_helpers_mac)
elseif (WIN32)
    target_link_libraries(foo_sample PRIVATE foosdk_ppui)
endif ()

unset(_foosdk_glob_root)
