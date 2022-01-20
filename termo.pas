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
type
	wordlist = string[5];

var
	arquivo_entrada: file of wordlist;
	nome_arquivo_entrada: string[80];
	palavra: wordlist;
	tamanho_arquivo, aleatorio: integer;

BEGIN
	nome_arquivo_entrada := 'd:pt_word.lst';
	aleatorio := 0;
	
	clrscr;
	randomize;
	assign (arquivo_entrada, nome_arquivo_entrada);
	{$i-}
	reset (arquivo_entrada);
	{$i+}

	tamanho_arquivo := filesize(arquivo_entrada);
	aleatorio := round(int(random(tamanho_arquivo)));

	fillchar(palavra, sizeof(palavra), chr(32));
	seek(arquivo_entrada, aleatorio);
	read(arquivo_entrada, palavra);
	writeln(aleatorio , ' ' , palavra);

	close(arquivo_entrada);
END.

