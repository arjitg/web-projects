// These extension methods enable session state to set and get serializable objects
// https://learn.microsoft.com/en-us/aspnet/core/fundamentals/app-state?view=aspnetcore-6.0

// add this namespace

using Newtonsoft.Json;

namespace TestReverseEngineer.Models
{
    public static class SessionExtensions
    {
        public static void SetObject<T>(this ISession session, string key, T value)
        {
            session.SetString(key, JsonConvert.SerializeObject(value));
        }

        public static T? GetObject<T>(this ISession session, string key)
        {
            var value = session.GetString(key);

            return (value == null) ? default : JsonConvert.DeserializeObject<T>(value);
        }
    }
}
