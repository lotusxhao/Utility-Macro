/*=============================================================================
/ Program   : equals.sas
/ Author    : Wendi Wang
/ Date      : 17-Jul-2013
/ Purpose   : In-datastep function-style macro to compare two numeric values to
/             find if they are equal or very nearly equal.
/ SubMacros : none
/ Notes     : This technique was copied from the SAS Technical Support site but
/             amended slightly. You use it in a data step. You can get very
/             slight differences in values depending how a value was arrived at
/             but they will be very close. This code will compare them but allow
/             for tiny differences.
/ Usage     : if %equals(val1, 7.3) then ...
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ val1              (pos) First value for comparison (can be text or a variable)
/ val2              (pos) Second value for comparison (text or a variable)
/=============================================================================*/

%put MACRO CALLED: equals;

%macro equals(val1, val2);
  (abs(&val1 - &val2) LE 1E-15 * max(abs(&val1), abs(&val2)))
%mend equals;
