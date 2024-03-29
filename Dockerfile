FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.csproj ./
#COPY NuGet.config ./
RUN dotnet restore

# copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out


# build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 as runtime
WORKDIR /app
COPY --from=build-env /app/out ./

EXPOSE 5000/tcp
ENV ASPNETCORE_URLS http://*:5000
ENTRYPOINT ["dotnet", "HelloWorld.dll"]