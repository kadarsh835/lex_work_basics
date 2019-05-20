%{
#include<stdio.h>
#include<string.h>
int lineNo=1,error=0,comment=0,var_D=0;
%}
digit   [0-9]
letter  [a-z]
wrong	[A-Z0-9!~@#$%^&*()_+{}:">?<|]
wrong2	[A-Z!~@#$%^&*()_+{}:">?<|]
datatype int|double|char|float|string|bool
%%
\n	{lineNo++;}
;	{if(var_D==1)var_D=0;}
"*/"	comment=2;
{datatype}(" ")+{letter}([a-z0-9])*(" ")*[,;]	{			//Correct Variable Declared
									var_D=1;
									if(yytext[strlen(yytext)-1]==';')
										var_D=0;
									if(comment!=2){
										printf("Line %d: \n-2Variable declaration should be documented",lineNo);
										comment=0;
									}
								}

{datatype}(" ")+{letter}([a-z0-9])*(" ")*=(" ")*([a-zA-Z0-9])*(" ")*[,;]	{			//Correct Variable Declared
														var_D=1;
														if(yytext[strlen(yytext)-1]==';')
															var_D=0;
														if(comment!=2){
															printf("Line %d: \n-1Variable declaration should be documented",lineNo);
															comment=0;
														}
													}

(" ")*{letter}([a-z0-9])*(" ")*=(" ")*([a-zA-Z0-9])*(" ")*[,;]	comment=0;			//Correct Variable Declared

{datatype}(" ")+{letter}([a-z0-9_])*(" ")*\(	{
									if(comment!=2){
										printf("Line %d: \n0Function declaration should be documented",lineNo);
										comment=0;
									}
								}

{datatype}(" ")+{wrong}([a-zA-Z0-9_])*(" ")*\(	{
									error++;
									printf("Line %d: \n%s\n1Function name should start with lowercase character\n",lineNo,yytext);
									if(comment!=2){
										printf("Line %d: \n1Function declaration/definition should be documented",lineNo);
										comment=0;
									}
								}

{datatype}(" ")*[a-z]([a-z0-9])*{wrong2}([a-zA-Z0-9_])*\(	{
											error++;
											printf("Line %d: \n%s\n2Function name should contain only lowercase letters&digits\n",lineNo,yytext);
											
											if(comment!=2){
												printf("Line %d: \n1Function declaration/definition should be documented",lineNo);
												comment=0;
											}
										}

{datatype}(" ")+	{
				var_D=1;
				comment=0;
			}

{wrong}([a-zA-Z0-9])*(" ")*[,;]	{
							var_D=1;
							error++;
							printf("Line %d: \n%s\n3Variable name should start with only lowercase letters\n",lineNo,yytext);
							if(yytext[strlen(yytext)-1]==';')
								var_D=0;
						}

(" ")*{wrong}([a-zA-Z0-9])*(" ")*[,;]	{
								if(var_D==1){
									error++;
									printf("Line %d: \n%s\n4Variable name should start with only lowercase letters\n",lineNo,yytext);
									if(yytext[strlen(yytext)-1]==';')
										var_D=0;
								}
							}

(" ")*{wrong}([a-zA-Z0-9])*(" ")*=(" ")*([a-zA-Z0-9])*(" ")*[,;]	{
												if(var_D==1){
													error++;
													printf("Line %d: \n%s\n5Variable name should start with only lowercase letters\n",lineNo,yytext);
													if(yytext[strlen(yytext)-1]==';')
														var_D=0;
												}
											}


(" ")*[a-z]([a-z0-9])*{wrong2}([a-zA-Z0-9])*(" ")*[,;]	{
											if(var_D==1){
												error++;
												printf("Line %d: \n%s\n6Variable name should contain only lowercase letters\n",lineNo,yytext);
												if(yytext[strlen(yytext)-1]==';')
													var_D=0;
											}
										}
(" ")*[a-z]([a-z0-9])*{wrong2}([a-zA-Z0-9])*(" ")*=(" ")*([a-zA-Z0-9])*(" ")*[,;]	{
															if(var_D==1){
																error++;
																printf("Line %d: \n%s\n7Variable name should contain only lowercase letters\n",lineNo,yytext);
																if(yytext[strlen(yytext)-1]==';')
																	var_D=0;
															}
														}

([ \t])+	;
.	if(comment==2)comment=0;
%%
int main(int argc, char *argv[]) {
	extern FILE *yyin;
	yyin = fopen(argv[1], "r");
	yylex();
	return 0;
}
