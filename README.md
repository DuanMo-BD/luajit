# luajit

<ins>**1. 下载仓库内容:**</ins>

git clone --recursive https://github.com/DuanMo-BD/luajit.git

<ins>**2. 下载premake5:**</ins>

https://github.com/premake/premake-core/releases

将premake5.exe放到luajit/premake/目录下

```
luajit
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