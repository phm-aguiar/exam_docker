# Makefile

criaDiretorios:
	@echo "Criando diretórios 'rendu' e 'subjects'."
	@mkdir -p rendu subjects
	@echo "Diretórios criados com sucesso."

build:
	@docker build -t exam-project .
	@echo "Imagem 'exam-project' criada com sucesso."
	@echo "Iniciando o contêiner 'exam-container'."
	@echo "O contêiner 'exam-container' será iniciado com os diretórios 'rendu' e 'subjects' montados."
	@echo "O contêiner será iniciado em segundo plano e será removido após o uso."
	@echo "Para parar o contêiner, use 'make clean'."
	@echo "Para reiniciar o contêiner, use 'make re'."
	@echo "Para parar o contêiner, use 'make clean'."
	@echo "Para remover os diretórios 'rendu' e 'subjects', use 'make clean'."

run:
	@echo "Iniciando o contêiner 'exam-container'."
	@docker run -dit --rm --name exam-container -v $(PWD)/rendu:/app/rendu -v $(PWD)/subjects:/app/subjects exam-project
	@echo "Contêiner 'exam-container' iniciado com sucesso."
	@echo "Acesse o contêiner com 'docker exec -it exam-container zsh'."
all: criaDiretorios build run

clean:
	@echo "O contêiner será removido."
	docker stop exam-container || true
	rm -rf rendu subjects


startExam:
	@echo "Iniciando o 'exam-42."
	@docker exec -it exam-container make
	

re: clean run

.PHONY: all criaDiretorios build run clean re