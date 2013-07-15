/*==============================================================================
/ Program   : varlist.sas
/ Author    : Wendi Wang
/ Date      : 15-Jul-2013
/ Purpose   : Function-style macro to return a list of variables (all, character
/             or numeric) in a dataset
/ SubMacros : none
/ Notes     : Variable names will be in uppercase.
/ Usage     : %let varlist = %varlist(dsname, type = chr);
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                (pos) Dataset name
/ type = all        Set the type of variable list (all, character, or numeric)
/                   Only the first letter will be used
/=============================================================================*/

%put MACRO CALLED: varlist;

%macro varlist(ds, type = all);

  %local dsid rc nvars i varlist err;
  %let type = %substr(%upcase(&type), 1, 1);
  %if &type ne N and &type ne C %then %let type = A;

  %let err = ERR%str(OR);
  %let dsid = %sysfunc(open(&ds, is));
  %if &dsid EQ 0 %then %do;
    %put &err: (varlist) Dataset &ds not opened due to the following reason:;
    %put %sysfunc(sysmsg());
  %end;
  %else %do;
    %let nvars = %sysfunc(attrn(&dsid, nvars));
    %if &nvars LT 1 %then %put &err: (varlist) No variables in dataset &ds;
    %else %do;
      /* numeric variable list */
      %if &type EQ N %then %do;
        %do i = 1 %to &nvars;
          %if "%sysfunc(vartype(&dsid, &i))" EQ "N" %then %do;
            %if %length(&varlist) EQ 0 %then %let varlist = %sysfunc(varname(&dsid, &i));
            %else %let varlist = &varlist %sysfunc(varname(&dsid, &i));
          %end;
        %end;
      %end;
      /* character variable list */
      %if &type EQ C %then %do;
        %do i = 1 %to &nvars;
          %if "%sysfunc(vartype(&dsid, &i))" EQ "C" %then %do;
            %if %length(&varlist) EQ 0 %then %let varlist = %sysfunc(varname(&dsid, &i));
            %else %let varlist = &varlist %sysfunc(varname(&dsid, &i));
          %end;
        %end;
      %end;
      /* all variable list */
      %if &type EQ A %then %do;
        %do i = 1 %to &nvars;
          %if %length(&varlist) EQ 0 %then %let varlist = %sysfunc(varname(&dsid, &i));
          %else %let varlist = &varlist %sysfunc(varname(&dsid, &i));
        %end;
      %end;
    %end;
    %let rc = %sysfunc(close(&dsid));
  %end;
&varlist

%mend varlist;

