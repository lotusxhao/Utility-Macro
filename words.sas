/*==============================================================================
/ Program   : words.sas
/ Author    : Wendi Wang
/ Date      : 11-Jul-2013
/ Purpose   : Function-style macro to return the number of words in a string
/ SubMacros : none
/ Notes     : You can change the delimiter to other than a space if required.
/ Usage     : %let words=%words(string);
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ str               (pos) String (UNQUOTED)
/ delim=%str( )     Delimeter (defaults to a space)
/=============================================================================*/

%put MACRO CALLED: words;

%macro words(str, delim = %str( ));
  %local i;
  %let i = 1;
  %do %while(%length(%qscan(&str, &i, &delim)) GT 0);
    %let i = %eval(&i + 1);
  %end;
%eval(&i - 1)
%mend words;
