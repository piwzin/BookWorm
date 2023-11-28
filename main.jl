using Dates

# Definição do tipo de dados para representar um livro
mutable struct Livro
    titulo::String
  
    autor::String
    genero::String
    isbn::String
    ano_publicacao::Int
    quantidade::Int
end

# Definição do tipo de dados para representar um usuário
mutable struct Usuario
    nome::String
    id::Int
end

# Estrutura para representar o histórico de empréstimos
struct HistoricoEmprestimo
    usuario::Usuario
    livro::Livro
    data_emprestimo::Date
    data_devolucao_estimada::Date
end

# Dicionários para armazenar os livros, usuários e histórico de empréstimos
livros = Dict{String, Livro}()
usuarios = Dict{Int, Usuario}()
historico_emprestimos = Vector{HistoricoEmprestimo}()

# Função para cadastrar um novo livro
function cadastrar_livro()
    println("Cadastro de Livro:")
    println("Título: ")
    titulo = readline()
    
    println("Autor: ")
    autor = readline()
    
    println("Gênero: ")
    genero = readline()
    
    println("ISBN: ")
    isbn = readline()
    
    println("Ano de Publicação: ")
    ano = parse(Int, readline())
    
    println("Quantidade de Exemplares Disponíveis: ")
    quantidade = parse(Int, readline())
    
    livro = Livro(titulo, autor, genero, isbn, ano, quantidade)
    livros[isbn] = livro
    println("Livro cadastrado com sucesso.")
end

# Função para cadastrar um novo usuário
function cadastrar_usuario()
    println("Cadastro de Usuário:")
    println("Nome: ")
    nome = readline()
    
    println("ID: ")
    id = parse(Int, readline())
    
    usuario = Usuario(nome, id)
    usuarios[id] = usuario
    println("Usuário cadastrado com sucesso.")
end

# Função para realizar um empréstimo de livro
function emprestar_livro(usuario::Usuario, isbn::String, data_emprestimo::Date, data_devolucao_estimada::Date)
    if haskey(livros, isbn)
        livro = livros[isbn]
        if livro.quantidade > 0
            livro.quantidade -= 1
            historico_emprestimo = HistoricoEmprestimo(usuario, livro, data_emprestimo, data_devolucao_estimada)
            push!(historico_emprestimos, historico_emprestimo)
            println("Empréstimo realizado com sucesso.")
        else
            println("Não há exemplares disponíveis deste livro para empréstimo.")
        end
    else
        println("Livro com ISBN '$isbn' não encontrado.")
    end
end

# Função para realizar a devolução de um livro
function devolver_livro(isbn::String)
    if haskey(livros, isbn)
        livro = livros[isbn]
        livro.quantidade += 1
        println("Devolução realizada com sucesso.")
    else
        println("Livro com ISBN '$isbn' não encontrado.")
    end
end

# Função para pesquisar livros pelo título, autor, gênero ou ISBN
function pesquisar_livro(termo::String)
    println("Resultados da pesquisa:")
    encontrado = false
    
    for (_, livro) in pairs(livros)
        if contains(lowercase(livro.titulo), lowercase(termo)) ||     
           contains(lowercase(livro.autor), lowercase(termo)) ||         
           contains(lowercase(livro.genero), lowercase(termo)) || 
           contains(lowercase(livro.isbn), lowercase(termo))
            println("Título: ", livro.titulo)
            println("Autor: ", livro.autor)
            println("Gênero: ", livro.genero)
            println("ISBN: ", livro.isbn)
            println("Ano de Publicação: ", livro.ano_publicacao)
            println("Quantidade Disponível: ", livro.quantidade)
            println()
            encontrado = true
        end
    end
    
    if !encontrado
        println("Nenhum livro encontrado para o termo '$termo'.")
    end
end


# Função para gerar relatório de livros emprestados
function relatorio_livros_emprestados()
    println("Relatório de Livros Emprestados:")
    for historico in historico_emprestimos
        println("Usuário: ", historico.usuario.nome)
        println("Título do Livro: ", historico.livro.titulo)
        println("Data de Empréstimo: ", historico.data_emprestimo)
        println("Data de Devolução Estimada: ", historico.data_devolucao_estimada)
        println()
    end
end

# Função para exibir o menu e receber a escolha do usuário
function exibir_menu()
    println("Bem-vindo ao Sistema de Controle de Biblioteca")
    println("Escolha uma opção:")
    println("1. Cadastrar Livro")
    println("2. Cadastrar Usuário")
    println("3. Emprestar Livro")
    println("4. Devolver Livro")
    println("5. Pesquisar Livro")
    println("6. Gerar Relatório de Livros Emprestados")
    println("7. Sair")
    print("Escolha uma opção: ")
    return parse(Int, readline())
end

# Função principal que inicia o sistema
function main()
    while true
        escolha = exibir_menu()
        
        if escolha == 1
            cadastrar_livro()
        elseif escolha == 2
            cadastrar_usuario()
        elseif escolha == 3
            println("Digite o ID do usuário: ")
            id_usuario = parse(Int, readline())
            println("Digite o ISBN do livro: ")
            isbn_livro = readline()
            data_emprestimo = today()
            data_devolucao_estimada = today() + Dates.Day(14)  # Prazo de 14 dias para devolução
            usuario = get(usuarios, id_usuario, nothing)
            if usuario !== nothing
                emprestar_livro(usuario, isbn_livro, data_emprestimo, data_devolucao_estimada)
            else
                println("Usuário não encontrado.")
            end
        elseif escolha == 4
            println("Digite o ISBN do livro a ser devolvido: ")
            isbn_livro = readline()
            devolver_livro(isbn_livro)
        elseif escolha == 5
            println("Digite um termo de pesquisa: ")
            termo = readline()
            pesquisar_livro(termo)
        elseif escolha == 6
            relatorio_livros_emprestados()
        elseif escolha == 7
            println("Saindo do sistema.")
            break
        else
            println("Opção inválida. Por favor, escolha uma opção válida.")
        end
    end
end

main()  # Iniciar o programa
