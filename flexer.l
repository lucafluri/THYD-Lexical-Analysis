/* SC-T-603-THYD Fall 2020. Project, lexical analysis. */
%option c++
%option noyywrap
%option yylineno
%{
#include "common.h"
#include "language.h"
%}
ws [ \t\r\n]
letter [a-zA-Z_]
digit [0-9]
nodigits [^0-9]
exponent [eE][+-]?[0-9]+
floatingPart [.][0-9]+
%x COMMENT

%%

{ws}+           /* do nothing */

"(*" {BEGIN(COMMENT);}
<COMMENT>\w
<COMMENT>"*)" {BEGIN(INITIAL);}

"{" {BEGIN(COMMENT);}
<COMMENT>[^}]
<COMMENT>"}" {BEGIN(INITIAL);}


">="            { return LNG::TokenName::t_gteq; }
"<="            { return LNG::TokenName::t_lteq; }
":="            { return LNG::TokenName::t_assign; }
"<>"            { return LNG::TokenName::t_neq; }
".."            { return LNG::TokenName::t_subrange; }

{letter}({letter}|{digit})* {

        auto it = LNG::ReservedWordToTokenName.find( Common::to_lower( yytext ) );
        if ( it != LNG::ReservedWordToTokenName.end() ) {
            return it->second;
        }

        return LNG::TokenName::t_identifier;

}


'[^']*'            { return LNG::TokenName::t_string_l; }

{digit}+(({floatingPart}?{exponent})|{floatingPart}) { return LNG::TokenName::t_real_l;  }



{digit}+          { return LNG::TokenName::t_integer_l; }




[^a-z0-9\s] {

        auto it = LNG::SpecialSymbolToTokenName.find(yytext);
        if ( it != LNG::SpecialSymbolToTokenName.end() ) {
            return it->second;
        }

        return LNG::TokenName::t_unknown;
}




.               { return LNG::TokenName::t_unknown; }

%%
 // No need to add any code here.
