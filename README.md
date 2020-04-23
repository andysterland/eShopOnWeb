![Build Status](https://github.com/dotnet-architecture/eShopOnWeb/workflows/eShopOnWeb%20Build%20and%20Test/badge.svg)



# Microsoft eShopOnWeb ASP.NET Core Reference Application

Sample ASP.NET Core reference application, powered by Microsoft, demonstrating a single-process (monolithic) application architecture and deployment model. If you're new to .NET development, read the [Getting Started for Beginners](https://github.com/dotnet-architecture/eShopOnWeb/wiki/Getting-Started-for-Beginners) guide.

A list of Frequently Asked Questions about this repository can be found [here](https://github.com/dotnet-architecture/eShopOnWeb/wiki/Frequently-Asked-Questions). 

This reference application is meant to support the free .PDF download ebook: [Architecting Modern Web Applications with ASP.NET Core and Azure](https://aka.ms/webappebook), updated to **ASP.NET Core 3.1**. [Also available in ePub/mobi formats](https://dotnet.microsoft.com/learn/web/aspnet-architecture).

You can also read the book in online pages at the .NET docs here: 
https://docs.microsoft.com/en-us/dotnet/standard/modern-web-apps-azure-architecture/

[<img src="https://user-images.githubusercontent.com/782127/74948402-48512c80-53ca-11ea-948a-58d037440888.png" height="300" />](https://dotnet.microsoft.com/learn/web/aspnet-architecture)

The **eShopOnWeb** sample is related to the [eShopOnContainers](https://github.com/dotnet/eShopOnContainers) sample application which, in that case, focuses on a microservices/containers-based application architecture. However, **eShopOnWeb** is much simpler in regards to its current functionality and focuses on traditional Web Application Development with a single deployment.

The goal for this sample is to demonstrate some of the principles and patterns described in the [eBook](https://aka.ms/webappebook). It is not meant to be an eCommerce reference application, and as such it does not implement many features that would be obvious and/or essential to a real eCommerce application.

## Getting started

1. Use Visual Studio Online to [Create Environment](https://online.dev.core.vsengsaas.visualstudio.com/environments/new?name=eShopOnWeb&repo=andysterland/eShopOnWeb&instanceType=premiumWindows)
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
