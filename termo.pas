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

var
	arquivo_entrada: text;
	vetor_de_palavras: array [1..maximo_palavras] of wordlist;
	nome_arquivo_entrada: string[14];
	palavra, palavra_certa, palavra_impressa: wordlist;
	tamanho_arquivo, aleatorio, i, j, k: integer;
	resposta_certa: boolean;

{$i readvram.inc}
{$i readstr.inc}

procedure inicializacao;
begin
	nome_arquivo_entrada := 'pt.txt';
	aleatorio := 0;
	randomize;
	clrscr;
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
	i := 0;
	while not eof(arquivo_entrada) do
	begin
		readln(arquivo_entrada, vetor_de_palavras[i]);
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
    comeco		:=	1;
    fim			:=	maximo_palavras;
    Encontrou	:=	false;

    while (comeco <= fim) and (Encontrou = false) do
    begin
        meio:=(comeco + fim) div 2;

        if (palavra = vetor_de_palavras[meio]) then
            Encontrou := true
        else
            if (palavra < vetor_de_palavras[meio]) then
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
	linha, coluna, resultado, localizacao: byte;
begin
	i := 1;
	linha := 3;
	resposta_certa := false;

	while (i <= 6) or (resposta_certa = false) do
	begin
		gotoxy (1, linha);
		writeln(i, 'a tentativa: ');
		fillchar(palavra, sizeof(palavra), chr(32));
		gotoxy (16, linha); 
		palavra := readstring(5);
		
(*	Testa pra ver se achou a palavra. *)			
		
		if palavra = palavra_certa then
		begin
			palavra_impressa := palavra_certa;
			gotoxy (1, 22);
			clreol;
			writeln('Acertou!');
			resposta_certa := true;
			i := 7;
		end
		else
		begin

(*	Primeiro testa pra ver se tem a palavra no acervo. *)				

			fillchar(palavra_impressa, sizeof(palavra_impressa), chr(32));
			palavra_impressa := '?????';
			tem_ou_nao := busca_binaria (palavra);
			if tem_ou_nao <> 0 then
			begin
				gotoxy (1, 22);
				clreol;
				writeln('Essa palavra esta no acervo.');

(*	Agora vamos ver quais letras estão certas. *)

				coluna := 16;

(*	Letra certa, posicao certa. *)

				for j := 1 to 5 do
					if palavra[j] = palavra_certa[j] then
						palavra_impressa[j] := upcase(palavra[j])
					else

(*	Letra certa, posicao errada. *)																

					begin
						resultado 	:= 	pos(palavra[j], palavra_certa);
						if resultado <> 0 then
						begin
							localizacao := 	pos(palavra[j], palavra);
							palavra_impressa[localizacao] := palavra[j];
						end;
					end;
				i := i + 1;
				gotoxy (26, linha);
				writeln(palavra_impressa);
				writeln;
				linha := linha + 1;
			end
			else
			begin
				gotoxy (1, 22); 
				clreol;
				writeln('Essa palavra nao esta no acervo.');
			end;
		end;
	end;
	for i := 1 to 5 do
		palavra[i] := upcase(palavra_certa[i]);
	gotoxy (26, linha); 
	writeln(palavra);
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
	writeln('Palavra: ', vetor_de_palavras[aleatorio]);
	forca;
END.
