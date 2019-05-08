# Lued CMakeLists.txt

cmake_minimum_required(VERSION 2.8)

project(lued_src)

add_executable(lued lued.c main.c)
target_link_libraries(lued carr lua m dl)
install(TARGETS lued RUNTIME DESTINATION bin)

