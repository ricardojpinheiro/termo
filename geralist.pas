{
   geralist.pas
   
   Copyright 2022 Ricardo Jurczyk Pinheiro <ricardojpinheiro@gmail.com>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   
}

program geralist;
type
    wordlist = string[5];
    registerwordlist    = record
        nome: wordlist;
    end;

var
    arquivo_entrada: text;
    arquivo_saida: file of registerwordlist;
    nome_arquivo_entrada, nome_arquivo_saida: string[80];
    palavra: wordlist;
    registropalavra: registerwordlist;

BEGIN
    if paramcount <> 2 then
    begin
        writeln ('geralist <arquivo de entrada> <arquivo de saida>');
        writeln ('Gera a lista de entradas para uso do wordle/termo');
        exit;
    end;
    
    nome_arquivo_entrada    := paramstr(1);
    nome_arquivo_saida      := paramstr(2);
    
    assign (arquivo_entrada, nome_arquivo_entrada);
    assign (arquivo_saida,  nome_arquivo_saida);
    {$i-}
    reset (arquivo_entrada);
    rewrite (arquivo_saida);
    {$i+}
    while not eof(arquivo_entrada) do
    begin
        fillchar(palavra, sizeof(palavra), chr(32));
        readln(arquivo_entrada, palavra);
        registropalavra.nome := palavra;
        write(arquivo_saida, registropalavra);
    end;
    close(arquivo_saida);
    close(arquivo_entrada);
END.

