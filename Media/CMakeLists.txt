list(APPEND QML_ICON_SINGLETONS
    IconFont.qml
    Icons.qml
    Images.qml
)

list(APPEND ICON_ASSETS
    assets/icomoon.ttf
    assets/style.css
    assets/light-icons.default.json
)

set_source_files_properties(
    ${QML_ICON_SINGLETONS}
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(MediaLib
    URI MMaterial.Media
    VERSION 1.0
    STATIC
    QML_FILES
        ${QML_ICON_SINGLETONS}
        Icon.qml
        LightIcon.qml
        HeavyIcon.qml
        IconBase.qml
        IconSet.qml

    SOURCES
        src/TextFileReader.h src/TextFileReader.cpp
        src/LightIconMap.h src/LightIconMap.cpp
        src/IconData.h src/IconData.cpp

    RESOURCES ${ICON_ASSETS}
)

target_include_directories(MediaLib PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

set_target_properties(MediaLib PROPERTIES AUTOMOC ON)
target_link_libraries(MediaLib PRIVATE Qt6::Quick)

target_compile_definitions(MediaLib PRIVATE QT_QUICKCONTROLS_MATERIAL_STYLE)

qt_add_resources(MediaLib
    "mmaterial_icon_assets"
    BASE "${CMAKE_CURRENT_SOURCE_DIR}"
    PREFIX "MMaterial"
    BIG_RESOURCES
    FILES
        ${ICON_ASSETS}
)
