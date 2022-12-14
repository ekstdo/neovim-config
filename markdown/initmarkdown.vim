echo &filetype 

" Version Clears: {{{1

" by default, enable all region-based highlighting
let s:tex_fast= "bcmMprsSvV"
if exists("g:tex_fast")
 if type(g:tex_fast) != 1
  " g:tex_fast exists and is not a string, so
  " turn off all optional region-based highighting
  let s:tex_fast= ""
 else
  let s:tex_fast= g:tex_fast
 endif
endif

" let user determine which classes of concealment will be supported
"   a=accents/ligatures d=delimiters m=math symbols  g=Greek  s=superscripts/subscripts
if !exists("g:tex_conceal")
 let s:tex_conceal= 'abdmgsS'
else
 let s:tex_conceal= g:tex_conceal
endif
if !exists("g:tex_superscripts")
 let s:tex_superscripts= '[0-9a-zA-W.,:;+-<>/()=]'
else
 let s:tex_superscripts= g:tex_superscripts
endif
if !exists("g:tex_subscripts")
 let s:tex_subscripts= '[0-9aehijklmnoprstuvx,+-/().]'
else
 let s:tex_subscripts= g:tex_subscripts
endif

" Determine whether or not to use "*.sty" mode {{{1
" The user may override the normal determination by setting
"   g:tex_stylish to 1      (for    "*.sty" mode)
"    or to           0 else (normal "*.tex" mode)
" or on a buffer-by-buffer basis with b:tex_stylish
let s:extfname=expand("%:e")
if exists("g:tex_stylish")
 let b:tex_stylish= g:tex_stylish
elseif !exists("b:tex_stylish")
 if s:extfname == "sty" || s:extfname == "cls" || s:extfname == "clo" || s:extfname == "dtx" || s:extfname == "ltx"
  let b:tex_stylish= 1
 else
  let b:tex_stylish= 0
 endif
endif

" handle folding {{{1
if !exists("g:tex_fold_enabled")
 let s:tex_fold_enabled= 0
elseif g:tex_fold_enabled && !has("folding")
 let s:tex_fold_enabled= 0
 echomsg "Ignoring g:tex_fold_enabled=".g:tex_fold_enabled."; need to re-compile vim for +fold support"
else
 let s:tex_fold_enabled= 1
endif
if s:tex_fold_enabled && &fdm == "manual"
 setl fdm=syntax
endif
if s:tex_fold_enabled && has("folding")
 com! -nargs=* TexFold <args> fold 
else
 com! -nargs=* TexFold <args> 
endif

" (La)TeX keywords: uses the characters 0-9,a-z,A-Z,192-255 only... {{{1
" but _ is the only one that causes problems.
" One may override this iskeyword setting by providing
" g:tex_isk
if exists("g:tex_isk")
 if b:tex_stylish && g:tex_isk !~ '@'
  let b:tex_isk= '@,'.g:tex_isk
 else
  let b:tex_isk= g:tex_isk
 endif
elseif b:tex_stylish
 let b:tex_isk="@,48-57,a-z,A-Z,192-255"
else
 let b:tex_isk="48-57,a-z,A-Z,192-255"
endif
if (v:version == 704 && has("patch-7.4.1142")) || v:version > 704
 exe "syn iskeyword ".b:tex_isk
else
 exe "setl isk=".b:tex_isk
endif
if exists("g:tex_no_error") && g:tex_no_error
 let s:tex_no_error= 1
else
 let s:tex_no_error= 0
endif
if exists("g:tex_comment_nospell") && g:tex_comment_nospell
 let s:tex_comment_nospell= 1
else
 let s:tex_comment_nospell= 0
endif
if exists("g:tex_nospell") && g:tex_nospell
 let s:tex_nospell = 1
else
 let s:tex_nospell = 0
endif

" Clusters: {{{1
" --------
syn cluster texCmdGroup			contains=texCmdBody,texComment,texDefParm,texDelimiter,texDocType,texInput,texLength,texLigature,texMathDelim,texMathOper,texNewCmd,texNewEnv,texRefZone,texSection,texBeginEnd,texBeginEndName,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,@texMathZones
if !s:tex_no_error
 syn cluster texCmdGroup		add=texMathError
endif
syn cluster texEnvGroup			contains=texMatcher,texMathDelim,texSpecialChar,texStatement
syn cluster texFoldGroup		contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texInputFile,texLength,texLigature,texMatcher,texMathZoneV,texMathZoneW,texMathZoneX,texMathZoneY,texMathZoneZ,texNewCmd,texNewEnv,texOnlyMath,texOption,texParen,texRefZone,texSection,texBeginEnd,texSectionZone,texSpaceCode,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,@texMathZones,texTitle,texAbstract,texBoldStyle,texItalStyle,texEmphStyle,texNoSpell
syn cluster texBoldGroup		contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texInputFile,texLength,texLigature,texMatcher,texMathZoneV,texMathZoneW,texMathZoneX,texMathZoneY,texMathZoneZ,texNewCmd,texNewEnv,texOnlyMath,texOption,texParen,texRefZone,texSection,texBeginEnd,texSectionZone,texSpaceCode,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,@texMathZones,texTitle,texAbstract,texBoldStyle,texBoldItalStyle,texNoSpell
syn cluster texItalGroup		contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texInputFile,texLength,texLigature,texMatcher,texMathZoneV,texMathZoneW,texMathZoneX,texMathZoneY,texMathZoneZ,texNewCmd,texNewEnv,texOnlyMath,texOption,texParen,texRefZone,texSection,texBeginEnd,texSectionZone,texSpaceCode,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,@texMathZones,texTitle,texAbstract,texItalStyle,texEmphStyle,texItalBoldStyle,texNoSpell
if !s:tex_nospell
 syn cluster texMatchGroup		contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texMatcher,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texBoldStyle,texBoldItalStyle,texItalStyle,texItalBoldStyle,texZone,texInputFile,texOption,@Spell
 syn cluster texMatchNMGroup		contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texMatcherNM,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texBoldStyle,texBoldItalStyle,texItalStyle,texItalBoldStyle,texZone,texInputFile,texOption,@Spell
 syn cluster texStyleGroup		contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texBoldStyle,texBoldItalStyle,texItalStyle,texItalBoldStyle,texZone,texInputFile,texOption,texStyleStatement,texStyleMatcher,@Spell
else
 syn cluster texMatchGroup		contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texMatcher,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,texInputFile,texOption
 syn cluster texMatchNMGroup		contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texMatcherNM,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,texInputFile,texOption
 syn cluster texStyleGroup		contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone,texInputFile,texOption,texStyleStatement,texStyleMatcher
endif
syn cluster texPreambleMatchGroup	contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texMatcherNM,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTitle,texTypeSize,texTypeStyle,texZone,texInputFile,texOption,texMathZoneZ
syn cluster texRefGroup			contains=texMatcher,texComment,texDelimiter
if !exists("g:tex_no_math")
 syn cluster texPreambleMatchGroup	contains=texAccent,texBadMath,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texMatcherNM,texNewCmd,texNewEnv,texOnlyMath,texParen,texRefZone,texSection,texSpecialChar,texStatement,texString,texTitle,texTypeSize,texTypeStyle,texZone,texInputFile,texOption,texMathZoneZ
 syn cluster texMathZones		contains=texMathZoneV,texMathZoneW,texMathZoneX,texMathZoneY,texMathZoneZ
 syn cluster texMatchGroup		add=@texMathZones
 syn cluster texMathDelimGroup		contains=texMathDelimBad,texMathDelimKey,texMathDelimSet1,texMathDelimSet2
 syn cluster texMathMatchGroup		contains=@texMathZones,texComment,texDefCmd,texDelimiter,texDocType,texInput,texLength,texLigature,texMathDelim,texMathMatcher,texMathOper,texNewCmd,texNewEnv,texRefZone,texSection,texSpecialChar,texStatement,texString,texTypeSize,texTypeStyle,texZone
 syn cluster texMathZoneGroup		contains=texComment,texDelimiter,texLength,texMathDelim,texMathMatcher,texMathOper,texMathSymbol,texMathText,texRefZone,texSpecialChar,texStatement,texTypeSize,texTypeStyle
 if !s:tex_no_error
  syn cluster texMathMatchGroup		add=texMathError
  syn cluster texMathZoneGroup		add=texMathError
 endif
 syn cluster texMathZoneGroup		add=@NoSpell
 " following used in the \part \chapter \section \subsection \subsubsection
 " \paragraph \subparagraph \author \title highlighting
 syn cluster texDocGroup		contains=texPartZone,@texPartGroup
 syn cluster texPartGroup		contains=texChapterZone,texSectionZone,texParaZone
 syn cluster texChapterGroup		contains=texSectionZone,texParaZone
 syn cluster texSectionGroup		contains=texSubSectionZone,texParaZone
 syn cluster texSubSectionGroup		contains=texSubSubSectionZone,texParaZone
 syn cluster texSubSubSectionGroup	contains=texParaZone
 syn cluster texParaGroup		contains=texSubParaZone
 if has("conceal") && &enc == 'utf-8'
  syn cluster texMathZoneGroup		add=texGreek,texSuperscript,texSubscript,texMathSymbol
  syn cluster texMathMatchGroup		add=texGreek,texSuperscript,texSubscript,texMathSymbol
 endif
endif

" Try to flag {} and () mismatches: {{{1
if s:tex_fast =~# 'm'
  if !s:tex_no_error
   syn region texMatcher	matchgroup=Delimiter start="{" skip="\\\\\|\\[{}]"	end="}"			transparent contains=@texMatchGroup,texError
   syn region texMatcher	matchgroup=Delimiter start="\["				end="]"			transparent contains=@texMatchGroup,texError,@NoSpell
   syn region texMatcherNM	matchgroup=Delimiter start="{" skip="\\\\\|\\[{}]"	end="}"			transparent contains=@texMatchNMGroup,texError
   syn region texMatcherNM	matchgroup=Delimiter start="\["				end="]"			transparent contains=@texMatchNMGroup,texError,@NoSpell
  else
   syn region texMatcher	matchgroup=Delimiter start="{" skip="\\\\\|\\[{}]"	end="}"			transparent contains=@texMatchGroup
   syn region texMatcher	matchgroup=Delimiter start="\["				end="]"			transparent contains=@texMatchGroup
   syn region texMatcherNM	matchgroup=Delimiter start="{" skip="\\\\\|\\[{}]"	end="}"			transparent contains=@texMatchNMGroup
   syn region texMatcherNM	matchgroup=Delimiter start="\["				end="]"			transparent contains=@texMatchNMGroup
  endif
  if !s:tex_nospell
   " syn region texParen		start="("	end=")"								transparent contains=@texMatchGroup,@Spell
  else
   " syn region texParen		start="("	end=")"								transparent contains=@texMatchGroup
  endif
endif
if !s:tex_no_error
 syn match  texError		"[}\])]"
endif
if s:tex_fast =~# 'M'
  if !exists("g:tex_no_math")
   if !s:tex_no_error
    syn match  texMathError	"}"	contained
   endif
   syn region texMathMatcher	matchgroup=Delimiter	start="{"          skip="\%(\\\\\)*\\}"     end="}" end="%stopzone\>"	contained contains=@texMathMatchGroup
  endif
endif

" TeX/LaTeX keywords: {{{1
" Instead of trying to be All Knowing, I just match \..alphameric..
" Note that *.tex files may not have "@" in their \commands
if exists("g:tex_tex") || b:tex_stylish
  syn match texStatement	"\\[a-zA-Z@]\+"
else
  syn match texStatement	"\\\a\+"
  if !s:tex_no_error
   syn match texError		"\\\a*@[a-zA-Z@]*"
  endif
endif

" TeX/LaTeX delimiters: {{{1
syn match texDelimiter		"&"
syn match texDelimiter		"\\\\"

" Tex/Latex Options: {{{1
syn match texOption		"[^\\]\zs#\d\+\|^#\d\+"

" texAccent (tnx to Karim Belabas) avoids annoying highlighting for accents: {{{1
if b:tex_stylish
  syn match texAccent		"\\[bcdvuH][^a-zA-Z@]"me=e-1
  syn match texLigature		"\\\([ijolL]\|ae\|oe\|ss\|AA\|AE\|OE\)[^a-zA-Z@]"me=e-1
else
  syn match texAccent		"\\[bcdvuH]\A"me=e-1
  syn match texLigature		"\\\([ijolL]\|ae\|oe\|ss\|AA\|AE\|OE\)\A"me=e-1
endif
syn match texAccent		"\\[bcdvuH]$"
syn match texAccent		+\\[=^.\~"`']+
syn match texAccent		+\\['=t'.c^ud"vb~Hr]{\a}+
syn match texLigature		"\\\([ijolL]\|ae\|oe\|ss\|AA\|AE\|OE\)$"


" \begin{}/\end{} section markers: {{{1
syn match  texBeginEnd		"\\begin\>\|\\end\>" nextgroup=texBeginEndName
if s:tex_fast =~# 'm'
  syn region texBeginEndName		matchgroup=Delimiter	start="{"		end="}"	contained	nextgroup=texBeginEndModifier	contains=texComment
  syn region texBeginEndModifier	matchgroup=Delimiter	start="\["		end="]"	contained	contains=texComment,@texMathZones,@NoSpell
endif

" \documentclass, \documentstyle, \usepackage: {{{1
syn match  texDocType		"\\documentclass\>\|\\documentstyle\>\|\\usepackage\>"	nextgroup=texBeginEndName,texDocTypeArgs
if s:tex_fast =~# 'm'
  syn region texDocTypeArgs	matchgroup=Delimiter start="\[" end="]"			contained	nextgroup=texBeginEndName	contains=texComment,@NoSpell
endif

" Preamble syntax-based folding support: {{{1
if s:tex_fold_enabled && has("folding")
 syn region texPreamble	transparent fold	start='\zs\\documentclass\>' end='\ze\\begin{document}'	contains=texStyle,@texPreambleMatchGroup
endif

" TeX input: {{{1
syn match texInput		"\\input\s\+[a-zA-Z/.0-9_^]\+"hs=s+7				contains=texStatement
syn match texInputFile		"\\include\(graphics\|list\)\=\(\[.\{-}\]\)\=\s*{.\{-}}"	contains=texStatement,texInputCurlies,texInputFileOpt
syn match texInputFile		"\\\(epsfig\|input\|usepackage\)\s*\(\[.*\]\)\={.\{-}}"		contains=texStatement,texInputCurlies,texInputFileOpt
syn match texInputCurlies	"[{}]"								contained
if s:tex_fast =~# 'm'
 syn region texInputFileOpt	matchgroup=Delimiter start="\[" end="\]"			contained	contains=texComment
endif

" Type Styles (LaTeX 2.09): {{{1
syn match texTypeStyle		"\\rm\>"
syn match texTypeStyle		"\\em\>"
syn match texTypeStyle		"\\bf\>"
syn match texTypeStyle		"\\it\>"
syn match texTypeStyle		"\\sl\>"
syn match texTypeStyle		"\\sf\>"
syn match texTypeStyle		"\\sc\>"
syn match texTypeStyle		"\\tt\>"

" Type Styles: attributes, commands, families, etc (LaTeX2E): {{{1
if s:tex_conceal !~# 'b'
 syn match texTypeStyle		"\\textbf\>"
 syn match texTypeStyle		"\\textit\>"
 syn match texTypeStyle		"\\emph\>"
endif
syn match texTypeStyle		"\\textmd\>"
syn match texTypeStyle		"\\textrm\>"
syn match texTypeStyle		"\\textsc\>"
syn match texTypeStyle		"\\textsf\>"
syn match texTypeStyle		"\\textsl\>"
syn match texTypeStyle		"\\texttt\>"
syn match texTypeStyle		"\\textup\>"

syn match texTypeStyle		"\\mathbb\>"
syn match texTypeStyle		"\\mathbf\>"
syn match texTypeStyle		"\\mathcal\>"
syn match texTypeStyle		"\\mathfrak\>"
syn match texTypeStyle		"\\mathit\>"
syn match texTypeStyle		"\\mathnormal\>"
syn match texTypeStyle		"\\mathrm\>"
syn match texTypeStyle		"\\mathsf\>"
syn match texTypeStyle		"\\mathtt\>"

syn match texTypeStyle		"\\rmfamily\>"
syn match texTypeStyle		"\\sffamily\>"
syn match texTypeStyle		"\\ttfamily\>"

syn match texTypeStyle		"\\itshape\>"
syn match texTypeStyle		"\\scshape\>"
syn match texTypeStyle		"\\slshape\>"
syn match texTypeStyle		"\\upshape\>"

syn match texTypeStyle		"\\bfseries\>"
syn match texTypeStyle		"\\mdseries\>"

" Some type sizes: {{{1
syn match texTypeSize		"\\tiny\>"
syn match texTypeSize		"\\scriptsize\>"
syn match texTypeSize		"\\footnotesize\>"
syn match texTypeSize		"\\small\>"
syn match texTypeSize		"\\normalsize\>"
syn match texTypeSize		"\\large\>"
syn match texTypeSize		"\\Large\>"
syn match texTypeSize		"\\LARGE\>"
syn match texTypeSize		"\\huge\>"
syn match texTypeSize		"\\Huge\>"

" Spacecodes (TeX'isms): {{{1
" \mathcode`\^^@="2201  \delcode`\(="028300  \sfcode`\)=0 \uccode`X=`X  \lccode`x=`x
syn match texSpaceCode		"\\\(math\|cat\|del\|lc\|sf\|uc\)code`"me=e-1 nextgroup=texSpaceCodeChar
syn match texSpaceCodeChar    "`\\\=.\(\^.\)\==\(\d\|\"\x\{1,6}\|`.\)"	contained

" Sections, subsections, etc: {{{1
if s:tex_fast =~# 'p'
 if !s:tex_nospell
  TexFold syn region texDocZone			matchgroup=texSection start='\\begin\s*{\s*document\s*}' end='\\end\s*{\s*document\s*}'											contains=@texFoldGroup,@texDocGroup,@Spell
  TexFold syn region texPartZone		matchgroup=texSection start='\\part\>'			 end='\ze\s*\\\%(part\>\|end\s*{\s*document\s*}\)'								contains=@texFoldGroup,@texPartGroup,@Spell
  TexFold syn region texChapterZone		matchgroup=texSection start='\\chapter\>'		 end='\ze\s*\\\%(chapter\>\|part\>\|end\s*{\s*document\s*}\)'							contains=@texFoldGroup,@texChapterGroup,@Spell
  TexFold syn region texSectionZone		matchgroup=texSection start='\\section\>'		 end='\ze\s*\\\%(section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'					contains=@texFoldGroup,@texSectionGroup,@Spell
  TexFold syn region texSubSectionZone		matchgroup=texSection start='\\subsection\>'		 end='\ze\s*\\\%(\%(sub\)\=section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				contains=@texFoldGroup,@texSubSectionGroup,@Spell
  TexFold syn region texSubSubSectionZone	matchgroup=texSection start='\\subsubsection\>'		 end='\ze\s*\\\%(\%(sub\)\{,2}section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				contains=@texFoldGroup,@texSubSubSectionGroup,@Spell
  TexFold syn region texParaZone		matchgroup=texSection start='\\paragraph\>'		 end='\ze\s*\\\%(paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'			contains=@texFoldGroup,@texParaGroup,@Spell
  TexFold syn region texSubParaZone		matchgroup=texSection start='\\subparagraph\>'		 end='\ze\s*\\\%(\%(sub\)\=paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'	contains=@texFoldGroup,@Spell
  TexFold syn region texTitle			matchgroup=texSection start='\\\%(author\|title\)\>\s*{' end='}'													contains=@texFoldGroup,@Spell
  TexFold syn region texAbstract		matchgroup=texSection start='\\begin\s*{\s*abstract\s*}' end='\\end\s*{\s*abstract\s*}'											contains=@texFoldGroup,@Spell
 else
  TexFold syn region texDocZone			matchgroup=texSection start='\\begin\s*{\s*document\s*}' end='\\end\s*{\s*document\s*}'											contains=@texFoldGroup,@texDocGroup
  TexFold syn region texPartZone		matchgroup=texSection start='\\part\>'			 end='\ze\s*\\\%(part\>\|end\s*{\s*document\s*}\)'								contains=@texFoldGroup,@texPartGroup
  TexFold syn region texChapterZone		matchgroup=texSection start='\\chapter\>'		 end='\ze\s*\\\%(chapter\>\|part\>\|end\s*{\s*document\s*}\)'							contains=@texFoldGroup,@texChapterGroup
  TexFold syn region texSectionZone		matchgroup=texSection start='\\section\>'		 end='\ze\s*\\\%(section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'					contains=@texFoldGroup,@texSectionGroup
  TexFold syn region texSubSectionZone		matchgroup=texSection start='\\subsection\>'		 end='\ze\s*\\\%(\%(sub\)\=section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				contains=@texFoldGroup,@texSubSectionGroup
  TexFold syn region texSubSubSectionZone	matchgroup=texSection start='\\subsubsection\>'		 end='\ze\s*\\\%(\%(sub\)\{,2}section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'				contains=@texFoldGroup,@texSubSubSectionGroup
  TexFold syn region texParaZone		matchgroup=texSection start='\\paragraph\>'		 end='\ze\s*\\\%(paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'			contains=@texFoldGroup,@texParaGroup
  TexFold syn region texSubParaZone		matchgroup=texSection start='\\subparagraph\>'		 end='\ze\s*\\\%(\%(sub\)\=paragraph\>\|\%(sub\)*section\>\|chapter\>\|part\>\|end\s*{\s*document\s*}\)'	contains=@texFoldGroup
  TexFold syn region texTitle			matchgroup=texSection start='\\\%(author\|title\)\>\s*{' end='}'													contains=@texFoldGroup
  TexFold syn region texAbstract		matchgroup=texSection start='\\begin\s*{\s*abstract\s*}' end='\\end\s*{\s*abstract\s*}'											contains=@texFoldGroup
  endif
endif

" particular support for bold and italic {{{1
if s:tex_fast =~# 'b'
  if s:tex_conceal =~# 'b'
   if !exists("g:tex_nospell") || !g:tex_nospell
    syn region texBoldStyle	matchgroup=texTypeStyle start="\\textbf\s*{" matchgroup=texTypeStyle  end="}" concealends contains=@texBoldGroup,@Spell
    syn region texBoldItalStyle	matchgroup=texTypeStyle start="\\textit\s*{" matchgroup=texTypeStyle  end="}" concealends contains=@texItalGroup,@Spell
    syn region texItalStyle	matchgroup=texTypeStyle start="\\textit\s*{" matchgroup=texTypeStyle  end="}" concealends contains=@texItalGroup,@Spell
    syn region texItalBoldStyle	matchgroup=texTypeStyle start="\\textbf\s*{" matchgroup=texTypeStyle  end="}" concealends contains=@texBoldGroup,@Spell
    syn region texEmphStyle	matchgroup=texTypeStyle start="\\emph\s*{"   matchgroup=texTypeStyle  end="}" concealends contains=@texItalGroup,@Spell
   else                                                                                              
    syn region texBoldStyle	matchgroup=texTypeStyle start="\\textbf\s*{" matchgroup=texTypeStyle  end="}" concealends contains=@texBoldGroup
    syn region texBoldItalStyle	matchgroup=texTypeStyle start="\\textit\s*{" matchgroup=texTypeStyle  end="}" concealends contains=@texItalGroup
    syn region texItalStyle	matchgroup=texTypeStyle start="\\textit\s*{" matchgroup=texTypeStyle  end="}" concealends contains=@texItalGroup
    syn region texItalBoldStyle	matchgroup=texTypeStyle start="\\textbf\s*{" matchgroup=texTypeStyle  end="}" concealends contains=@texBoldGroup
    syn region texEmphStyle	matchgroup=texTypeStyle start="\\emph\s*{"   matchgroup=texTypeStyle  end="}" concealends contains=@texItalGroup
   endif
  endif
endif

" Bad Math (mismatched): {{{1
if !exists("g:tex_no_math") && !s:tex_no_error
 syn match texBadMath		"\\end\s*{\s*\(array\|[bBpvV]matrix\|split\|smallmatrix\)\s*}"
 syn match texBadMath		"\\end\s*{\s*\(displaymath\|equation\|eqnarray\|math\)\*\=\s*}"
 syn match texBadMath		"\\[\])]"
endif

" Math Zones: {{{1
if !exists("g:tex_no_math")
 " TexNewMathZone: function creates a mathzone with the given suffix and mathzone name. {{{2
 "                 Starred forms are created if starform is true.  Starred
 "                 forms have syntax group and synchronization groups with a
 "                 "S" appended.  Handles: cluster, syntax, sync, and highlighting.
 fun! TexNewMathZone(sfx,mathzone,starform)
   let grpname  = "texMathZone".a:sfx
   let syncname = "texSyncMathZone".a:sfx
   if s:tex_fold_enabled
    let foldcmd= " fold"
   else
    let foldcmd= ""
   endif
   exe "syn cluster texMathZones add=".grpname
   if s:tex_fast =~# 'M'
    exe 'syn region '.grpname.' start='."'".'\\begin\s*{\s*'.a:mathzone.'\s*}'."'".' end='."'".'\\end\s*{\s*'.a:mathzone.'\s*}'."'".' keepend contains=@texMathZoneGroup'.foldcmd
    exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
    exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
   endif
   exe 'hi def link '.grpname.' texMath'
   if a:starform
    let grpname  = "texMathZone".a:sfx.'S'
    let syncname = "texSyncMathZone".a:sfx.'S'
    exe "syn cluster texMathZones add=".grpname
    if s:tex_fast =~# 'M'
     exe 'syn region '.grpname.' start='."'".'\\begin\s*{\s*'.a:mathzone.'\*\s*}'."'".' end='."'".'\\end\s*{\s*'.a:mathzone.'\*\s*}'."'".' keepend contains=@texMathZoneGroup'.foldcmd
     exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
     exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
    endif
    exe 'hi def link '.grpname.' texMath'
   endif
 endfun

 " Text Inside Math Zones: {{{2
 if s:tex_fast =~# 'M'
  if !exists("g:tex_nospell") || !g:tex_nospell
   syn region texMathText matchgroup=texStatement start='\\\(\(inter\)\=text\|mbox\)\s*{'	end='}'	contains=@texFoldGroup,@Spell
  else
   syn region texMathText matchgroup=texStatement start='\\\(\(inter\)\=text\|mbox\)\s*{'	end='}'	contains=@texFoldGroup
  endif
 endif

 " \left..something.. and \right..something.. support: {{{2
 syn match   texMathDelimBad	contained		"\S"
 if has("conceal") && &enc == 'utf-8' && s:tex_conceal =~# 'm'
  syn match   texMathDelim	contained		"\\left\["
  syn match   texMathDelim	contained		"\\left\\{"	skipwhite nextgroup=texMathDelimSet1,texMathDelimSet2,texMathDelimBad contains=texMathSymbol cchar={
  syn match   texMathDelim	contained		"\\right\\}"	skipwhite nextgroup=texMathDelimSet1,texMathDelimSet2,texMathDelimBad contains=texMathSymbol cchar=}
  let s:texMathDelimList=[
     \ ['<'            , '<'] ,
     \ ['>'            , '>'] ,
     \ ['('            , '('] ,
     \ [')'            , ')'] ,
     \ ['\['           , '['] ,
     \ [']'            , ']'] ,
     \ ['\\{'          , '{'] ,
     \ ['\\}'          , '}'] ,
     \ ['|'            , '|'] ,
     \ ['\\|'          , '???'] ,
     \ ['\\backslash'  , '\'] ,
     \ ['\\downarrow'  , '???'] ,
     \ ['\\Downarrow'  , '???'] ,
     \ ['\\lbrace'     , '['] ,
     \ ['\\lceil'      , '???'] ,
     \ ['\\lfloor'     , '???'] ,
     \ ['\\lgroup'     , '???'] ,
     \ ['\\lmoustache' , '???'] ,
     \ ['\\rbrace'     , ']'] ,
     \ ['\\rceil'      , '???'] ,
     \ ['\\rfloor'     , '???'] ,
     \ ['\\rgroup'     , '???'] ,
     \ ['\\rmoustache' , '???'] ,
     \ ['\\uparrow'    , '???'] ,
     \ ['\\Uparrow'    , '???'] ,
     \ ['\\updownarrow', '???'] ,
     \ ['\\Updownarrow', '???']]
  if &ambw == "double" || exists("g:tex_usedblwidth")
    let s:texMathDelimList= s:texMathDelimList + [
     \ ['\\langle'     , '???'] ,
     \ ['\\rangle'     , '???']]
  else
    let s:texMathDelimList= s:texMathDelimList + [
     \ ['\\langle'     , '<'] ,
     \ ['\\rangle'     , '>']]
  endif
  syn match texMathDelim	'\\[bB]igg\=[lr]' contained nextgroup=texMathDelimBad
  for texmath in s:texMathDelimList
   exe "syn match texMathDelim	'\\\\[bB]igg\\=[lr]\\=".texmath[0]."'	contained conceal cchar=".texmath[1]
  endfor

 else
  syn match   texMathDelim	contained		"\\\(left\|right\)\>"	skipwhite nextgroup=texMathDelimSet1,texMathDelimSet2,texMathDelimBad
  syn match   texMathDelim	contained		"\\[bB]igg\=[lr]\=\>"	skipwhite nextgroup=texMathDelimSet1,texMathDelimSet2,texMathDelimBad
  syn match   texMathDelimSet2	contained	"\\"		nextgroup=texMathDelimKey,texMathDelimBad
  syn match   texMathDelimSet1	contained	"[<>()[\]|/.]\|\\[{}|]"
  syn keyword texMathDelimKey	contained	backslash       lceil           lVert           rgroup          uparrow
  syn keyword texMathDelimKey	contained	downarrow       lfloor          rangle          rmoustache      Uparrow
  syn keyword texMathDelimKey	contained	Downarrow       lgroup          rbrace          rvert           updownarrow
  syn keyword texMathDelimKey	contained	langle          lmoustache      rceil           rVert           Updownarrow
  syn keyword texMathDelimKey	contained	lbrace          lvert           rfloor
 endif
 syn match   texMathDelim	contained		"\\\(left\|right\)arrow\>\|\<\([aA]rrow\|brace\)\=vert\>"
 syn match   texMathDelim	contained		"\\lefteqn\>"
endif

" Special TeX characters  ( \$ \& \% \# \{ \} \_ \S \P ) : {{{1
syn match texSpecialChar	"\\[$&%#{}_]"
if b:tex_stylish
  syn match texSpecialChar	"\\[SP@][^a-zA-Z@]"me=e-1
else
  syn match texSpecialChar	"\\[SP@]\A"me=e-1
endif
syn match texSpecialChar	"\\\\"
if !exists("g:tex_no_math")
 syn match texOnlyMath		"[_^]"
endif
syn match texSpecialChar	"\^\^[0-9a-f]\{2}\|\^\^\S"
if s:tex_conceal !~# 'S'
 syn match texSpecialChar	'\\glq\>'	contained conceal cchar=???
 syn match texSpecialChar	'\\grq\>'	contained conceal cchar=???
 syn match texSpecialChar	'\\glqq\>'	contained conceal cchar=???
 syn match texSpecialChar	'\\grqq\>'	contained conceal cchar=???
 syn match texSpecialChar	'\\hyp\>'	contained conceal cchar=-
endif

" Comments: {{{1
"    Normal TeX LaTeX     :   %....
"    Documented TeX Format:  ^^A...	-and-	leading %s (only)
if !s:tex_comment_nospell
 syn cluster texCommentGroup	contains=texTodo,@Spell
else
 syn cluster texCommentGroup	contains=texTodo,@NoSpell
endif
syn case ignore
syn keyword texTodo		contained		combak	fixme	todo	xxx
syn case match
if s:extfname == "dtx"
 syn match texComment		"\^\^A.*$"	contains=@texCommentGroup
 syn match texComment		"^%\+"		contains=@texCommentGroup
else
 if s:tex_fold_enabled
  " allows syntax-folding of 2 or more contiguous comment lines
  " single-line comments are not folded
  syn match  texComment	"%.*$"				contains=@texCommentGroup
  if s:tex_fast =~# 'c'
   TexFold syn region texComment						start="^\zs\s*%.*\_s*%"	skip="^\s*%"	end='^\ze\s*[^%]'	contains=@texCommentGroup
   TexFold syn region texNoSpell	contained	matchgroup=texComment	start="%\s*nospell\s*{"	end="%\s*nospell\s*}"			contains=@texFoldGroup,@NoSpell
  endif
 else
  syn match texComment		"%.*$"			contains=@texCommentGroup
  if s:tex_fast =~# 'c'
   syn region texNoSpell		contained	matchgroup=texComment start="%\s*nospell\s*{"	end="%\s*nospell\s*}"	contains=@texFoldGroup,@NoSpell
  endif
 endif
endif

" %begin-include ... %end-include acts like a texDocZone for \include'd files.  Permits spell checking, for example, in such files.
if !s:tex_nospell
 TexFold syn region texDocZone			matchgroup=texSection start='^\s*%begin-include\>'	 end='^\s*%end-include\>'											contains=@texFoldGroup,@texDocGroup,@Spell
else
 TexFold syn region texDocZone			matchgroup=texSection start='^\s*%begin-include\>'	 end='^\s*%end-include\>'											contains=@texFoldGroup,@texDocGroup
endif

" Separate lines used for verb` and verb# so that the end conditions {{{1
" will appropriately terminate.
" If g:tex_verbspell exists, then verbatim texZones will permit spellchecking there.
if s:tex_fast =~# 'v'
  if exists("g:tex_verbspell") && g:tex_verbspell
   syn region texZone		start="\\begin{[vV]erbatim}"		end="\\end{[vV]erbatim}\|%stopzone\>"	contains=@Spell
   " listings package:
   if b:tex_stylish
    syn region texZone		start="\\verb\*\=\z([^\ta-zA-Z@]\)"	end="\z1\|%stopzone\>"			contains=@Spell
   else
    syn region texZone		start="\\verb\*\=\z([^\ta-zA-Z]\)"	end="\z1\|%stopzone\>"			contains=@Spell
   endif
  else
   syn region texZone		start="\\begin{[vV]erbatim}"		end="\\end{[vV]erbatim}\|%stopzone\>"
   if b:tex_stylish
     syn region texZone		start="\\verb\*\=\z([^\ta-zA-Z@]\)"	end="\z1\|%stopzone\>"
   else
     syn region texZone		start="\\verb\*\=\z([^\ta-zA-Z]\)"	end="\z1\|%stopzone\>"
   endif
  endif
endif

" Tex Reference Zones: {{{1
if s:tex_fast =~# 'r'
  syn region texZone		matchgroup=texStatement start="@samp{"			end="}\|%stopzone\>"	contains=@texRefGroup
  syn region texRefZone		matchgroup=texStatement start="\\nocite{"		end="}\|%stopzone\>"	contains=@texRefGroup
  syn region texRefZone		matchgroup=texStatement start="\\bibliography{"		end="}\|%stopzone\>"	contains=@texRefGroup
  syn region texRefZone		matchgroup=texStatement start="\\label{"		end="}\|%stopzone\>"	contains=@texRefGroup
  syn region texRefZone		matchgroup=texStatement start="\\\(page\|eq\)ref{"	end="}\|%stopzone\>"	contains=@texRefGroup
  syn region texRefZone		matchgroup=texStatement start="\\v\=ref{"		end="}\|%stopzone\>"	contains=@texRefGroup
  syn region texRefOption	contained	matchgroup=Delimiter start='\[' end=']'		contains=@texRefGroup,texRefZone	nextgroup=texRefOption,texCite
  syn region texCite		contained	matchgroup=Delimiter start='{' end='}'		contains=@texRefGroup,texRefZone,texCite
endif
syn match  texRefZone		'\\cite\%([tp]\*\=\)\=' nextgroup=texRefOption,texCite

" Handle newcommand, newenvironment : {{{1
syn match  texNewCmd				"\\newcommand\>"			nextgroup=texCmdName skipwhite skipnl
if s:tex_fast =~# 'V'
  syn region texCmdName contained matchgroup=Delimiter start="{"rs=s+1  end="}"		nextgroup=texCmdArgs,texCmdBody skipwhite skipnl
  syn region texCmdArgs contained matchgroup=Delimiter start="\["rs=s+1 end="]"		nextgroup=texCmdBody skipwhite skipnl
  syn region texCmdBody contained matchgroup=Delimiter start="{"rs=s+1 skip="\\\\\|\\[{}]"	matchgroup=Delimiter end="}" contains=@texCmdGroup
endif
syn match  texNewEnv				"\\newenvironment\>"			nextgroup=texEnvName skipwhite skipnl
if s:tex_fast =~# 'V'
  syn region texEnvName contained matchgroup=Delimiter start="{"rs=s+1  end="}"		nextgroup=texEnvBgn skipwhite skipnl
  syn region texEnvBgn  contained matchgroup=Delimiter start="{"rs=s+1  end="}"		nextgroup=texEnvEnd skipwhite skipnl contains=@texEnvGroup
  syn region texEnvEnd  contained matchgroup=Delimiter start="{"rs=s+1  end="}"		skipwhite skipnl contains=@texEnvGroup
endif
"}}}

" Definitions/Commands: {{{1
syn match texDefCmd				"\\def\>"				nextgroup=texDefName skipwhite skipnl
if b:tex_stylish
  syn match texDefName contained		"\\[a-zA-Z@]\+"				nextgroup=texDefParms,texCmdBody skipwhite skipnl
  syn match texDefName contained		"\\[^a-zA-Z@]"				nextgroup=texDefParms,texCmdBody skipwhite skipnl
else
  syn match texDefName contained		"\\\a\+"				nextgroup=texDefParms,texCmdBody skipwhite skipnl
  syn match texDefName contained		"\\\A"					nextgroup=texDefParms,texCmdBody skipwhite skipnl
endif
syn match texDefParms  contained		"#[^{]*"	contains=texDefParm	nextgroup=texCmdBody skipwhite skipnl
syn match  texDefParm  contained		"#\d\+"
"}}}

" TeX Lengths: {{{1
syn match  texLength		"\<\d\+\([.,]\d\+\)\=\s*\(true\)\=\s*\(bp\|cc\|cm\|dd\|em\|ex\|in\|mm\|pc\|pt\|sp\)\>"
"}}

" TeX String Delimiters: {{{1
syn match texString		"\(``\|''\|,,\)"

" makeatletter -- makeatother sections
if !s:tex_no_error
 if s:tex_fast =~# 'S'
  syn region texStyle			matchgroup=texStatement start='\\makeatletter' end='\\makeatother'	contains=@texStyleGroup contained
 endif
 syn match  texStyleStatement		"\\[a-zA-Z@]\+"	contained
 if s:tex_fast =~# 'S'
  syn region texStyleMatcher		matchgroup=Delimiter start="{" skip="\\\\\|\\[{}]"	end="}"		contains=@texStyleGroup,texError	contained
  syn region texStyleMatcher		matchgroup=Delimiter start="\["				end="]"		contains=@texStyleGroup,texError	contained
 endif
endif

if !exists("skip_tex_syntax_inits")

" TeX highlighting groups which should share similar highlighting
  

  hi texBoldStyle		gui=bold	cterm=bold
  hi texItalStyle		gui=italic	cterm=italic
  hi texBoldItalStyle		gui=bold,italic cterm=bold,italic
  hi texItalBoldStyle		gui=bold,italic cterm=bold,italic
  hi def link texEmphStyle	texItalStyle
  hi def link texCite		texRefZone
  hi def link texDefCmd		texDef
  hi def link texDefName	texDef
  hi def link texDocType	texCmdName
  hi def link texDocTypeArgs	texCmdArgs
  hi def link texInputFileOpt	texCmdArgs
  hi def link texInputCurlies	texDelimiter
  hi def link texLigature	texSpecialChar

  hi def link texBeginEnd	texCmdName
  hi def link texBeginEndName	texSection
  hi def link texSpaceCode	texStatement
  hi def link texStyleStatement	texStatement
  hi def link texTypeSize	texType
  hi def link texTypeStyle	texType

   " Basic TeX highlighting groups
  hi def link texCmdArgs	Number
  hi def link texCmdName	Statement
  hi def link texComment	Comment
  hi def link texDef		Statement
  hi def link texDefParm	Special
  hi def link texDelimiter	Delimiter
  hi def link texInput		Special
  hi def link texInputFile	Special
  hi def link texLength		Number
  hi def link texMath		Special
  hi def link texMathDelim	Statement
  hi def link texMathOper	Operator
  hi def link texNewCmd		Statement
  hi def link texNewEnv		Statement
  hi def link texOption		Number
  hi def link texRefZone	Special
  hi def link texSection	PreCondit
  hi def link texSpaceCodeChar	Special
  hi def link texSpecialChar	SpecialChar
  hi def link texStatement	Statement
  hi def link texString		String
  hi def link texTodo		Todo
  hi def link texType		Type
  hi def link texZone		PreCondit

endif

syn match texMathSymbol '\\Rightarrow\>' contained conceal cchar=???
syn match texMathSymbol '\\Leftarrow\>' contained conceal cchar=???
syn match texMathSymbol '\\rightarrow\>' contained conceal cchar=???
syn match texMathSymbol '\\leftarrow\>' contained conceal cchar=???
syn match texMathSymbol '\\emptyset\>' contained conceal cchar=??
syn match texMathSymbol '\\varphi\>' contained conceal cchar=??
syn match texMathSymbol '\\phi\>' contained conceal cchar=??
syn match texMathSymbol '\\langle\>\s*' contained conceal cchar=???
syn match texMathSymbol '\s*\\rangle\>' contained conceal cchar=???
syn match texMathSymbol '\\\\' contained conceal cchar=???

" logical symbols
syn match texMathSymbol '\\lor\>' contained conceal cchar=???
syn match texMathSymbol '\\land\>' contained conceal cchar=???
syn match texMathSymbol '\\lnot\>' contained conceal cchar=??
syn match texMathSymbol '\\implies\>' contained conceal cchar=???
syn match texMathSymbol '\\geqslant\>' contained conceal cchar=???
syn match texMathSymbol '\\leqslant\>' contained conceal cchar=???

" \mathbb characters
syn match texMathSymbol '\\mathbb{\s*A\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*B\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*C\s*}' contained conceal cchar=???
syn match texMathSymbol '\\mathbb{\s*D\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*E\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*F\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*G\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*H\s*}' contained conceal cchar=???
syn match texMathSymbol '\\mathbb{\s*I\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*J\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*K\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*L\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*M\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*N\s*}' contained conceal cchar=???
syn match texMathSymbol '\\mathbb{\s*O\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*P\s*}' contained conceal cchar=???
syn match texMathSymbol '\\mathbb{\s*Q\s*}' contained conceal cchar=???
syn match texMathSymbol '\\mathbb{\s*R\s*}' contained conceal cchar=???
syn match texMathSymbol '\\mathbb{\s*S\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*T\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*U\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*V\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*W\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*X\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*Y\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathbb{\s*Z\s*}' contained conceal cchar=???

" \mathsf characters
syn match texMathSymbol '\\mathsf{\s*a\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*b\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*c\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*d\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*e\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*f\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*g\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*h\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*i\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*j\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*k\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*l\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*m\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*n\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*o\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*p\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*q\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*r\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*s\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*t\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*u\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*v\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*w\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*x\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*y\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*z\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*A\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*B\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*C\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*D\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*E\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*F\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*G\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*H\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*I\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*J\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*K\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*L\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*M\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*N\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*O\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*P\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*Q\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*R\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*S\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*T\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*U\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*V\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*W\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*X\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*Y\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathsf{\s*Z\s*}' contained conceal cchar=????

" \mathfrak characters
syn match texMathSymbol '\\mathfrak{\s*a\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*b\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*c\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*d\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*e\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*f\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*g\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*h\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*i\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*j\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*k\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*l\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*m\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*n\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*o\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*p\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*q\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*r\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*s\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*t\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*u\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*v\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*w\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*x\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*y\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*z\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*A\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*B\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*C\s*}' contained conceal cchar=???
syn match texMathSymbol '\\mathfrak{\s*D\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*E\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*F\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*G\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*H\s*}' contained conceal cchar=???
syn match texMathSymbol '\\mathfrak{\s*I\s*}' contained conceal cchar=???
syn match texMathSymbol '\\mathfrak{\s*J\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*K\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*L\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*M\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*N\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*O\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*P\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*Q\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*R\s*}' contained conceal cchar=???
syn match texMathSymbol '\\mathfrak{\s*S\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*T\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*U\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*V\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*W\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*X\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*Y\s*}' contained conceal cchar=????
syn match texMathSymbol '\\mathfrak{\s*Z\s*}' contained conceal cchar=???

" \mathcal characters
syn match texMathSymbol '\\math\%(scr\|cal\){\s*A\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*B\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*C\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*D\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*E\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*F\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*G\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*H\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*I\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*J\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*K\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*L\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*M\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*N\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*O\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*P\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*Q\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*R\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*S\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*T\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*U\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*V\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*W\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*X\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*Y\s*}' contained conceal cchar=????
syn match texMathSymbol '\\math\%(scr\|cal\){\s*Z\s*}' contained conceal cchar=????

syn match texSpecialChar '\\#' contained conceal cchar=#

syn match texStatement '``' contained conceal cchar=???
syn match texStatement '\'\'' contained conceal cchar=???
syn match texStatement '\\item\>' contained conceal cchar=???
syn match texStatement '\\ldots' contained conceal cchar=???
syn match texStatement '\\quad' contained conceal cchar=  
syn match texStatement '\\qquad' contained conceal cchar=    
"syn match texStatement '\\\[' contained conceal cchar=???
"syn match texStatement '\\\]' contained conceal cchar=???
syn match texDelimiter '\\{' contained conceal cchar={
syn match texDelimiter '\\}' contained conceal cchar=}
syn match texMathSymbol '\\setminus\>' contained conceal cchar=\
syn match texMathSymbol '\\coloneqq\>' contained conceal cchar=???
syn match texMathSymbol '\\colon\>' contained conceal cchar=:
syn match texMathSymbol '\\:' contained conceal cchar= 
syn match texMathSymbol '\\;' contained conceal cchar= 
syn match texMathSymbol '\\,' contained conceal cchar= 
syn match texMathSymbol '\\ ' contained conceal cchar= 
syn match texMathSymbol '\\quad' contained conceal cchar=  
syn match texMathSymbol '\\qquad' contained conceal cchar=    
syn match texMathSymbol '\\sqrt' contained conceal cchar=???
syn match texMathSymbol '\\sqrt\[3]' contained conceal cchar=???
syn match texMathSymbol '\\sqrt\[4]' contained conceal cchar=???
syn match texMathSymbol '\\\!' contained conceal
syn match texMathSymbol '\\therefore' contained conceal cchar=???
syn match texMathSymbol '\\because' contained conceal cchar=???


  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(1\|{1}\)\(2\|{2}\)' contained conceal cchar=??
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(1\|{1}\)\(3\|{3}\)' contained conceal cchar=???
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(2\|{2}\)\(3\|{3}\)' contained conceal cchar=???
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(1\|{1}\)\(4\|{4}\)' contained conceal cchar=??
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(1\|{1}\)\(5\|{5}\)' contained conceal cchar=???
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(2\|{2}\)\(5\|{5}\)' contained conceal cchar=???
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(3\|{3}\)\(5\|{5}\)' contained conceal cchar=???
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(3\|{3}\)\(4\|{4}\)' contained conceal cchar=??
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(4\|{4}\)\(5\|{5}\)' contained conceal cchar=???
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(1\|{1}\)\(6\|{6}\)' contained conceal cchar=???
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(5\|{5}\)\(6\|{6}\)' contained conceal cchar=???
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(1\|{1}\)\(8\|{8}\)' contained conceal cchar=???
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(3\|{3}\)\(8\|{8}\)' contained conceal cchar=???
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(5\|{5}\)\(8\|{8}\)' contained conceal cchar=???
  syn match texMathSymbol '\\\(\(d\|t\)\|\)frac\(7\|{7}\)\(8\|{8}\)' contained conceal cchar=???

" hide \text delimiter etc inside math mode
if !exists("g:tex_nospell") || !g:tex_nospell
  syn region texMathText matchgroup=texStatement start='\\\%(\%(inter\)\=mathrm\)\s*{'     end='}' concealends keepend contains=@texFoldGroup containedin=texMathMatcher
  syn region texMathText matchgroup=texStatement start='\\\%(\%(inter\)\=text\|mbox\)\s*{' end='}' concealends keepend contains=@texFoldGroup,@Spell containedin=texMathMatcher
else
  syn region texMathText matchgroup=texStatement start='\\\%(\%(inter\)\=text\|mbox\|mathrm\)\s*{' end='}' concealends keepend contains=@texFoldGroup containedin=texMathMatcher
endif

syn region texBoldMathText  matchgroup=texStatement start='\\\%(mathbf\|bm\|symbf\|pmb\){' end='}' concealends contains=@texMathZoneGroup containedin=texMathMatcher
syn cluster texMathZoneGroup add=texBoldMathText

syn region texBoldItalStyle matchgroup=texTypeStyle start="\\emph\s*{" end="}" concealends contains=@texItalGroup
syn region texItalStyle  matchgroup=texTypeStyle start="\\emph\s*{" end="}" concealends contains=@texItalGroup
syn region texMatcher matchgroup=texTypeStyle start="\\\%(underline\|uline\){" end="}" concealends contains=@texItalGroup

hi texBoldMathText cterm=bold gui=bold
hi texUnderStyle cterm=underline gui=underline
match texUnderStyle /\\\%(underline\|uline\){\zs\(.\([^\\]}\)\@<!\)\+\ze}/

" set ambiwidth=single

" Simple number super/sub-scripts

if !exists("g:tex_superscripts")
  let s:tex_superscripts= '[0-9a-zA-W.,:;+-<>/()=]'
else
  let s:tex_superscripts= g:tex_superscripts
endif
if !exists("g:tex_subscripts")
  let s:tex_subscripts= "[0-9aeijoruvx,+-/().]"
else
  let s:tex_subscripts= g:tex_subscripts
endif

" s:SuperSub:
fun! s:SuperSub(leader, pat, cchar)
  if a:pat =~# '^\\' || (a:leader == '\^' && a:pat =~# s:tex_superscripts) || (a:leader == '_' && a:pat =~# s:tex_subscripts)
    exe "syn match texMathSymbol '".a:leader.'\%('.a:pat.'\|{\s*'.a:pat.'\s*}\)'."' contained conceal cchar=".a:cchar
  endif
endfun

call s:SuperSub('\^','0','???')
call s:SuperSub('\^','1','??')
call s:SuperSub('\^','2','??')
call s:SuperSub('\^','3','??')
call s:SuperSub('\^','4','???')
call s:SuperSub('\^','5','???')
call s:SuperSub('\^','6','???')
call s:SuperSub('\^','7','???')
call s:SuperSub('\^','8','???')
call s:SuperSub('\^','9','???')
call s:SuperSub('\^','a','???')
call s:SuperSub('\^','b','???')
call s:SuperSub('\^','c','???')
call s:SuperSub('\^','d','???')
call s:SuperSub('\^','e','???')
call s:SuperSub('\^','f','???')
call s:SuperSub('\^','g','???')
call s:SuperSub('\^','h','??')
call s:SuperSub('\^','i','???')
call s:SuperSub('\^','j','??')
call s:SuperSub('\^','k','???')
call s:SuperSub('\^','l','??')
call s:SuperSub('\^','m','???')
call s:SuperSub('\^','n','???')
call s:SuperSub('\^','o','???')
call s:SuperSub('\^','p','???')
call s:SuperSub('\^','r','??')
call s:SuperSub('\^','s','??')
call s:SuperSub('\^','t','???')
call s:SuperSub('\^','u','???')
call s:SuperSub('\^','v','???')
call s:SuperSub('\^','w','??')
call s:SuperSub('\^','x','??')
call s:SuperSub('\^','y','??')
call s:SuperSub('\^','z','???')
call s:SuperSub('\^','A','???')
call s:SuperSub('\^','B','???')
call s:SuperSub('\^','D','???')
call s:SuperSub('\^','E','???')
call s:SuperSub('\^','G','???')
call s:SuperSub('\^','H','???')
call s:SuperSub('\^','I','???')
call s:SuperSub('\^','J','???')
call s:SuperSub('\^','K','???')
call s:SuperSub('\^','L','???')
call s:SuperSub('\^','M','???')
call s:SuperSub('\^','N','???')
call s:SuperSub('\^','O','???')
call s:SuperSub('\^','P','???')
call s:SuperSub('\^','R','???')
call s:SuperSub('\^','T','???')
call s:SuperSub('\^','U','???')
call s:SuperSub('\^','W','???')
call s:SuperSub('\^','+','???')
call s:SuperSub('\^','-','???')
call s:SuperSub('\^','<','??')
call s:SuperSub('\^','>','??')
call s:SuperSub('\^','/','??')
call s:SuperSub('\^','(','???')
call s:SuperSub('\^',')','???')
call s:SuperSub('\^','\.','??')
call s:SuperSub('\^','=','??')
call s:SuperSub('\^','\\alpha','???')
call s:SuperSub('\^','\\beta','???')
call s:SuperSub('\^','\\gamma','???')
call s:SuperSub('\^','\\delta','???')
call s:SuperSub('\^','\\epsilon','???')
call s:SuperSub('\^','\\theta','???')
call s:SuperSub('\^','\\iota','???')
call s:SuperSub('\^','\\Phi','???')
call s:SuperSub('\^','\\varphi','???')
call s:SuperSub('\^','\\chi','???')

syn match texMathSymbol '\^\%(\*\|\\ast\|\\star\|{\s*\\\%(ast\|star\)\s*}\)' contained conceal cchar=??
syn match texMathSymbol '\^{\s*-1\s*}' contained conceal contains=texSuperscripts
syn match texMathSymbol '\^\%(\\math\%(rm\|sf\){\s*T\s*}\|{\s*\\math\%(rm\|sf\){\s*T\s*}\s*}\)' contained conceal contains=texSuperscripts
syn match texMathSymbol '\^\%(\\math\%(rm\|sf\){\s*-T\s*}\|{\s*\\math\%(rm\|sf\){\s*-T\s*}\s*}\|{\s*-\s*\\math\%(rm\|sf\){\s*T\s*}\s*}\)' contained conceal contains=texSuperscripts
syn match texSuperscripts '1' contained conceal cchar=??
syn match texSuperscripts '-' contained conceal cchar=???
syn match texSuperscripts 'T' contained conceal cchar=???

call s:SuperSub('_','0','???')
call s:SuperSub('_','1','???')
call s:SuperSub('_','2','???')
call s:SuperSub('_','3','???')
call s:SuperSub('_','4','???')
call s:SuperSub('_','5','???')
call s:SuperSub('_','6','???')
call s:SuperSub('_','7','???')
call s:SuperSub('_','8','???')
call s:SuperSub('_','9','???')
call s:SuperSub('_','a','???')
call s:SuperSub('_','e','???')
call s:SuperSub('_','h','???')
call s:SuperSub('_','i','???')
call s:SuperSub('_','j','???')
call s:SuperSub('_','k','???')
call s:SuperSub('_','l','???')
call s:SuperSub('_','m','???')
call s:SuperSub('_','n','???')
call s:SuperSub('_','o','???')
call s:SuperSub('_','p','???')
call s:SuperSub('_','r','???')
call s:SuperSub('_','s','???')
call s:SuperSub('_','t','???')
call s:SuperSub('_','u','???')
call s:SuperSub('_','v','???')
call s:SuperSub('_','x','???')
call s:SuperSub('_','+','???')
call s:SuperSub('_','-','???')
call s:SuperSub('_','/','??')
call s:SuperSub('_','(','???')
call s:SuperSub('_',')','???')
call s:SuperSub('_','\\beta','???')
call s:SuperSub('_','\\rho','???')
call s:SuperSub('_','\\phi','???')
call s:SuperSub('_','\\gamma','???')
call s:SuperSub('_','\\chi','???')


" Conceal mode support (supports set cole=2) {{{1
if has("conceal") && &enc == 'utf-8'

 " Math Symbols {{{2
 " (many of these symbols were contributed by Bj??rn Winckler)
 if s:tex_conceal =~# 'm'
  let s:texMathList=[
    \ ['|'		, '???'],
    \ ['aleph'		, '???'],
    \ ['amalg'		, '???'],
    \ ['angle'		, '???'],
    \ ['approx'		, '???'],
    \ ['ast'		, '???'],
    \ ['asymp'		, '???'],
    \ ['backslash'	, '???'],
    \ ['bigcap'		, '???'],
    \ ['bigcirc'	, '???'],
    \ ['bigcup'		, '???'],
    \ ['bigodot'	, '???'],
    \ ['bigoplus'	, '???'],
    \ ['bigotimes'	, '???'],
    \ ['bigsqcup'	, '???'],
    \ ['bigtriangledown', '???'],
    \ ['bigtriangleup'	, '???'],
    \ ['bigvee'		, '???'],
    \ ['bigwedge'	, '???'],
    \ ['bot'		, '???'],
    \ ['bowtie'		, '???'],
    \ ['bullet'		, '???'],
    \ ['cap'		, '???'],
    \ ['cdot'		, '??'],
    \ ['cdots'		, '???'],
    \ ['circ'		, '???'],
    \ ['clubsuit'	, '???'],
    \ ['cong'		, '???'],
    \ ['coprod'		, '???'],
    \ ['copyright'	, '??'],
    \ ['cup'		, '???'],
    \ ['dagger'		, '???'],
    \ ['dashv'		, '???'],
    \ ['ddagger'	, '???'],
    \ ['ddots'		, '???'],
    \ ['diamond'	, '???'],
    \ ['diamondsuit'	, '???'],
    \ ['div'		, '??'],
    \ ['doteq'		, '???'],
    \ ['dots'		, '???'],
    \ ['downarrow'	, '???'],
    \ ['Downarrow'	, '???'],
    \ ['ell'		, '???'],
    \ ['emptyset'	, '???'],
    \ ['equiv'		, '???'],
    \ ['exists'		, '???'],
    \ ['flat'		, '???'],
    \ ['forall'		, '???'],
    \ ['frown'		, '???'],
    \ ['ge'		, '???'],
    \ ['geq'		, '???'],
    \ ['gets'		, '???'],
    \ ['gg'		, '???'],
    \ ['hbar'		, '???'],
    \ ['heartsuit'	, '???'],
    \ ['hookleftarrow'	, '???'],
    \ ['hookrightarrow'	, '???'],
    \ ['iff'            , '???'],
    \ ['Im'		, '???'],
    \ ['imath'		, '??'],
    \ ['in'		, '???'],
    \ ['infty'		, '???'],
    \ ['int'		, '???'],
    \ ['jmath'		, '????'],
    \ ['land'		, '???'],
    \ ['lnot'		, '??'],
    \ ['lceil'		, '???'],
    \ ['ldots'		, '???'],
    \ ['le'		, '???'],
    \ ['left('		, '('],
    \ ['left\['		, '['],
    \ ['left\\{'	, '{'],
    \ ['leftarrow'	, '???'],
    \ ['Leftarrow'	, '???'],
    \ ['leftharpoondown', '???'],
    \ ['leftharpoonup'	, '???'],
    \ ['leftrightarrow'	, '???'],
    \ ['Leftrightarrow'	, '???'],
    \ ['leq'		, '???'],
    \ ['leq'		, '???'],
    \ ['lfloor'		, '???'],
    \ ['ll'		, '???'],
    \ ['lmoustache'     , '???'],
    \ ['lor'		, '???'],
    \ ['mapsto'		, '???'],
    \ ['mid'		, '???'],
    \ ['models'		, '???'],
    \ ['mp'		, '???'],
    \ ['nabla'		, '???'],
    \ ['natural'	, '???'],
    \ ['ne'		, '???'],
    \ ['nearrow'	, '???'],
    \ ['neg'		, '??'],
    \ ['neq'		, '???'],
    \ ['ni'		, '???'],
    \ ['notin'		, '???'],
    \ ['nwarrow'	, '???'],
    \ ['odot'		, '???'],
    \ ['oint'		, '???'],
    \ ['ominus'		, '???'],
    \ ['oplus'		, '???'],
    \ ['oslash'		, '???'],
    \ ['otimes'		, '???'],
    \ ['owns'		, '???'],
    \ ['P'		, '??'],
    \ ['parallel'	, '???'],
    \ ['partial'	, '???'],
    \ ['perp'		, '???'],
    \ ['pm'		, '??'],
    \ ['prec'		, '???'],
    \ ['preceq'		, '???'],
    \ ['prime'		, '???'],
    \ ['prod'		, '???'],
    \ ['propto'		, '???'],
    \ ['rceil'		, '???'],
    \ ['Re'		, '???'],
    \ ['quad'		, '???'],
    \ ['qquad'		, '???'],
    \ ['rfloor'		, '???'],
    \ ['right)'		, ')'],
    \ ['right]'		, ']'],
    \ ['right\\}'	, '}'],
    \ ['rightarrow'	, '???'],
    \ ['Rightarrow'	, '???'],
    \ ['rightleftharpoons', '???'],
    \ ['rmoustache'     , '???'],
    \ ['S'		, '??'],
    \ ['searrow'	, '???'],
    \ ['setminus'	, '???'],
    \ ['sharp'		, '???'],
    \ ['sim'		, '???'],
    \ ['simeq'		, '???'],
    \ ['smile'		, '???'],
    \ ['spadesuit'	, '???'],
    \ ['sqcap'		, '???'],
    \ ['sqcup'		, '???'],
    \ ['sqsubset'	, '???'],
    \ ['sqsubseteq'	, '???'],
    \ ['sqsupset'	, '???'],
    \ ['sqsupseteq'	, '???'],
    \ ['star'		, '???'],
    \ ['subset'		, '???'],
    \ ['subseteq'	, '???'],
    \ ['succ'		, '???'],
    \ ['succeq'		, '???'],
    \ ['sum'		, '???'],
    \ ['supset'		, '???'],
    \ ['supseteq'	, '???'],
    \ ['surd'		, '???'],
    \ ['swarrow'	, '???'],
    \ ['times'		, '??'],
    \ ['to'		, '???'],
    \ ['top'		, '???'],
    \ ['triangle'	, '???'],
    \ ['triangleleft'	, '???'],
    \ ['triangleright'	, '???'],
    \ ['uparrow'	, '???'],
    \ ['Uparrow'	, '???'],
    \ ['updownarrow'	, '???'],
    \ ['Updownarrow'	, '???'],
    \ ['vdash'		, '???'],
    \ ['vdots'		, '???'],
    \ ['vee'		, '???'],
    \ ['wedge'		, '???'],
    \ ['wp'		, '???'],
    \ ['wr'		, '???']]
  if &ambw == "double" || exists("g:tex_usedblwidth")
    let s:texMathList= s:texMathList + [
    \ ['right\\rangle'	, '???'],
    \ ['left\\langle'	, '???']]
  else
    let s:texMathList= s:texMathList + [
    \ ['right\\rangle'	, '>'],
    \ ['left\\langle'	, '<']]
  endif
  for texmath in s:texMathList
   if texmath[0] =~# '\w$'
    exe "syn match texMathSymbol '\\\\".texmath[0]."\\>' contained conceal cchar=".texmath[1]
   else
    exe "syn match texMathSymbol '\\\\".texmath[0]."' contained conceal cchar=".texmath[1]
   endif
  endfor

  if &ambw == "double"
   syn match texMathSymbol '\\gg\>'			contained conceal cchar=???
   syn match texMathSymbol '\\ll\>'			contained conceal cchar=???
  else
   syn match texMathSymbol '\\gg\>'			contained conceal cchar=???
   syn match texMathSymbol '\\ll\>'			contained conceal cchar=???
  endif

  syn match texMathSymbol '\\hat{a}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{A}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{c}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{C}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{e}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{E}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{g}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{G}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{i}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{I}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{o}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{O}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{s}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{S}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{u}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{U}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{w}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{W}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{y}' contained conceal cchar=??
  syn match texMathSymbol '\\hat{Y}' contained conceal cchar=??
"  syn match texMathSymbol '\\bar{a}' contained conceal cchar=a??

  syn match texMathSymbol '\\dot{B}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{b}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{D}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{d}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{F}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{f}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{H}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{h}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{M}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{m}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{N}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{n}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{P}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{p}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{R}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{r}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{S}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{s}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{T}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{t}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{W}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{w}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{X}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{x}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{Y}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{y}' contained conceal cchar=???
  syn match texMathSymbol '\\dot{Z}' contained conceal cchar=??
  syn match texMathSymbol '\\dot{z}' contained conceal cchar=??

  syn match texMathSymbol '\\dot{C}' contained conceal cchar=??
  syn match texMathSymbol '\\dot{c}' contained conceal cchar=??
  syn match texMathSymbol '\\dot{E}' contained conceal cchar=??
  syn match texMathSymbol '\\dot{e}' contained conceal cchar=??
  syn match texMathSymbol '\\dot{G}' contained conceal cchar=??
  syn match texMathSymbol '\\dot{g}' contained conceal cchar=??
  syn match texMathSymbol '\\dot{I}' contained conceal cchar=??

  syn match texMathSymbol '\\dot{A}' contained conceal cchar=??
  syn match texMathSymbol '\\dot{a}' contained conceal cchar=??
  syn match texMathSymbol '\\dot{O}' contained conceal cchar=??
  syn match texMathSymbol '\\dot{o}' contained conceal cchar=??
 endif
 "}}}

 " Greek {{{2
 if s:tex_conceal =~# 'g'
  fun! s:Greek(group,pat,cchar)
    exe 'syn match '.a:group." '".a:pat."' contained conceal cchar=".a:cchar
  endfun
  call s:Greek('texGreek','\\alpha\>'		,'??')
  call s:Greek('texGreek','\\beta\>'		,'??')
  call s:Greek('texGreek','\\gamma\>'		,'??')
  call s:Greek('texGreek','\\delta\>'		,'??')
  call s:Greek('texGreek','\\epsilon\>'		,'??')
  call s:Greek('texGreek','\\varepsilon\>'	,'??')
  call s:Greek('texGreek','\\zeta\>'		,'??')
  call s:Greek('texGreek','\\eta\>'		,'??')
  call s:Greek('texGreek','\\theta\>'		,'??')
  call s:Greek('texGreek','\\vartheta\>'	,'??')
  call s:Greek('texGreek','\\iota\>'            ,'??')
  call s:Greek('texGreek','\\kappa\>'		,'??')
  call s:Greek('texGreek','\\lambda\>'		,'??')
  call s:Greek('texGreek','\\mu\>'		,'??')
  call s:Greek('texGreek','\\nu\>'		,'??')
  call s:Greek('texGreek','\\xi\>'		,'??')
  call s:Greek('texGreek','\\pi\>'		,'??')
  call s:Greek('texGreek','\\varpi\>'		,'??')
  call s:Greek('texGreek','\\rho\>'		,'??')
  call s:Greek('texGreek','\\varrho\>'		,'??')
  call s:Greek('texGreek','\\sigma\>'		,'??')
  call s:Greek('texGreek','\\varsigma\>'	,'??')
  call s:Greek('texGreek','\\tau\>'		,'??')
  call s:Greek('texGreek','\\upsilon\>'		,'??')
  call s:Greek('texGreek','\\phi\>'		,'??')
  call s:Greek('texGreek','\\varphi\>'		,'??')
  call s:Greek('texGreek','\\chi\>'		,'??')
  call s:Greek('texGreek','\\psi\>'		,'??')
  call s:Greek('texGreek','\\omega\>'		,'??')
  call s:Greek('texGreek','\\Gamma\>'		,'??')
  call s:Greek('texGreek','\\Delta\>'		,'??')
  call s:Greek('texGreek','\\Theta\>'		,'??')
  call s:Greek('texGreek','\\Lambda\>'		,'??')
  call s:Greek('texGreek','\\Xi\>'              ,'??')
  call s:Greek('texGreek','\\Pi\>'		,'??')
  call s:Greek('texGreek','\\Sigma\>'		,'??')
  call s:Greek('texGreek','\\Upsilon\>'		,'??')
  call s:Greek('texGreek','\\Phi\>'		,'??')
  call s:Greek('texGreek','\\Chi\>'		,'??')
  call s:Greek('texGreek','\\Psi\>'		,'??')
  call s:Greek('texGreek','\\Omega\>'		,'??')
  delfun s:Greek
 endif
"}}}

 " Superscripts/Subscripts {{{2
 if s:tex_conceal =~# 's'
  if s:tex_fast =~# 's'
   syn region texSuperscript	matchgroup=Delimiter start='\^{'	skip="\\\\\|\\[{}]" end='}'	contained concealends contains=texSpecialChar,texSuperscripts,texStatement,texSubscript,texSuperscript,texMathMatcher
   syn region texSubscript	matchgroup=Delimiter start='_{'		skip="\\\\\|\\[{}]" end='}'	contained concealends contains=texSpecialChar,texSubscripts,texStatement,texSubscript,texSuperscript,texMathMatcher
  endif
  " s:SuperSub:
  fun! s:SuperSub(group,leader,pat,cchar)
    if a:pat =~# '^\\' || (a:leader == '\^' && a:pat =~# s:tex_superscripts) || (a:leader == '_' && a:pat =~# s:tex_subscripts)
"     call Decho("SuperSub: group<".a:group."> leader<".a:leader."> pat<".a:pat."> cchar<".a:cchar.">")
     exe 'syn match '.a:group." '".a:leader.a:pat."' contained conceal cchar=".a:cchar
     exe 'syn match '.a:group."s '".a:pat        ."' contained conceal cchar=".a:cchar.' nextgroup='.a:group.'s'
    endif
  endfun
  call s:SuperSub('texSuperscript','\^','0','???')
  call s:SuperSub('texSuperscript','\^','1','??')
  call s:SuperSub('texSuperscript','\^','2','??')
  call s:SuperSub('texSuperscript','\^','3','??')
  call s:SuperSub('texSuperscript','\^','4','???')
  call s:SuperSub('texSuperscript','\^','5','???')
  call s:SuperSub('texSuperscript','\^','6','???')
  call s:SuperSub('texSuperscript','\^','7','???')
  call s:SuperSub('texSuperscript','\^','8','???')
  call s:SuperSub('texSuperscript','\^','9','???')
  call s:SuperSub('texSuperscript','\^','a','???')
  call s:SuperSub('texSuperscript','\^','b','???')
  call s:SuperSub('texSuperscript','\^','c','???')
  call s:SuperSub('texSuperscript','\^','d','???')
  call s:SuperSub('texSuperscript','\^','e','???')
  call s:SuperSub('texSuperscript','\^','f','???')
  call s:SuperSub('texSuperscript','\^','g','???')
  call s:SuperSub('texSuperscript','\^','h','??')
  call s:SuperSub('texSuperscript','\^','i','???')
  call s:SuperSub('texSuperscript','\^','j','??')
  call s:SuperSub('texSuperscript','\^','k','???')
  call s:SuperSub('texSuperscript','\^','l','??')
  call s:SuperSub('texSuperscript','\^','m','???')
  call s:SuperSub('texSuperscript','\^','n','???')
  call s:SuperSub('texSuperscript','\^','o','???')
  call s:SuperSub('texSuperscript','\^','p','???')
  call s:SuperSub('texSuperscript','\^','r','??')
  call s:SuperSub('texSuperscript','\^','s','??')
  call s:SuperSub('texSuperscript','\^','t','???')
  call s:SuperSub('texSuperscript','\^','u','???')
  call s:SuperSub('texSuperscript','\^','v','???')
  call s:SuperSub('texSuperscript','\^','w','??')
  call s:SuperSub('texSuperscript','\^','x','??')
  call s:SuperSub('texSuperscript','\^','y','??')
  call s:SuperSub('texSuperscript','\^','z','???')
  call s:SuperSub('texSuperscript','\^','A','???')
  call s:SuperSub('texSuperscript','\^','B','???')
  call s:SuperSub('texSuperscript','\^','D','???')
  call s:SuperSub('texSuperscript','\^','E','???')
  call s:SuperSub('texSuperscript','\^','G','???')
  call s:SuperSub('texSuperscript','\^','H','???')
  call s:SuperSub('texSuperscript','\^','I','???')
  call s:SuperSub('texSuperscript','\^','J','???')
  call s:SuperSub('texSuperscript','\^','K','???')
  call s:SuperSub('texSuperscript','\^','L','???')
  call s:SuperSub('texSuperscript','\^','M','???')
  call s:SuperSub('texSuperscript','\^','N','???')
  call s:SuperSub('texSuperscript','\^','O','???')
  call s:SuperSub('texSuperscript','\^','P','???')
  call s:SuperSub('texSuperscript','\^','R','???')
  call s:SuperSub('texSuperscript','\^','T','???')
  call s:SuperSub('texSuperscript','\^','U','???')
  call s:SuperSub('texSuperscript','\^','W','???')
  call s:SuperSub('texSuperscript','\^',',','???')
  call s:SuperSub('texSuperscript','\^',':','???')
  call s:SuperSub('texSuperscript','\^',';','???')
  call s:SuperSub('texSuperscript','\^','+','???')
  call s:SuperSub('texSuperscript','\^','-','???')
  call s:SuperSub('texSuperscript','\^','<','??')
  call s:SuperSub('texSuperscript','\^','>','??')
  call s:SuperSub('texSuperscript','\^','/','??')
  call s:SuperSub('texSuperscript','\^','(','???')
  call s:SuperSub('texSuperscript','\^',')','???')
  call s:SuperSub('texSuperscript','\^','\.','??')
  call s:SuperSub('texSuperscript','\^','=','??')
  call s:SuperSub('texSubscript','_','0','???')
  call s:SuperSub('texSubscript','_','1','???')
  call s:SuperSub('texSubscript','_','2','???')
  call s:SuperSub('texSubscript','_','3','???')
  call s:SuperSub('texSubscript','_','4','???')
  call s:SuperSub('texSubscript','_','5','???')
  call s:SuperSub('texSubscript','_','6','???')
  call s:SuperSub('texSubscript','_','7','???')
  call s:SuperSub('texSubscript','_','8','???')
  call s:SuperSub('texSubscript','_','9','???')
  call s:SuperSub('texSubscript','_','a','???')
  call s:SuperSub('texSubscript','_','e','???')
  call s:SuperSub('texSubscript','_','h','???')
  call s:SuperSub('texSubscript','_','i','???')
  call s:SuperSub('texSubscript','_','j','???')
  call s:SuperSub('texSubscript','_','k','???')
  call s:SuperSub('texSubscript','_','l','???')
  call s:SuperSub('texSubscript','_','m','???')
  call s:SuperSub('texSubscript','_','n','???')
  call s:SuperSub('texSubscript','_','o','???')
  call s:SuperSub('texSubscript','_','p','???')
  call s:SuperSub('texSubscript','_','r','???')
  call s:SuperSub('texSubscript','_','s','???')
  call s:SuperSub('texSubscript','_','t','???')
  call s:SuperSub('texSubscript','_','u','???')
  call s:SuperSub('texSubscript','_','v','???')
  call s:SuperSub('texSubscript','_','x','???')
  call s:SuperSub('texSubscript','_',',','???')
  call s:SuperSub('texSubscript','_','+','???')
  call s:SuperSub('texSubscript','_','-','???')
  call s:SuperSub('texSubscript','_','/','??')
  call s:SuperSub('texSubscript','_','(','???')
  call s:SuperSub('texSubscript','_',')','???')
  call s:SuperSub('texSubscript','_','\.','???')
  call s:SuperSub('texSubscript','_','r','???')
  call s:SuperSub('texSubscript','_','v','???')
  call s:SuperSub('texSubscript','_','x','???')
  call s:SuperSub('texSubscript','_','\\beta\>' ,'???')
  call s:SuperSub('texSubscript','_','\\delta\>','???')
  call s:SuperSub('texSubscript','_','\\phi\>'  ,'???')
  call s:SuperSub('texSubscript','_','\\gamma\>','???')
  call s:SuperSub('texSubscript','_','\\chi\>'  ,'???')

  delfun s:SuperSub
 endif

 " Accented characters and Ligatures: {{{2
 if s:tex_conceal =~# 'a'
  if b:tex_stylish
   syn match texAccent		"\\[bcdvuH][^a-zA-Z@]"me=e-1
   syn match texLigature	"\\\([ijolL]\|ae\|oe\|ss\|AA\|AE\|OE\)[^a-zA-Z@]"me=e-1
   " syn match texLigature	'--'
   " syn match texLigature	'---'
  else
   fun! s:Accents(chr,...)
     let i= 1
     for accent in ["`","\\'","^",'"','\~','\.','=',"c","H","k","r","u","v"]
      if i > a:0
       break
      endif
      if strlen(a:{i}) == 0 || a:{i} == ' ' || a:{i} == '?'
       let i= i + 1
       continue
      endif
      if accent =~# '\a'
       exe "syn match texAccent '".'\\'.accent.'\(\s*{'.a:chr.'}\|\s\+'.a:chr.'\)'."' conceal cchar=".a:{i}
      else
       exe "syn match texAccent '".'\\'.accent.'\s*\({'.a:chr.'}\|'.a:chr.'\)'."' conceal cchar=".a:{i}
      endif
      let i= i + 1
     endfor
   endfun
   "                  \`  \'  \^  \"  \~  \.  \=  \c  \H  \k  \r  \u  \v
   call s:Accents('a','??','??','??','??','??','??','??',' ',' ','??','??','??','??')
   call s:Accents('A','??','??','??','??','??','??','??',' ',' ','??','??','??','??')
   call s:Accents('c',' ','??','??',' ',' ','??',' ','??',' ',' ',' ',' ','??')
   call s:Accents('C',' ','??','??',' ',' ','??',' ','??',' ',' ',' ',' ','??')
   call s:Accents('d',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','??')
   call s:Accents('D',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','??')
   call s:Accents('e','??','??','??','??','???','??','??','??',' ','??',' ','??','??')
   call s:Accents('E','??','??','??','??','???','??','??','??',' ','??',' ','??','??')
   call s:Accents('g',' ','??','??',' ',' ','??',' ','??',' ',' ',' ','??','??')
   call s:Accents('G',' ','??','??',' ',' ','??',' ','??',' ',' ',' ','??','??')
   call s:Accents('h',' ',' ','??',' ',' ',' ',' ',' ',' ',' ',' ',' ','??')
   call s:Accents('H',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','??')
   call s:Accents('i','??','??','??','??','??','??','??',' ',' ','??',' ','??','??')
   call s:Accents('I','??','??','??','??','??','??','??',' ',' ','??',' ','??','??')
   call s:Accents('J',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','??')
   call s:Accents('k',' ',' ',' ',' ',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('K',' ',' ',' ',' ',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('l',' ','??','??',' ',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('L',' ','??','??',' ',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('n',' ','??',' ',' ','??',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('N',' ','??',' ',' ','??',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('o','??','??','??','??','??','??','??',' ','??','??',' ','??','??')
   call s:Accents('O','??','??','??','??','??','??','??',' ','??','??',' ','??','??')
   call s:Accents('r',' ','??',' ',' ',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('R',' ','??',' ',' ',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('s',' ','??','??',' ',' ',' ',' ','??',' ','??',' ',' ','??')
   call s:Accents('S',' ','??','??',' ',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('t',' ',' ',' ',' ',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('T',' ',' ',' ',' ',' ',' ',' ','??',' ',' ',' ',' ','??')
   call s:Accents('u','??','??','??','??','??',' ','??',' ','??','??','??','??','??')
   call s:Accents('U','??','??','??','??','??',' ','??',' ','??','??','??','??','??')
   call s:Accents('w',' ',' ','??',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ')
   call s:Accents('W',' ',' ','??',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ')
   call s:Accents('y','???','??','??','??','???',' ',' ',' ',' ',' ',' ',' ',' ')
   call s:Accents('Y','???','??','??','??','???',' ',' ',' ',' ',' ',' ',' ',' ')
   call s:Accents('z',' ','??',' ',' ',' ','??',' ',' ',' ',' ',' ',' ','??')
   call s:Accents('Z',' ','??',' ',' ',' ','??',' ',' ',' ',' ',' ',' ','??')
   call s:Accents('\\i','??','??','??','??','??','??',' ',' ',' ',' ',' ','??',' ')
   "                    \`  \'  \^  \"  \~  \.  \=  \c  \H  \k  \r  \u  \v
   delfun s:Accents
   syn match texAccent		'\\aa\>'	conceal cchar=??
   syn match texAccent		'\\AA\>'	conceal cchar=??
   syn match texAccent		'\\o\>'		conceal cchar=??
   syn match texAccent		'\\O\>'		conceal cchar=??
   syn match texLigature	'\\AE\>'	conceal cchar=??
   syn match texLigature	'\\ae\>'	conceal cchar=??
   syn match texLigature	'\\oe\>'	conceal cchar=??
   syn match texLigature	'\\OE\>'	conceal cchar=??
   syn match texLigature	'\\ss\>'	conceal cchar=??
   " syn match texLigature	'--'		conceal cchar=???
   " syn match texLigature	'---'		conceal cchar=???
  endif
 endif
endif
"}}}

"}}}
"}}}

let b:okularopened=0

syntax region Statement start='\\ref{' end='}' transparent contains=myStart,myEnd
syntax match myStart '\\ref{\ze\w\+' contained conceal cchar=[
syntax match myEnd '\(\\ref{\w\+\)\@<=\zs}' contained conceal cchar=]



"????????????????????? ????????????????????? ????????????????????? ????????????????????? ????????????????????? ?????????????????????
" ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ???
" ????????????????????? ????????????????????? ????????????????????? ????????????????????? ????????????????????? ?????????????????????
" ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ???
" ????????????????????? ????????????????????? ????????????????????? ????????????????????? ????????????????????? ?????????????????????
" ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ??? ???
" ????????????????????? ????????????????????? ????????????????????? ????????????????????? ????????????????????? ?????????????????????




hi! link Conceal Statement


syn match pandocGridTableCornerMidMid  /-\@<=+-\@=/ contained containedin=pandocGridTable conceal cchar=???
" syn match pandocGridCornerFirstMid /^+-\@=/ contained containedin=pandocGridTable conceal cchar=???

" Header lines
syn match pandocGridTableCornerHeaderLine /=/ contained containedin=pandocGridTable conceal cchar=???
syn match pandocGridTableCornerHeaderMid /+=\@=/ contained containedin=pandocGridTable conceal cchar=???
syn match pandocGridTableCornerHeaderFirst /^+=\@=/ contained containedin=pandocGridTable conceal cchar=???
syn match pandocGridTableCornerHeaderLast /=\@<=+$/ contained containedin=pandocGridTable conceal cchar=???

" Lines of a table
syn match pandocGridTableHorizontalLine /-/ contained containedin=pandocGridTable conceal cchar=???
syn match pandocGridTableVerticalLine /|/ contained containedin=pandocGridTable conceal cchar=???

" syn match pandocGridCornerMidFirst /\(\n\)\@<=+-\@=/ contained containedin=pandocGridTable conceal cchar=???
syn match pandocGridTableCornerTopMid /\(\(+\||\)\n.*\)\@<!+-\@=/ contained containedin=pandocGridTable conceal cchar=???
syn match pandocGridTableCornerMidRight /-\@<=+\(\n\(+\|-\||\)\)\@=/ contained containedin=pandocGridTable conceal cchar=???
syn match pandocGridTableCornerTopRight /\(\(+\||\)\n.*\)\@<!+-\@!/ contained containedin=pandocGridTable conceal cchar=???
syn match pandocGridTableCornerTopLeft /\(\(+\||\)\n\|-\)\@<!+-\@=/ contained containedin=pandocGridTable conceal cchar=???
" syn match pandocGridTableMidStart /\(\(+\||\)\n\)\@<=+-\@=/ contained containedin=pandocGridTable conceal cchar=???
syn match pandocGridTableCornerBottomMid /+\(.*\n\n\)\@=/ contained containedin=pandocGridTable conceal cchar=???
syn match pandocGridTableCornerBottomRight /-\@<=+\(\n\(+\||\)\|-\)\@!/ contained containedin=pandocGridTable conceal cchar=???
syn match pandocGridTableCornerBottomLeft /^+\(.*\n\n\)\@=/ contained containedin=pandocGridTable conceal cchar=???
syn match pandocGridTableCornerBottomLeft2 /\n\@<=+\(.*\n\n\)\@=/ contained containedin=pandocGridTable conceal cchar=???

let b:table_mode_corner = '+'

function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'

exec "source " . fnamemodify(expand("$MYVIMRC"), ":h") . "/markdown/corrections.vim"

set ft=markdown.pandoc
let g:table_mode_corner='+'
let b:table_mode_corner='+'

