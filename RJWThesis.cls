\newcommand{\docdate}{}
\newcommand{\filedate}{}
\newcommand{\fileversion}{}
\renewcommand{\docdate}{2003/04/04}
\renewcommand{\filedate}{2003/04/04}
\renewcommand{\fileversion}{0.1}

\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{RJWThesis}%
[\filedate\space v\fileversion\space RJW Thesis Class class]

\LoadClassWithOptions{book}

\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{ifthen}
\RequirePackage{color}
\RequirePackage{amssymb}
\RequirePackage{sectsty}
\RequirePackage{eso-pic}

\newcommand{\chapnum@fontname}{ptm}
\DeclareOption{sabonnumbers}{\renewcommand{\chapnum@fontname}{psb}}

\ProcessOptions

%% Lengths

% Width of the page decoration bars.
\newlength{\pagedecorationwidth}
\setlength{\pagedecorationwidth}{0.05\paperwidth}
\def\rulewidth{1pt}

% Margin to offset decoration by
\newlength{\decorationoffset}
\setlength{\decorationoffset}{0pt}

% Standard lengths
\renewcommand{\headrulewidth}{0pt}

%% Colours
\definecolor{CambridgeLightBlue}{rgb}{0.6,0.8,1.0}
\definecolor{CambridgeDeepBlue}{rgb}{0,0.2,0.4}
\definecolor{CambridgeGreen}{rgb}{0,0.2,0}
\definecolor{CambridgeBurgandy}{rgb}{0.2,0,0}
\definecolor{CambridgeRed}{rgb}{0.8,0.0,0}
\definecolor{CambridgeYellow}{rgb}{1,0.8,0}
\definecolor{White}{rgb}{1,1,1}
\definecolor{Black}{rgb}{0,0,0}

\definecolor{CambridgePastelRed}{rgb}{1.0,0.5,0.5}

\def\title@colour{Black}
\def\subtitle@colour{Black}
\def\thanks@colour{Black}
\def\date@colour{Black}
\def\author@colour{Black}
\def\quote@colour{CambridgeDeepBlue}
\def\dedication@colour{CambridgeDeepBlue}
\def\chaphead@colour{Black}
\def\chaprule@colour{CambridgeDeepBlue}
\def\chapbackground@colour{White}
\def\chapnum@colour{CambridgeDeepBlue}
\def\pagenumber@colour{CambridgeDeepBlue}
\def\pagefooter@colour{CambridgeDeepBlue}
\def\section@colour{CambridgeRed}
\def\subsection@colour{CambridgeDeepBlue}
\def\cph@colour{CambridgeDeepBlue}
\def\cpb@colour{CambridgeDeepBlue}

%% Custom title page fields
\def\sub@title{} \def\subtitle#1{\def\sub@title{#1}}
\def\@group{\ } \def\group#1{\def\@group{#1}}
\def\@department{\ } \def\department#1{\def\@department{#1}}

%% Line spacing
\def\baselinestretch{1.5}

%% Fonts
\def\title@font{\LARGE\sc\bfseries}
\def\subtitle@font{\normalsize}
\def\thanks@font{\large\em}
\def\date@font{\large}
\def\author@font{\Large}
\def\quote@font{\small\sf\em}
\def\dedication@font{\Large\em}
\def\chaphead@font{\sf\bfseries\LARGE}
\def\pagenumber@font{\sf\bfseries\itshape\small}
\def\pagefooter@font{\sf\bfseries\itshape\small}
\def\section@font{\sf\bfseries\Large}
\def\subsection@font{\sf\bfseries}
\def\chapnum@font{\usefont{T1}{\chapnum@fontname}{b}{n}\fontsize{100}{130}\selectfont}
\def\cph@font{\sf\bfseries\small}
\def\cpb@font{\sf\small}

%% Set the geometry.
\geometry{inner=10em,outer=8em}
\geometry{top=0.05\paperheight,bottom=0.12\paperheight}
\geometry{nohead,foot=0.07\paperheight}

\def\dedication#1{%
  {\centering%
    \vspace*{0.2\textheight}\par%
    \hskip -1in \hskip -\oddsidemargin%
    \parbox{\paperwidth}{%
      \centering%
      \dedication@font\textcolor{\dedication@colour}{#1}%
    }%
  }%
}

% Set page header, footer
\pagestyle{fancy}\fancyhead{}\fancyfoot{}%
\fancyfoot[RO,LE]{\pagenumber@font\textcolor{\pagenumber@colour}{\thepage}}%

%% Section headings etc.

% We have to do it this way because pdflatex sometimes screws up
% the colour of text if we do it the sensible way.
\newcommand{\sect@format}[1]{%
  \noindent\protect{%
    \@tempdima=\hsize
    \parbox{\@tempdima}{%
      \smallskip\section@font%
      \textcolor{\section@colour}{#1}\smallskip
    }%
  }%
}%
\sectionfont{\sect@format}
\newcommand{\subsect@format}[1]{%
  \noindent\protect{%
    \@tempdima=\hsize
    \parbox{\@tempdima}{%
      \smallskip\subsection@font%
      \textcolor{\subsection@colour}{#1}\smallskip
    }%
  }%
}%
\subsectionfont{\subsect@format}

% Make section numbers appear in margin
\def\@seccntformat#1{\protect\makebox[0pt][r]{\csname the#1\endcsname\quad}}

%% Background picture
\AtBeginDocument{
\newlength{\flashheight}
\setlength{\flashheight}{0.67\paperheight}
\setlength\unitlength{1mm}%
}
\def\pagedec@skip{}
\AddToShipoutPicture{%
  \def\pagedec@skip{\hskip \paperwidth \hskip -\pagedecorationwidth \hskip -\decorationoffset}
  \def\flash@width{\pagedecorationwidth}
  \if@twoside
    \ifodd\c@page
      % nothing
    \else
      \def\pagedec@skip{\hskip \decorationoffset}
      \def\flash@width{-\pagedecorationwidth}
    \fi
  \fi        
  \AtPageLowerLeft{\pagedec@skip\includegraphics[width=\flash@width,height=\flashheight]{page_flash}}
}

%% Quotes for fancy chapter headings.
\newsavebox{\@quotebox}
\newcommand{\i@printquote}{%
  \usebox{\@quotebox}
%  \vbox to\z@{\copy\@quotebox\vss}
  \global\let\@printquote\relax
}
\global\let\@printquote\relax
\newenvironment{savequote}[1][0.33\paperwidth]{%
  \begin{lrbox}{\@quotebox}%
    \def\baselinestretch {1.1}%
    \begin{minipage}[t]{#1}%
      \raggedright\color{\quote@colour}\quote@font
}{%
      \unskip%
      \end{minipage}%
    \end{lrbox}%
    \global\setbox\@quotebox\copy\@quotebox
    \global\let\@printquote\i@printquote
}%
\newcommand{\qauthor}[1]{%
  \par\smallskip
  {\raggedleft\upshape #1\qquad\hbox{}\par}\bigskip}

\newcommand{\quoteperson}[2]{%
  {\@hangfrom{``}{#1''}\par\nobreak}{\raggedleft --- \emph{#2}\par\nobreak}%
}

%% Chapter headings
\newsavebox{\chap@savetitle}
\newlength{\chapheadwidth}
\newlength{\chapnumheight}
\newlength{\chapflash@width}

\AtBeginDocument{
\setlength{\chapheadwidth}{\paperwidth}
\addtolength{\chapheadwidth}{-1in}
\addtolength{\chapheadwidth}{-\oddsidemargin}
\addtolength{\chapheadwidth}{-3\pagedecorationwidth}

\setlength{\chapflash@width}{\paperwidth}
\addtolength{\chapflash@width}{-2\decorationoffset}
}

\renewcommand{\@makechapterhead}[1]{%
  \fancyfoot[RE]{\pagefooter@font\textcolor{\pagefooter@colour}{%
  \parbox[t]{0.6\paperwidth}{\raggedleft #1}%
  }}%
  \fancyfoot[LO]{\pagefooter@font\textcolor{\pagefooter@colour}{%
  \parbox[t]{0.6\paperwidth}{\raggedright #1}%
  }}%
  \relax\rule{0pt}{0pt}\par%
  \vskip -\topmargin \vskip -\headsep \vskip -\headheight %
  \vskip -1in %
  \vskip 0.33\paperheight %
  \vskip -0.5\baselineskip %
  \AddToShipoutPicture*{%
    \setlength\unitlength{\paperheight}%
    \AtPageUpperLeft{%
      % Background splash
      \put(0,-0.33){%
        \color{\chapbackground@colour}%
        \rule{\paperwidth}{0.33\paperheight}%
      }%
      % Flash
      \put(0,-0.33){%
        \hskip \decorationoffset %
        \includegraphics[width=\chapflash@width,height=0.33\paperheight]{chapter_flash}
      }%
      % Quote
      \put(0,-0.05){%
        \hspace{0.05\paperwidth}%
        \@printquote%
      }%
      % Title
      \put(0,-0.3){%
        \hspace{1in}\hspace{\oddsidemargin}%
        \def\baselinestretch{1.0}%
        \parbox[b]{\chapheadwidth}{%
          \raggedright%
          \chaphead@font\textcolor{\chaphead@colour}{#1}%
        }%
      }%
      % Rule
      \put(0,-0.33){%
        \color{\chaprule@colour}\rule{\paperwidth}{\rulewidth}%
      }%
    }%
  }%
  % Only draw number if necessary
  \ifnum \c@secnumdepth >\m@ne%
    \if@mainmatter%
      \AddToShipoutPicture*{%
        \setlength\unitlength{\paperheight}%
        \AtPageUpperLeft{
          \put(0,-0.05){%
            \parbox{\paperwidth}{%
              \settoheight{\chapnumheight}{%
                \chapnum@font\thechapter%
              }\vskip \chapnumheight%
              \raggedleft\chapnum@font\textcolor{\chapnum@colour}\thechapter%
              \hspace*{\pagedecorationwidth}%
              \hspace*{\decorationoffset}%
            }
          }
        }
      }
    \fi%
  \fi%
  \thispagestyle{empty}%
}

\renewcommand{\@makeschapterhead}[1]{%
  {\let\c@secnumdepth\m@ne\@makechapterhead{#1}}}

%% Title page

\def\thanks#1{\\{\thanks@font\textcolor{\thanks@colour}{#1}}}
\def\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi\space%
  \number\year}

\newlength{\title@height}
\newlength{\title@offset}
\def\maketitle{%
  \begin{titlepage}
    \AddToShipoutPicture*{%
      \setlength\unitlength{\paperheight}%
      \AtPageLowerLeft{%
        \color{White}\rule{\paperwidth}{\paperheight}%
      }%
      %\AtPageLowerLeft{%
      %  \put(0,0.6){%
      %    \hskip \decorationoffset%
      %    \includegraphics[width=\chapflash@width,height=0.17\paperheight]{chapter_flash}%
      %  }%
      %}%
      \AtPageLowerLeft{%
        \put(0,0.6){\color{CambridgeLightBlue}\rule{\paperwidth}{0.17\paperheight}}%
      }%
      \AtPageLowerLeft{
        \put(0,0.05){%
          \hspace*{\pagedecorationwidth}%
          \parbox{0.5\paperwidth}{%
            \def\baselinestretch{1.0}
            {\sc\large\bfseries \@group\newline\@department}
          }
        }%
        \put(0,0.05){%
          \parbox{\paperwidth}{%
            \raggedleft%
            \includegraphics[height=0.05\paperheight]{CUnibig}%
            \hspace*{\pagedecorationwidth}%
          }%
        }%
        \put(0,0.10){%
          \textcolor{CambridgeDeepBlue}{\rule{\paperwidth}{\rulewidth}}%
        }%
        \put(0,0.6){%
          \hspace*{0.15\paperwidth}%
          \def\baselinestretch{1.3}%
          \settoheight{\title@height}{%
            \parbox[b]{0.7\paperwidth}{\centering\title@font\@title}%
          }%
          \setlength{\title@offset}{0.085\paperheight}%
          \addtolength{\title@offset}{-0.5\title@height}%
          \parbox[b]{0.7\paperwidth}{%
            \centering\title@font\textcolor{\title@colour}{\@title}%
            \vspace*{\title@offset}%
          }%
        }%
        \put(0,0.565){%
          \parbox[t]{\paperwidth}{%
            \def\baselinestretch{1.0}%
            \centering%
            {\author@font\textcolor{\author@colour}{%
            \begin{tabular}[t]{c}%
            \@author\end{tabular}
            }}
            \par\vspace*{1.0\baselineskip}%
            {\date@font\textcolor{\date@colour}{\@date}}%
            \par%
            \textcolor{CambridgeDeepBlue}{\rule{\paperwidth}{\rulewidth}}
            \par\vspace*{0.5\baselineskip}%
            \def\baselinestretch{1.3}%
            {\subtitle@font\textcolor{\subtitle@colour}{\sub@title}\par}%
          }%
        }%
        \put(0,0.6){%
          \textcolor{CambridgeDeepBlue}{\rule{\paperwidth}{\rulewidth}}%
        }%
        \put(0,0.77){%
          \textcolor{CambridgeDeepBlue}{\rule{\paperwidth}{\rulewidth}}%
        }%
      }%
    }
    \vfil\null
  \end{titlepage}%
}


%% Fancy captions
\long\def\@makecaption#1#2{%
 \vskip\abovecaptionskip\hrule\vskip\abovecaptionskip%
 \setbox\@tempboxa\hbox{{\cph@font\textcolor{\cph@colour}{#1: }}%
   {\cpb@font\textcolor{\cpb@colour}{#2}}}%
 \ifdim \wd\@tempboxa >\hsize
    \@hangfrom{{\cph@font\textcolor{\cph@colour}{#1: }}}%
    {{\cpb@font\textcolor{\cpb@colour}{#2}}\par}%
 \else
    \hbox to\hsize{\hfil\box\@tempboxa\hfil}%
 \fi
 \vskip\abovecaptionskip\hrule%
 \vskip\belowcaptionskip}

