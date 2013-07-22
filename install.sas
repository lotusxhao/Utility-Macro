/*==============================================================================
/ Program   : install.sas
/ Author    : Wendi Wang
/ Date      : 11-Jul-2013
/ Purpose   : Install all macro in a single file
/ Usage     : Include this file in the beginning of any program to call macros
/=============================================================================*/

filename storage 'C:\wendi\Utility-Macro';

options nosource;

/* No dependence */
%inc storage(age.sas);
/* No dependence */
%inc storage(attrn.sas);
/* No dependence */
%inc storage(attrc.sas);
/* No dependence */
%inc storage(attrv.sas);
/* Dependence = %words */
%inc storage(char2num.sas);
/* No dependence */
%inc storage(words.sas);
/* No dependence */
%inc storage(varlist.sas);
/* No dependence */
%inc storage(varnum.sas);
%inc storage(nvars.sas);
/* No dependence */
%inc storage(delmac.sas);
/* No dependence */
%inc storage(remove.sas);
/* Dependence = %words */
%inc storage(removew.sas);
/* No dependence */
%inc storage(quotelst.sas);
/* No dependence */
%inc storage(getvalue.sas);
/* No dependence */
%inc storage(dslist.sas);
/* No dependence */
%inc storage(nlobs.sas);
/* No dependence */
%inc storage(nobs.sas);
/* Dependence = %nvars */
%inc storage(misscnt.sas);
/* Dependence = %nvars */
%inc storage(missvars.sas);
/* Dependence = %words %dslist */
%inc storage(dsall.sas);
/* Dependence = %dsall %words %varlist %quotelst */
%inc storage(dropvars.sas);
/* No dependence */
%inc storage(compvars.sas);
/* No dependence */
%inc storage(equals.sas);
/* Dependence = %words */
%inc storage(nodup.sas);
/* Dependence = %words %nodup */
%inc storage(match.sas);
/* Dependence = %match %varlist */
%inc storage(hasvars.sas);
/* Dependence = %attrn */
%inc storage(modte.sas);
/* No dependence */
%inc storage(mvarlist.sas);
/* Dependence = %words */
%inc storage(mvarvalues.sas);
/* Dependence = %varlist %quotelst %words %remove */
%inc storage(duplvars.sas);
/* Dependence = %words %nobs */
%inc storage(clength.sas);

options source;
