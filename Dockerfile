FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["newapi.csproj", "./"]
RUN dotnet restore "./newapi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "newapi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "newapi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "newapi.dll"]
