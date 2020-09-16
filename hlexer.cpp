#include "hlexer.h"

bool HLexer::remove_whitespaces()
{
    if ( isspace( c_ ) ) {
        for ( ; !c_eoi() && isspace( c_ ); c_next() );
        return true;
    }
    else { return false; }
}


bool HLexer::remove_comment( Token& token )
{
    if (c_ == '{') {
        while(c_ != '}'){
            c_next();
        }
        c_next();
    }
    if(c_ == '\n'){
        c_next();
    }
    return true;
}


void HLexer::process_string( Token& token )
{
    assert( c_ == '\'' );

    bool has_ended = false;

    while (!c_eoi()) {
        token.text.push_back(c_);
        c_next();
        if (c_ == '\'') {
            has_ended = true;
            break;
        }
    }

    if (!has_ended) {
        throw LexerException( token.loc, "Unexpected end of string" );
    }
    token.text.push_back(c_);
    token.name = LNG::TN::t_string_l;
    c_next();
}


// Process identifier names.
void HLexer::process_identifier( Token& token )
{
    // NOTE: Add your code here (instead of the provided c_next()).

    bool has_ended = false;

    while (!c_eoi() && (isalpha(c_) || c_ == '_' || digit(c_))) {
        token.text.push_back(c_);
        c_next();
        if (c_ == '\n') {
            has_ended = true;
            break;
        }
    }

   /* if (!has_ended) {
        throw LexerException( token.loc, "Unexpected end of string" );
    }*/
    token.text.push_back(c_);
    token.name = LNG::TN::t_identifier;

    //end of custom code
    c_next();

}


// A sequence of numbers/digits e.g. 12345
void HLexer::process_digits( Token& token )
{
    // NOTE: Add your code here (instead of the provided c_next()).
    c_next();
}


// Process integers and real numbers.
void HLexer::process_number( Token& token )
{
    // NOTE: Add your code here (instead of the provided c_next()).
    c_next();
    //   Provided file test/test4.pas could help with the testing.
}


void HLexer::get( Token& token )
{
    token.name = LNG::TN::t_unknown;
    token.text.clear();
    token.loc = loc_;

    // NOTE: Add code to remove comments and white-spaces.
    while (remove_whitespaces());
    (remove_comment(token));

    // Return EOI if at end of input
    if ( c_eoi() ) {
        token.name = LNG::TN::t_eoi;
        return;
    }

    // Process a token.
    switch ( c_ ) {
        case ';': set( token, LNG::TN::t_semicolon );
            break;
        case '=': set( token, LNG::TN::t_eq );
            break;
        case '.': set(token, LNG::TN::t_dot);
            break;
        case ':':
            if (is_.peek() == '=') {
                token.text = ':=';
                token.name = LNG::TN::t_assign;
                c_next();
                c_next();
            } else {
                set( token, LNG::TN::t_colon );
            }
            break;
        case '>':
            if (is_.peek() == '=') {
                token.text = '>=';
                token.name = LNG::TN::t_gteq;
                c_next();
                c_next();
            } else {
                set( token, LNG::TN::t_gt );
            }
            break;
        case 'i':
            if (is_.peek() == 'f') {
                token.text = "if";
                token.name = LNG::TN::t_if;
                c_next();
                c_next();
            }
            else if(is_.peek() == 'n') {
                std::string prog = "integer";
                int i = 1;
                token.text = "i";
                while (is_.peek() == prog.at(i)) {
                    token.text = token.text + prog.at(i);
                    if (i >= prog.size() - 1) {
                        break;
                    }
                    i++;
                    c_next();
                }
                if (token.text == "integer") {
                    token.name = LNG::TN::t_integer;
                    c_next();
                    c_next();
                } else {
                    token.name = LNG::TN::t_identifier;
                    c_next();
                }
            }else {
                set(token, LNG::TN::t_unknown);
            }
            break;
        case 'b':
            if(is_.peek() == 'e'){
                std::string prog = "begin";
                int i = 1;
                token.text = "b";
                while (is_.peek() == prog.at(i)){
                    token.text = token.text + prog.at(i);
                    if(i >= prog.size()-1){
                        break;
                    }
                    i++;
                    c_next();
                }
                if(token.text == "begin"){
                    token.name = LNG::TN::t_begin;
                    c_next();
                    c_next();
                } else{
                    token.name = LNG::TN::t_identifier;
                    c_next();
                }
            } else {
                set(token, LNG::TN::t_unknown);
            }
            break;
        case 'p':
            if(is_.peek() == 'r'){
                std::string prog = "program";
                int i = 1;
                token.text = "p";
                while (is_.peek() == prog.at(i)){
                    token.text = token.text + prog.at(i);
                    if(i >= prog.size()-1){
                        break;
                    }
                    i++;
                    c_next();
                }
                if(token.text == "program"){
                    token.name = LNG::TN::t_program;
                    c_next();
                    c_next();
                } else{
                    token.name = LNG::TN::t_identifier;
                    c_next();
                }
            } else {
                set(token, LNG::TN::t_unknown);
            }
            break;
        case 'v':
            if(is_.peek() == 'a'){
                std::string prog = "var";
                int i = 1;
                token.text = "v";
                while (is_.peek() == prog.at(i)){
                    token.text = token.text + prog.at(i);
                    if(i >= prog.size()-1){
                        break;
                    }
                    i++;
                    c_next();
                }
                if(token.text == "var"){
                    token.name = LNG::TN::t_var;
                    c_next();
                    c_next();
                } else{
                    token.name = LNG::TN::t_identifier;
                    c_next();
                }
            } else {
                set(token, LNG::TN::t_unknown);
            }
            break;
        case 'e':
            if(is_.peek() == 'n'){
                std::string prog = "end";
                int i = 1;
                token.text = "e";
                while (is_.peek() == prog.at(i)){
                    token.text = token.text + prog.at(i);
                    if(i >= prog.size()-1){
                        break;
                    }
                    i++;
                    c_next();
                }
                if(token.text == "end"){
                    token.name = LNG::TN::t_end;
                    c_next();
                    c_next();
                } else{
                    token.name = LNG::TN::t_identifier;
                    c_next();
                }
            }
            else if(is_.peek() == 'l') {
                std::string prog = "else";
                int i = 1;
                token.text = "e";
                while (is_.peek() == prog.at(i)) {
                    token.text = token.text + prog.at(i);
                    if (i >= prog.size() - 1) {
                        break;
                    }
                    i++;
                    c_next();
                }
                if (token.text == "else") {
                    token.name = LNG::TN::t_else;
                    c_next();
                    c_next();
                } else {
                    token.name = LNG::TN::t_identifier;
                    c_next();
                }
                } else {
                    set(token, LNG::TN::t_unknown);
                }
            break;

         // NOTE: Add code here for all the remaining cases.

        default:
            if ( c_ == '\'' )        { process_string( token ); }
            else if ( digit( c_ ) )  { process_number( token ); }
            else if ( letter( c_ ) || c_ == '_') {
                process_identifier( token );
                auto it = LNG::ReservedWordToTokenName.find( Common::to_lower( token.text ) );
                if ( it != LNG::ReservedWordToTokenName.end() ) {
                    token.name = it->second;
                }
            }
            else { set( token, LNG::TN::t_unknown ); }
    }
}
