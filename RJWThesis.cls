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

\ProcessOptions

%% Lengths

% Width of the page decoration bars.
\newlength{\pagedecorationwidth}
\setlength{\pagedecorationwidth}{0.05\paperwidth}
\def\rulewidth{1pt}

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

\def\title@colour{CambridgeDeepBlue}
\def\author@colour{Black}
\def\chaphead@colour{CambridgeDeepBlue}
\def\chaprule@colour{CambridgeDeepBlue}
\def\chapbackground@colour{White}
\def\chapnum@colour{CambridgeDeepBlue}
\def\pagenumber@colour{CambridgeDeepBlue}
\def\pagefooter@colour{CambridgeDeepBlue}
\def\section@colour{CambridgeRed}
\def\subsection@colour{CambridgeDeepBlue}
\def\cph@colour{CambridgeDeepBlue}
\def\cpb@colour{CambridgeDeepBlue}

%% Line spacing
\def\baselinestretch{1.5}

%% Fonts
\def\title@font{\LARGE\sc\bfseries}
\def\author@font{\Large\bfseries}
\def\chaphead@font{\sf\bfseries\LARGE}
\def\pagenumber@font{\sf\bfseries\itshape\small}
\def\pagefooter@font{\sf\bfseries\itshape\small}
\def\section@font{\sf\bfseries\Large}
\def\subsection@font{\sf\bfseries}
\def\chapnum@font{\usefont{T1}{psb}{b}{n}\fontsize{100}{130}\selectfont}
\def\cph@font{\sf\bfseries\small}
\def\cpb@font{\sf\small}

%% Set the geometry.
\geometry{inner=10em,outer=7em}
\geometry{top=0.05\paperheight,bottom=0.12\paperheight}
\geometry{nohead,foot=0.07\paperheight}

% Set page header, footer
\pagestyle{fancy}\fancyhead{}\fancyfoot{}%
\fancyfoot[RO,LE]{\pagenumber@font\textcolor{\pagenumber@colour}{\thepage}}%
\renewcommand{\chaptermark}[1]{%
  \fancyfoot[RE]{\pagefooter@font\textcolor{\pagefooter@colour}{%
  \parbox[t]{0.6\paperwidth}{\raggedleft #1}%
  }}%
  \fancyfoot[LO]{\pagefooter@font\textcolor{\pagefooter@colour}{%
  \parbox[t]{0.6\paperwidth}{\raggedright #1}%
  }}%
}

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
\setlength\unitlength{1mm}%
\def\pagedec@skip{}
\AddToShipoutPicture{%
  \if@twoside
    \ifodd\c@page
      \def\pagedec@skip{\hskip \paperwidth \hskip -\pagedecorationwidth}
    \else
      \def\pagedec@skip{}
    \fi
  \else
    \def\pagedec@skip{\hskip \paperwidth \hskip -\pagedecorationwidth}
  \fi        
  \AtPageLowerLeft{\pagedec@skip%
    \color{CambridgeRed}\rule{\pagedecorationwidth}{0.67\paperheight}}
  \AtPageLowerLeft{\pagedec@skip%
    \color{CambridgeDeepBlue}\rule{\pagedecorationwidth}{0.5\paperheight}}
}

%% Chapter headings
\newsavebox{\chap@savetitle}
\newlength{\chapheadwidth}
\setlength{\chapheadwidth}{\paperwidth}
\addtolength{\chapheadwidth}{-1in}
\addtolength{\chapheadwidth}{-\oddsidemargin}
\addtolength{\chapheadwidth}{-3\pagedecorationwidth}
\newlength{\chapnumheight}
\renewcommand{\@makechapterhead}[1]{%
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
      % Title
      \put(0,-0.3){%
        \hspace{1in}\hspace{\oddsidemargin}%
        \def\baselinestretch{1.0}%
        \parbox[b]{\chapheadwidth}{%
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
          \put(0,-0.1){%
            \parbox{\paperwidth}{%
              \settoheight{\chapnumheight}{%
                \chapnum@font\thechapter%
              }\vskip \chapnumheight%
              \raggedleft\chapnum@font\textcolor{\chapnum@colour}\thechapter%
              \hspace*{2\pagedecorationwidth}%
            }
          }
        }
      }
    \fi%
  \fi%
  \thispagestyle{empty}
}

\renewcommand{\@makeschapterhead}[1]{%
  {\let\c@secnumdepth\m@ne\@makechapterhead{#1}}}

%% Title page
\newlength{\title@height}
\newlength{\title@offset}
\def\maketitle{%
  \begin{titlepage}
    \AddToShipoutPicture*{%
      \setlength\unitlength{\paperheight}%
      \AtPageLowerLeft{%
        \color{White}\rule{\paperwidth}{\paperheight}%
      }%
      \AtPageLowerLeft{%
        \color{CambridgeLightBlue}\rule{\paperwidth}{0.67\paperheight}%
      }%
      \AtPageLowerLeft{%
        \color{White}\rule{\paperwidth}{0.5\paperheight}%
      }%
      \AtPageLowerLeft{
        \put(0,0.05){%
          \parbox{\paperwidth}{%
            \raggedleft%
            \includegraphics[height=0.05\paperheight]{CUnibig}%
            \hspace*{\pagedecorationwidth}%
          }%
        }%
        \put(0,0.5){%
          \hspace*{0.15\paperwidth}%
          \def\baselinestretch{1.3}%
          \settoheight{\title@height}{%
            \parbox[b]{0.66\paperwidth}{\centering\title@font\@title}%
          }%
          \setlength{\title@offset}{0.085\paperheight}%
          \addtolength{\title@offset}{-0.5\title@height}%
          \parbox[b]{0.7\paperwidth}{%
            \centering\title@font\textcolor{\title@colour}{\@title}%
            \vspace*{\title@offset}%
          }%
        }%
        \put(0,0.465){%
          \hspace*{0.1\paperwidth}%
          \parbox[t]{0.8\paperwidth}{%
            \centering\author@font\textcolor{\author@colour}{%
            \begin{tabular}[t]{c}%
            \@author\end{tabular}
            }
          }%
        }%
        \put(0,0.5){%
          \textcolor{CambridgeDeepBlue}{\rule{\paperwidth}{\rulewidth}}%
        }%
        \put(0,0.67){%
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

