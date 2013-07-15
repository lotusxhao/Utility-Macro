/*==============================================================================
/ Program   : attrv.sas
/ Author    : Wendi Wang
/ Date      : 11-Jul-2013
/ Purpose   : Function-style macro to return a variable attribute
/ SubMacros : none
/ Notes     : This is a low-level utility macro that other shell macros will
/             call. The full list of variable attributes can be found in the
/             SAS documentation. The most common ones used will be VARTYPE,
/             VARLEN, VARLABEL, VARFMT and VARINFMT.
/
/             This macro will only work correctly for datasets (i.e. not views)
/             and where there are no dataset modifiers.
/
/ Usage     : %let vartype=%attrv(dsname, varname, vartype);
/ 
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                (pos) Dataset name (do not use views or dataset modifiers)
/ var               (pos) Variable name
/ attrib            (pos) Attribute
/=============================================================================*/

%put MACRO CALLED: attrv;

%macro attrv(ds, var, attrib);

  %local dsid rc varnum err;
  %let err = ERR%str(OR);
  %let dsid = %sysfunc(open(&ds, is));
  %if &dsid EQ 0 %then %do;
    %put &err: (attrv) Dataset &ds not opened due to the following reason:;
    %put %sysfunc(sysmsg());
  %end;
  %else %do;
    %let varnum = %sysfunc(varnum(&dsid, &var));
    %if &varnum LT 1 %then %put &err: (attrv) Variable &var not in dataset &ds;
    %else %do;
%sysfunc(&attrib(&dsid, &varnum))
    %end;
    %let rc = %sysfunc(close(&dsid));
  %end;

%mend attrv;
