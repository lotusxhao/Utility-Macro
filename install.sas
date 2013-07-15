/*==============================================================================
/ Program   : install.sas
/ Author    : Wendi Wang
/ Date      : 11-Jul-2013
/ Purpose   : Install all macro in a single file
/ Usage     : Include this file in the beginning of any program to call macros
/=============================================================================*/

filename storage 'C:\wendi\Utility-Macro';

%inc storage(age.sas);
%inc storage(attrn.sas);
%inc storage(attrc.sas);
%inc storage(attrv.sas);
%inc storage(char2num.sas);
%inc storage(words.sas);
%inc storage(varlist.sas);
%inc storage(varlistc.sas);
%inc storage(varlistn.sas)
