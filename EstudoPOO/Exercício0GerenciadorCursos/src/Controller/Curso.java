package Controller;

import java.util.ArrayList;
import java.util.List;

import model.Aluno;
import model.Professor;

public class Curso {
    //atributos - privados
    private String nomeCurso;
    private Professor professor;
    private List<Aluno> alunos;
    //métodos - públicos
    //construtor
    public Curso(String nomeCurso, Controller.Professor professor2) {
        this.nomeCurso = nomeCurso;
        this.professor = professor;
        this.alunos = new ArrayList<>();
    }
    //adicionar alunos
    public void adicionarAluno(Controller.Aluno aluno){
        alunos.add(aluno);
    }
    //exibir as informações do curso
    public void exibirInformacoesCurso(){
        System.out.println("Nome do Curso: "+nomeCurso);
        System.out.println("Nome Professor: "+professor.getNome());

       }

     } 
}
                 //exibirStatusAluno
                 public void exibirStatusAluno() {

          //loop - foreach
          int i = 1;
          for (Aluno aluno : alunos) {
            if(aluno.getNota() >=6)
            System.out.println(i+"."+aluno.getNome() + "|Aprovado");
            else
            System.out.println(i+"."+aluno.getNome() + "| Reprovado");
              i++;

             }
    
       }