\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{THUExam}[2018/06/29 v1.0 An exam class for THU]

% 是否显示答案
\newif\ifanswer

\DeclareOption{answer}{\answertrue}
\DeclareOption{noanswer}{\answerfalse}

%其它选项
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexart}}

%不可省略
\ProcessOptions

\ExecuteOptions{answer}






% 四号  小四号 五号    小五号
% 14bp  12bp    10.5bp  9bp
\LoadClass[zihao=-4,UTF8]{ctexart}

\RequirePackage[a4paper,left=15mm,right=15mm,top=25mm,bottom=25mm]{geometry}
\RequirePackage{amsmath,amssymb}
\RequirePackage{unicode-math}
\RequirePackage{multirow}
\RequirePackage{lastpage}
\RequirePackage{fancyhdr}
\RequirePackage{comment}
% \RequirePackage{environ}
\RequirePackage{calc}
\RequirePackage{graphicx}
\RequirePackage{ifthen}
\RequirePackage[shortlabels]{enumitem}
\RequirePackage{xeCJK}
\RequirePackage{makecell}
\RequirePackage{tabularx}
% \RequirePackage{zref-lastpage}
\RequirePackage{tikz}

\RequirePackage{hyperref}
\AtBeginDocument{%
  \hypersetup{
    pdfinfo={
      Title    = {\@title},
      Author   = {\@author},
      Subject  = {\THU@Subject},
      Keywords = {\THU@Keywords},
    },
  }
}
\setlength{\parindent}{0em}
\setlength{\lineskiplimit}{3pt}
\setlength{\lineskip}{3pt}

\newcommand{\Subject}[1]{\def\THU@Subject{#1}}
\newcommand{\Keywords}[1]{\def\THU@Keywords{#1}}
\newcommand{\Year}[1]{\def\THU@Year{#1}}
\newcommand{\Semester}[1]{\def\THU@Semester{#1}}
\newcommand{\Time}[1]{\def\THU@Time{#1}}
\newcommand{\Course}[1]{\def\THU@Course{#1}}
\newcommand{\Type}[1]{\def\THU@Type{#1}}

\newcommand{\underspace}[1]{\underline{\hspace{#1}}}


\newcounter{SubColumn}
\newcounter{EmptyColumn}



% 试卷头制作
\newcommand{\makehead}{
  \begin{center}
    \parbox{\textwidth}{\centering \large \bfseries 清华大学 \THU@Year 学年 \THU@Semester 学期 
 \THU@Course  \, （\THU@Type\,卷 \ifanswer{解析}\fi）}

    \vspace{1em}
    \THU@Time ~  班级 \hrulefill~
    姓名 \hrulefill~  学号 \hrulefill\mbox{}\\
    \vspace{0.5em}
\small（注: 选择、判断、填空题的解答直接写在这张试题纸上，该试题纸一并上交。其他题目写在答题本上）
    \vspace*{-2em}
  \end{center}
}


\newcommand{\my@foottext}{\THU@Course 试卷 \ifanswer{解析}\fi \quad 第~\thepage~页~共~\pageref{LastPage}~页}


% 去掉页眉下划线
%\renewcommand{\headrulewidth}{0pt}
% 装订线页眉外侧超宽6em
%\cfoot{\small\my@foottext}

\renewcommand{\headrulewidth}{0pt}
% 装订线页眉外侧超宽6em
\fancyheadoffset[L]{6em}
\fancyhf{}
\pagestyle{fancy}
\cfoot{\small\my@foottext}



\newcounter{problem}

\newcommand{\makepart}[2]{
  \setcounter{problem}{0}
  \stepcounter{section}
  \vspace{1em}
  \textbf{\Chinese{section}、#1}(#2)
  \vspace{1em}
}


\newcommand{\answer}[1]{
  \ifanswer{\textcolor{red}{#1}}\else\hphantom{#1}\fi
}

\newcommand{\fillin}[1]{
  \underline{\hspace{0.5em}\answer{#1}\hspace{0.5em}}
}

\newcommand{\pickout}[1]{
  \hfill【\makebox[1.5em]{\answer{#1~}}】
}

\newcommand{\pickin}[1]{
  【\makebox[1.5em]{\answer{#1~}}】
}

\newcommand{\ignorepars}{\@ifnextchar\par{\expandafter\ignorepars\@gobble}{}}

\newenvironment{problemreal}{
  \stepcounter{problem}
  \arabic{problem}.\ignorespaces
}{\par}
\newenvironment{solutionreal}{\color{red}\textsf{解}\quad\ignorepars}{\ifanswer\hfill\ensuremath{\square}\bigskip\fi\par}
\newenvironment{proofreal}{\color{red}\textsf{证明}\quad\ignorepars}{\ifanswer\hfill\ensuremath{\square}\bigskip\fi\par}
\newenvironment{notereal}{\color{blue}\textsf{注}\quad\ignorepars}{\ifanswer\hfill\bigskip\fi\par}

\newenvironment{problem}{\problemreal}{\endproblemreal}
\newenvironment{solution}{\solutionreal}{\endsolutionreal}
\newenvironment{proof}{\proofreal}{\endproofreal}
\newenvironment{note}{\notereal}{\endnotereal}

% 增加只在试卷里面换页的命令
\newcommand{\mynewpage}{\ifanswer\else\newpage\fi}
\newcommand{\myvfill}{\ifanswer\else\vfill\fi}
\newcommand{\vempty}[1]{\ifanswer\else\vspace*{#1}\fi}

\AtBeginDocument{
  \ifanswer\else
    \excludecomment{solution}
    \excludecomment{proof}
    \excludecomment{note}
  \fi
}

\newlength{\xxla}
\newlength{\xxlb}
\newlength{\xxlc}
\newlength{\xxld}
\newlength{\lhalf}
\newlength{\lquarter}
\newlength{\lmax}

\newcommand{\options}[4]{
  \par
  \settowidth{\xxla}{(A)~#1~~~}
  \settowidth{\xxlb}{(B)~#2~~~}
  \settowidth{\xxlc}{(C)~#3~~~}
  \settowidth{\xxld}{(D)~#4~~~}

  \ifthenelse{\lengthtest{\xxla>\xxlb}}{\setlength{\lmax}{\xxla}}{\setlength{\lmax}{\xxlb}}
  \ifthenelse{\lengthtest{\xxlc>\lmax}}{\setlength{\lmax}{\xxlc}}{}
  \ifthenelse{\lengthtest{\xxld>\lmax}}{\setlength{\lmax}{\xxld}}{}
  \setlength{\lhalf}{0.5\linewidth}
  \setlength{\lquarter}{0.25\linewidth}
  \ifthenelse{\lengthtest{\lmax>\lhalf}}
  {
    \begin{enumerate}[label=(\Alph*),parsep=0ex,itemsep=0ex,leftmargin=2em, topsep=0ex]
      \item #1
      \item #2
      \item #3
      \item #4
    \end{enumerate}
  }
  {
    \ifthenelse{\lengthtest{\lmax>\lquarter}}
    {
      \makebox[\lhalf][l]{(A)~#1~~~}%
      \makebox[\lhalf][l]{(B)~#2~~~}%

      \makebox[\lhalf][l]{(C)~#3~~~}%
      \makebox[\lhalf][l]{(D)~#4~~~}%
    }
    {
      \makebox[\lquarter][l]{(A)~#1~~~}%
      \makebox[\lquarter][l]{(B)~#2~~~}%
      \makebox[\lquarter][l]{(C)~#3~~~}%
      \makebox[\lquarter][l]{(D)~#4~~~}%
    }
  }
}