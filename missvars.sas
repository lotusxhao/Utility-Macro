/*=============================================================================
/ Program   : missvars.sas
/ Author    : Wendi Wang
/ Date      : 17-Jul-2013
/ Purpose   : To create a list of all-missing variables
/ SubMacros : %nvars
/ Notes     : It is not possible to implement this as a function-style macro due
/             to the data step boundary so the results will be written out to a
/             global macro variable. What you do with the list created is
/             up to you. You might report them as errors or warnings or you
/             could drop the variables from a dataset as shown in the usage
/             notes below.
/ Usage     : %missvars(dsname);
/             run;
/             data dsname;
/               set dsname(drop = &_miss_);
/             run;
/             data dsname;
/               set dsname(keep = &_nonmiss_);
/             run;
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                (pos) Dataset (must be pure dataset name and have no keep,
/                   drop, where or rename associated with it).
/=============================================================================*/

%put MACRO CALLED: missvars;

%macro missvars(ds);

  %local nvarsn nvarsc savopts;
  %global _miss_ _nonmiss_;

  %let savopts = %sysfunc(getoption(notes));
  options nonotes;

  %let _miss_ = ;
  %let _nonmiss_ = ;

  %let nvarsn = %nvars(&ds, type = N);
  %let nvarsc = %nvars(&ds, type = C);

  data _null_;
    %if &nvarsn GT 0 %then %do;
      array _nmiss {&nvarsn} $ 1 _temporary_ (&nvarsn*'1');
    %end;
    %if &nvarsc GT 0 %then %do;
      array _cmiss {&nvarsc} $ 1 _temporary_ (&nvarsc*'1');
    %end;
    set &ds end = last;
    %if &nvarsn GT 0 %then %do;
      array _num {*} _numeric_;
    %end;
    %if &nvarsc GT 0 %then %do;
      array _char (*) _character_;
    %end;
    length _miss_ _nmiss_ $ 32767;
    retain _miss_ _nmiss_ " ";
    %if &nvarsn GT 0 %then %do;
      do i = 1 to &nvarsn;
        if _num(i) NE . then _nmiss(i) = '0';
      end;
    %end;
    %if &nvarsc GT 0 %then %do;
      do i = 1 to &nvarsc;
        if left(_char(i)) NOT IN (' ' '.') then _cmiss(i) = '0';
      end;
    %end;
    if last then do;
      %if &nvarsn GT 0 %then %do;
        do i = 1 to &nvarsn;
          if _nmiss(i) EQ '1' then _miss_ = trim(_miss_) || " " || vname(_num(i));
          else _nmiss_ = trim(_nmiss_) || " " || vname(_num(i));
        end;
      %end;
      %if &nvarsc GT 0 %then %do;
        do i = 1 to &nvarsc;
          if _cmiss(i) EQ '1' then _miss_ = trim(_miss_) || " " || vname(_char(i));
          else _nmiss_ = trim(_nmiss_) || " " || vname(_char(i));
        end;
      %end;
      call symput('_miss_', left(trim(_miss_)));
      call symput('_nonmiss_', left(trim(_nmiss_)));
    end;
  run;

  options &savopts;

%mend missvars;
