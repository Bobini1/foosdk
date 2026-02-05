if (WIN32)
    find_package(WTL REQUIRED)
endif ()

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

include(GNUInstallDirs)
set(PFC_SOURCES
        sdk/pfc/SmartStrStr.cpp
        sdk/pfc/audio_math.cpp
        sdk/pfc/audio_sample.cpp
        sdk/pfc/base64.cpp
        sdk/pfc/bigmem.cpp
        sdk/pfc/bit_array.cpp
        sdk/pfc/bsearch.cpp
        sdk/pfc/charDownConvert.cpp
        sdk/pfc/cpuid.cpp
        sdk/pfc/crashWithMessage.cpp
        sdk/pfc/filehandle.cpp
        sdk/pfc/filetimetools.cpp
        sdk/pfc/guid.cpp
        sdk/pfc/other.cpp
        sdk/pfc/pathUtils.cpp
        sdk/pfc/printf.cpp
        sdk/pfc/selftest.cpp
        sdk/pfc/sort.cpp
        sdk/pfc/splitString2.cpp
        sdk/pfc/string-compare.cpp
        sdk/pfc/string-conv-lite.cpp
        sdk/pfc/string-lite.cpp
        sdk/pfc/string_base.cpp
        sdk/pfc/string_conv.cpp
        sdk/pfc/threads.cpp
        sdk/pfc/timers.cpp
        sdk/pfc/unicode-normalize.cpp
        sdk/pfc/utf8.cpp
        sdk/pfc/wildcard.cpp
        sdk/pfc/win-objects.cpp
)
if (APPLE)
    set(PFC_SOURCES
            sdk/pfc/SmartStrStr.cpp
            sdk/pfc/audio_math.cpp
            sdk/pfc/audio_sample.cpp
            sdk/pfc/base64.cpp
            sdk/pfc/bigmem.cpp
            sdk/pfc/bit_array.cpp
            sdk/pfc/bsearch.cpp
            sdk/pfc/charDownConvert.cpp
            sdk/pfc/cpuid.cpp
            sdk/pfc/crashWithMessage.cpp
            sdk/pfc/filehandle.cpp
            sdk/pfc/filetimetools.cpp
            sdk/pfc/guid.cpp
            sdk/pfc/nix-objects.cpp
            sdk/pfc/obj-c.mm
            sdk/pfc/other.cpp
            sdk/pfc/pathUtils.cpp
            sdk/pfc/printf.cpp
            sdk/pfc/selftest.cpp
            sdk/pfc/sort.cpp
            sdk/pfc/splitString2.cpp
            sdk/pfc/string-compare.cpp
            sdk/pfc/string-conv-lite.cpp
            sdk/pfc/string-lite.cpp
            sdk/pfc/string_base.cpp
            sdk/pfc/string_conv.cpp
            sdk/pfc/synchro_nix.cpp
            sdk/pfc/threads.cpp
            sdk/pfc/timers.cpp
            sdk/pfc/unicode-normalize.cpp
            sdk/pfc/utf8.cpp
            sdk/pfc/wildcard.cpp
            sdk/pfc/win-objects.cpp
    )
endif ()

add_library(pfc STATIC ${PFC_SOURCES})
target_include_directories(pfc PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/sdk>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)
target_compile_features(pfc PUBLIC cxx_std_17)
if (MSVC)
    target_compile_options(pfc PRIVATE "$<$<COMPILE_LANGUAGE:C,CXX>:/d2notypeopt>")
endif ()
add_library(foosdk::pfc ALIAS pfc)
target_compile_definitions(pfc PUBLIC ${FLAGS})
if (APPLE)
    target_link_libraries(pfc PUBLIC "$<LINK_LIBRARY:FRAMEWORK,Foundation>")
endif ()

set(COMPONENT_CLIENT_SOURCES
        sdk/foobar2000/foobar2000_component_client/component_client.cpp
)
add_library(component_client STATIC ${COMPONENT_CLIENT_SOURCES})
target_include_directories(component_client PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/sdk/foobar2000>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/foobar2000>"
)
target_link_libraries(component_client PUBLIC pfc)
add_library(foosdk::component_client ALIAS component_client)

set(SDK_SOURCES
        sdk/foobar2000/SDK/abort_callback.cpp
        sdk/foobar2000/SDK/advconfig.cpp
        sdk/foobar2000/SDK/album_art.cpp
        sdk/foobar2000/SDK/app_close_blocker.cpp
        sdk/foobar2000/SDK/audio_chunk.cpp
        sdk/foobar2000/SDK/audio_chunk_channel_config.cpp
        sdk/foobar2000/SDK/cfg_var.cpp
        sdk/foobar2000/SDK/cfg_var_legacy.cpp
        sdk/foobar2000/SDK/chapterizer.cpp
        sdk/foobar2000/SDK/commandline.cpp
        sdk/foobar2000/SDK/commonObjects.cpp
        sdk/foobar2000/SDK/completion_notify.cpp
        sdk/foobar2000/SDK/componentversion.cpp
        sdk/foobar2000/SDK/configStore.cpp
        sdk/foobar2000/SDK/config_io_callback.cpp
        sdk/foobar2000/SDK/config_object.cpp
        sdk/foobar2000/SDK/console.cpp
        sdk/foobar2000/SDK/dsp.cpp
        sdk/foobar2000/SDK/dsp_manager.cpp
        sdk/foobar2000/SDK/file_cached_impl.cpp
        sdk/foobar2000/SDK/file_info.cpp
        sdk/foobar2000/SDK/file_info_const_impl.cpp
        sdk/foobar2000/SDK/file_info_impl.cpp
        sdk/foobar2000/SDK/file_info_merge.cpp
        sdk/foobar2000/SDK/file_operation_callback.cpp
        sdk/foobar2000/SDK/filesystem.cpp
        sdk/foobar2000/SDK/filesystem_helper.cpp
        sdk/foobar2000/SDK/foosort.cpp
        sdk/foobar2000/SDK/fsItem.cpp
        sdk/foobar2000/SDK/guids.cpp
        sdk/foobar2000/SDK/hasher_md5.cpp
        sdk/foobar2000/SDK/image.cpp
        sdk/foobar2000/SDK/input.cpp
        sdk/foobar2000/SDK/input_file_type.cpp
        sdk/foobar2000/SDK/link_resolver.cpp
        sdk/foobar2000/SDK/main_thread_callback.cpp
        sdk/foobar2000/SDK/mainmenu.cpp
        sdk/foobar2000/SDK/mem_block_container.cpp
        sdk/foobar2000/SDK/menu_helpers.cpp
        sdk/foobar2000/SDK/menu_item.cpp
        sdk/foobar2000/SDK/menu_manager.cpp
        sdk/foobar2000/SDK/metadb.cpp
        sdk/foobar2000/SDK/metadb_handle.cpp
        sdk/foobar2000/SDK/metadb_handle_list.cpp
        sdk/foobar2000/SDK/output.cpp
        sdk/foobar2000/SDK/packet_decoder.cpp
        sdk/foobar2000/SDK/playable_location.cpp
        sdk/foobar2000/SDK/playback_control.cpp
        sdk/foobar2000/SDK/playlist.cpp
        sdk/foobar2000/SDK/playlist_loader.cpp
        sdk/foobar2000/SDK/popup_message.cpp
        sdk/foobar2000/SDK/preferences_page.cpp
        sdk/foobar2000/SDK/replaygain.cpp
        sdk/foobar2000/SDK/replaygain_info.cpp
        sdk/foobar2000/SDK/service.cpp
        sdk/foobar2000/SDK/stdafx.cpp
        sdk/foobar2000/SDK/tag_processor.cpp
        sdk/foobar2000/SDK/tag_processor_id3v2.cpp
        sdk/foobar2000/SDK/threaded_process.cpp
        sdk/foobar2000/SDK/titleformat.cpp
        sdk/foobar2000/SDK/track_property.cpp
        sdk/foobar2000/SDK/ui.cpp
        sdk/foobar2000/SDK/ui_element.cpp
        sdk/foobar2000/SDK/utility.cpp
)

if (APPLE)
    set(SDK_SOURCES
            sdk/foobar2000/SDK/abort_callback.cpp
            sdk/foobar2000/SDK/advconfig.cpp
            sdk/foobar2000/SDK/album_art.cpp
            sdk/foobar2000/SDK/app_close_blocker.cpp
            sdk/foobar2000/SDK/audio_chunk.cpp
            sdk/foobar2000/SDK/audio_chunk_channel_config.cpp
            sdk/foobar2000/SDK/cfg_var.cpp
            sdk/foobar2000/SDK/cfg_var_legacy.cpp
            sdk/foobar2000/SDK/chapterizer.cpp
            sdk/foobar2000/SDK/commandline.cpp
            sdk/foobar2000/SDK/commonObjects-Apple.mm
            sdk/foobar2000/SDK/commonObjects.cpp
            sdk/foobar2000/SDK/completion_notify.cpp
            sdk/foobar2000/SDK/componentversion.cpp
            sdk/foobar2000/SDK/configStore.cpp
            sdk/foobar2000/SDK/config_io_callback.cpp
            sdk/foobar2000/SDK/config_object.cpp
            sdk/foobar2000/SDK/console.cpp
            sdk/foobar2000/SDK/dsp.cpp
            sdk/foobar2000/SDK/dsp_manager.cpp
            sdk/foobar2000/SDK/file_cached_impl.cpp
            sdk/foobar2000/SDK/file_info.cpp
            sdk/foobar2000/SDK/file_info_const_impl.cpp
            sdk/foobar2000/SDK/file_info_impl.cpp
            sdk/foobar2000/SDK/file_info_merge.cpp
            sdk/foobar2000/SDK/file_operation_callback.cpp
            sdk/foobar2000/SDK/filesystem.cpp
            sdk/foobar2000/SDK/filesystem_helper.cpp
            sdk/foobar2000/SDK/foosort.cpp
            sdk/foobar2000/SDK/fsItem.cpp
            sdk/foobar2000/SDK/guids.cpp
            sdk/foobar2000/SDK/hasher_md5.cpp
            sdk/foobar2000/SDK/image.cpp
            sdk/foobar2000/SDK/input.cpp
            sdk/foobar2000/SDK/input_file_type.cpp
            sdk/foobar2000/SDK/link_resolver.cpp
            sdk/foobar2000/SDK/main_thread_callback.cpp
            sdk/foobar2000/SDK/mainmenu.cpp
            sdk/foobar2000/SDK/mem_block_container.cpp
            sdk/foobar2000/SDK/menu_helpers.cpp
            sdk/foobar2000/SDK/menu_item.cpp
            sdk/foobar2000/SDK/menu_manager.cpp
            sdk/foobar2000/SDK/metadb.cpp
            sdk/foobar2000/SDK/metadb_handle.cpp
            sdk/foobar2000/SDK/metadb_handle_list.cpp
            sdk/foobar2000/SDK/output.cpp
            sdk/foobar2000/SDK/packet_decoder.cpp
            sdk/foobar2000/SDK/playable_location.cpp
            sdk/foobar2000/SDK/playback_control.cpp
            sdk/foobar2000/SDK/playlist.cpp
            sdk/foobar2000/SDK/playlist_loader.cpp
            sdk/foobar2000/SDK/popup_message.cpp
            sdk/foobar2000/SDK/preferences_page.cpp
            sdk/foobar2000/SDK/replaygain.cpp
            sdk/foobar2000/SDK/replaygain_info.cpp
            sdk/foobar2000/SDK/service.cpp
            sdk/foobar2000/SDK/stdafx.cpp
            sdk/foobar2000/SDK/tag_processor.cpp
            sdk/foobar2000/SDK/tag_processor_id3v2.cpp
            sdk/foobar2000/SDK/threaded_process.cpp
            sdk/foobar2000/SDK/titleformat.cpp
            sdk/foobar2000/SDK/track_property.cpp
            sdk/foobar2000/SDK/ui.cpp
            sdk/foobar2000/SDK/ui_element.cpp
            sdk/foobar2000/SDK/utility.cpp
    )
endif ()
add_library(foosdk STATIC ${SDK_SOURCES})
target_include_directories(foosdk PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/sdk/foobar2000>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/foobar2000>"
)
target_link_libraries(foosdk PUBLIC pfc component_client)
add_library(foosdk::foosdk ALIAS foosdk)

set(SDK_HELPERS_SOURCES
        sdk/foobar2000/helpers/AutoComplete.cpp
        sdk/foobar2000/helpers/CTableEditHelper-Legacy.cpp
        sdk/foobar2000/helpers/DarkMode.cpp
        sdk/foobar2000/helpers/ThreadUtils.cpp
        sdk/foobar2000/helpers/VisUtils.cpp
        sdk/foobar2000/helpers/VolumeMap.cpp
        sdk/foobar2000/helpers/WindowPositionUtils.cpp
        sdk/foobar2000/helpers/album_art_helpers.cpp
        sdk/foobar2000/helpers/cfg_guidlist.cpp
        sdk/foobar2000/helpers/cfg_var_import.cpp
        sdk/foobar2000/helpers/create_directory_helper.cpp
        sdk/foobar2000/helpers/cue_creator.cpp
        sdk/foobar2000/helpers/cue_parser.cpp
        sdk/foobar2000/helpers/cue_parser_embedding.cpp
        sdk/foobar2000/helpers/cuesheet_index_list.cpp
        sdk/foobar2000/helpers/dialog_resize_helper.cpp
        sdk/foobar2000/helpers/dropdown_helper.cpp
        sdk/foobar2000/helpers/dynamic_bitrate_helper.cpp
        sdk/foobar2000/helpers/file_list_helper.cpp
        sdk/foobar2000/helpers/file_move_helper.cpp
        sdk/foobar2000/helpers/file_win32_wrapper.cpp
        sdk/foobar2000/helpers/filetimetools.cpp
        sdk/foobar2000/helpers/image_load_save.cpp
        sdk/foobar2000/helpers/inplace_edit.cpp
        sdk/foobar2000/helpers/input_helper_cue.cpp
        sdk/foobar2000/helpers/input_helpers.cpp
        sdk/foobar2000/helpers/mp3_utils.cpp
        sdk/foobar2000/helpers/packet_decoder_aac_common.cpp
        sdk/foobar2000/helpers/packet_decoder_mp3_common.cpp
        sdk/foobar2000/helpers/readers.cpp
        sdk/foobar2000/helpers/seekabilizer.cpp
        sdk/foobar2000/helpers/stream_buffer_helper.cpp
        sdk/foobar2000/helpers/text_file_loader.cpp
        sdk/foobar2000/helpers/text_file_loader_v2.cpp
        sdk/foobar2000/helpers/track_property_callback_impl.cpp
        sdk/foobar2000/helpers/ui_element_helpers.cpp
        sdk/foobar2000/helpers/win-systemtime.cpp
        sdk/foobar2000/helpers/win32_dialog.cpp
        sdk/foobar2000/helpers/win32_misc.cpp
        sdk/foobar2000/helpers/window_placement_helper.cpp
        sdk/foobar2000/helpers/writer_wav.cpp
)
if (APPLE)
    list(REMOVE_ITEM SDK_HELPERS_SOURCES
            "sdk/foobar2000/helpers/inplace_edit.cpp"
            "sdk/foobar2000/helpers/WindowPositionUtils.cpp"
            "sdk/foobar2000/helpers/CTableEditHelper-Legacy.cpp"
            "sdk/foobar2000/helpers/ui_element_helpers.cpp"
            "sdk/foobar2000/helpers/image_load_save.cpp"
            "sdk/foobar2000/helpers/AutoComplete.cpp"
            "sdk/foobar2000/helpers/DarkMode.cpp"
    )
endif ()
add_library(helpers STATIC ${SDK_HELPERS_SOURCES})
target_include_directories(helpers PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/sdk/foobar2000/helpers>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/foobar2000/helpers>"
)
target_link_libraries(helpers PUBLIC pfc foosdk)
if (WIN32)
    target_link_libraries(helpers PUBLIC WTL::WTL)
endif ()
add_library(foosdk::helpers ALIAS helpers)

if (APPLE)
    list(SORT SDK_HELPERS_MAC_SOURCES)
    set(SDK_HELPERS_MAC_SOURCES_UNPREFIXED ${SDK_HELPERS_MAC_SOURCES})
    list(TRANSFORM SDK_HELPERS_MAC_SOURCES PREPEND "sdk/")
    add_library(helpers_mac INTERFACE)
    target_include_directories(helpers_mac INTERFACE
            "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/sdk/foobar2000/helpers-mac>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/foobar2000/helpers-mac>"
    )
    target_link_libraries(helpers_mac INTERFACE helpers)
    target_sources(helpers_mac INTERFACE
            "$<BUILD_INTERFACE:${SDK_HELPERS_MAC_SOURCES}>"
            "$<INSTALL_INTERFACE:${SDK_HELPERS_MAC_SOURCES_UNPREFIXED}>"
    )
    add_library(foosdk::helpers_mac ALIAS helpers_mac)
endif ()

if (WIN32)
    set(PPUI_SOURCES
            sdk/libPPUI/AutoComplete.cpp
            sdk/libPPUI/CDialogResizeHelper.cpp
            sdk/libPPUI/CEditWithButtons.cpp
            sdk/libPPUI/CListAccessible.cpp
            sdk/libPPUI/CListControl-Cells.cpp
            sdk/libPPUI/CListControl-Subst.cpp
            sdk/libPPUI/CListControl.cpp
            sdk/libPPUI/CListControlHeaderImpl.cpp
            sdk/libPPUI/CListControlTruncationTooltipImpl.cpp
            sdk/libPPUI/CListControlWithSelection.cpp
            sdk/libPPUI/CMiddleDragImpl.cpp
            sdk/libPPUI/CPowerRequest.cpp
            sdk/libPPUI/Controls.cpp
            sdk/libPPUI/DarkMode.cpp
            sdk/libPPUI/EditBoxFix.cpp
            sdk/libPPUI/GDIUtils.cpp
            sdk/libPPUI/IDataObjectUtils.cpp
            sdk/libPPUI/ImageEncoder.cpp
            sdk/libPPUI/InPlaceCombo.cpp
            sdk/libPPUI/InPlaceEdit.cpp
            sdk/libPPUI/InPlaceEditTable.cpp
            sdk/libPPUI/PaintUtils.cpp
            sdk/libPPUI/TypeFind.cpp
            sdk/libPPUI/clipboard.cpp
            sdk/libPPUI/commandline_parser.cpp
            sdk/libPPUI/gdiplus_helpers.cpp
            sdk/libPPUI/listview_helper.cpp
            sdk/libPPUI/stdafx.cpp
            sdk/libPPUI/win32_op.cpp
            sdk/libPPUI/win32_utility.cpp
            sdk/libPPUI/wtl-pp.cpp
    )
    add_library(ppui STATIC ${PPUI_SOURCES})
    target_include_directories(ppui PUBLIC
            "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/sdk/libPPUI>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/libPPUI>"
    )
    target_link_libraries(ppui PUBLIC pfc WTL::WTL)
    add_library(foosdk::ppui ALIAS ppui)
    target_compile_options(ppui PRIVATE "$<$<COMPILE_LANGUAGE:C,CXX>:/d2notypeopt>")
endif ()

set(SHARED_SOURCES
        sdk/foobar2000/shared/audio_math.cpp
        sdk/foobar2000/shared/crash_info.cpp
        sdk/foobar2000/shared/filedialogs.cpp
        sdk/foobar2000/shared/filedialogs_vista.cpp
        sdk/foobar2000/shared/font_description.cpp
        sdk/foobar2000/shared/minidump.cpp
        sdk/foobar2000/shared/modal_dialog.cpp
        sdk/foobar2000/shared/stdafx.cpp
        sdk/foobar2000/shared/systray.cpp
        sdk/foobar2000/shared/text_drawing.cpp
        sdk/foobar2000/shared/utf8.cpp
        sdk/foobar2000/shared/utf8api.cpp
        sdk/foobar2000/shared/Utility.cpp
)
if (APPLE)
    set(SHARED_SOURCES
            sdk/foobar2000/shared/audio_math.cpp
            sdk/foobar2000/shared/shared-apple.mm
            sdk/foobar2000/shared/shared-nix.cpp
            sdk/foobar2000/shared/stdafx.cpp
            sdk/foobar2000/shared/utf8.cpp
    )
endif ()
add_library(shared SHARED ${SHARED_SOURCES})
target_compile_definitions(shared PRIVATE SHARED_EXPORTS)
target_link_libraries(shared PUBLIC pfc foosdk)
target_include_directories(shared PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/sdk/foobar2000/shared>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/foobar2000/shared>"
)
if (APPLE)
    target_link_libraries(shared PUBLIC "$<LINK_LIBRARY:FRAMEWORK,AppKit>")
elseif (WIN32)
    target_link_libraries(shared PUBLIC Dbghelp Comctl32 UxTheme)
endif ()
add_library(foosdk::shared ALIAS shared)

if (WIN32)
    set(SAMPLE_SOURCES
            sdk/foobar2000/foo_sample/IO.cpp
            sdk/foobar2000/foo_sample/contextmenu.cpp
            sdk/foobar2000/foo_sample/decode.cpp
            sdk/foobar2000/foo_sample/dsp_sample.cpp
            sdk/foobar2000/foo_sample/foo_sample.rc
            sdk/foobar2000/foo_sample/initquit.cpp
            sdk/foobar2000/foo_sample/input_raw.cpp
            sdk/foobar2000/foo_sample/listcontrol-advanced.cpp
            sdk/foobar2000/foo_sample/listcontrol-ownerdata.cpp
            sdk/foobar2000/foo_sample/listcontrol-simple.cpp
            sdk/foobar2000/foo_sample/main.cpp
            sdk/foobar2000/foo_sample/mainmenu-dynamic.cpp
            sdk/foobar2000/foo_sample/mainmenu.cpp
            sdk/foobar2000/foo_sample/playback_state.cpp
            sdk/foobar2000/foo_sample/playback_stream_capture.cpp
            sdk/foobar2000/foo_sample/preferences.cpp
            sdk/foobar2000/foo_sample/rating.cpp
            sdk/foobar2000/foo_sample/ui_and_threads.cpp
            sdk/foobar2000/foo_sample/ui_element.cpp
            sdk/foobar2000/foo_sample/ui_element_dialog.cpp
    )
    list(APPEND SAMPLE_SOURCES ${SAMPLE_SOURCES_WINDOWS})
elseif (APPLE)
    set(SAMPLE_SOURCES
            sdk/foobar2000/foo_sample/IO.cpp
            sdk/foobar2000/foo_sample/Mac/fooSampleDSPView.mm
            sdk/foobar2000/foo_sample/Mac/fooSampleMacPreferences.mm
            sdk/foobar2000/foo_sample/contextmenu.cpp
            sdk/foobar2000/foo_sample/decode.cpp
            sdk/foobar2000/foo_sample/dsp_sample.cpp
            sdk/foobar2000/foo_sample/initquit.cpp
            sdk/foobar2000/foo_sample/input_raw.cpp
            sdk/foobar2000/foo_sample/main.cpp
            sdk/foobar2000/foo_sample/mainmenu-dynamic.cpp
            sdk/foobar2000/foo_sample/playback_stream_capture.cpp
            sdk/foobar2000/foo_sample/preferences.cpp
            sdk/foobar2000/foo_sample/rating.cpp
            sdk/foobar2000/foo_sample/ui_and_threads.cpp
            sdk/foobar2000/helpers-mac/NSView+embed.m
            sdk/foobar2000/helpers-mac/fooDecibelFormatter.m
    )
endif ()
add_library(foo_sample MODULE ${SAMPLE_SOURCES})
target_include_directories(foo_sample PRIVATE
        sdk/foobar2000/foo_sample
)
target_link_libraries(foo_sample PRIVATE foosdk helpers shared)
if (APPLE)
    set_target_properties(foo_sample PROPERTIES BUNDLE ON BUNDLE_EXTENSION component)
    target_link_libraries(foo_sample PRIVATE "$<LINK_LIBRARY:FRAMEWORK,Cocoa>")
elseif (WIN32)
    target_link_libraries(foo_sample PRIVATE ppui)
endif ()

