/*==============================================================================
/ Program   : misscnt.sas
/ Author    : Wendi Wang
/ Date      : 17-Jul-2013
/ Purpose   : To create a list of variables with missing value and their missing 
/             value count
/ SubMacros : %nvars
/ Notes     : It is not possible to implement this as a function-style macro due
/             to the data step boundary so the results will be written out to a
/             global macro variable. What you do with the list created is
/             entirely up to you. The variable will be directly followed by an
/             equal sign followed directly by the missing value count. VARIABLES
/             WITH ZERO MISSING VALUES WILL NOT BE SHOWN. Note that this macro,
/             unlike its sister %missvars, has a drop list. You might want to
/             use the output from %missvars to ignore all-missing variables from
/             your analysis.
/ Usage     : %misscnt(dsname);
/             %misscnt(dsname, droplist, globvar = _miss_);
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                (pos) Dataset (must be pure dataset name and have no keep,
/                   drop, where or rename associated with it).
/ drop              (pos) List of variables (unquoted and separated by spaces)
/                   to drop from the analysis.
/ globvar=_miss_    Name of the global macro variable to set up to contain the
/                   list of variables and their missing count.
/=============================================================================*/

%put MACRO CALLED: misscnt;

%macro misscnt(ds, drop, globvar = _miss_);

  %local dsname nvarsn nvarsc;
  %global &globvar;
  %let &globvar = ;
  %let dsname = &ds;

  %if %length(&drop) GT 0 %then %do;
    %let dsname = _misscnt;
    data _misscnt;
      set &ds(drop = &drop);
    run;
  %end;

  %let nvarsn=%nvars(&dsname, type = N);
  %let nvarsc=%nvars(&dsname, type = C);

  data _null_;
    %if &nvarsn GT 0 %then %do;
      array _nmiss {&nvarsn} 8 _temporary_ (&nvarsn*0);
    %end;
    %if &nvarsc GT 0 %then %do;
      array _cmiss {&nvarsc} 8 _temporary_ (&nvarsc*0);
    %end;
    set &dsname end=last;
    %if &nvarsn GT 0 %then %do;
      array _num {*} _numeric_;
    %end;
    %if &nvarsc GT 0 %then %do;
      array _char {*} _character_;
    %end;
    %if &nvarsn GT 0 %then %do;
      do i = 1 to &nvarsn;
        if _num(i) EQ . then _nmiss(i) = _nmiss(i) + 1;
      end;
    %end;
    %if &nvarsc GT 0 %then %do;
      do i = 1 to &nvarsc;
        if _char(i) EQ ' ' then _cmiss(i) = _cmiss(i) + 1;
      end;
    %end;
    if last then do;
      %if &nvarsn GT 0 %then %do;
        do i = 1 to &nvarsn;
          if _nmiss(i) GT 0 then call execute('%let &globvar = &&&globvar '||
            trim(vname(_num(i))) || '=' || compress(put(_nmiss(i),11.)) || ';');
        end;
      %end;
      %if &nvarsc GT 0 %then %do;
        do i = 1 to &nvarsc;
          if _cmiss(i) GT 0 then call execute('%let &globvar = &&&globvar '||
            trim(vname(_char(i))) || '=' || compress(put(_cmiss(i),11.)) || ';');
        end;
      %end;
    end;
  run;

  %if %length(&drop) GT 0 %then %do;
    proc datasets nolist;
      delete _misscnt;
    run;
  %end;

%mend misscnt;
