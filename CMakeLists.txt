cmake_minimum_required(VERSION 3.16)

project(plasmoid-simplemenu)

set(BUILD_WITH_QT6 "6")

find_package(ECM 6.0.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})
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