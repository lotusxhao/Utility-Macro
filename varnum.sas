/*=============================================================================
/ Program   : varnum.sas
/ Author    : Wendi Wang
/ Date      : 15-Jul-2013
/ Purpose   : Function-style macro to return the variable position in a dataset
/             or 0 if not in dataset.
/ SubMacros : none
/ Notes     : Since only 0 or a positive integer is returned you can use this
/             like a truth statement such as %if %varnum(dsname, varnam) %then..
/ Usage     : %let varnum = %varnum(dsname, varname);
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                (pos) Dataset name
/ var               (pos) Variable name
/=============================================================================*/

%put MACRO CALLED: varnum;

%macro varnum(ds, var);

  %local dsid rc varnum err;

  %let varnum = 0;
  %let err = ERR%str(OR);
  %let dsid = %sysfunc(open(&ds, is));
  %if &dsid EQ 0 %then %do;
    %put &err: (varnum) Dataset &ds not opened due to the following reason:;
    %put %sysfunc(sysmsg());
  %end;
  %else %do;
    %let varnum = %sysfunc(varnum(&dsid, &var));
    %let rc = %sysfunc(close(&dsid));
  %end;

&varnum

%mend varnum;
