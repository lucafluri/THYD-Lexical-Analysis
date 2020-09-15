#ifndef TPLEXER_HLEXER_H
#define TPLEXER_HLEXER_H

#include "lexer.h"

class HLexer : public Lexer {
public:

    HLexer( std::istream& is )
        : Lexer(is), is_(is), c_('\0'), loc_{1,0}
    {
        c_next();
    }

    virtual void get( Token& token ) override ;

    virtual std::string get_name() const override {
        return "hlex";
    }

    virtual ~HLexer() {}

private:

    // Check whether end-of-input.
    inline bool c_eoi() { return is_.eof(); }

    // Reads in the next character and updates location.
    inline void c_next() {
        c_ = '\0';
        is_.get( c_ );
        if ( c_ == '\n' ) {
            ++loc_.line;
            loc_.col = 0;
        }
        else { ++loc_.col; }
    }

    // Look (peek) at the next character in the input stream, without reading it.
    inline char c_peek() { return (char) is_.peek(); }

    // Predicate telling the type of a character.
    inline bool letter( char c ) { return isalpha( c ) || c == '_'; }
    inline bool digit( char c ) { return static_cast<bool>( isdigit( c ) ); }
    inline bool letter_or_digit( char c ) { return letter( c ) || digit( c ); }

    // Set token to be of a given type, and read in next character.
    void set( Token& token, Language::TokenName t ) {
        token.name = t;
        token.text.push_back( c_ );
        c_next();
    }

    // Helper routiens.

    bool remove_whitespaces();
    bool remove_comment( Token& token );

    void process_string( Token& token );
    void process_digits( Token& token );
    void process_number( Token& token );
    void process_identifier( Token& token );

    // Member variables.
    std::istream& is_;
    char c_;
    Common::Location loc_;
};

#endif //TPLEXER_HLEXER_H
