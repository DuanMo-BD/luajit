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
minilua = "%{wks.location}/bin/%{outputconfig}/minilua/minilua"
buildvm = "%{wks.location}/bin/%{outputconfig}/buildvm/buildvm"
dasmdir = "%{wks.location}/LuaJIT/dynasm"
dasm = "%{dasmdir}/dynasm.lua"
hostdir = "%{srcdir}/host"
alllib = "%{srcdir}/lib_base.c %{srcdir}/lib_math.c %{srcdir}/lib_bit.c %{srcdir}/lib_string.c %{srcdir}/lib_table.c %{srcdir}/lib_io.c %{srcdir}/lib_os.c %{srcdir}/lib_package.c %{srcdir}/lib_debug.c %{srcdir}/lib_jit.c %{srcdir}/lib_ffi.c"
buildvmobjdir = "%{wks.location}/bin-int/%{outputconfig}/buildvm"
lua51bindir = "%{wks.location}/bin/%{outputconfig}/lua51"
lua51objdir = "%{wks.location}/bin-int/%{outputconfig}/lua51"

dasmflags = "-D WIN -D JIT -D FFI -D P64"
ljarch = "x64"

project "minilua"
    kind "ConsoleApp"
    language "c"

    targetdir ("%{wks.location}/bin/%{outputconfig}/%{prj.name}")
    objdir ("%{wks.location}/bin-int/%{outputconfig}/%{prj.name}")

    files
    {
        "LuaJIT/src/host/minilua.c"
    }

    defines
    {
        "_CRT_SECURE_NO_DEPRECATE",
        "_CRT_STDIO_INLINE=__declspec(dllexport)__inline"
    }

    postbuildcommands
    {
        "%{minilua} %{dasm} %{dasmflags} -o %{hostdir}/buildvm_arch.h %{srcdir}/vm_x86.dasc"
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

    targetdir ("%{wks.location}/bin/%{outputconfig}/%{prj.name}")
    objdir ("%{wks.location}/bin-int/%{outputconfig}/%{prj.name}")

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
        "_CRT_STDIO_INLINE=__declspec(dllexport)__inline"
    }

    postbuildcommands
    {
        "%{buildvm} -m peobj -o %{buildvmobjdir}/lj_vm.obj",
        "%{buildvm} -m bcdef -o %{srcdir}/lj_bcdef.h %{alllib}",
        "%{buildvm} -m ffedf -o %{srcdir}/lj_ffdef.h %{alllib}",
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

    targetdir ("%{wks.location}/bin/%{outputconfig}/%{prj.name}")
    objdir ("%{wks.location}/bin-int/%{outputconfig}/%{prj.name}")

    files
    {
        "LuaJIT/src/lj_*.c",
        "LuaJIT/src/lib_*.c",
        "LuaJIT/src/lj_*.h",
        "LuaJIT/src/lib_*.h",
    }

    includedirs
    {
        "LuaJIT/src"
    }

    defines
    {
        "_CRT_SECURE_NO_DEPRECATE",
        "_CRT_STDIO_INLINE=__declspec(dllexport)__inline",
        "LUA_BUILD_AS_DLL"
    }

    links
    {
        "%{buildvmobjdir}/lj_vm.obj"
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

    targetdir ("%{wks.location}/bin/%{outputconfig}/%{prj.name}")
    objdir ("%{wks.location}/bin-int/%{outputconfig}/%{prj.name}")

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
        "_CRT_STDIO_INLINE=__declspec(dllexport)__inline"
    }

    filter "system:windows"
        systemversion "latest"

    filter "configurations:Debug"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        runtime "Release"
        optimize "on"