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

foreach (tgt IN ITEMS pfc foosdk foosdk_component_client foosdk_helpers foosdk_helpers_mac foosdk_ppui wtl)
    _foosdk_install(${tgt})
endforeach ()

if (TARGET foosdk_shared)
    if (WIN32)
        install(IMPORTED_RUNTIME_ARTIFACTS foosdk_shared
                DESTINATION ${CMAKE_INSTALL_BINDIR}
        )
    elseif (APPLE)
        install(
                TARGETS foosdk_shared
                EXPORT foosdkTargets ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
                LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
                RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
                INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        )
    endif ()
endif ()

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