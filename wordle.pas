{
   termo.pas
   
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

program termo;
const
    maximo_palavras = 1500;
type
    wordlist = string[5];
    registerwordlist    = record
        nome: wordlist;
    end;

var
    arquivo_entrada: file of registerwordlist;
    vetor_de_palavras: array [1..maximo_palavras] of registerwordlist;
    nome_arquivo_entrada: string[80];
    palavra: wordlist;
    registro_de_palavra, palavra_certa: registerwordlist;
    tamanho_arquivo, aleatorio, i, j: integer;
    resposta_certa: boolean;
{
function Readkey: char;
var
    bt: integer;
    qqc: byte absolute $FCA9;
 
begin
    Readkey := chr(0);
    qqc := 1;
    Inline($f3/$fd/$2a/$c0/$fc/$DD/$21/$9F/00/$CD/$1c/00/$32/bt/$fb);
    Readkey := chr(bt);
    qqc := 0;
end;
}
procedure inicializacao;
begin
    nome_arquivo_entrada := 'pt_word.lst';
    aleatorio := 0;
    randomize;
end;

procedure abre_arquivo;
begin
    assign (arquivo_entrada, nome_arquivo_entrada);
    {$i-}
    reset (arquivo_entrada);
    {$i+}
end;

procedure le_arquivo_para_memoria;
begin
    i := 1;
    while not eof(arquivo_entrada) do
    begin
        read(arquivo_entrada, vetor_de_palavras[i]);
        i := i + 1;
    end;
end;

procedure sorteio;
begin
    aleatorio := round(int(random(maximo_palavras)));
    palavra_certa := vetor_de_palavras[aleatorio];
end;

function busca_binaria (palavra: wordlist): integer;
var
    comeco, meio, fim: integer;
    Encontrou: boolean;
    
begin
    comeco      :=  1;
    fim         :=  maximo_palavras;
    Encontrou   :=  false;

    while (comeco <= fim) and (Encontrou = false) do
    begin
        meio:=(comeco + fim) div 2;

        registro_de_palavra := vetor_de_palavras[meio];
        if (palavra = registro_de_palavra.nome) then
            Encontrou := true
        else
            if (palavra < registro_de_palavra.nome) then
                fim := meio - 1
            else
                comeco := meio + 1;
    end;
    if Encontrou = true then
        busca_binaria := meio
    else
        busca_binaria := 0;
end;

procedure forca;
var
    tem_ou_nao: integer;
begin
    i := 1;
    resposta_certa := false;

    while (i <= 6) or (resposta_certa = false) do
    begin
        writeln(i, 'a tentativa: ');
        fillchar(palavra, sizeof(palavra), chr(32));
        read(palavra);
        
(*  Testa pra ver se achou a palavra. *)            
        
        if palavra_certa.nome = palavra then
        begin
            writeln('Acertou miserável!');
            resposta_certa := true;
        end
        else
        begin

(*  Primeiro testa pra ver se tem a palavra no acervo. *)               

            tem_ou_nao := busca_binaria (palavra);
            if tem_ou_nao <> 0 then
            begin
                writeln('Essa palavra tem no dicionário.');

(*  Agora vamos ver quais letras estão certas. *)

                for j := 1 to 5 do
                if palavra[j] = palavra_certa.nome[j] then
                    write(palavra[j])
                else
                    write('?')
            end
            else
                writeln('Essa palavra não tem no dicionário.');
        writeln;
        i := i + 1;
        end;
    end;
end;

procedure fecha_arquivo;
begin
    close(arquivo_entrada);
end;

BEGIN
    inicializacao;
    abre_arquivo;
    le_arquivo_para_memoria;
    fecha_arquivo;
    sorteio;
    writeln('Aleatorio: ', aleatorio);
    writeln('Palavra: ', vetor_de_palavras[aleatorio].nome);
    forca;
END.

