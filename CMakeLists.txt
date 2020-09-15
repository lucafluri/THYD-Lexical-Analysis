cmake_minimum_required(VERSION 3.14)
project(TPLexer)

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_CXX_FLAGS "${CMAKE_CPP_FLAGS} -Wall -Wno-conversion -Wno-unused-function -Wno-register -Wno-deprecated-register")

find_package(FLEX)
FLEX_TARGET(Flexer flexer.l ${CMAKE_CURRENT_BINARY_DIR}/../flexer.cpp)

include_directories(.)

set(SOURCE_FILES
        main.cpp
        common.h
        language.h
        language.cpp
        lexer.h
        hlexer.h
        hlexer.cpp
        flexer.h
        ${FLEX_Flexer_OUTPUTS})

add_executable(TPLexer ${SOURCE_FILES})
