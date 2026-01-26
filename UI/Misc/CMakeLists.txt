qt_add_qml_module(MiscLib
    URI MMaterial.UI.Misc
    VERSION 1.0
    STATIC
    QML_FILES
        Battery.qml
)

set_target_properties(MiscLib PROPERTIES AUTOMOC ON)
target_link_libraries(MiscLib PRIVATE Qt6::Quick)

target_compile_definitions(MiscLib PRIVATE QT_QUICKCONTROLS_MATERIAL_STYLE)
