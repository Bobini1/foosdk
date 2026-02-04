include(GNUInstallDirs)
function(_foosdk_install target)
    if (TARGET ${target})
        install(
                TARGETS ${target}
                EXPORT foosdkTargets ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
                LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
                RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
                INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        )
    endif ()
endfunction()

foreach (tgt IN ITEMS pfc foosdk component_client helpers helpers_mac ppui shared)
    _foosdk_install(${tgt})
endforeach ()

install(
        EXPORT foosdkTargets NAMESPACE foosdk::
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/foosdk
)
install(DIRECTORY
        "${foobar_sdk_source_SOURCE_DIR}/pfc"
        "${foobar_sdk_source_SOURCE_DIR}/foobar2000"
        "${foobar_sdk_source_SOURCE_DIR}/libPPUI"
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
)

install(DIRECTORY
        "${foobar_sdk_source_SOURCE_DIR}/foobar2000/helpers-mac/"
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/foobar2000/helpers-mac
)

include(CMakePackageConfigHelpers)
configure_package_config_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake/foosdkConfig.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/foosdkConfig.cmake"
        INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/foosdk
)
write_basic_package_version_file(
        "${CMAKE_CURRENT_BINARY_DIR}/foosdkConfigVersion.cmake"
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY AnyNewerVersion
)
install(FILES
        "${CMAKE_CURRENT_BINARY_DIR}/foosdkConfig.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/foosdkConfigVersion.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/foosdk
)