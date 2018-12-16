Avoiding obfuscated SAS macro code

More maitainable code?

Problem: Pass the following quoted macro strings to a relational SQL query

         1. "12-16-2018"  ==> todays date
         2. "11-01-2018"  ==> first day of previous month
         3. "11-30-2018"  ==> last day of previous month

 Problem: Obfuscated code?

   %utlnopts;
   %let begPre = %str(%')%sysfunc(intnx(month, "&sysdate"d, -1, B), yymmdd10.)%str(%');
   %let endPre = %str(%')%sysfunc(intnx(month, "&sysdate"d, -1, E), yymmdd10.)%str(%');
   %let today  = %str(%')%sysfunc(putn("&sysdate"d, yymmdd10.))%str(%');

   %put &=begPre;
   %put &=endPre;
   %put &=today;

   BEGPRE='2018-11-01'
   ENDPRE='2018-11-30'
   TODAY='2018-12-16'


 EXAMPLE OUTPUT  (same output but more understandable code)
 -------------------------------------------

   BEGPRE='2018-11-01'
   ENDPRE='2018-11-30'
   TODAY='2018-12-16'

PROCESS
=======

   %utlnopts; * so only the put statements are in the log - urn options off;
   %symdel begPre endPre today;

   %let rc=%sysfunc(dosubl(%nrstr(

     data _null_;

        retain sq "'";  * only needed to replace default double quotes;

        today  = quote(put(today(), yymmdd10.),sq);
        begPre = quote(putn(intnx('month', today(), -1, 'B'),'yymmdd10.'),sq);
        endPre = quote(putn(intnx('month', today(), -1, 'E'),'yymmdd10.'),sq);

        call symputx('today',today);
        call symputx('begPre',begPre);
        call symputx('endPre',endPre);

     run;quit;

   )));

   %put &=begPre;
   %put &=endPre;
   %put &=today;

   %utlopts; * turn options back on;


OUTPUT
======

   BEGPRE='2018-11-01'
   ENDPRE='2018-11-30'
   TODAY='2018-12-16'

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

just today()

