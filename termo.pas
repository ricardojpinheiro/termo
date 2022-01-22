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
	registerwordlist	= record
		nome: wordlist;
	end;

var
	arquivo_entrada: file of registerwordlist;
	nome_arquivo_entrada: string[80];
	palavra: wordlist;
	registropalavra: registerwordlist;
	tamanho_arquivo, aleatorio, i, j: integer;
	resposta_certa: boolean;

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

procedure sorteio;
begin
	tamanho_arquivo := filesize(arquivo_entrada);
	aleatorio := round(int(random(tamanho_arquivo)));
end;

procedure busca_da_palavra;
begin
	seek(arquivo_entrada, aleatorio);
	read(arquivo_entrada, registropalavra);
end;

procedure forca;
begin
	i := 1;
	resposta_certa := false;

	with registropalavra do
		while (i <= 6) or (resposta_certa = false) do
		begin
			writeln(i, 'a tentativa: ');
			fillchar(palavra, sizeof(palavra), chr(32));
			read(palavra);
			if nome <> palavra then
				for j := 1 to 5 do
					if nome[j] = palavra[j] then
						write(palavra[j])
					else
						write('?')
			else
				resposta_certa := true;
			writeln;
			i := i + 1;
		end;
end;

procedure fecha_arquivo;
begin
	close(arquivo_entrada);
end;

BEGIN
	inicializacao;
	abre_arquivo;
	sorteio;
	busca_da_palavra;

	writeln('Aleatorio: ', aleatorio);
	writeln('Tamanho do arquivo: ', tamanho_arquivo);
	writeln('Palavra: ', registropalavra.nome);

	forca;
	fecha_arquivo;
END.

