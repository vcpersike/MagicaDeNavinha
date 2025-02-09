# Etapa 1: Construção
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY MagicaDeNavinha.Web/MagicaDeNavinha.Web.csproj ./MagicaDeNavinha.Web/
COPY MagicaDeNavinha.Shared/MagicaDeNavinha.Shared.csproj ./MagicaDeNavinha.Shared/
RUN dotnet restore "MagicaDeNavinha.Web/MagicaDeNavinha.Web.csproj"
COPY . .
RUN dotnet build "MagicaDeNavinha.Web/MagicaDeNavinha.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MagicaDeNavinha.Web/MagicaDeNavinha.Web.csproj" -c Release -o /app/publish
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MagicaDeNavinha.Web.dll"]