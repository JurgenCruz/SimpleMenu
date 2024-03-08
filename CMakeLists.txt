cmake_minimum_required(VERSION 3.16)

project(plasmoid-simplemenu) #VERSION ${PROJECT_VERSION})

#set(QT_NO_CREATE_VERSIONLESS_FUNCTIONS 1)
set(QT_MAJOR_VERSION "6")
set(INTERFACE_QT_MAJOR_VERSION 6)

find_package(ECM 6.0.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})
find_package(Qt6 COMPONENTS CoreTools CONFIG)
if (TARGET Qt6::qtpaths)
    get_target_property(_qtpaths_executable Qt6::qtpaths LOCATION)
    set(QUERY_EXECUTABLE ${_qtpaths_executable} CACHE FILEPATH "Location of the Qt6 qtpaths executable" FORCE)
    message("${_qtpaths_executable} ${QUERY_EXECUTABLE}")
endif ()
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(FeatureSummary)

find_package(Qt6 CONFIG REQUIRED COMPONENTS
        Qml
        Core
)

find_package(Plasma REQUIRED)

plasma_install_package(package com.github.jurgencruz.simplemenu)

add_subdirectory(plugin)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)