/*==============================================================================
/ Program   : getvalue.sas
/ Author    : Wendi Wang
/ Date      : 17-Jul-2013
/ Purpose   : Function-style macro to return a variable's value
/ SubMacros : none
/ Notes     : Use the macro %getvalueq if you want character strings returned
/             in double quotes by default.
/ Usage     : %let value=%getvalue(dsname, varname, 1);
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                (pos) Dataset name
/ var               (pos) Variable name
/ obs               (pos) Observation number. Defaults to 1.
/ usequotes = no    By default, do not put character string in double quotes.
/                   Set to "yes" (no quotes) to return characters quoted or use
/                   the %getvalueq macro which by default quotes strings.
/=============================================================================*/

%put MACRO CALLED: getvalue;

%macro getvalue(ds, var, obs, usequotes = no);

  %local dsid rc varnum value err;
  %let err = ERR%str(OR);

  %if not %length(&usequotes) %then %let usequotes = no;
  %let usequotes = %upcase(%substr(&usequotes, 1, 1));

  %if not %length(&obs) %then %let obs = 1;

  %let dsid = %sysfunc(open(&ds, is));
  %if &dsid EQ 0 %then %do;
    %put &err: (getvalue) Dataset &ds not opened due to the following reason:;
    %put %sysfunc(sysmsg());
  %end;
  %else %do;
    %let varnum = %sysfunc(varnum(&dsid, &var));
    %if &varnum LT 1 %then %put &err: (getvalue) Variable &var not in dataset &ds;
    %else %do;
      %let rc = %sysfunc(fetchobs(&dsid, &obs));
      %if &rc = -1 %then %put &err: (getvalue) Observation &obs is beyond dataset end;
      %else %do;
        %if "%sysfunc(vartype(&dsid, &varnum))" EQ "C" %then %do;
          %let value = %sysfunc(getvarc(&dsid, &varnum));
          %if "&usequotes" EQ "N" %then %do;
&value
          %end;
          %else %do;
"&value"
          %end;
        %end;
        %else %do;
          %let value = %sysfunc(getvarn(&dsid, &varnum));
&value
        %end;
      %end;
    %end;
    %let rc = %sysfunc(close(&dsid));
  %end;

%mend getvalue;
