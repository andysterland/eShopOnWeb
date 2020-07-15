devinit init
pushd src\web\Infrastructure\
dotnet ef database update -c catalogcontext -p Infrastructure.csproj -s Web.csproj
dotnet ef database update -c appidentitydbcontext -p Infrastructure.csproj -s Web.csproj
popd