/*==============================================================================
/ Program   : dsall.sas
/ Author    : Wendi Wang
/ Date      : 17-Jul-2013
/ Purpose   : To expand out the _all_ in a dataset list into all datasets in the
/             library.
/ SubMacros : %words %dslist
/ Notes     : This is NOT a function-style macro. See usage notes.
/             The list of datasets will be written to the global macro variable
/             _dsall_.
/ Usage     : %dsall(sasuser.test work._all_);
/             %let dsall = &_dsall_;
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ list              (pos) List of datasets some of which may be referred to 
/                   using the _all_ notation.
/=============================================================================*/

%put MACRO CALLED: dsall;

%macro dsall(list);

  %global _dsall_;
  %let _dsall_ = ;
  %local i;
  %do i = 1 %to %words(&list);
    %if "%upcase(%scan(%scan(&list, &i, %str( )), 2, .))" NE "_ALL_" %then 
      %let _dsall_ = &_dsall_ %scan(&list, &i, %str( ));
    %else %do;
      %dslist(%scan(%scan(&list, &i, %str( )), 1, .), yes)
      %let _dsall_ = &_dsall_ &_dslist_;
    %end;
  %end;

%mend dsall;
