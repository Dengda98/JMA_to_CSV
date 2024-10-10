从日本气象厅(JMA)归档的地震目录文件中提取主要信息转为csv格式的简易**FORTRAN**小程序，方便我后续使用别的工具处理。    
A simple **FORTRAN** small program that extracts the main information from the earthquake catalog files archived by the Japan Meteorological Agency (JMA) into csv format.

关于JMA归档的地震目录文件的下载([Download](https://www.data.jma.go.jp/svd/eqev/data/bulletin/hypo_e.html))以及格式说明([Format](https://www.data.jma.go.jp/svd/eqev/data/bulletin/data/format/hypfmt_e.html))可点击链接查看。  

程序简短，可根据需求更改。

## 使用示例

+ 编译 

``` bash 
    gfortran JMA2CSV.F90 -o jma2csv
```

+ 下载JMA地震目录文件
``` bash
    wget "https://www.data.jma.go.jp/svd/eqev/data/bulletin/data/hypo/h2008.zip"
    unzip h2008.zip
```

+ 使用

``` bash 
    # 两个文件名输入，分别为输入的原始JMA地震目录文件和输出的csv文件
    ./jma2csv h2008 my_h2008.csv
```
