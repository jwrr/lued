cmake_minimum_required(VERSION 2.8)
project(lued_prj)

set (CMAKE_BUILD_TYPE Release)
#set (CMAKE_BUILD_TYPE Debug)

include_directories(src src/lua/src src/carr/src)
set (CMAKE_C_FLAGS "-std=gnu99")
file(GLOB SRC src/*.c src/lua/src/*c src/carr/src/*c)
add_definitions(-DLUA_USE_POSIX)
add_executable(lued ${SRC})
target_link_libraries(lued m)



