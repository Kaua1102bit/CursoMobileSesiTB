package View;

import java.util.Scanner;

import Controller.Aluno;
import Controller.Curso;
import Controller.Professor;

public class App {
    public static void main(String[] args) throws Exception {
        //criar curso incluir professor
        Professor professor = new Professor("José Pereira", "123.456.789-00", 15000.00);
        Curso curso = new Curso("Programação Java", professor);
        //menu de opçoes
        int operacao;
        boolean continuar = true;
        Scanner sc = new Scanner(System.in);
        while (continuar) {
            System.out.println("Escolha a opção desejada:");
            System.out.println("1. Adicionar Aluno");
            System.out.println("2. Informações do Curso");
            System.out.println("3. Status do Aluno");
            System.out.println("4. Sair");
            System.out.println("=========================");
            operacao = sc.nextInt();
            switch (operacao) {
                case 1://adicionar aluno
                    System.out.println("Informe o Nome do Aluno");
                    String nomeA = sc.next();
                    System.out.println("Informe o cpf do Aluno");
                    String cpfA = sc.next();
                    System.out.println("Informe o n° da Matricula");
                    String matriculaA= sc.next();
                    System.out.println("Informe a nota do Aluno");
                    double notaA = sc.nextDouble();
                    Aluno aluno = new Aluno(nomeA, cpfA, matriculaA, notaA);
                    curso.adicionarAluno(aluno);
                    System.out.println("Aluno Adicionado com Sucesso");
                    System.out.println("============================");
                    break;
                    case 2://exibir informações do curso
                    curso.exibirInformacoesCurso();
                    break;
                    case 3://sair
                    System.out.println("Saindo...");
                    continuar = false;
                    break;        
                default: 
                    System.out.println("Informe um Valor Válido!");
                    break;
            }

        }
        sc.close();
    }
}
