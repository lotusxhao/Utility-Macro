/*==============================================================================
/ Program   : dropvars.sas
/ Author    : Wendi Wang
/ Date      : 17-Jul-2013
/ Purpose   : To drop a list of unwanted variables in a list of datasets.
/ SubMacros : %dsall %words %varlist %quotelst
/ Notes     : You can use the _all_ notation to refer to all the datasets in a
/             library.
/ Usage     : %dropvars(work._all_, x1 x2)
/             %dropvars(work.dsname, x1 x2)
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ list              (pos) List of datasets. The _all_ notation can be used.
/ drop              (pos) List of variables to drop.
/=============================================================================*/

%put MACRO CALLED: dropvars;

%macro dropvars(list, drop);

  %local dropvars varlist i j;
  %dsall(&list)
  %let drop = %quotelst(%upcase(&drop));

  %do i = 1 %to %words(&_dsall_);
    %let dropvars = ;
    %let varlist = %varlist(%scan(&_dsall_, &i, %str( )));
    %do j = 1 %to %words(&varlist);
      %if %index(&drop, "%upcase(%scan(&varlist, &j, %str( )))") 
        %then %let dropvars = &dropvars %scan(&varlist, &j, %str( ));
    %end;
    %if %length(&dropvars) %then %do;
      data %scan(&_dsall_, &i, %str( ));
        set %scan(&_dsall_, &i, %str( ));
        drop &dropvars;
      run;
    %end;
  %end;

%mend dropvars;


