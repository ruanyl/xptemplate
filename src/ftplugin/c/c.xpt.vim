XPTemplate priority=lang indent=auto


XPTvar $TRUE           1
XPTvar $FALSE          0
XPTvar $NULL           NULL

XPTvar $IF_BRACKET_STL     \ 
XPTvar $FOR_BRACKET_STL    \ 
XPTvar $WHILE_BRACKET_STL  \ 
XPTvar $STRUCT_BRACKET_STL \ 

XPTvar $INDENT_HELPER  /* void */;
XPTvar $CURSOR_PH      /* cursor */

XPTvar $CL  /*
XPTvar $CM   *
XPTvar $CR   */


XPTinclude
      \ _common/common
      \ _comment/c.like
      \ _condition/c.like
      \ _loops/c.for.like
      \ _loops/c.while.like
      \ _structures/c.like
      \ _preprocessor/c.like


" ========================= Function and Varaibles =============================

let s:f = XPTcontainer()[0]

let s:printfElts = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

"  %[flags][width][.precision][length]specifier  
let s:printfItemPattern = '\V\C' . '%' . '\[+\- 0#]\*' . '\%(*\|\d\+\)\?' . '\(.*\|.\d\+\)\?' . '\[hlL]\?' . '\(\[cdieEfgGosuxXpn]\)'

let s:printfSpecifierMap = {
      \'c' : 'char',
      \'d' : 'int',
      \'i' : 'int',
      \'e' : 'scientific',
      \'E' : 'scientific',
      \'f' : 'float',
      \'g' : 'float',
      \'G' : 'float',
      \'o' : 'octal',
      \'s' : 'str',
      \'u' : 'unsigned',
      \'x' : 'decimal',
      \'X' : 'Decimal',
      \'p' : 'pointer',
      \'n' : 'numWritten',
      \}

fun! s:f.c_printfElts( v )
  " remove '%%' representing a single '%'
  let v = substitute( a:v, '\V%%', '', 'g' )

  if v =~ '\V%'

    let start = 0
    let post = ''
    let i = -1
    while 1
      let i += 1

      let start = match( v, s:printfItemPattern, start )
      if start < 0
        break
      endif

      let eltList = matchlist( v, s:printfItemPattern, start )

      if eltList[1] == '.*'
        " need to specifying string length before string pointer
        let post .= ', `' . s:printfElts[ i ] . '_len^'
      endif

      let post .= ', `' . s:printfElts[ i ] . '_' . s:printfSpecifierMap[ eltList[2] ] . '^'

      let start += len( eltList[0] )

    endwhile
    return post

  else 
    return self.Next( '' )

  endif
endfunction

" ================================= Snippets ===================================
XPTemplateDef

XPT printf	hint=printf\\(...)
XSET elts=c_printfElts( R( 'pattern' ) )
printf( "`pattern^"`elts^ )


XPT sprintf alias=printf
XSET elts=c_printfElts( R( 'pattern' ) )
sprintf( `str^, "`pattern^"`elts^ )


XPT snprintf alias=printf
XSET elts=c_printfElts( R( 'pattern' ) )
snprintf( `str^, `size^, "`pattern^"`elts^ )


XPT fprintf alias=printf
XSET elts=c_printfElts( R( 'pattern' ) )
fprintf( `stream^, "`pattern^"`elts^ )


XPT assert	hint=assert\ (..,\ msg)
assert(`isTrue^, "`text^")

XPT main hint=main\ (argc,\ argv)
  int
main(int argc, char **argv)
{
    `cursor^
    return 0;
}
..XPT

" Quick-Repetition parameters list
XPT fun		hint=func..\ (\ ..\ )\ {...
XSET p_disabled..|post=ExpandIfNotEmpty(', ', 'p..')
  `int^
`name^(`^)
{
  `cursor^
}

XPT cmt
/**
 * @author : `$author^ | `$email^
 * @description
 *     `cursor^
 * @return {`int^} `desc^
 */


XPT para syn=comment	hint=comment\ parameter
@param {`Object^} `name^ `desc^


XPT filehead
/**-------------------------/// `sum^ \\\---------------------------
 *
 * <b>`function^</b>
 * @version : `1.0^
 * @since : `strftime("%Y %b %d")^
 * 
 * @description :
 *     `cursor^
 * @usage : 
 * 
 * @author : `$author^ | `$email^
 * @copyright `.com.cn^ 
 * @TODO : 
 * 
 *--------------------------\\\ `sum^ ///---------------------------*/

