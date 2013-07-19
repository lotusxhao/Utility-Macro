/*=============================================================================
/ Program   : duplvars.sas
/ Author    : Wendi Wang
/ Date      : 19-Jul-2013
/ Purpose   : Function-style macro to create a list of duplicate variables in a
/             second dataset so that they can be dropped before a merge.
/ SubMacros : %varlist %quotelst %words %remove
/ Notes     : The variables to ignore as duplicates will be the "by" variables
/             the datasets are being merged on, most usually.
/ Usage     : data newds;
/               merge ds1 ds2(drop = %duplvars(ds1, ds2, &bylist));
/               by &bylist;
/             run;
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds1               (pos) Primary dataset to merge (no keep/drop/rename etc.)
/ ds2               (pos) Secondary dataset to merge (no keep/drop/rename etc.)
/                   for which you want to identify duplicate variables.
/ ignore            (pos) List of variables to ignore from the duplicate list
/                   (variable list separated by spaces - no quotes)
/=============================================================================*/

%put MACRO CALLED: duplvars;

%macro duplvars(ds1, ds2, ignore);

  %local varlist1 varlist2 duplvars bylist i;

  %let varlist1 = %quotelst(%varlist(&ds1));
  %let varlist2 = %quotelst(%varlist(&ds2));
  %let bylist = %quotelst(&ignore);

  %do i = 1 %to %words(&bylist);
    %let varlist2 = %remove(&varlist2, %scan(&bylist, &i, %str( )), casesens = no);
  %end;

  %do i = 1 %to %words(&varlist2);
    %if %index(%upcase(&varlist1), %upcase(%scan(&varlist2, &i, %str( )))) 
      %then %let duplvars = &duplvars %scan(&varlist2, &i, %str( ));
  %end;

%sysfunc(compress(&duplvars, %str(%")))

%mend duplvars;
