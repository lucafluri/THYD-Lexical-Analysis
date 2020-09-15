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

%%

{ws}+             /* do nothing */
"["             { return LNG::TokenName::t_lbracket; }
"]"             { return LNG::TokenName::t_rbracket; }
">"             { return LNG::TokenName::t_gt; }
">="             { return LNG::TokenName::t_gteq; }
{letter}({letter}|{digit})* {

        auto it = LNG::ReservedWordToTokenName.find( Common::to_lower( yytext ) );
        if ( it != LNG::ReservedWordToTokenName.end() ) {
            return it->second;
        }

        return LNG::TokenName::t_identifier;

                            }
{digit}+({letter}|{digit})+ { return LNG::TokenName::t_unknown; }


.               { return LNG::TokenName::t_unknown; }

%%
 // No need to add any code here.
