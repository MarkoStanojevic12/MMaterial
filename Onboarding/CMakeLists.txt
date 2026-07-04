qt_add_qml_module(OnboardingLib
    URI MMaterial.Onboarding
    VERSION 1.0
    STATIC
    QML_FILES
        Tour.qml
        TourStep.qml
        Highlight.qml
)

set_target_properties(OnboardingLib PROPERTIES AUTOMOC ON)
target_link_libraries(OnboardingLib PRIVATE Qt6::Quick)

target_compile_definitions(OnboardingLib PRIVATE QT_QUICKCONTROLS_MATERIAL_STYLE)
