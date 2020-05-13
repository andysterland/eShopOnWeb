# Microsoft eShopOnWeb ASP.NET Core Reference Application


## Getting started

1. Use Visual Studio Online to [create an environment](https://online.visualstudio.com/environments/new?name=eShopOnWeb&repo=andysterland/eShopOnWeb&instanceType=premiumWindows)
1. Follow the setup instructions below
1. Hit F5!

### First time setup 

1. Open a command prompt in the Web folder and execute the following commands:

```
dotnet restore
dotnet tool restore
dotnet ef database update -c catalogcontext -p ../Infrastructure/Infrastructure.csproj -s Web.csproj
dotnet ef database update -c appidentitydbcontext -p ../Infrastructure/Infrastructure.csproj -s Web.csproj
```

These commands will create two separate databases, one for the store's catalog data and shopping cart information, and one for the app's user credentials and identity data.
