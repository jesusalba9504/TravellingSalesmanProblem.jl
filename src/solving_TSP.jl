"""
Solving the travelling salesman problem.

if you have a costs square symetric matrix with diagonal equal to zero use the function solve_TSP()
if you have the set of (x,y) coordinates then use the function hacematrixdedistancias() first to generate the costs matrix

The function solve_TSP give the minimun costs posible and the elements of the costs matrix that minimize the costs the travel
"""
function solve_TSP(costs_matrix)
    N=size(costs_matrix)[1]
    if N==size(costs_matrix)[2];
        m = JuMP.Model(JuMP.with_optimizer(GLPK.Optimizer))
        @variable(m, x[1:N,1:N], Bin)

        @objective(m, Min, sum(costs_matrix.*x))
        @constraint(m, notself[i=1:N], x[i,i] == 0)
        @constraint(m, goto[i=1:N], sum(x[i,1:N]) == 1)
        @constraint(m, cometo[j=1:N], sum(x[1:N,j]) == 1)
        @variable(m, t[1:N], Int)
        for i=1:N,j=2:N
            if i!=j
                @constraint(m,t[j]>=t[i]+1-N*(1-x[i,j]))
            end
        end

        optimize!(m)
        println("El coste optimo es: ")
        println(objective_value(m))
        for i=1:N
            for j=1:N
                if value(x[i,j])!=0
                    println("d[$i,$j]=",costs_matrix[i,j])
                end
            end
        end
    else println("La matriz debe ser cuadrada, con diagonal principal =0 y simetrica")
    end

end

function hacematrixdedistancias(listadeptos)
    distmatrix=zeros(Float64,(length(listadeptos),length(listadeptos)));
    for i=1:length(listadeptos)
        for j=1:length(listadeptos)
            distmatrix[i,j]=distanciacartesiana(listadeptos[i],listadeptos[j])
        end
    end
    return distmatrix;
end

function distanciacartesiana(pto1,pto2)
    dis=sqrt((pto1[1]-pto2[1])^2+(pto1[2]-pto2[2])^2);
    return dis;
end
