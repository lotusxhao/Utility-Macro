/*==============================================================================
/ Program   : nvars.sas
/ Author    : Wendi Wang
/ Date      : 15-Jul-2013
/ Purpose   : Function-style macro to return the number of variables (all, 
/             character or numeric) in a dataset.
/ SubMacros : %attrn %words %varlist
/ Notes     : This is a shell macro that calls %attrn
/ Usage     : %let nvars=%nvars(dsname, type = chr);
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                Dataset name
/ type = all        Set the type of variable list (all, character, or numeric)
/                   only the first letter will be used
/=============================================================================*/

%put MACRO CALLED: nvars;

%macro nvars(ds, type = all);
  
  %local err dsid rc;
  %let type = %substr(%upcase(&type), 1, 1);
  %if &type ne N and &type ne C %then %let type = A;
  
  %let err = ERR%str(OR);
  %let dsid = %sysfunc(open(&ds, is));
  %if &dsid EQ 0 %then %do;
    %put &err: (varlist) Dataset &ds not opened due to the following reason:;
    %put %sysfunc(sysmsg());
  %end;
  %else %do;
    %let nvars = %attrn(&ds, nvars);
    %if &nvars LT 1 %then %put &err: (varlist) No variables in dataset &ds;
    %else %let nvars = %words(%varlist(&ds, type = &type));
  %end;

&nvars

%mend nvars;

