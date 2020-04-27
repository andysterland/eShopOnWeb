using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.IO;
using Microsoft.AspNetCore.Hosting;

namespace Microsoft.eShopWeb.Web.Controllers.Api
{
    [Route("api/[controller]")]
    [ApiController]
    public class ImageController : ControllerBase
    {
        private readonly IWebHostEnvironment _env;
        private byte[] _imageNotFoundBytes;
        private static Dictionary<string, byte[]> Images = new Dictionary<string, byte[]>();
        private const string _imageBasePath = "images/products/";
        private const string _imageExtension = ".png";
        private const string _imageMimeType = "image/png";

        public ImageController(IWebHostEnvironment env)
        {
            _env = env;

            string imagePath = Path.Combine(_env.WebRootPath, _imageBasePath, "NotFoundImage.png");
            byte[] _imageNotFoundBytes = System.IO.File.ReadAllBytes(imagePath);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetImage(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return File(_imageNotFoundBytes, _imageMimeType);
            }

            if(!Images.ContainsKey(id))
            {
                string imagePath = Path.Combine(_env.WebRootPath, _imageBasePath, id);
                imagePath = Path.ChangeExtension(imagePath, _imageExtension);
                if(!System.IO.File.Exists(imagePath))
                {
                    // Uh oh, no such image.
                    return File(_imageNotFoundBytes, _imageMimeType);
                }
                byte[] imageBytes = System.IO.File.ReadAllBytes(imagePath);

                Images.Add(id, imageBytes);
            }

            return File(Images[id], _imageMimeType);
        }
    }
}
