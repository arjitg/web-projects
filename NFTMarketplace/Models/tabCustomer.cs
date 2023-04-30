﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace TestReverseEngineer.Models
{
    [Table("tabCustomer")]
    public partial class tabCustomer
    {
        public tabCustomer()
        {
            tabItems = new HashSet<tabItem>();
            tabOrders = new HashSet<tabOrder>();
            tabReviews = new HashSet<tabReview>();
        }

        [Key]
        public int CustomerID { get; set; }
        [StringLength(50)]
        [Unicode(false)]
        public string Type { get; set; }
        [StringLength(20)]
        [Unicode(false)]
        public string CardNumber { get; set; }
        [StringLength(50)]
        [Unicode(false)]
        public string BillingAddress { get; set; }
        [StringLength(50)]
        [Unicode(false)]
        public string CardName { get; set; }
        [Column(TypeName = "date")]
        public DateTime? CardValidity { get; set; }
        [StringLength(3)]
        [Unicode(false)]
        public string CardCvv { get; set; }
        [StringLength(10)]
        [Unicode(false)]
        public string UserName { get; set; }
        [StringLength(500)]
        [Unicode(false)]
        public string UserPassword { get; set; }
        [StringLength(10)]
        public string Role { get; set; }
        [StringLength(50)]
        [Unicode(false)]
        [RegularExpression(@"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$", ErrorMessage = "Please use a valid email")]
        public string Email { get; set; }
        [Column(TypeName = "date")]
        public DateTime? DoB { get; set; }
        [StringLength(50)]
        [Unicode(false)]
        [RegularExpression(@"^[a-zA-Z]+\s[a-zA-Z]+$", ErrorMessage = "First and Last Name; Upper and lower case letters")]
        public string FullName { get; set; }

        [InverseProperty("CreatedByNavigation")]
        public virtual ICollection<tabItem> tabItems { get; set; }
        [InverseProperty("CustomerFKNavigation")]
        public virtual ICollection<tabOrder> tabOrders { get; set; }
        [InverseProperty("ReviewByNavigation")]
        public virtual ICollection<tabReview> tabReviews { get; set; }
    }
}