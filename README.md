# TinyTex
a mini texlive.
More indormation can be get https://github.com/yihui/tinytex/.

1. Change the Tsinghua mirror, https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet/

2. Set the intall dir as 'd:/TinyTex'

3. Add package ctex, then, we can use Chnese in the simlie way,just like this,

4. the totle zip can get in the baudu [], with [].
--------------------------------------
% 使用 pdflatex, xelatex 都可以编译通过
\documentclass[12pt, a4paper]{article}
\usepackage[UTF8]{ctex}

abcdefg, 就这。

\end{document}

--------------------------
