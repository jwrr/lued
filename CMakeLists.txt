cmake_minimum_required(VERSION 2.8)
project(lued_prj) 

SET(EXTERN_PATH ${CMAKE_CURRENT_BINARY_DIR}/extern)
SET(INSTALL_PATH ${CMAKE_CURRENT_BINARY_DIR}/install)

include(ExternalProject)

ExternalProject_Add (prj_lua52
  DOWNLOAD_NO_PROGRESS 1
  URL http://www.lua.org/ftp/lua-5.2.4.tar.gz
  BUILD_IN_SOURCE 1
  PREFIX ${EXTERN_PATH}/prj_lua52
  CONFIGURE_COMMAND ""
  BUILD_COMMAND make linux
  INSTALL_COMMAND make install INSTALL_TOP=${INSTALL_PATH}
)

ExternalProject_Add (prj_carr
  GIT_REPOSITORY https://github.com/jwrr/carr.git
  UPDATE_COMMAND ""
  PREFIX ${EXTERN_PATH}/prj_carr
  INSTALL_DIR ${INSTALL_PATH}
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH}
)

set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${INSTALL_PATH}/bin)
include_directories(${INSTALL_PATH}/include)
link_directories(${INSTALL_PATH}/lib)

add_subdirectory(src)
