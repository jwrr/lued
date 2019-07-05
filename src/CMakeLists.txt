cmake_minimum_required(VERSION 2.8)
set (CMAKE_C_FLAGS "-std=c99")
add_executable(lued lued.c main.c)
target_link_libraries(lued carr lua m dl)
