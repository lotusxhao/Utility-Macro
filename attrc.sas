/*==============================================================================
/ Program   : attrc.sas
/ Author    : Wendi Wang
/ Date      : 11-Jul-2013
/ SubMacros : none
/ Purpose   : Function-style macro to return a character attribute of a dataset
/ Notes     : This is a low-level utility macro that other shell macros will
/             call. About all you would use this for is to get the dataset label
/             and the variables a dataset is sorted by.
/
/             This macro will only work correctly for datasets (i.e. not views)
/             and where there are no dataset modifiers.
/
/ Usage     : %let dslabel=%attrc(dsname,label);
/             %let sortseq=%attrc(dsname,sortedby);
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                Dataset name (pos) (do not use views or dataset modifiers)
/ attrib            Attribute (pos)
/=============================================================================*/

%put MACRO CALLED: attrc;

%macro attrc(ds, attrib);

  %local dsid rc err;
  %let err = ERR%str(OR);
  %let dsid = %sysfunc(open(&ds, is));
  %if &dsid EQ 0 %then %do;
    %put &err: (attrc) Dataset &ds not opened due to the following reason:;
    %put %sysfunc(sysmsg());
  %end;
  %else %do;
%sysfunc(attrc(&dsid, &attrib))
    %let rc=%sysfunc(close(&dsid));
  %end;

%mend attrc;
