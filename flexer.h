#ifndef TPLEXER_FLEXER_H
#define TPLEXER_FLEXER_H

#include <FlexLexer.h>
#include "lexer.h"

class FLexer : public Lexer {
public:

    FLexer( std::istream& is )
            : Lexer( is ), lexer_( &is ){
    }

    virtual void get( Token& token ) override {
        int token_no = lexer_.yylex();
        token.name = (token_no == 0) ? LNG::TokenName::t_eoi
                                     : static_cast<LNG::TokenName>(token_no);
        token.text = lexer_.YYText();
        token.loc.line = lexer_.lineno();
        token.loc.col = 0; // not supported by default in C++ flex.
    }

    virtual std::string get_name() const override {
        return "flex";
    }

    virtual ~FLexer() {
    }

private:
    yyFlexLexer lexer_;
};

#endif //TPLEXER_FLEXER_H
