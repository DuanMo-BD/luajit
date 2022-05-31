workspace "luajit"
    architecture "x86_64"
    startproject "luajit"

    configurations
    {
        "Debug",
        "Release"
    }

    flags
    {
        "MultiProcessorCompile"
    }

srcdir = "LuaJIT/src"
outputconfig = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"
dasmdir = "%{wks.location}/luajit/dynasm"
dasm = "%{dasmdir}/dynasm.lua"
hostdir = "%{srcdir}/host"
alllib = "%{srcdir}/lib_base.c %{srcdir}/lib_math.c %{srcdir}/lib_bit.c %{srcdir}/lib_string.c %{srcdir}/lib_table.c %{srcdir}/lib_io.c %{srcdir}/lib_os.c %{srcdir}/lib_package.c %{srcdir}/lib_debug.c %{srcdir}/lib_jit.c %{srcdir}/lib_ffi.c %{srcdir}/lib_buffer.c"

bindir = "%{wks.location}/bin/%{outputconfig}"
intdir = "%{wks.location}/bin-int/%{outputconfig}"

buildvm = "%{bindir}/buildvm"

dasmflags = "-D WIN -D JIT -D FFI -D P64"
ljarch = "x64"

project "minilua"
    kind "ConsoleApp"
    language "c"

    targetdir ("%{wks.location}/bin/%{outputconfig}")
    objdir ("%{wks.location}/bin-int/%{outputconfig}")

    files
    {
        "LuaJIT/src/host/minilua.c"
    }

    defines
    {
        "_CRT_SECURE_NO_DEPRECATE",
        "_CRT_STDIO_INLINE=__declspec(dllexport)__inline",
        "LUAJIT_ENABLE_GC64",
        "LUAJIT_ENABLE_LUA52COMPAT",
        "LUAJIT_ENABLE_CHECKHOOK",
        "LUA_USE_APICHECK",
    }

    postbuildcommands
    {
        "%{bindir}/minilua %{dasm} -LN %{dasmflags} -o %{hostdir}/buildvm_arch.h %{srcdir}/vm_x64.dasc"
    }

    filter "system:windows"
        systemversion "latest"

    filter "configurations:Debug"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        runtime "Release"
        optimize "on"

project "buildvm"
    kind "ConsoleApp"
    language "c"

    targetdir ("%{wks.location}/bin/%{outputconfig}")
    objdir ("%{wks.location}/bin-int/%{outputconfig}")

    files
    {
        "LuaJIT/src/host/buildvm*.c",
        "LuaJIT/src/lj_def.h",
        "LuaJIT/src/lj_arch.h"
    }

    includedirs
    {
        "LuaJIT/src"
    }

    defines
    {
        "_CRT_SECURE_NO_DEPRECATE",
        "_CRT_STDIO_INLINE=__declspec(dllexport)__inline",
        "LUAJIT_ENABLE_GC64",
        "LUAJIT_ENABLE_LUA52COMPAT",
        "LUAJIT_ENABLE_CHECKHOOK",
        "LUA_USE_APICHECK",
    }

    postbuildcommands
    {
        "%{buildvm} -m peobj -o %{intdir}/lj_vm.obj",
        "%{buildvm} -m bcdef -o %{srcdir}/lj_bcdef.h %{alllib}",
        "%{buildvm} -m ffdef -o %{srcdir}/lj_ffdef.h %{alllib}",
        "%{buildvm} -m libdef -o %{srcdir}/lj_libdef.h %{alllib}",
        "%{buildvm} -m recdef -o %{srcdir}/lj_recdef.h %{alllib}",
        "%{buildvm} -m vmdef -o %{srcdir}/jit/vmdef.h %{alllib}",
        "%{buildvm} -m folddef -o %{srcdir}/lj_folddef.h %{srcdir}/lj_opt_fold.c",
    }

    filter "system:windows"
        systemversion "latest"

    filter "configurations:Debug"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        runtime "Release"
        optimize "on"

project "lua51"
    kind "SharedLib"
    language "c"

    targetdir ("%{wks.location}/bin/%{outputconfig}")
    objdir ("%{wks.location}/bin-int/%{outputconfig}")

    files
    {
        "LuaJIT/src/lj_*.c",
        "LuaJIT/src/lib_*.c",
        "LuaJIT/src/*.h",
    }

    includedirs
    {
        "LuaJIT/src"
    }

    defines
    {
        "_CRT_SECURE_NO_DEPRECATE",
        "_CRT_STDIO_INLINE=__declspec(dllexport)__inline",
        "LUA_BUILD_AS_DLL",
        "LUAJIT_ENABLE_GC64",
        "LUAJIT_ENABLE_LUA52COMPAT",
        "LUAJIT_ENABLE_CHECKHOOK",
        "LUA_USE_APICHECK",
    }

    links
    {
        "%{intdir}/lj_vm.obj"
    }

    filter "system:windows"
        systemversion "latest"

    filter "configurations:Debug"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        runtime "Release"
        optimize "on"

project "luajit"
    kind "ConsoleApp"
    language "c"

    targetdir ("%{wks.location}/bin/%{outputconfig}")
    objdir ("%{wks.location}/bin-int/%{outputconfig}")

    files
    {
        "LuaJIT/src/luajit.c",
    }

    includedirs
    {
        "LuaJIT/src"
    }

    links
    {
        "lua51"
    }

    defines
    {
        "_CRT_SECURE_NO_DEPRECATE",
        "_CRT_STDIO_INLINE=__declspec(dllexport)__inline",
        "LUAJIT_ENABLE_GC64",
        "LUAJIT_ENABLE_LUA52COMPAT",
        "LUAJIT_ENABLE_CHECKHOOK",
        "LUA_USE_APICHECK",
    }

    filter "system:windows"
        systemversion "latest"

    filter "configurations:Debug"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        runtime "Release"
        optimize "on"