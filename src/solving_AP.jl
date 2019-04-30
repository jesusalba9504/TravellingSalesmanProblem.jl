"""
Solving the assigment problem.
Introduce a costs square matrix.
The function give the minimun costs posible and the elements of the costs matrix that minimize the costs of the task assigment
"""
function solve_assigm_prob(costs_matrix)
    N=size(costs_matrix)[1];
    if N==size(costs_matrix)[2];
        modelo = JuMP.Model(JuMP.with_optimizer(GLPK.Optimizer))
        @variable(modelo, x[1:N,1:N] >=0 )

        @objective(modelo, Min, sum(costs_matrix.*x))
        @constraint(modelo, rows[i=1:N], sum(x[i,1:N])==1)
        @constraint(modelo, cols[j=1:N], sum(x[1:N,j])==1)
        optimize!(modelo)
        println("El coste optimo es: ")
        println(objective_value(modelo))
        for i=1:N
            for j=1:N
                if value(x[i,j])!=0
                    println("C[$i,$j]=",costs_matrix[i,j])
                end
            end
        end

    else println("La matriz debe ser cuadrada")
    end
end
