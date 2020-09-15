// SC-T-603-THYD Fall 2020. Project part I.
#include <iostream>
#include <fstream>
#include <iomanip>
#include "hlexer.h"
#include "flexer.h"

using namespace std;

int main(int argc, char* argv[]) {

    // Process command-line arguments, if any.
    // Usage:  program [ option [ filename ] ]  (option -h or -f)
    bool use_flex = false;
    if ( argc >= 2 && string(argv[1]) == "-f" ) {
        use_flex = true;
    }
    string filename( "./test/test0.pas" );
    if ( argc >= 3 ) {
        filename = argv[2];
    }

    // Open file with program, exit if error opening file.
    ifstream fis( filename );
    if ( !fis.good() ) {
        cerr << "Could not open input file '" << filename << "'." << endl;
        return -1;
    }

    // Instantiate the right lexer.
    Lexer* lexer;
    if (use_flex) {
        lexer = new FLexer(fis);
    }
    else {
        lexer = new HLexer(fis);
    }

    // Output tokens.
    cout << "Using lexical analyzer: " << lexer->get_name() << endl;
    Language::init();
    std::cout << "Testing lexer ..." << std::endl;
    Lexer::Token token;
    lexer->get(token);
    while (token.name != Language::TokenName::t_eoi) {
        cout << std::setw( 3) << token.loc.line << '\t'
             << std::setw( 3) << token.loc.col << '\t'
             << std::setw(20) << Language::TokenNameToText[token.name] << '\t'
             << '\'' << token.text << '\'' << endl;
        lexer->get(token);
    }

    // Clean up and return.
    delete lexer;
    return 0;
}