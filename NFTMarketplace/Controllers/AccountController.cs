using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using TestReverseEngineer.Models;

using aBCryptNet = BCrypt.Net.BCrypt;
using Microsoft.AspNetCore.Authentication.Cookies;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;

namespace TestReverseEngineer.Controllers
{
    public class AccountController : Controller
    {
        private readonly Team108DBContext _context;

        public AccountController(Team108DBContext context)
        {
            _context = context;
        }

        // GET: Account/MyAccount/5
        [Authorize]
        public async Task<IActionResult> MyAccount(int? id)
        {
            if (id == null || _context.tabCustomers == null)
            {
                return NotFound();
            }

            var tabCustomer = await _context.tabCustomers.FirstOrDefaultAsync(m => m.CustomerID == id);
            if (tabCustomer == null)
            {
                return NotFound();
            }

            return View(tabCustomer);
        }

        public IActionResult Login(string returnUrl)
        {
            returnUrl = String.IsNullOrEmpty(returnUrl) ? "~/Item" : returnUrl;
            return View(new LoginInput { ReturnURL = returnUrl });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login([Bind("UserName,UserPassword,ReturnURL")] LoginInput loginInput)
        {
            if (ModelState.IsValid)
            {
                var aUser = await _context.tabCustomers.FirstOrDefaultAsync(u => u.UserName == loginInput.UserName);

                if (aUser != null && aBCryptNet.Verify(loginInput.UserPassword, aUser.UserPassword))
                {
                    var claims = new List<Claim>
                    {
                        new Claim(ClaimTypes.Name, aUser.FullName),
                        new Claim(ClaimTypes.Sid, aUser.CustomerID.ToString()),
                        new Claim(ClaimTypes.Role, aUser.Role)
                    };

                    var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    var principal = new ClaimsPrincipal(identity);
                    await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal);

                    HttpContext.Session.SetString("Sid", aUser.CustomerID.ToString());

                    return Redirect(loginInput?.ReturnURL ?? "~/");
                }
                else
                {
                    ViewData["failure"] = "Invalid credentials";
                }
            }
            return View(loginInput);
        }

        // GET: Sign up for an Account
        public IActionResult SignUp()
        {
            return View();
        }

        // POST: Account/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SignUp([Bind("Email,DoB,SignupDate,CardCvv,CardName,CardNumber,BillingAddress,CardValidity,UserName,UserPassword,FullName,Role")] tabCustomer tabCustomer)
        {
            if (ModelState.IsValid)
            {
                var users = await _context.tabCustomers.FirstOrDefaultAsync(x => x.UserName == tabCustomer.UserName);

                if (users == null)
                {
                    tabCustomer.UserPassword = aBCryptNet.HashPassword(tabCustomer.UserPassword);
                    _context.Add(tabCustomer);
                    await _context.SaveChangesAsync();
                    TempData["success"] = "Account created";

                    return RedirectToAction(nameof(Login));
                }
                else
                {
                    ViewData["message"] = "Choose a different username";
                }                
            }
            return View(tabCustomer);
        }

        // GET: Account/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null || _context.tabCustomers == null)
            {
                return RedirectToAction("Index", "Item");
            }

            var tabUser = await _context.tabCustomers.FindAsync(id);

            if (tabUser == null)
            {
                return RedirectToAction("Index", "Item");
            }
            return View(tabUser);
        }

        // POST: Account/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [Authorize]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("CustomerID,FullName,Email,CardNumber,BillingAddress,CardName,CardValidity,CardCvv")] tabCustomer tabCustomer)
        {
            if (id != tabCustomer.CustomerID)
            {
                return RedirectToAction("Index", "Item");
            }

            var dbCustomer = await _context.tabCustomers.FirstOrDefaultAsync(m => m.CustomerID == id);
            if (dbCustomer == null)
            {
                return RedirectToAction("Index", "Item");
            }

            if (ModelState.IsValid)
            {
                try
                {
                    dbCustomer.FullName = tabCustomer.FullName;
                    dbCustomer.Email = tabCustomer.Email;
                    dbCustomer.CardNumber = tabCustomer.CardNumber;
                    dbCustomer.BillingAddress = tabCustomer.BillingAddress;
                    dbCustomer.CardName = tabCustomer.CardName;
                    dbCustomer.CardValidity = tabCustomer.CardValidity;
                    dbCustomer.CardCvv = tabCustomer.CardCvv;

                    _context.Update(dbCustomer);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!tabCustomerExists(tabCustomer.CustomerID))
                    {
                        ViewData["failure"] = "Concurrency error in updating customer";
                        return RedirectToAction("Index", "Item");
                    }
                    else
                    {
                        throw;
                    }
                }
                //logout after update
                //await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
                ViewData["success"] = "Account Updated";
                return RedirectToAction("Index", "Item");
            }
            return RedirectToAction("Index", "Item");
        }


        // method to log user out and redirect to Home View
        public async Task<RedirectToActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Index", "Home");
        }

        private bool tabCustomerExists(int id)
        {
          return (_context.tabCustomers?.Any(e => e.CustomerID == id)).GetValueOrDefault();
        }
    }
}
