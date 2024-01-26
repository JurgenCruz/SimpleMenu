cmake_minimum_required(VERSION 3.16)

project(plasmoid-simplemenu)

find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})
message("${CMAKE_MODULE_PATH}")
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(FeatureSummary)

find_package(Qt5 CONFIG REQUIRED COMPONENTS
        Core
        Qml
)

find_package(KF5 REQUIRED COMPONENTS
        Plasma
)

plasma_install_package(package com.github.jurgencruz.simplemenu)

add_subdirectory(plugin)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)