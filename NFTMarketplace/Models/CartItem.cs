using System.ComponentModel.DataAnnotations;

namespace TestReverseEngineer.Models
{
    public class CartItem
    {
        public tabItem? Item { get; set; }

        [Required(ErrorMessage = "Please enter quantity")]
        [Range(1, 20, ErrorMessage = "Please enter an amount between 1 and 20")]
        public int Quantity { get; set; }
        public double FinalAmount { get; set; }
    }
}
