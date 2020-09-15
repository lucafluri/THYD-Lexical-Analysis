#ifndef TPLEXER_LANGUAGE_H
#define TPLEXER_LANGUAGE_H

#include <set>
#include <string>
#include <map>

class Language {
public:

    // See language.cpp for details of tokens.
    enum TokenName {
        // Operators
        t_assign = 256,
        t_divide,
        t_eq,
        t_gt, t_gteq,
        t_lt, t_lteq,
        t_minus, t_multiply,
        t_neq,
        t_plus,
        // Punctuation marks.
        t_caret, t_colon, t_comma,
        t_dot,
        t_lbracket, t_lparenthesis,
        t_rbracket, t_rparenthesis,
        t_subrange, t_semicolon,
        // Reserved words.
        t_absolute, t_and, t_array,
        t_begin,
        t_case, t_const,
        t_div, t_do, t_downto,
        t_else, t_end, t_external,
        t_file, t_forward, t_for, t_function,
        t_goto,
        t_if, t_in, t_inline,
        t_label,
        t_mod,
        t_nil, t_not,
        t_of, t_or, t_overlay,
        t_packed, t_procedure, t_program,
        t_record, t_repeat,
        t_set, t_shl, t_shr, t_string,
        t_then, t_to, t_type,
        t_until,
        t_var, t_while, t_with,
        t_xor,
        // Standard scalars
        t_boolean, t_byte, t_char, t_integer, t_real,
        t_false, t_true,
        // ... other words are matched as identifiers.
        t_identifier,
        // Literals.
        t_integer_l, t_real_l, t_string_l,
        // End of input.
        t_eoi,
        // Otherwise matched as an unknown token.
        t_unknown
    };
    using TN = TokenName;

    static const std::map<std::string,TokenName> SpecialSymbolToTokenName;

    // The language is case-insensitive, i.e. keywords (and identifiers) can be written
    // as any combination of upper-and lower-case (e.g., 'program', 'Program', or 'PROGRAM').
    static const std::map<std::string,TokenName> ReservedWordToTokenName;

    static std::map<TokenName,std::string> TokenNameToText;

    static void init() {
        populate_tokenname_to_text();
    }

private:

    static void populate_tokenname_to_text();

    Language() = default; // Do not want the class instantiated, thus private.
};

using LNG = Language;

#endif //TPLEXER_LANGUAGE_H
