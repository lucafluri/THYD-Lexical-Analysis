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
    // NOTE: Add your code here.
    //    Remember that there are two types of comments.
    //    You should throw an exception if there are unterminated comments.
    c_next();

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

    if (!has_ended) {
        throw LexerException( token.loc, "Unexpected end of string" );
    }
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

    // Return EOI if at end of input
    if ( c_eoi() ) {
        token.name = LNG::TN::t_eoi;
        return;
    }

    // Process a token.
    switch ( c_ ) {
        case ';': set( token, LNG::TN::t_semicolon );
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
