enum AssignType <IMMUTABLE SCALAR-ASSIGN LIST-ASSIGN>;

enum ASSOC <LEFT RIGHT>;

enum Spit-Phaser <END FILE-CLEAN CHECK-CLEAN>;

# Can't put this directly in intializer because of
# "Cannot invoke this object (REPR: Null; VMNull)"
sub eq-prec ($var) { $var.assign-type == LIST-ASSIGN ?? 'e=' !! 'i=' }
constant %precedence is export = %(
    |(<and or> X=> $('d=',LEFT)),
    '=' => $(&eq-prec,RIGHT),
    ',' => $('g=',LEFT),
    '.=' => $('i=',RIGHT),
    '=>' => $('i=',RIGHT),
    '??' => $('j=',RIGHT),
    '~~' => $('m=',LEFT),
    '=~' => $('m=',LEFT),
    |(<|| &&> X=> $('l=',LEFT)),
    |(('==','!=','>','<','>=','<=',
       'eq','ne','gt','lt','le','ge') X=> $('m=',LEFT)),
    '..' => $('n=',LEFT),
    '~' => $('q=',LEFT),
    '+' => $('t=',LEFT),
    '-' => $('t=',LEFT),
    '*' => $('u=',LEFT),
    '/' => $('u=',LEFT),
);
sub derive-precedence($_,$lhs) is export {
    return '',LEFT unless $_;
    my ($prec,$assoc) = %precedence{.<sym>.Str};
    $prec = $prec ~~ Callable:D ?? $prec($lhs) !! $prec;
    $prec,$assoc
}
enum SymbolType <SUB SCALAR ARRAY CLASS>;

subset Sigil of Str where any <$ @ % &>;
