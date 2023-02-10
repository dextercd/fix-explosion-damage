cmake_minimum_required(VERSION 3.24)

project(fix-explosion-damage
    VERSION 1.0.0
    DESCRIPTION "Noita mod for fixing explosion damage display"
    HOMEPAGE_URL "https://github.com/dextercd/fix-explosion-damage"
    LANGUAGES # Empty
)

install(DIRECTORY fix-explosion-damage
    DESTINATION .
    COMPONENT fix-explosion-damage
)

set(CPACK_GENERATOR ZIP)
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY FALSE)
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
set(CPACK_VERBATIM_VARIABLES TRUE)
include(CPack)
