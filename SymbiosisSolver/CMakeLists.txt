cmake_minimum_required(VERSION 3.10)
project(SymbiosisSolver)

set(CMAKE_CXX_STANDARD 11)

include_directories(.)

add_executable(SymbiosisSolver
        AtomicityUnit.h
        ConstraintModelGenerator.cpp
        ConstraintModelGenerator.h
        Fix.h
        GraphvizGenerator.cpp
        GraphvizGenerator.h
        JPFParser.cpp
        JPFParser.h
        KQueryParser.cpp
        KQueryParser.h
        LEGraph.h
        main.cpp
        Operations.cpp
        Operations.h
        Parameters.cpp
        Parameters.h
        Schedule.cpp
        Schedule.h
        Types.cpp
        Types.h
        Util.cpp
        Util.h
        Z3Solver.cpp
        Z3Solver.h)
