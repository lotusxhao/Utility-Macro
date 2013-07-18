/*==============================================================================
/ Program   : nodup.sas
/ Author    : Wendi Wang
/ Date      : 17-Jul-2013
/ Purpose   : Function-style macro to drop duplicates in a space-delimited list
/ SubMacros : %words
/ Notes     : 
/ Usage     : %let str = %nodup(aaa bbb aaa);
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ list              (pos) space-delimited list of items
/ casesens=no       Case sensitive. no by default.
/=============================================================================*/

%put MACRO CALLED: nodup;

%macro nodup(list, casesens = no);

  %local i j match item errflag err;
  %let err = ERR%str(OR);
  %let errflag = 0;
  %if not %length(&casesens) %then %let casesens = no;
  %let casesens = %upcase(%substr(&casesens,1,1));

  %if not %index(YN,&casesens) %then %do;
    %put &err: (nodup) casesens must be set to yes or no;
    %let errflag=1;
  %end;

  %if &errflag %then %goto exit;

  %do i = 1 %to %words(&list);
    %let item = %scan(&list, &i, %str( ));
    %let match = NO;
    %do j = %eval(&i+1) %to %words(&list);
      %if &casesens EQ Y %then %do;
        %if "&item" EQ "%scan(&list, &j, %str( ))" %then %let match = YES;
      %end;
      %else %do;
        %if "%upcase(&item)" EQ "%upcase(%scan(&list, &j, %str( )))" %then %let match = YES;
      %end;
    %end;
    %if &match EQ NO %then &item;
  %end;

  %goto skip;
  %exit: %put &err: (nodup) Leaving macro due to problem(s) listed;
  %skip:

%mend nodup;
  
