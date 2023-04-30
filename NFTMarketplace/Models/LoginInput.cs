using System.ComponentModel.DataAnnotations;
namespace TestReverseEngineer.Models
{
    public class LoginInput
    {
        [Key]
        //[RegularExpression(@"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$", ErrorMessage = "Please use a valid email for username")]
        [MaxLength(50)]
        public string? UserName { get; set; }

        [Required(ErrorMessage = "Please enter a password")]
        [MaxLength(50)]
        [UIHint("password")]
        [Display(Name = "Password")]
        public string? UserPassword { get; set; }

        public string? ReturnURL { get; set; }

    }
}
