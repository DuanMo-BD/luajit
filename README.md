# luajit

## 通过Visual Studio编译调试luajit

<ins>**1. 下载仓库内容:**</ins>

git clone --recursive https://github.com/DuanMo-BD/luajit.git

<ins>**2. 下载premake5:**</ins>

https://github.com/premake/premake-core/releases

将premake5.exe放到../premake/目录下

```
│   README.md
|
└───premake
│   │   
│   │   Win-GenProjects.bat
│   │   premake5.exe
```

<ins>**3. 编译:**</ins>

1. 运行premake/Win-GenProjects.bat生成解决方案luajit.sln
2. IDE打开sln
3. 编译minilua项目
4. 编译buildvm项目
5. 运行premake/Win-GenProjects.bat重新生成解决方案
6. 编译lua51项目
7. 编译luajit项目

<ins>**4. 运行 & 调试:**</ins>

1. 确保启动项目为luajit
2. 开始调试(F5)

## Visual Studio版本

* 默认版本VS2019
* 使用其它VS版本，可以修改../premake/Win-GenProjects.bat `call premake\premake5.exe vs2019`中的vs2019，以vs2022为例，修改结果为`call premake\premake5.exe vs2022`