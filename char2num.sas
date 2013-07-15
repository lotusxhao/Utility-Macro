/*=============================================================================
/ Program   : char2num.sas
/ Author    : Wendi Wang
/ Date      : 11-Jul-2013
/ Purpose   : To "effectively" convert a list of character variables to numeric
/             variable (including number, currency and time)
/ SubMacros : %words
/ Notes     : Converting variable types in SAS datasets is not allowed so this
/             macro will create new numeric variables having the same name as
/             the original character variables as well as the same label. You
/             might find the %numchars macro useful for extracting a list of
/             numeric-like character variables. All variables must be specified
/             as a space delimited list. Forms such as char: and char1-char12
/             are not allowed. No modifiers in brackets are allowed against the
/             input and output data set names.
/ Usage     : %char2num(ds, char1 char2 char3 char4)
/             %char2num(dsin, dsout, char1 char2, fmt=date9.) 
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ dsin              (pos) Input data set (no modifiers in brackets allowed)
/ vars              (pos) Character variables to convert to numeric
/ dsout             (pos) Output data set. Will default to input dataset if not
/                   specified.
/ fmt=comma32.      Informat: default is comma32. If set to other format, then
/                   convert character variable into other type variable
/=============================================================================*/

%put MACRO CALLED: char2num;

%macro char2num(dsin, vars, dsout, fmt=comma32.);
  
  %local errflag err;
  %let err = ERR%str(OR);
  %let errflag = 0;

  %if not %length(&dsin) %then %do;
    %let errflag = 1;
    %put &err: (char2num) No parameter define to dsin =;
  %end;

  %if not %length(&dsout) %then %let dsout = %scan(&dsin, 1, %str(%());

  %if &errflag %then %goto exit;

  %local i w oldlist lib mem;
  %let w = %words(&vars);
  
  * if output a permanent data set;
  %if %length(%scan(&dsout, 2, .)) %then %do;
    %let lib = %scan(&dsout, 1, .);
    %let mem = %scan(&dsout, 2, .);
  %end;
  %else %do;
    %let lib = ;
    %let mem = &dsout;
  %end;

  %do i = 1 %to &w;
    %let oldlist = &oldlist old_%scan(&vars, &i, %str( ));
  %end;

  data &dsout;
    length _execode $ 200;
    set &dsin(rename = (
    %do i = 1 %to &w;
      %scan(&vars, &i, %str( )) = %scan(&oldlist, &i, %str( ))
    %end;
    )) end = last;
    %do i = 1 %to &w;
      %scan(&vars, &i, %str( )) = input(%scan(&oldlist, &i, %str( )), &fmt);
    %end;

    if _error_ > 0 then do;
      put;
      put "&err: (char2num) The format chosen did not match the raw data type.";
      put;
      abort cancel;
    end;
    
    * copy the label from the old data set;
    if last then do;
      _execode = "proc datasets nolist memtype=data ";
      call execute(_execode);
      %if %length(&lib) %then %do;
        _execode = " lib=&lib ;modify &mem;label ";
      %end;
      %else %do;
        _execode = ";modify &mem;label ";
      %end;
      call execute(_execode);

      %do i = 1 %to &w;
        if vlabel(%scan(&oldlist, &i, %str( ))) ne "%scan(&oldlist, &i, %str( ))" then do;
          _execode = " %scan(&vars, &i, %str( )) = ";
          call execute(_execode);
          _execode = "'" || trim(tranwrd(vlabel(%scan(&oldlist, &i, %str( ))), "'", "''")) || "'";
          call execute(_execode);
        end;
      %end;
      call execute(';run;quit;');
    end;

    drop &oldlist _execode;
  run;
  
  %goto skip;
  %exit: %put &err: (char2num) Leaving macro due to problem(s) listed;
  %skip:

%mend char2num;


