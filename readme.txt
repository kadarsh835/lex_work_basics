How to run :
    1. lex code_2017csb1064.l
    2. gcc lex.yy.c -lfl
    3. ./a.out Input.c

Logic of program:
    In this program we are using lex tool. In lex tool we have functionality to match
    string patterns using regular expression. Using this I'm matching the functions ,variables
    and comment patterns. After identifiyng the pattern it is showing the detected errors.
