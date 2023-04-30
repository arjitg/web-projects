#nullable disable
using Newtonsoft.Json;

namespace TestReverseEngineer.Models
{
    public class Cart
    {
        [JsonProperty]
        private List<CartItem> cartItems = new();

        const int MaxQuantity = 1;

        public CartItem? GetCartItem(int? itemID)
        {
            CartItem? aItem = cartItems.Where(p => p.Item?.ItemID == itemID).FirstOrDefault();

            return aItem;
        }

        public bool hasItem(int itemID)
        {
            return GetCartItem(itemID) != null;
        }

        public void AddItem(tabItem aProduct)
        {
            CartItem? aItem = GetCartItem(aProduct.ItemID);

            // If it is a new item
            if (aItem == null)
            {
                cartItems.Add(new CartItem { 
                    Item = aProduct, 
                    FinalAmount = (double)aProduct.UnitPrice * 1.2
                });;
            }

            else
            {
                if (aItem.Quantity < MaxQuantity)
                {
                    aItem.Quantity += 1;
                }
            }
        }

        public void UpdateItem(int? itemID, int quantity)
        {
            CartItem? aItem = GetCartItem(itemID);

            if (aItem != null)
            {
                aItem.Quantity = (quantity <= MaxQuantity) ? quantity : MaxQuantity;
            }
        }

        public void RemoveItem(int? itemID)
        {
            cartItems.RemoveAll(r => r.Item?.ItemID == itemID);
        }

        public void ClearCart()
        {
            cartItems.Clear();
        }

        public double? ComputeOrderTotal()
        {
            return cartItems.Sum(s => s.FinalAmount);
        }

        public IEnumerable<CartItem> CartItems()
        {
            return cartItems;
        }

    }
}
