/*=============================================================================
/ Program   : attrn.sas
/ Author    : Wendi Wang
/ Date      : 11-Jul-2013
/ Purpose   : Function-style macro to return a numeric attribute of a dataset
/ SubMacros : none
/ Notes     : This is a low-level utility macro that other shell macros will
/             call. The full list of attributes can be found in the SAS
/             documentation. The most common ones used will be CRDTE and MODTE
/             (creation and last modification date), NOBS and NLOBS (number of
/             observations and number of logical [i.e. not marked for deletion]
/             observations) and NVARS (number of variables).
/
/             This macro will only work correctly for datasets (i.e. not views)
/             and where there are no dataset modifiers. If you need to subset
/             the data using a where clause or subset by using other means then
/             apply the subsetting and create a new dataset before calling this
/             macro.
/
/ Usage     : %let nobs=%attrn(dsname,nlobs);
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                (pos) Dataset name (do not use views or dataset modifiers)
/ attrib            (pos) Attribute 
/=============================================================================*/

%put MACRO CALLED: attrn;

%macro attrn(ds, attrib);

  %local dsid rc err;
  %let err = ERR%str(OR);
  %let dsid = %sysfunc(open(&ds, is));
  %if &dsid EQ 0 %then %do;
    %put &err: (attrn) Dataset &ds not opened due to the following reason:;
    %put %sysfunc(sysmsg());
  %end;
  %else %do;
%sysfunc(attrn(&dsid, &attrib))
    %let rc = %sysfunc(close(&dsid));
  %end;

%mend attrn;
