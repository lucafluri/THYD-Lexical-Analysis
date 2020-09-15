#ifndef TPLEXER_LEXER_H
#define TPLEXER_LEXER_H

#include <cassert>
#include<iostream>
#include<string>
#include "common.h"
#include "language.h"

class Lexer {
public:

    class LexerException: public Common::CompilerException {
    public:
        LexerException( const Common::Location& loc, std::string msg ) : CompilerException( loc, msg ) {}
    };

    struct Token {
        LNG::TokenName name;
        std::string text;
        Common::Location loc;
    };

    // Constructor, input stream to read and a symbol table are provided.
    explicit Lexer( std::istream& is ) : is_(is) {}

    // Get the next token from the input stream. Return token EOI on end of input.
    // This method could potentially throw IO-related exceptions.
    virtual void get( Token& token ) = 0;

    // Return a name given to the lexical analyzer (e.g., "flex" or "handmade").
    virtual std::string get_name() const = 0;

    // Destructor.
    virtual ~Lexer() {};

protected:
    std::istream& is_;
};

#endif //TPLEXER_LEXER_H
