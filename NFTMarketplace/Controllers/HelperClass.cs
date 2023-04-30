using System.Security.Cryptography;
using System.Text;
using System.Net.Http;

namespace TestReverseEngineer.Controllers
{
    public class HelperClass
    {
        public static string GetDigitalSignature(string imgURL)
        {
            return GetHashString(GetBase64StringFromImageUrl(imgURL));
        }

        public static string newGetDigitalSignature(string imgPath)
        {
            return GetHashString(GetB64StringFromFile(imgPath));
        }



        public static string GetBase64StringFromImageUrl(string imageUrl)
        {
            using (var httpClient = new HttpClient())
            {
                var response = httpClient.GetAsync(imageUrl).Result;
                if (response.IsSuccessStatusCode)
                {
                    var imageBytes = response.Content.ReadAsByteArrayAsync().Result;
                    var base64String = Convert.ToBase64String(imageBytes);
                    return base64String;
                }
                else
                {
                    throw new Exception($"Failed to retrieve image from URL: {imageUrl}. Status code: {response.StatusCode}");
                }
            }
        }

        public static string GetB64StringFromFile(string filePath)
        {
            Byte[] bytes = File.ReadAllBytes(filePath);
            return Convert.ToBase64String(bytes);
        }

        public static string GetHashString(string inputString)
        {
            StringBuilder sb = new StringBuilder();
            foreach (byte b in GetHash(inputString))
                sb.Append(b.ToString("X2"));

            return sb.ToString();
        }
        public static byte[] GetHash(string inputString)
        {
            using (HashAlgorithm algorithm = SHA256.Create())
                return algorithm.ComputeHash(Encoding.UTF8.GetBytes(inputString));
        }
    }
}
