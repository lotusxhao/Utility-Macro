/*==============================================================================
/ Program   : match.sas
/ Author    : Wendi Wang
/ Date      : 17-Jul-2013
/ Purpose   : Function-style macro to return elements of a list that match those
/             in a reference list.
/ SubMacros : %words %nodup
/ Notes     : Non-matching list elements are returned in the global macro
/             variable _nomatch_ .
/ Usage     : %let match = %match(aa bb, aa cc);
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ref               (pos) Space-delimited reference list
/ list              (pos) Space-delimited list
/ nodup=yes         By default, remove duplicates from the list
/ casesens=no       By default, case sensitivity is not important.
/ fixcase=no        By default, do not make the case of matching items the same
/                   as the item in the reference list.
/=============================================================================*/

%put MACRO CALLED: match;

%macro match(ref, list, nodup = yes, casesens = no, fixcase = no);

  %local err errflag list2 nref nlist i j item match refitem;
  %let err = ERR%str(OR);
  %let errflag = 0;

  %global _nomatch_ ;
  %let _nomatch_ = ;

  %if not %length(&nodup) %then %let nodup = yes;
  %if not %length(&casesens) %then %let casesens = no;
  %if not %length(&fixcase) %then %let fixcase = no;

  %let nodup = %upcase(%substr(&nodup, 1, 1));
  %let casesens = %upcase(%substr(&casesens, 1, 1));
  %let fixcase = %upcase(%substr(&fixcase, 1, 1));
  
  /* allow duplication or not */
  %if "&nodup" EQ "Y" %then %let list2 = %nodup(&list, casesens = &casesens);
  %else %let list2 = &list;

  %let nref = %words(&ref);
  %let nlist = %words(&list2);

  %if not &nref %then %do;
    %put &err: (match) No elements in reference list;
    %let errflag = 1;
  %end;

  %if &errflag %then %goto exit;

  %if not &nlist %then %goto skip;

  %do i = 1 %to &nlist;
    %let item = %scan(&list2, &i, %str( ));
    %let match = NO;
    %do j = 1 %to &nref;
      %let refitem = %scan(&ref, &j, %str( ));
      %if "&casesens" EQ "N" %then %do;
        %if "%upcase(&item)" EQ "%upcase(&refitem)" %then %do;
          %let match = YES;
          %let j = &nref;
        %end;
      %end;
      %else %do;
        %if "&item" EQ "&refitem" %then %do;
          %let match = YES;
          %let j = &nref;
        %end;
      %end;
    %end;
    %if &match EQ YES %then %do;
      %if "&fixcase" EQ "N" %then &item;
      %else &refitem;
    %end;
    %else %let _nomatch_ = &_nomatch_ &item;
  %end;

  %goto skip;
  %exit: %put &err: (match) Leaving macro due to problem(s) listed.;
  %skip:

%mend match;
