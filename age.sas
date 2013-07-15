/*==============================================================================
/ Program   : age.sas
/ Author    : Wendi Wang
/ Date      : 11-Jul-2013
/ Purpose   : In-datastep function-style macro to calculate the age of a person
/             on a date (integer or with decimal age)
/ SubMacros : none
/ Notes     : Used in a data step to calculate the age of a person (integer or 
/             with decimal point), given a date and a date of birth
/ Usage     : data test;
/               age=%age(dob, date);
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ dob               (pos) Date of birth
/ date              (pos) Date on which age is to be calculated 
/ dec=yes           If set to "yes" (default) then the age of a person as a 
/                   fractional number of years was calculated otherwise
/                   the integer number of yeears was calculated
/ mar1=yes          Whether those born on Feb29 on a leap year are legally a
/                   year older on Mar1 on non-leap years. If set to "no" (no
/                   quotes) then Feb28 is assumed for celebrating the birth date
/                   otherwise Mar01 is assumed. It is highly recommended you
/                   keep to the default of "yes" (i.e. Mar01 is assumed) unless
/                   you have sound knowledge otherwise.
/=============================================================================*/

%put MACRO CALLED: age;

%macro age(dob, date, dec=yes, mar1=yes);
  
  %if %upcase(&dec) ne YES and %upcase(&dec) ne NO %then %let dec = yes;
  %if %upcase(&mar1) ne YES and %upcase(&mar1) ne NO %then %let mar1 = yes;
  %let dec = %substr(%upcase(&dec), 1, 1);
  %let mar1 = %substr(%upcase(&mar1), 1, 1);

  %let age = year(&date) - year(&dob) - ((month(&date) < month(&dob)) or ((month(&date) = month(&dob)) and (day(&date) < day(&dob))));

  %if &dec = Y %then %do;
    %if &mar1 NE N %then %do;
      &age + ( (&date - (intnx('year', &dob-1, &age, 'S') + 1)) / ((intnx('year', &dob-1, &age+1, 'S') + 1) - (intnx('year', &dob-1, &age, 'S') + 1)) )
    %end;
    %else %do;
      &age + ( (&date - intnx('year', &dob, &age, 'S')) / (intnx('year', &dob, &age+1, 'S') - intnx('year', &dob, &age, 'S')))
    %end;
  %end;
  %else %do;
    &age
  %end;

%mend age;


