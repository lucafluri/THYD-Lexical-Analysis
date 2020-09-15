#include "language.h"

const std::map<std::string,Language::TokenName> Language::ReservedWordToTokenName = {
        {"absolute", TokenName::t_absolute},
        {"and", TokenName::t_and},
        {"array", TokenName::t_array},
        {"begin", TokenName::t_begin},
        {"boolean", TokenName::t_boolean},
        {"byte", TokenName::t_byte},
        {"case", TokenName::t_case},
        {"char", TokenName::t_char},
        {"const", TokenName::t_const},
        {"div", TokenName::t_div},
        {"do", TokenName::t_do},
        {"downto", TokenName::t_downto},
        {"else", TokenName::t_else},
        {"end", TokenName::t_end},
        {"external", TokenName::t_external},
        {"false", TokenName::t_false},
        {"file", TokenName::t_file},
        {"forward", TokenName::t_forward},
        {"for", TokenName::t_for},
        {"function", TokenName::t_function},
        {"goto", TokenName::t_goto},
        {"if", TokenName::t_if},
        {"in", TokenName::t_in},
        {"integer", TokenName::t_integer},
        {"inline", TokenName::t_inline},
        {"label", TokenName::t_label},
        {"mod", TokenName::t_mod},
        {"nil", TokenName::t_nil},
        {"not", TokenName::t_not},
        {"of", TokenName::t_of},
        {"or", TokenName::t_or},
        {"overlay", TokenName::t_overlay},
        {"packed", TokenName::t_packed},
        {"procedure", TokenName::t_procedure},
        {"program", TokenName::t_program},
        {"real", TokenName::t_real},
        {"record", TokenName::t_record},
        {"repeat", TokenName::t_repeat},
        {"set", TokenName::t_set},
        {"shl", TokenName::t_shl},
        {"shr", TokenName::t_shr},
        {"string", TokenName::t_string},
        {"then", TokenName::t_then},
        {"to", TokenName::t_to},
        {"true", TokenName::t_true},
        {"name", TokenName::t_type},
        {"until", TokenName::t_until},
        {"var", TokenName::t_var},
        {"while", TokenName::t_while},
        {"with", TokenName::t_with},
        {"xor", TokenName::t_xor}
};

const std::map<std::string,Language::TokenName> Language::SpecialSymbolToTokenName = {
        {":=", TokenName::t_assign},
        {"=", TokenName::t_eq},
        {"/", TokenName::t_divide},
        {">", TokenName::t_gt},
        {">=", TokenName::t_gteq},
        {"<", TokenName::t_lt},
        {"<=", TokenName::t_lteq},
        {"-", TokenName::t_minus},
        {"*", TokenName::t_multiply},
        {"<>", TokenName::t_neq},
        {"+", TokenName::t_plus},
        {"^", TokenName::t_caret},
        {":", TokenName::t_colon},
        {",", TokenName::t_comma},
        {".", TokenName::t_dot},
        {"[", TokenName::t_lbracket},
        {"(", TokenName::t_lparenthesis},
        {"]", TokenName::t_rbracket},
        {")", TokenName::t_rparenthesis},
        {"..", TokenName::t_subrange},
        {";", TokenName::t_semicolon}
};

std::map<Language::TokenName,std::string> Language::TokenNameToText;

void Language::populate_tokenname_to_text()
{
    for ( auto& elem : ReservedWordToTokenName ) {
        TokenNameToText[elem.second] = elem.first;
    }
    TokenNameToText[TokenName::t_identifier] = "<identifier>";
    for ( auto& elem : SpecialSymbolToTokenName ) {
        TokenNameToText[elem.second] = elem.first;
    }
    TokenNameToText[TokenName::t_integer_l] = "<integer-literal>";
    TokenNameToText[TokenName::t_real_l] = "<real-literal>";
    TokenNameToText[TokenName::t_string_l] = "<string-literal>";
    TokenNameToText[TokenName::t_eoi] = "<eoi>";
    TokenNameToText[TokenName::t_unknown] = "<unknown>";
}

