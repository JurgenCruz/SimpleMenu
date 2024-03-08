add_definitions(-DTRANSLATION_DOMAIN=\"com.github.jurgencruz.simplemenu\")
set(simplemenuplugin_SRCS
        flattener.cpp
        proxylistmodel.cpp
        simplemenuplugin.cpp
        delegateinfo.cpp
        categorylistmodel.cpp
        categorylistmodel.h
)
add_library(simplemenuplugin SHARED ${simplemenuplugin_SRCS})

target_link_libraries(simplemenuplugin
        Qt::Core
        Qt::Qml
        # KF6::Plasma
        # KF6::I18n
)

install(TARGETS simplemenuplugin DESTINATION ${KDE_INSTALL_QMLDIR}/com/github/jurgencruz/simplemenu)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/com/github/jurgencruz/simplemenu)