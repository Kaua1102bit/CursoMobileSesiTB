package model;

public class Professor extends Pessoa{
    //atributos - privados
    private Double Salario;
    //métodos - públicos
    //construtor
    public Professor(String nome, String cpf, Double salário) {
        super(nome, cpf);
        this.Salario = Salario;
    }
    //getters and setters
    public Double getsalario() {
        return Salario;
    }
    public void setSalário(String Salário) {
        this.Salario = Salario;
    }

    public void setsalario(double salario) {
        this.Salario = salario;
    }
    //polimorfismo - override - exibirInformações
    @Override 
    public void exibirInformacoes(){
        super.exibirInformacoes();
        System.out.println("Salário: "+getsalario());
    }

}


