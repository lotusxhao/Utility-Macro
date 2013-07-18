/*==============================================================================
/ Program   : hasvars.sas
/ Author    : Wendi Wang
/ Date      : 18-Jul-2013
/ Purpose   : Function-style macro to return true if a dataset has all the
/             variables (all, character or numeric) defined to a list.
/ SubMacros : %match %varlist
/ Notes     : Non-matching variables will be returned in the global macro
/             variable _nomatch_ .
/ Usage     : %if not %hasvars(dsname, aa bb cc) %then %do ....
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                (pos) Dataset
/ varlist           (pos) Space-delimited list of variables to check
/ type=all          By default, both character and numeric variables will be 
/                   checked
/ casesens=no       By default, case is not important
/=============================================================================*/

%put MACRO CALLED: hasvars;

%macro hasvars(ds, varlist, type = all, casesens = no);

  %local varmatch;
  %if not %length(&casesens) %then %let casesens = no;
  %let casesens = %upcase(%substr(&casesens, 1, 1));
  %let type = %substr(%upcase(&type), 1, 1);
  %if &type ne N and &type ne C %then %let type = A;

  %let varmatch = %match(%varlist(&ds, type = &type), &varlist, casesens = &casesens);

  %if not %length(&_nomatch_) %then 1;
  %else 0;

%mend hasvars;

 
