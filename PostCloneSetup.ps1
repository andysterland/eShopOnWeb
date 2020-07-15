devinit init
dotnet ef database update -c catalogcontext -p src/Web/Infrastructure/Infrastructure.csproj -s Web.csproj
dotnet ef database update -c appidentitydbcontext -p src/Web/Infrastructure/Infrastructure.csproj -s Web.csproj