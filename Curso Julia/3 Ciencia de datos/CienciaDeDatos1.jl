### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ b107d7f9-90c3-4a9f-9b55-0e1dc323ee56
using PlutoUI

# ╔═╡ ad6469ef-68a5-4819-bf98-85d06d37b960
using CSV

# ╔═╡ f31b4062-c763-4647-84ef-b3db25406fc8
using HTTP

# ╔═╡ 6cab610d-e713-4b08-8a5b-5eab8820732f
using DataFrames

# ╔═╡ 6fc301b3-18f2-44e8-91d2-268e10c3a0e6
using BenchmarkTools

# ╔═╡ 7ef54d4e-a43d-4b37-8b2e-021d9a5ea99f
begin
	using MLJ
	import RDatasets: dataset
	import DataFrames: DataFrame, select, Not, describe
	using Random
end

# ╔═╡ b33417a7-6263-4954-a923-c6716c61f2bf
using MLJMultivariateStatsInterface

# ╔═╡ 76e7ce0e-7c62-45e2-a02e-2f2283c56c3b
using MLJClusteringInterface

# ╔═╡ 9ecc20b5-538e-415b-80c3-c4fad54b0ccf
using Plots

# ╔═╡ 65e9979c-ec08-4093-9a35-3b872da2dee1
using UrlDownload

# ╔═╡ cfc8f87e-3502-4115-9da4-c137acd880cb
using MLJScikitLearnInterface #También hay que instalar scikit-learn donde sea que tengamos a Julia, en mi caso, uso pip3 install scikit-learn

# ╔═╡ 6b4a8fd1-60f5-4760-a453-86a75a201a5f
md"""# Ciencia de Datos

	- Oscar Alejando Esquivel Flores
	- Óscar Anuar Alvarado Morán
	- Mario Horacio Garrido Czacki
"""

# ╔═╡ ef6340c4-f4f7-11eb-30f9-599dcebb98be
PlutoUI.TableOfContents(title="🔬 Ciencia de datos 🔭", depth = 5)

# ╔═╡ d24051dc-5efa-48c8-b65b-c756ba43b864
md"# Manejo de datos"

# ╔═╡ b1a67905-09f3-41aa-9a87-362d051fc69f
md"## CSV.jl
- [GitHub](https://github.com/JuliaData/CSV.jl)
- [JuliaData](https://csv.juliadata.org/stable/)"

# ╔═╡ 6069ba43-4a4d-4c59-a465-098385eb6e80
md"### Leyendo csv
Usemos la función `CSV.File` para leer archivos `.csv`. Podemos hacerlo desde archivos locales:"

# ╔═╡ a3c21e5d-a030-4cf3-aed3-e7100a885d37
hotel = CSV.File("Julia-IIMAS-v1.0/datos/hotel_bookings.csv")

# ╔═╡ 6baca64d-6dcb-44d7-b03d-69c0322631fe
md"O también podemos leer desde una página con la paquetería `HTTP.jl`"

# ╔═╡ e32d05c9-5896-4435-8f4c-15f887d6b256
begin
	url = "https://raw.githubusercontent.com/OscarAlvaradoM/Pokemon/master/datos/Disp8_completo.csv"
	pokemon = CSV.File(HTTP.get(url).body)
end

# ╔═╡ bf9cd655-eafe-41d2-ab06-f0a53cde9455
pokemon.names

# ╔═╡ f653a134-d37a-4959-bf81-40c2d20d4a87
pokemon.cols

# ╔═╡ 7ea3c9a3-a369-4ee9-908d-ed8b7d1ae3cb
md"### Delimitador"

# ╔═╡ 36b56e8b-dde9-4fcb-a3f9-a93fb3101cdf
md"""
	col1::col2
	1::2
	3::4
```Julia
CSV.File(file; delim="::")
```
"""

# ╔═╡ fcd2724d-aa29-4e7b-8d39-818463e7ceb5
md"### Sin encabezado"

# ╔═╡ 6165b59f-2c9c-44d8-b914-a307f99a5a48
md"""
	1,2,3
	4,5,6
	7,8,9
```Julia
CSV.File(file; header=false)
CSV.File(file; header=["col1", "col2", "col3"])
CSV.File(file; header=[:col1, :col2, :col3])
```
"""

# ╔═╡ c36c1741-21fe-4758-a82d-dbf3439830cd
md"### Datarow"

# ╔═╡ 51e1ee64-9541-4ee2-9499-748811dacac9
md"""
	col1,col2,col3
	metadata1,metadata2,metadata3
	extra1,extra2,extra3
	1,2,3
	4,5,6
	7,8,9

```Julia
CSV.File(file; datarow=4)
CSV.File(file; skipto=4)
```
"""

# ╔═╡ e2da47f5-d1bf-4060-8113-5fa2a7de56ff
md"### Leyendo lotes"

# ╔═╡ 4ece0521-051e-475c-bec9-10f38beb009d
md"""
	col1,col2,col3
	1,2,3
	4,5,6
	7,8,9
	10,11,12
	13,14,15
	16,17,18
	19,20,21

```Julia
CSV.File(file; limit=3)
CSV.File(file; skipto=4, limit=1)
CSV.File(file; skipto=7, footerskip=1)
```
"""

# ╔═╡ 236f6a7d-86a5-4bbc-a0d8-49f06e1714bf
md"### Reenglones comentados"

# ╔═╡ 66e15e9e-f283-487d-8e73-ae5ec23edb54
md"""
	col1,col2,col3
	# this row is commented and we'd like to ignore it while parsing
	1,2,3
	4,5,6

```Julia
CSV.File(file; comment="#")
CSV.File(file; datarow=3)
```
"""

# ╔═╡ 72e80a6f-8d30-4a85-a154-d2fbfc653421
md"### Valores nulos"

# ╔═╡ 0b5f90c0-7b51-484a-a023-0f533167bf7b
md"""
	code,age,score
	0,21,3.42
	1,42,6.55
	-999,81,NA
	-999,83,NA

```Julia
CSV.File(file; missingstring="-999")
CSV.File(file; missingstrings=["-999", "NA"])
```
"""

# ╔═╡ 720f5fe8-0616-4480-be24-b81764c4361f
md"### Fechas"

# ╔═╡ 7cbe09ae-5dcc-4c42-b824-bd401ed7f18b
md"""
	code,date
	0,2019/01/01
	1,2019/01/02

```Julia
CSV.File(file; dateformat="yyyy/mm/dd")
```
"""

# ╔═╡ 6b8336a6-fac6-4042-84e5-2cf4a0bf83b7
md"### Asignando tipos"

# ╔═╡ 9d3653a3-a617-4694-bc87-72d2606245c9
md"""
	col1,col2,col3
	1,2,3
	4,5,invalid
	6,7,8

```Julia
CSV.File(file; types=Dict(3 => Int))
CSV.File(file; types=Dict(:col3 => Int))
CSV.File(file; types=Dict("col3" => Int))
CSV.File(file; types=[Int, Int, Int])
CSV.File(file; types=[Int, Int, Int], silencewarnings=true)
CSV.File(file; types=[Int, Int, Int], strict=true)
```
"""

# ╔═╡ 7f43e8c7-7ac8-4aa2-acae-87e0c3814da1
md"### Seleccionar o eliminar columnas de un archivo"

# ╔═╡ ffb89c6b-cdd1-4a64-8ad7-b512373dfa1a
md"""
	a,b,c
	1,2,3
	4,5,6
	7,8,9

```Julia
# select
CSV.File(file; select=[1, 3])
CSV.File(file; select=[:a, :c])
CSV.File(file; select=["a", "c"])
CSV.File(file; select=[true, false, true])
CSV.File(file; select=(i, nm) -> i in (1, 3))
# drop
CSV.File(file; drop=[2])
CSV.File(file; drop=[:b])
CSV.File(file; drop=["b"])
CSV.File(file; drop=[false, true, false])
CSV.File(file; drop=(i, nm) -> i == 2)
```
"""

# ╔═╡ acf3fc88-d7cd-4bf9-ba4b-dd166984d7aa
md"## DataFrames.jl
- [GitHub](https://github.com/JuliaData/DataFrames.jl)
- [JuliaData](https://dataframes.juliadata.org/stable/#)"

# ╔═╡ 92056bbd-8dde-4b38-8780-02e248c6cfd3
md"### Transformando de un CSV.File a DataFrame"

# ╔═╡ fdbd56bb-4a02-436a-9ee3-552b373547c7
df_poke = CSV.read(HTTP.get("https://raw.githubusercontent.com/OscarAlvaradoM/Pokemon/master/datos/Disp8_completo.csv").body, DataFrame)

# ╔═╡ ccd0662b-455d-453f-be8c-d0a998910a7f
df_pokemon = DataFrame(pokemon)

# ╔═╡ 97d67ce7-cfb5-47fd-9ea3-272ded84e9fd
methodswith(typeof(df_pokemon))

# ╔═╡ 21f1d7dd-a865-4e8b-ab03-cd81b91f5f29
names(df_pokemon)

# ╔═╡ 6dc1461e-ad0e-4020-825a-a696de245ca8
nrow(df_pokemon)

# ╔═╡ 7dd8b809-0870-4945-97d2-2a655d0fcc63
md"### Creando DataFrames desde 0"

# ╔═╡ fd76cca7-48c0-474a-b826-3be1d7c54c14
DataFrame(A=1:3, B=5:7, fixed=1)

# ╔═╡ a5f4bad2-2919-4241-9178-e944e42d69a5
DataFrame("Edad" => ["?", 23, 24], "Nombre" => ["Oscar", "Mario", "Anuar"])

# ╔═╡ b2fbf649-32b6-4dd8-894c-9ca2e2fa1e9c
begin
	dict_edades1 = Dict("Edad" => ["?", 23, 24], "Nombre" => ["Oscar", "Mario", "Anuar"])
	DataFrame(dict_edades1)
end

# ╔═╡ 8b1d8c99-7fa1-4054-ae7d-52b01a97b0b3
begin
	dict_edades2 = Dict(:Edad => ["?", 23, 24], :Nombre => ["Oscar", "Mario", "Anuar"])
	DataFrame(dict_edades2)
end

# ╔═╡ 76dbe6fa-7426-4ef1-874a-7463602e6c7c
DataFrame((a=[1, 2], b=[3, 4]))

# ╔═╡ bbae294a-01f4-47a3-9cfb-99e8e0978796
DataFrame([(a=1, b=0), (a=2, b=0)])

# ╔═╡ 064bea34-0890-4d27-8c5c-63d7f66e10ac
DataFrame([1 0; 2 0], ["A", "B"])

# ╔═╡ 35fef6ab-eaf7-4e39-8424-1e77ef29a4f1
DataFrame([1 0; 2 0], :auto)

# ╔═╡ e13caf23-fe50-456a-a7f0-1df74580e6c6
md"### Operaciones básicas sobre DataFrames"

# ╔═╡ 2d0dd71a-d577-4d56-bf42-31ce47d0bebe
names(df_pokemon)

# ╔═╡ 41424723-6627-4462-9e31-36ef20933230
md"Esto no es una copia"

# ╔═╡ 816b06b0-82b9-45ce-8cbb-22061363c936
df_pokemon.Nombre

# ╔═╡ 8784abe2-688d-401f-bce0-0ad02b4b7e76
md"Esto es una copia:"

# ╔═╡ efca9fcb-2378-49ad-b82b-a528674944da
df_pokemon[:, :Nombre] #Agarra todos los renglones y la columna Nombre

# ╔═╡ 0cd53836-8853-46da-86f4-2a11bee5bed8
md"Y esto ¿qué es?"

# ╔═╡ 0eb90afd-4e1c-4bf2-b8a4-b7241ed7d042
df_pokemon[!, :Nombre]

# ╔═╡ 7c787df1-3f7e-4057-91e2-db9b0a42b11f
df_pokemon.Nombre === df_pokemon[!, :Nombre] # === es exactamente el mismo objeto?

# ╔═╡ e426364d-dc2d-45a7-8e3f-a7d63424433e
df_pokemon.Nombre === df_pokemon[:, :Nombre]

# ╔═╡ d96f14f8-dc5c-4adf-899e-5e9497e9bba1
eltype.(eachcol(df_pokemon))

# ╔═╡ 79bf46e7-96c3-488d-9ced-e35798d6ed09
size(df_pokemon)

# ╔═╡ d6b8b7f2-2eff-4201-b53f-c10848942f9b
nrow(df_pokemon)

# ╔═╡ dfe4c5c0-d51d-4aae-abe7-604619a16e17
ncol(df_pokemon)

# ╔═╡ 22b933e1-9763-4922-b72d-a9f59477aaaf
describe(df_pokemon, cols=1:10)

# ╔═╡ 4e6a6592-72dd-4e59-9cb8-e4aa75b82c3f
mapcols(Altura_m -> Altura_m.^2, df_pokemon)

# ╔═╡ dc16d155-379f-4d2a-8e01-825c384c117c
df_pokemon.Altura_m

# ╔═╡ f413974c-b210-4d9e-bc3f-c5b0d3f28e69
first(df_pokemon, 8)

# ╔═╡ 5f96e230-7e61-4a1e-962f-8ca5f0d0be60
last(df_pokemon, 5)

# ╔═╡ 466e107d-1c7a-4a15-a08b-c9120b84a917
df_pokemon[1:5, [:Nombre, :Clasificación]]

# ╔═╡ b7935362-ac6b-47a8-9106-cc2beaac70a8
df_pokemon[[1, 6, end], :]

# ╔═╡ 8d0b9978-b04a-436d-bf13-6946b043e48d
@view df_pokemon[end:-1:1, [:Nombre, :Generación]]

# ╔═╡ 38452d24-76bd-4d75-9f9b-39d5d0d2dae8
@btime @view $df_pokemon[1:end-1, 1:end-1]

# ╔═╡ 68733a99-4d7e-4256-a168-2032de50ab80
@btime $df_pokemon[1:end-1, 1:end-1];

# ╔═╡ e0968f67-1995-45d1-81e5-f6fb875312d5
df_pokemon.Contra_acero .= 1.

# ╔═╡ e51c2334-fd90-4847-9877-05ed2390d45a
insertcols!(df_pokemon, 1, :Juego => "Pokemon")

# ╔═╡ 432e6d0a-7671-4b3c-a8c4-0508a418cee7
df_pokemon[:, Not(:Evolución)]

# ╔═╡ 7e693874-9155-4c2f-8b4c-3543454fbb56
df_pokemon[:, Between(:Juego, :Generación)]

# ╔═╡ 7cc17b78-8f2a-49de-a7a6-99ab6d89b0e0
df_pokemon[:, Cols(:Altura_m, Between(:Juego, :Generación))]

# ╔═╡ ab72fb5f-90ac-446c-88d6-938852f3816e
md"Haciendo algunos joins"

# ╔═╡ 9c851f5a-4c8f-4388-86a1-ff6a3d83c8fe
people = DataFrame(ID = [20, 40], Name = ["John Doe", "Jane Doe"])

# ╔═╡ 6f6459c8-8242-4340-a588-0512eff5d5c3
jobs = DataFrame(ID = [20, 60], Job = ["Lawyer", "Doctor"])

# ╔═╡ db565011-1563-41cc-84d0-e14c8237aa8a
innerjoin(people, jobs, on = :ID)

# ╔═╡ f518b097-a6f4-4bf5-ba36-0088f5fc6b94
leftjoin(people, jobs, on = :ID)

# ╔═╡ 98693a39-71de-4e60-bf66-42e30618e254
rightjoin(people, jobs, on = :ID)

# ╔═╡ f1ea0441-6910-4704-906a-3e6cf05b4105
df = DataFrame(i = 1:5,x = [missing, 4, missing, 2, 1],y = [missing, missing, "c", "d", "e"])

# ╔═╡ a0d7c872-8c54-4eed-9a01-1ca92c2d6a28
dropmissing(df)

# ╔═╡ 65729744-b221-488d-b1ad-85981489916c
dropmissing(df, :x)

# ╔═╡ c0b3f6a7-341c-435a-b528-3a190f5c500c
md"Una buena comparación con Pandas y R:

[DataFrames (JuliaData)](https://dataframes.juliadata.org/stable/man/comparisons/)"

# ╔═╡ 185015b8-d252-4beb-96f0-4d2483f79344
md"# Tarea
Buscar un conjunto de datos de tu interés con el cuál trabajar para aprendizaje automatizado, leerlo y analizarlo con julia"

# ╔═╡ e9fcbd2a-6c9b-4e07-bcae-b990ebc1a3da
md"# Aprendizaje Automatizado"

# ╔═╡ 042c51dc-80d8-4c19-9c87-4e3e83de5e19
md"## MLJ.jl
- [GitHub](https://github.com/alan-turing-institute/MLJ.jl)
- [Alan Turing Institute](https://alan-turing-institute.github.io/MLJ.jl/dev/)
- [DataScience Tutorials](https://alan-turing-institute.github.io/DataScienceTutorials.jl/)

`MLJ.jl` es un ambiente que provee de una _interfaz uniforme_ para **ajustar**, **evaluar** y **tunear** modelos de aprendizaje automatizado. Contiene más de 150 modelos de aprendizaje automatizado escritos en Julia y en otros lenguajes, en particular, MLJ envuelve un gran número de modelos del H.H.H `scikit.learn`."

# ╔═╡ eda00801-1169-4f24-ad20-56585835002a
md"### Aprendizaje no supervisado
	- PCA 
	- Agrupamiento"

# ╔═╡ 6f396986-414e-4a2a-a1b4-fb097e1759df
md"Usaremos el conjunto de datos [USArrests](https://www.rdocumentation.org/packages/datasets/versions/3.6.2/topics/USArrests), que consta de arrestos por cada 100,000 residentes para asalto, asesinato y violación en cada uno de los 50 estados de Estados Unidos en el año de 1973. También se presenta el porcentaje de la población viviendo en áreas urbanas."

# ╔═╡ 37aef421-934c-4d0e-a78e-7da96f8b3edc
begin
	data = dataset("datasets", "USArrests")
	first(data, 5)
end

# ╔═╡ 6d09d7e5-57d8-4619-b409-3fea32f427a4
md"Vemos un poco de descripción de los datos:"

# ╔═╡ 9d3e1566-7dbf-4cdc-9a79-796b1bb9b961
describe(data, :mean, :std, :min, :max)

# ╔═╡ eef96558-9a43-447f-a52d-a44636e5015d
md"Obtengamos los datos numéricos"

# ╔═╡ 9ead4d07-7586-480a-a24a-7eb866d4b130
begin
	X = select(data, Not(:State))
	X = coerce(X, :UrbanPop => Continuous, :Assault => Continuous)
end

# ╔═╡ a75720f2-9d56-4e1e-8fdd-e4d248871367
md"#### PCA
Primero, cargamos el modelo"

# ╔═╡ 0eea30b5-7729-40c8-aadf-8017fa3e740d
@load PCA pkg = MultivariateStats

# ╔═╡ 9c3f3c32-ec53-46db-8b06-a446d3871175
md"¿Qué pasó aquí? La cosa es que MLJ es sólo una interface para usar paquetes de aprendizaje automatizado, por lo que habrá que instalar diferentes paquetes dependiendo del modelo que querramos usar. Podemos ver algunos modelos a continuación."

# ╔═╡ 35cfad5a-cc8b-4c14-81e6-808ec0f67008
models(matching(X))

# ╔═╡ 6c8ee67c-66ee-480f-9154-01cf26583215
md"Si queremos ver todos los modelos disponibles podemos hacerlo como sigue:"

# ╔═╡ 2d5b8029-d913-43ff-bab4-3319c5681e71
models()

# ╔═╡ 7959d6c7-5b4a-4865-8fd1-3934cef54755
md"Creamos el modelo"

# ╔═╡ f7fd7736-f30d-40ea-af14-c422a31fbd77
pca_mdl = PCA()

# ╔═╡ 1cb799aa-dfe3-4b24-baf1-a2ad9c68c6d3
md"Creamos una _máquina_, que es un objeto que vincula un modelo (algoritmo + hiperparámetros) con los datos. Esta almacena los parámetros aprendidos."

# ╔═╡ 1274b8b5-8aa2-4b83-8170-fac74bebb946
pca = machine(pca_mdl, X)

# ╔═╡ 73691cc0-f43d-46ab-952b-d877a16de744
md"¡Ajustamos!"

# ╔═╡ 0bff6458-b298-4ea2-b1f8-01b00ce185b5
fit!(pca)

# ╔═╡ f48cce8b-6b4d-47e7-9827-26cd2a847a38
md"¡Transformamos!"

# ╔═╡ 565cb36b-96a6-4a05-b1b0-5ab8b95478d5
W = MLJ.transform(pca, X)

# ╔═╡ 8f44f8fa-53f3-490d-8835-0bb32cbc23d2
begin
	r = report(pca)
	cumsum(r.principalvars ./ r.tvar)
end

# ╔═╡ 610fa1c7-8c0c-4608-bc36-f7c8aa3f0f3b
md"Trabajemos con datos más interesantes:"

# ╔═╡ b211535c-fd8b-4f84-b88b-2ea2286a58f4
md"""
[Conjunto de datos Orange Juice](https://rdrr.io/cran/ISLR/man/OJ.html):

"The data contains 1070 purchases where the customer either purchased Citrus Hill or Minute Maid Orange Juice. A number of characteristics of the customer and product are recorded."


"""

# ╔═╡ 45bb9873-5eac-4e62-a041-0c4f47975462
begin
	data1 = dataset("ISLR", "OJ")
	X1 = select(data1, [:PriceCH, :PriceMM, :DiscCH, :DiscMM, :SalePriceMM,
                  :SalePriceCH, :PriceDiff, :PctDiscMM, :PctDiscCH]);
end

# ╔═╡ 728d6e97-9e60-4e42-b9ad-39c1a2e32808
names(data1)

# ╔═╡ 43594135-f686-4649-8f03-c87c7294315c
begin
	SPCA = @pipeline(Standardizer(),
	                 PCA())
	
	spca = machine(SPCA, X1)
	fit!(spca)
	W1 = MLJ.transform(spca, X1)
	W1
end

# ╔═╡ 60751597-b4b6-46e4-b2fe-a18de27301ef
begin
	rpca = collect(values(report(spca).report_given_machine))[2]
	cs = cumsum(rpca.principalvars ./ rpca.tvar)
end

# ╔═╡ 131dc691-87b0-46f6-ba6e-1a421b491f7d
md"#### Agrupamiento
Hagamos algo de agrupamiento con estos mismos datos que acabamos de obtener"

# ╔═╡ 7a981cc3-1a22-407c-aafe-69f170c64062
begin
	@load KMeans pkg=Clustering
	SPCA2 = @pipeline(Standardizer(),
	                  PCA(),
	                  KMeans(k=3))
	
	spca2 = machine(SPCA2, X1)
	fit!(spca2)
end

# ╔═╡ b15087d4-51d5-4903-8064-2f7cfac3f3c2
assignments = collect(values(report(spca2).report_given_machine))[3].assignments

# ╔═╡ 51a697bf-c7ce-4fa0-864c-57f93eb41d92
begin
	mask1 = assignments .== 1
	mask2 = assignments .== 2
	mask3 = assignments .== 3;
end

# ╔═╡ 95be3be8-af10-4286-97b0-5366792ad349
plotly()

# ╔═╡ a0ef1009-87bb-4f04-86f8-cf61f69577a1
begin
	plot(1,1,1, alpha = 0)
	for (m, c) in zip((mask1, mask2, mask3), ("red", "green", "blue"))
	    scatter!(W1[m, 1], W1[m, 2], W1[m, 3], markersize=1, color=c, alpha = 0.5)
	end
	plot!(1,1,1, alpha = 0)
end

# ╔═╡ a506982f-6ab8-4f90-9974-8ccbc5e15d35
md"### Aprendizaje supervisado"

# ╔═╡ 353d48a4-20ea-4167-bf93-c517e3488220
md"#### Clasificación"

# ╔═╡ c0385ff2-3c5a-4f01-acb8-a036cd5c85ff
begin
	url2 = "http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data"
	header = ["Class", "Alcool", "Malic acid", "Ash", "Alcalinity of ash",
	          "Magnesium", "Total phenols", "Flavanoids",
	          "Nonflavanoid phenols", "Proanthcyanins", "Color intensity",
	          "Hue", "OD280/OD315 of diluted wines", "Proline"]
	data2 = urldownload(url2, true, format=:CSV, header=header)
end

# ╔═╡ 8934fed8-f0ba-4635-9d96-74b9751c8b95
begin
	df2 = DataFrame(data2)
	describe(df2)
end

# ╔═╡ 26fac042-79b9-46d7-ade0-dd893fd4280e
y_wine, X_wine = unpack(df2, ==(:Class), colname->true)

# ╔═╡ 59160fa4-83dc-4d23-8759-ce8ab979b7b9
scitype(y_wine)

# ╔═╡ 1645c96b-84d0-43d2-b57f-09adf5d04803
yc = coerce(y_wine, OrderedFactor)

# ╔═╡ 04c66bc0-c607-46c2-8625-042f50e0a32b
scitype(X_wine)

# ╔═╡ 3c813b9e-1859-47b5-911f-06b36dc9b5c2
schema(X_wine)

# ╔═╡ b4aff21d-885a-44c4-abf0-a686fa44ae7a
Xc = coerce(X_wine, :Proline=>Continuous, :Magnesium=>Continuous)

# ╔═╡ 7787818f-b621-4039-94cf-91059e45d200
describe(Xc, :mean, :std)

# ╔═╡ 6c050cbf-ce13-4fa1-a992-2261702369f7
@load KNeighborsClassifier pkg="ScikitLearn"

# ╔═╡ 483537db-0253-4083-86b4-9678f66e137e
models()

# ╔═╡ 525d3cd2-f231-4138-b6be-c35d8a317bbc
KnnPipe = @pipeline(Standardizer(), KNeighborsClassifier())

# ╔═╡ 02d2647b-951a-41ad-9a50-767fdbdf54ec
train, test = partition(eachindex(yc), 0.8, shuffle=true, rng=111)

# ╔═╡ a22e4fc2-5ae3-4e64-8589-9c2ce68b01a2
knn = machine(KnnPipe, Xc, yc)

# ╔═╡ 8b9e878d-6f32-48d7-abeb-005bbcd14549
fit!(knn, rows=train)

# ╔═╡ 8b6374e9-47c2-4417-ae11-1ff909f9e5e1
ŷ = predict_mode(knn, rows=test)

# ╔═╡ 7ddff453-bb4b-4086-9d29-1f37ab99643a
begin
	r3 = x -> round(x, sigdigits=3)
	accuracy(ŷ, yc[test]) |> r3
end

# ╔═╡ eee433ec-6493-48d6-bcd0-e0e3b9c34bdc
md"#### Regresión"

# ╔═╡ 20ecc9ce-db93-4733-8fc1-24e058c84fb5
begin
	req = HTTP.get("https://raw.githubusercontent.com/rupakc/UCI-Data-Analysis/master/Airfoil%20Dataset/airfoil_self_noise.dat");
	
	df_air = CSV.File(req.body; header=["Frequency","Attack_Angle","Chord+Length",
	                  "Free_Velocity","Suction_Side","Scaled_Sound"])
end

# ╔═╡ 3e6d49ab-53ea-4d74-9478-4e3b48798977
schema(df_air)

# ╔═╡ 0d9281c5-3560-4a2c-9cec-21d16d4af695
y_q, X_q = unpack(df_air, ==(:Scaled_Sound), colname->true)

# ╔═╡ 11c5a4f7-ff46-4298-a05d-c75f48b5c483
df_air

# ╔═╡ 98483c7e-7cb0-42a6-b52d-da7d4ee43cce
begin
	#y_air, X_air = unpack(df_air, ==(:Scaled_Sound), colname -> true)
	#X_air = MLJ.transform(fit!(machine(Standardizer(), X_air)), X_air);
end

# ╔═╡ 37483f0a-b23e-4f26-a592-8c539b47eb0f
#train_air, test_air = partition(eachindex(y_air), 0.7, shuffle=true, rng=111)

# ╔═╡ 7e1d9ecc-be3a-418b-bcfc-e8268d1e4512


# ╔═╡ 46cd4e9c-e9f5-4cd6-a216-7ddb185ac35c


# ╔═╡ cd79d6f8-eeae-484d-af38-3b52574c030f


# ╔═╡ 33117a1d-ac85-44db-b75f-bf56d1d39f4f


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"
MLJ = "add582a8-e3ab-11e8-2d5e-e98b27df1bc7"
MLJClusteringInterface = "d354fa79-ed1c-40d4-88ef-b8c7bd1568af"
MLJMultivariateStatsInterface = "1b6a4a23-ba22-4f51-9698-8599985d3728"
MLJScikitLearnInterface = "5ae90465-5518-4432-b9d2-8a1def2f0cab"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
RDatasets = "ce6b1742-4840-55fa-b093-852dadbb1d8b"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
UrlDownload = "856ac37a-3032-4c1c-9122-f86d88358c8b"

[compat]
BenchmarkTools = "~1.1.1"
CSV = "~0.8.5"
DataFrames = "~1.2.2"
HTTP = "~0.9.13"
MLJ = "~0.16.7"
MLJClusteringInterface = "~0.1.4"
MLJMultivariateStatsInterface = "~0.2.2"
MLJScikitLearnInterface = "~0.1.10"
Plots = "~1.20.0"
PlutoUI = "~0.7.9"
RDatasets = "~0.7.5"
UrlDownload = "~1.0.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Arpack]]
deps = ["Arpack_jll", "Libdl", "LinearAlgebra"]
git-tree-sha1 = "2ff92b71ba1747c5fdd541f8fc87736d82f40ec9"
uuid = "7d9fca2a-8960-54d3-9f78-7d1dccf2cb97"
version = "0.4.0"

[[Arpack_jll]]
deps = ["Libdl", "OpenBLAS_jll", "Pkg"]
git-tree-sha1 = "e214a9b9bd1b4e1b4f15b22c0994862b66af7ff7"
uuid = "68821587-b530-5797-8361-c406ea357684"
version = "3.5.0+3"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[BSON]]
git-tree-sha1 = "92b8a8479128367aaab2620b8e73dff632f5ae69"
uuid = "fbb218c0-5317-5bc6-957e-2ee96dd4b1f0"
version = "0.3.3"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Statistics", "UUIDs"]
git-tree-sha1 = "c31ebabde28d102b602bada60ce8922c266d205b"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.1.1"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c3598e525718abcc440f69cc6d5f60dda0a1b61e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.6+5"

[[CSV]]
deps = ["Dates", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode"]
git-tree-sha1 = "b83aa3f513be680454437a0eee21001607e5d983"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.8.5"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "e2f47f6d8337369411569fd45ae5753ca10394c6"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.0+6"

[[CategoricalArrays]]
deps = ["DataAPI", "Future", "JSON", "Missings", "Printf", "RecipesBase", "Statistics", "StructTypes", "Unicode"]
git-tree-sha1 = "1562002780515d2573a4fb0c3715e4e57481075e"
uuid = "324d7699-5711-5eae-9e2f-1d82baa6b597"
version = "0.10.0"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "bdc0937269321858ab2a4f288486cb258b9a0af7"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.3.0"

[[Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "75479b7df4167267d75294d14b58244695beb2ac"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.14.2"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random", "StaticArrays"]
git-tree-sha1 = "ed268efe58512df8c7e224d2e170afd76dd6a417"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.13.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "344f143fa0ec67e47917848795ab19c6a455f32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.32.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[Conda]]
deps = ["JSON", "VersionParsing"]
git-tree-sha1 = "299304989a5e6473d985212c28928899c74e9421"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.5.2"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "ee400abb2298bd13bfc3df1c412ed228061a2385"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.7.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d785f42445b63fc86caa08bb9a9351008be9b765"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.2.2"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4437b64df1e0adccc3e5d1adbc3ac741095e4677"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.9"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "abe4ad222b26af3337262b8afb28fab8d215e9f8"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.3"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns"]
git-tree-sha1 = "a837fdf80f333415b69684ba8e8ae6ba76de6aaa"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.24.18"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "a32185f5428d3986f47c2ab78b1f216d5e6cc96f"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.5"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "92d8f9f208637e8d2d28c664051a00569c01493d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.1.5+1"

[[EarlyStopping]]
deps = ["Dates", "Statistics"]
git-tree-sha1 = "9427bc7a6c186d892f71b1c36ee7619e440c9e06"
uuid = "792122b4-ca99-40de-a6bc-6742525f08b6"
version = "0.1.8"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[ExprTools]]
git-tree-sha1 = "b7e3d17636b348f005f11040025ae8c6f645fe92"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.6"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "LibVPX_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "3cc57ad0a213808473eafef4845a74766242e05f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.3.1+4"

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "256d8e6188f3f1ebfa1a5d17e072a0efafa8c5bf"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.10.1"

[[FilePathsBase]]
deps = ["Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "0f5e8d0cb91a6386ba47bd1527b240bd5725fbae"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.10"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "693210145367e7685d8604aee33d9bfb85db8b31"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.11.9"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "35895cf184ceaab11fd778b4590144034a167a2f"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.1+14"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "cbd58c9deb1d304f5a245a0b7eb841a2560cfec6"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.1+5"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "dba1e8614e98949abfa60480b13653813d8f0157"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "182da592436e287758ded5be6e32c406de3a2e47"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.58.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "d59e8320c2747553788e4fc42231489cc602fa50"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.58.1+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "7bf67e9a481712b3dbe9cb3dac852dc4b1162e02"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "44e3b40da000eab4ccb1aecdc4801c040026aeb5"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.13"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InvertedIndices]]
deps = ["Test"]
git-tree-sha1 = "15732c475062348b0165684ffe28e85ea8396afc"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.0.0"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IterationControl]]
deps = ["EarlyStopping", "InteractiveUtils"]
git-tree-sha1 = "f61d5d4d0e433b3fab03ca5a1bfa2d7dcbb8094c"
uuid = "b3c1a2ee-3fec-4384-bf48-272ea71de57c"
version = "0.4.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JLSO]]
deps = ["BSON", "CodecZlib", "FilePathsBase", "Memento", "Pkg", "Serialization"]
git-tree-sha1 = "e00feb9d56e9e8518e0d60eef4d1040b282771e2"
uuid = "9da8a3cd-07a3-59c0-a743-3fdc52c30d11"
version = "2.6.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

[[LatinHypercubeSampling]]
deps = ["Random", "StableRNGs", "StatsBase", "Test"]
git-tree-sha1 = "42938ab65e9ed3c3029a8d2c58382ca75bdab243"
uuid = "a5e1c1ea-c99a-51d3-a14d-a9a37257b02d"
version = "1.8.0"

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[LearnBase]]
git-tree-sha1 = "a0d90569edd490b82fdc4dc078ea54a5a800d30a"
uuid = "7f8f8fb0-2700-5f03-b4bd-41f8cfc144b6"
version = "0.4.1"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[LibVPX_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "12ee7e23fa4d18361e7c2cde8f8337d4c3101bc7"
uuid = "dd192d2f-8180-539f-9fb4-cc70b1dcf69a"
version = "1.10.0+0"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "761a393aeccd6aa92ec3515e428c26bf99575b3b"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+0"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["DocStringExtensions", "LinearAlgebra"]
git-tree-sha1 = "7bd5f6565d80b6bf753738d2bc40a5dfea072070"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.2.5"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[LossFunctions]]
deps = ["InteractiveUtils", "LearnBase", "Markdown", "RecipesBase", "StatsBase"]
git-tree-sha1 = "0f057f6ea90a84e73a8ef6eebb4dc7b5c330020f"
uuid = "30fc2ffe-d236-52d8-8643-a9d8f7c094a7"
version = "0.7.2"

[[MLJ]]
deps = ["CategoricalArrays", "ComputationalResources", "Distributed", "Distributions", "LinearAlgebra", "MLJBase", "MLJEnsembles", "MLJIteration", "MLJModels", "MLJOpenML", "MLJSerialization", "MLJTuning", "Pkg", "ProgressMeter", "Random", "ScientificTypes", "Statistics", "StatsBase", "Tables"]
git-tree-sha1 = "7cbd651e39fd3f3aa37e8a4d8beaccfa8d13b1cd"
uuid = "add582a8-e3ab-11e8-2d5e-e98b27df1bc7"
version = "0.16.7"

[[MLJBase]]
deps = ["CategoricalArrays", "ComputationalResources", "Dates", "DelimitedFiles", "Distributed", "Distributions", "InteractiveUtils", "InvertedIndices", "LinearAlgebra", "LossFunctions", "MLJModelInterface", "Missings", "OrderedCollections", "Parameters", "PrettyTables", "ProgressMeter", "Random", "ScientificTypes", "StatisticalTraits", "Statistics", "StatsBase", "Tables"]
git-tree-sha1 = "ad7fdd566e2639c1a189e0d1b2ef43085091c2c7"
uuid = "a7f614a8-145f-11e9-1d2a-a57a1082229d"
version = "0.18.15"

[[MLJClusteringInterface]]
deps = ["Clustering", "Distances", "MLJModelInterface"]
git-tree-sha1 = "f45ba59648f6093f733df1bb6bd9bbbc4d13408e"
uuid = "d354fa79-ed1c-40d4-88ef-b8c7bd1568af"
version = "0.1.4"

[[MLJEnsembles]]
deps = ["CategoricalArrays", "ComputationalResources", "Distributed", "Distributions", "MLJBase", "MLJModelInterface", "ProgressMeter", "Random", "ScientificTypesBase", "StatsBase"]
git-tree-sha1 = "b9ce7bbc4bba927d52c26a3446ac2913777072c8"
uuid = "50ed68f4-41fd-4504-931a-ed422449fee0"
version = "0.1.1"

[[MLJIteration]]
deps = ["IterationControl", "MLJBase", "Random"]
git-tree-sha1 = "f927564f7e295b3205f37186191c82720a3d93a5"
uuid = "614be32b-d00c-4edb-bd02-1eb411ab5e55"
version = "0.3.1"

[[MLJModelInterface]]
deps = ["Random", "ScientificTypesBase", "StatisticalTraits"]
git-tree-sha1 = "54e0aa2c7e79f6f30a7b2f3e096af88de9966b7c"
uuid = "e80e1ace-859a-464e-9ed9-23947d8ae3ea"
version = "1.1.2"

[[MLJModels]]
deps = ["CategoricalArrays", "Dates", "Distances", "Distributions", "InteractiveUtils", "LinearAlgebra", "MLJBase", "MLJModelInterface", "OrderedCollections", "Parameters", "Pkg", "REPL", "Random", "Requires", "ScientificTypes", "Statistics", "StatsBase", "Tables"]
git-tree-sha1 = "a5dab276c8fe1ccd5c585ec1b876e143dbaf1f5c"
uuid = "d491faf4-2d78-11e9-2867-c94bc002c0b7"
version = "0.14.9"

[[MLJMultivariateStatsInterface]]
deps = ["Distances", "LinearAlgebra", "MLJModelInterface", "MultivariateStats", "StatsBase"]
git-tree-sha1 = "0cfc81ff677ea13ed72894992ee9e5f8ae4dbb9d"
uuid = "1b6a4a23-ba22-4f51-9698-8599985d3728"
version = "0.2.2"

[[MLJOpenML]]
deps = ["CSV", "HTTP", "JSON", "Markdown", "ScientificTypes"]
git-tree-sha1 = "a0d6e25ec042ab84505733a62a2b2894fbcf260c"
uuid = "cbea4545-8c96-4583-ad3a-44078d60d369"
version = "1.1.0"

[[MLJScikitLearnInterface]]
deps = ["MLJModelInterface", "PyCall", "ScikitLearn"]
git-tree-sha1 = "1a30a63d77c7dc858ae32e7450bd05ba1e1f85fd"
uuid = "5ae90465-5518-4432-b9d2-8a1def2f0cab"
version = "0.1.10"

[[MLJSerialization]]
deps = ["IterationControl", "JLSO", "MLJBase", "MLJModelInterface"]
git-tree-sha1 = "cd6285f95948fe1047b7d6fd346c172e247c1188"
uuid = "17bed46d-0ab5-4cd4-b792-a5c4b8547c6d"
version = "1.1.2"

[[MLJTuning]]
deps = ["ComputationalResources", "Distributed", "Distributions", "LatinHypercubeSampling", "MLJBase", "ProgressMeter", "Random", "RecipesBase"]
git-tree-sha1 = "1deadc54bf1577a46978d80fe2506d62fa8bf18f"
uuid = "03970b2e-30c4-11ea-3135-d1576263f10f"
version = "0.6.10"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "0fb723cd8c45858c22169b2e42269e53271a6df7"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.7"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Memento]]
deps = ["Dates", "Distributed", "JSON", "Serialization", "Sockets", "Syslogs", "Test", "TimeZones", "UUIDs"]
git-tree-sha1 = "19650888f97362a2ae6c84f0f5f6cda84c30ac38"
uuid = "f28f55f0-a522-5efc-85c2-fe41dfb9b2d9"
version = "1.2.0"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "4ea90bd5d3985ae1f9a908bd4500ae88921c5ce7"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Mocking]]
deps = ["ExprTools"]
git-tree-sha1 = "748f6e1e4de814b101911e64cc12d83a6af66782"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.7.2"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MultivariateStats]]
deps = ["Arpack", "LinearAlgebra", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "8d958ff1854b166003238fe191ec34b9d592860a"
uuid = "6f286f6a-111f-5878-ab1e-185364afe411"
version = "0.8.0"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "16baacfdc8758bc374882566c9187e785e85c2f0"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.9"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "4dd403333bcf0909341cfe57ec115152f937d7d8"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.1"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "2276ac65f1e236e0a6ea70baff3f62ad4c625345"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.2"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "bfd7d8c7fd87f04543810d9cbd3995972236ba1b"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.2"

[[PersistenceDiagramsBase]]
deps = ["Compat", "Tables"]
git-tree-sha1 = "ec6eecbfae1c740621b5d903a69ec10e30f3f4bc"
uuid = "b1ad91c1-539c-4ace-90bd-ea06abc420fa"
version = "0.1.1"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "501c20a63a34ac1d015d5304da0e645f42d91c9f"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.11"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "e39bea10478c6aff5495ab522517fae5134b40e3"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.20.0"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "cde4ce9d6f33219465b55162811d8de8139c0414"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.2.1"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "0d1245a357cc61c8cd61934c07447aa569ff22e6"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.1.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "afadeba63d90ff223a6a48d2009434ecee2ec9e8"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.1"

[[PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "169bb8ea6b1b143c5cf57df6d34d022a7b60c6db"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.92.3"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "12fbe86da16df6679be7521dfb39fbc861e1dc7b"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.1"

[[RData]]
deps = ["CategoricalArrays", "CodecZlib", "DataFrames", "Dates", "FileIO", "Requires", "TimeZones", "Unicode"]
git-tree-sha1 = "19e47a495dfb7240eb44dc6971d660f7e4244a72"
uuid = "df47a6cb-8c03-5eed-afd8-b6050d6c41da"
version = "0.8.3"

[[RDatasets]]
deps = ["CSV", "CodecZlib", "DataFrames", "FileIO", "Printf", "RData", "Reexport"]
git-tree-sha1 = "06d4da8e540edb0314e88235b2e8f0429404fdb7"
uuid = "ce6b1742-4840-55fa-b093-852dadbb1d8b"
version = "0.7.5"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "b3fb709f3c97bfc6e948be68beeecb55a0b340ae"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "2a7a2469ed5d94a98dea0e85c46fa653d76be0cd"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.3.4"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[ScientificTypes]]
deps = ["CategoricalArrays", "ColorTypes", "Dates", "PersistenceDiagramsBase", "PrettyTables", "ScientificTypesBase", "StatisticalTraits", "Tables"]
git-tree-sha1 = "345e33061ad7c49c6e860e42a04c62ecbea3eabf"
uuid = "321657f4-b219-11e9-178b-2701a2544e81"
version = "2.0.0"

[[ScientificTypesBase]]
git-tree-sha1 = "3f7ddb0cf0c3a4cff06d9df6f01135fa5442c99b"
uuid = "30f210dd-8aff-4c5f-94ba-8e64358c1161"
version = "1.0.0"

[[ScikitLearn]]
deps = ["Compat", "Conda", "DataFrames", "Distributed", "IterTools", "LinearAlgebra", "MacroTools", "Parameters", "Printf", "PyCall", "Random", "ScikitLearnBase", "SparseArrays", "StatsBase", "VersionParsing"]
git-tree-sha1 = "ccb822ff4222fcf6ff43bbdbd7b80332690f168e"
uuid = "3646fa90-6ef7-5e7e-9f22-8aca16db6324"
version = "0.6.4"

[[ScikitLearnBase]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "7877e55c1523a4b336b433da39c8e8c08d2f221f"
uuid = "6e75b9c4-186b-50bd-896f-2d2496a4843e"
version = "0.5.0"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "a3a337914a035b2d59c9cbe7f1a38aaba1265b02"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.6"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "LogExpFunctions", "OpenSpecFun_jll"]
git-tree-sha1 = "508822dca004bf62e210609148511ad03ce8f1d8"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.6.0"

[[StableRNGs]]
deps = ["Random", "Test"]
git-tree-sha1 = "3be7d49667040add7ee151fefaf1f8c04c8c8276"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.0"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3fedeffc02e47d6e3eb479150c8e5cd8f15a77a0"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.10"

[[StatisticalTraits]]
deps = ["ScientificTypesBase"]
git-tree-sha1 = "93f7326079b73910e5a81f8848e7a633f99a2946"
uuid = "64bff920-2084-43da-a3e6-9bb72801c0c9"
version = "2.0.1"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "fed1ec1e65749c4d96fc20dd13bea72b55457e62"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.9"

[[StatsFuns]]
deps = ["LogExpFunctions", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "30cd8c360c54081f806b1ee14d2eecbef3c04c49"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.8"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "000e168f5cc9aded17b6999a560b7c11dda69095"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.0"

[[StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "e36adc471280e8b346ea24c5c87ba0571204be7a"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.7.2"

[[SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[Syslogs]]
deps = ["Printf", "Sockets"]
git-tree-sha1 = "46badfcc7c6e74535cc7d833a91f4ac4f805f86d"
uuid = "cea106d9-e007-5e6c-ad93-58fe2094e9c4"
version = "0.3.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "d0c690d37c73aeb5ca063056283fde5585a41710"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.5.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TimeZones]]
deps = ["Dates", "Future", "LazyArtifacts", "Mocking", "Pkg", "Printf", "RecipesBase", "Serialization", "Unicode"]
git-tree-sha1 = "81753f400872e5074768c9a77d4c44e70d409ef0"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.5.6"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "7c53c35547de1c5b9d46a4797cf6d8253807108c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.5"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UrlDownload]]
deps = ["HTTP", "ProgressMeter"]
git-tree-sha1 = "05f86730c7a53c9da603bd506a4fc9ad0851171c"
uuid = "856ac37a-3032-4c1c-9122-f86d88358c8b"
version = "1.0.0"

[[VersionParsing]]
git-tree-sha1 = "80229be1f670524750d905f8fc8148e5a8c4537f"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.0"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "acc685bcf777b2202a904cdcb49ad34c2fa1880c"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.14.0+4"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7a5780a0d9c6864184b3a2eeeb833a0c871f00ab"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "0.1.6+4"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d713c1ce4deac133e3334ee12f4adff07f81778f"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2020.7.14+2"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "487da2f8f2f0c8ee0e83f39d13037d6bbf0a45ab"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.0.0+3"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─6b4a8fd1-60f5-4760-a453-86a75a201a5f
# ╠═b107d7f9-90c3-4a9f-9b55-0e1dc323ee56
# ╟─ef6340c4-f4f7-11eb-30f9-599dcebb98be
# ╟─d24051dc-5efa-48c8-b65b-c756ba43b864
# ╟─b1a67905-09f3-41aa-9a87-362d051fc69f
# ╠═ad6469ef-68a5-4819-bf98-85d06d37b960
# ╟─6069ba43-4a4d-4c59-a465-098385eb6e80
# ╠═a3c21e5d-a030-4cf3-aed3-e7100a885d37
# ╟─6baca64d-6dcb-44d7-b03d-69c0322631fe
# ╠═f31b4062-c763-4647-84ef-b3db25406fc8
# ╠═e32d05c9-5896-4435-8f4c-15f887d6b256
# ╠═bf9cd655-eafe-41d2-ab06-f0a53cde9455
# ╠═f653a134-d37a-4959-bf81-40c2d20d4a87
# ╟─7ea3c9a3-a369-4ee9-908d-ed8b7d1ae3cb
# ╟─36b56e8b-dde9-4fcb-a3f9-a93fb3101cdf
# ╟─fcd2724d-aa29-4e7b-8d39-818463e7ceb5
# ╟─6165b59f-2c9c-44d8-b914-a307f99a5a48
# ╟─c36c1741-21fe-4758-a82d-dbf3439830cd
# ╟─51e1ee64-9541-4ee2-9499-748811dacac9
# ╟─e2da47f5-d1bf-4060-8113-5fa2a7de56ff
# ╟─4ece0521-051e-475c-bec9-10f38beb009d
# ╟─236f6a7d-86a5-4bbc-a0d8-49f06e1714bf
# ╟─66e15e9e-f283-487d-8e73-ae5ec23edb54
# ╟─72e80a6f-8d30-4a85-a154-d2fbfc653421
# ╟─0b5f90c0-7b51-484a-a023-0f533167bf7b
# ╟─720f5fe8-0616-4480-be24-b81764c4361f
# ╟─7cbe09ae-5dcc-4c42-b824-bd401ed7f18b
# ╟─6b8336a6-fac6-4042-84e5-2cf4a0bf83b7
# ╟─9d3653a3-a617-4694-bc87-72d2606245c9
# ╟─7f43e8c7-7ac8-4aa2-acae-87e0c3814da1
# ╟─ffb89c6b-cdd1-4a64-8ad7-b512373dfa1a
# ╟─acf3fc88-d7cd-4bf9-ba4b-dd166984d7aa
# ╠═6cab610d-e713-4b08-8a5b-5eab8820732f
# ╟─92056bbd-8dde-4b38-8780-02e248c6cfd3
# ╠═fdbd56bb-4a02-436a-9ee3-552b373547c7
# ╠═ccd0662b-455d-453f-be8c-d0a998910a7f
# ╠═97d67ce7-cfb5-47fd-9ea3-272ded84e9fd
# ╠═21f1d7dd-a865-4e8b-ab03-cd81b91f5f29
# ╠═6dc1461e-ad0e-4020-825a-a696de245ca8
# ╟─7dd8b809-0870-4945-97d2-2a655d0fcc63
# ╠═fd76cca7-48c0-474a-b826-3be1d7c54c14
# ╠═a5f4bad2-2919-4241-9178-e944e42d69a5
# ╠═b2fbf649-32b6-4dd8-894c-9ca2e2fa1e9c
# ╠═8b1d8c99-7fa1-4054-ae7d-52b01a97b0b3
# ╠═76dbe6fa-7426-4ef1-874a-7463602e6c7c
# ╠═bbae294a-01f4-47a3-9cfb-99e8e0978796
# ╠═064bea34-0890-4d27-8c5c-63d7f66e10ac
# ╠═35fef6ab-eaf7-4e39-8424-1e77ef29a4f1
# ╟─e13caf23-fe50-456a-a7f0-1df74580e6c6
# ╠═2d0dd71a-d577-4d56-bf42-31ce47d0bebe
# ╟─41424723-6627-4462-9e31-36ef20933230
# ╠═816b06b0-82b9-45ce-8cbb-22061363c936
# ╟─8784abe2-688d-401f-bce0-0ad02b4b7e76
# ╠═efca9fcb-2378-49ad-b82b-a528674944da
# ╟─0cd53836-8853-46da-86f4-2a11bee5bed8
# ╠═0eb90afd-4e1c-4bf2-b8a4-b7241ed7d042
# ╠═7c787df1-3f7e-4057-91e2-db9b0a42b11f
# ╠═e426364d-dc2d-45a7-8e3f-a7d63424433e
# ╠═d96f14f8-dc5c-4adf-899e-5e9497e9bba1
# ╠═79bf46e7-96c3-488d-9ced-e35798d6ed09
# ╠═d6b8b7f2-2eff-4201-b53f-c10848942f9b
# ╠═dfe4c5c0-d51d-4aae-abe7-604619a16e17
# ╠═22b933e1-9763-4922-b72d-a9f59477aaaf
# ╠═4e6a6592-72dd-4e59-9cb8-e4aa75b82c3f
# ╠═dc16d155-379f-4d2a-8e01-825c384c117c
# ╠═f413974c-b210-4d9e-bc3f-c5b0d3f28e69
# ╠═5f96e230-7e61-4a1e-962f-8ca5f0d0be60
# ╠═466e107d-1c7a-4a15-a08b-c9120b84a917
# ╠═b7935362-ac6b-47a8-9106-cc2beaac70a8
# ╠═8d0b9978-b04a-436d-bf13-6946b043e48d
# ╠═6fc301b3-18f2-44e8-91d2-268e10c3a0e6
# ╠═38452d24-76bd-4d75-9f9b-39d5d0d2dae8
# ╠═68733a99-4d7e-4256-a168-2032de50ab80
# ╠═e0968f67-1995-45d1-81e5-f6fb875312d5
# ╠═e51c2334-fd90-4847-9877-05ed2390d45a
# ╠═432e6d0a-7671-4b3c-a8c4-0508a418cee7
# ╠═7e693874-9155-4c2f-8b4c-3543454fbb56
# ╠═7cc17b78-8f2a-49de-a7a6-99ab6d89b0e0
# ╟─ab72fb5f-90ac-446c-88d6-938852f3816e
# ╠═9c851f5a-4c8f-4388-86a1-ff6a3d83c8fe
# ╠═6f6459c8-8242-4340-a588-0512eff5d5c3
# ╠═db565011-1563-41cc-84d0-e14c8237aa8a
# ╠═f518b097-a6f4-4bf5-ba36-0088f5fc6b94
# ╠═98693a39-71de-4e60-bf66-42e30618e254
# ╠═f1ea0441-6910-4704-906a-3e6cf05b4105
# ╠═a0d7c872-8c54-4eed-9a01-1ca92c2d6a28
# ╠═65729744-b221-488d-b1ad-85981489916c
# ╟─c0b3f6a7-341c-435a-b528-3a190f5c500c
# ╟─185015b8-d252-4beb-96f0-4d2483f79344
# ╟─e9fcbd2a-6c9b-4e07-bcae-b990ebc1a3da
# ╟─042c51dc-80d8-4c19-9c87-4e3e83de5e19
# ╟─eda00801-1169-4f24-ad20-56585835002a
# ╠═7ef54d4e-a43d-4b37-8b2e-021d9a5ea99f
# ╟─6f396986-414e-4a2a-a1b4-fb097e1759df
# ╠═37aef421-934c-4d0e-a78e-7da96f8b3edc
# ╟─6d09d7e5-57d8-4619-b409-3fea32f427a4
# ╠═9d3e1566-7dbf-4cdc-9a79-796b1bb9b961
# ╟─eef96558-9a43-447f-a52d-a44636e5015d
# ╠═9ead4d07-7586-480a-a24a-7eb866d4b130
# ╟─a75720f2-9d56-4e1e-8fdd-e4d248871367
# ╠═b33417a7-6263-4954-a923-c6716c61f2bf
# ╠═0eea30b5-7729-40c8-aadf-8017fa3e740d
# ╟─9c3f3c32-ec53-46db-8b06-a446d3871175
# ╠═35cfad5a-cc8b-4c14-81e6-808ec0f67008
# ╟─6c8ee67c-66ee-480f-9154-01cf26583215
# ╠═2d5b8029-d913-43ff-bab4-3319c5681e71
# ╟─7959d6c7-5b4a-4865-8fd1-3934cef54755
# ╠═f7fd7736-f30d-40ea-af14-c422a31fbd77
# ╟─1cb799aa-dfe3-4b24-baf1-a2ad9c68c6d3
# ╠═1274b8b5-8aa2-4b83-8170-fac74bebb946
# ╟─73691cc0-f43d-46ab-952b-d877a16de744
# ╠═0bff6458-b298-4ea2-b1f8-01b00ce185b5
# ╟─f48cce8b-6b4d-47e7-9827-26cd2a847a38
# ╠═565cb36b-96a6-4a05-b1b0-5ab8b95478d5
# ╠═8f44f8fa-53f3-490d-8835-0bb32cbc23d2
# ╟─610fa1c7-8c0c-4608-bc36-f7c8aa3f0f3b
# ╟─b211535c-fd8b-4f84-b88b-2ea2286a58f4
# ╠═45bb9873-5eac-4e62-a041-0c4f47975462
# ╠═728d6e97-9e60-4e42-b9ad-39c1a2e32808
# ╠═43594135-f686-4649-8f03-c87c7294315c
# ╠═60751597-b4b6-46e4-b2fe-a18de27301ef
# ╟─131dc691-87b0-46f6-ba6e-1a421b491f7d
# ╠═76e7ce0e-7c62-45e2-a02e-2f2283c56c3b
# ╠═7a981cc3-1a22-407c-aafe-69f170c64062
# ╠═b15087d4-51d5-4903-8064-2f7cfac3f3c2
# ╠═51a697bf-c7ce-4fa0-864c-57f93eb41d92
# ╠═9ecc20b5-538e-415b-80c3-c4fad54b0ccf
# ╠═95be3be8-af10-4286-97b0-5366792ad349
# ╠═a0ef1009-87bb-4f04-86f8-cf61f69577a1
# ╟─a506982f-6ab8-4f90-9974-8ccbc5e15d35
# ╟─353d48a4-20ea-4167-bf93-c517e3488220
# ╠═65e9979c-ec08-4093-9a35-3b872da2dee1
# ╠═c0385ff2-3c5a-4f01-acb8-a036cd5c85ff
# ╠═8934fed8-f0ba-4635-9d96-74b9751c8b95
# ╠═26fac042-79b9-46d7-ade0-dd893fd4280e
# ╠═59160fa4-83dc-4d23-8759-ce8ab979b7b9
# ╠═1645c96b-84d0-43d2-b57f-09adf5d04803
# ╠═04c66bc0-c607-46c2-8625-042f50e0a32b
# ╠═3c813b9e-1859-47b5-911f-06b36dc9b5c2
# ╠═b4aff21d-885a-44c4-abf0-a686fa44ae7a
# ╠═7787818f-b621-4039-94cf-91059e45d200
# ╠═cfc8f87e-3502-4115-9da4-c137acd880cb
# ╠═6c050cbf-ce13-4fa1-a992-2261702369f7
# ╠═483537db-0253-4083-86b4-9678f66e137e
# ╠═525d3cd2-f231-4138-b6be-c35d8a317bbc
# ╠═02d2647b-951a-41ad-9a50-767fdbdf54ec
# ╠═a22e4fc2-5ae3-4e64-8589-9c2ce68b01a2
# ╠═8b9e878d-6f32-48d7-abeb-005bbcd14549
# ╠═8b6374e9-47c2-4417-ae11-1ff909f9e5e1
# ╠═7ddff453-bb4b-4086-9d29-1f37ab99643a
# ╟─eee433ec-6493-48d6-bcd0-e0e3b9c34bdc
# ╠═20ecc9ce-db93-4733-8fc1-24e058c84fb5
# ╠═3e6d49ab-53ea-4d74-9478-4e3b48798977
# ╠═0d9281c5-3560-4a2c-9cec-21d16d4af695
# ╠═11c5a4f7-ff46-4298-a05d-c75f48b5c483
# ╠═98483c7e-7cb0-42a6-b52d-da7d4ee43cce
# ╠═37483f0a-b23e-4f26-a592-8c539b47eb0f
# ╠═7e1d9ecc-be3a-418b-bcfc-e8268d1e4512
# ╠═46cd4e9c-e9f5-4cd6-a216-7ddb185ac35c
# ╠═cd79d6f8-eeae-484d-af38-3b52574c030f
# ╠═33117a1d-ac85-44db-b75f-bf56d1d39f4f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
