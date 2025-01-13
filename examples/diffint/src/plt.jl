using CSV
using DataFrames
using Plots

##println(ARGS[1])
df=DataFrames.DataFrame(CSV.File(ARGS[1],delim=";",header=false))
plot(df.Column1 , [df.Column2,df.Column3] ,
                  label=["x" ARGS[2]] ,
                  title=ARGS[1] , show=true);
savefig(ARGS[1] * "_.png")

