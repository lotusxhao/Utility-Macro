/*=============================================================================
/ Program   : quotelst.sas
/ Author    : Wendi Wang
/ Date      : 16-Jul-2013
/ Purpose   : Function-style macro to quote the elements of a list
/ SubMacros : none
/ Notes     : DO NOT COPY AND PASTE THIS FROM THIS BROWSER WINDOW. YOU MUST USE
/             THE "VIEW" PULL-DOWN WINDOW AND USE "SOURCE". This is because the
/             browser will change some of the characters in this file to quotes.
/
/             This is useful to turn a list into a quoted list so that you can
/             use the in() function on it in a data step. Also, if you search for
/             a quoted string among a list of quoted strings then you can avoid
/             matching on a subset of a single element. Note that you can change
/             not only the quote mark but the delimiter as well so you can use
/             this macro for other purposes like putting commas between variable
/             names etc. It is assumed that the elements of the list are
/             delimited by spaces.
/ Usage     : %if %index(%quotelst(varnames), "varname") %then...
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ str               (pos) String to quote elements of
/ quote=%str(%")    Quote character to use (defaults to double quotation mark)
/ delim=%str( )     Delimiter character to use (defaults to a space)
/=============================================================================*/

%put MACRO CALLED: quotelst;

%macro quotelst(str, quote = %str(%"), delim = %str( ));

  %local i quotelst;
  %let i = 1;
  %do %while(%length(%qscan(&str, &i, %str( ))) GT 0);
    %if %length(&quotelst) EQ 0 %then %let quotelst = &quote.%qscan(&str, &i, %str( ))&quote;
    %else %let quotelst = &quotelst.&quote.%qscan(&str, &i, %str( ))&quote;
    %let i = %eval(&i + 1);
    %if %length(%qscan(&str, &i, %str( ))) GT 0 %then %let quotelst = &quotelst.&delim;
  %end;
%unquote(&quotelst)

%mend quotelst;
