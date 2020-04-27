using Microsoft.eShopWeb.ApplicationCore.Entities;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Microsoft.eShopWeb.Infrastructure.Data
{
    public class CatalogContextSeed
    {
        public static async Task SeedAsync(CatalogContext catalogContext,
            ILoggerFactory loggerFactory, int? retry = 0)
        {
            int retryForAvailability = retry.Value;
            try
            {
                // TODO: Only run this if using a real database
                // context.Database.Migrate();

                if (!catalogContext.CatalogBrands.Any())
                {
                    catalogContext.CatalogBrands.AddRange(
                        GetPreconfiguredCatalogBrands());

                    await catalogContext.SaveChangesAsync();
                }

                if (!catalogContext.CatalogTypes.Any())
                {
                    catalogContext.CatalogTypes.AddRange(
                        GetPreconfiguredCatalogTypes());

                    await catalogContext.SaveChangesAsync();
                }

                if (!catalogContext.CatalogItems.Any())
                {
                    catalogContext.CatalogItems.AddRange(
                        GetPreconfiguredItems());

                    await catalogContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                if (retryForAvailability < 10)
                {
                    retryForAvailability++;
                    var log = loggerFactory.CreateLogger<CatalogContextSeed>();
                    log.LogError(ex.Message);
                    await SeedAsync(catalogContext, loggerFactory, retryForAvailability);
                }
                throw;
            }
        }

        static IEnumerable<CatalogBrand> GetPreconfiguredCatalogBrands()
        {
            return new List<CatalogBrand>()
            {
                new CatalogBrand("Azure"),
                new CatalogBrand(".NET"),
                new CatalogBrand("Visual Studio"),
                new CatalogBrand("SQL Server"),
                new CatalogBrand("Other")
            };
        }

        static IEnumerable<CatalogType> GetPreconfiguredCatalogTypes()
        {
            return new List<CatalogType>()
            {
                new CatalogType("Mug"),
                new CatalogType("T-Shirt"),
                new CatalogType("Sheet"),
                new CatalogType("USB Memory Stick")
            };
        }

        static IEnumerable<CatalogItem> GetPreconfiguredItems()
        {
            return new List<CatalogItem>()
            {
                new CatalogItem(2,2, ".NET Bot Black Sweatshirt", ".NET Bot Black Sweatshirt", 19.5M,  "/api/image/3ac72f74-7339-4ac7-8284-9ae64ce03f51"),
                new CatalogItem(1,2, ".NET Black & White Mug", ".NET Black & White Mug", 8.50M, "/api/image/06e8e5ee-8e30-4c27-8a04-1a29214ed7b6"),
                new CatalogItem(2,5, "Prism White T-Shirt", "Prism White T-Shirt", 12,  "/api/image/3548a995-4f90-4b53-b33a-9978e4a5a50a"),
                new CatalogItem(2,2, ".NET Foundation Sweatshirt", ".NET Foundation Sweatshirt", 12, "/api/image/39944eab-38ac-427f-9b6e-7b24e99dc585"),
                new CatalogItem(3,5, "Roslyn Red Sheet", "Roslyn Red Sheet", 8.5M, "/api/image/4ee49ac8-d6a5-47a7-96c3-fba7929c8ea2"),
                new CatalogItem(2,2, ".NET Blue Sweatshirt", ".NET Blue Sweatshirt", 12, "/api/image/019dd64f-f006-4883-97de-2e67ef18ffaa"),
                new CatalogItem(2,5, "Roslyn Red T-Shirt", "Roslyn Red T-Shirt",  12, "/api/image/e1ef0ff0-428e-46d3-9c3a-aaf9121d2e17"),
                new CatalogItem(2,5, "Kudu Purple Sweatshirt", "Kudu Purple Sweatshirt", 8.5M, "/api/image/a650d9cd-b61a-4c08-881f-f03c3ca0cfa2"),
                new CatalogItem(1,5, "Cup<T> White Mug", "Cup<T> White Mug", 12, "/api/image/eaa8d2f7-ae7b-4fd4-a03c-7d252624025e"),
                new CatalogItem(3,2, ".NET Foundation Sheet", ".NET Foundation Sheet", 12, "/api/image/9a992c9d-3e13-4847-8d60-b1b64faaeafb"),
                new CatalogItem(3,2, "Cup<T> Sheet", "Cup<T> Sheet", 8.5M, "/api/image/29b5ca7e-39d6-49eb-a868-b77be0b9851f"),
                new CatalogItem(2,5, "Prism White TShirt", "Prism White TShirt", 12, "/api/image/9ddf85f3-39b1-455c-8e9a-394cfcad82f0")
            };
        }
    }
}
