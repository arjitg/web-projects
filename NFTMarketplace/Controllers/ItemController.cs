using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using TestReverseEngineer.Models;
using Microsoft.AspNetCore.Hosting;

//using System.Dynamic;

namespace TestReverseEngineer.Controllers
{
    public class ItemController : Controller
    {
        private readonly Team108DBContext _context;

        private readonly IWebHostEnvironment _hostingEnvironment;

        public ItemController(Team108DBContext context, IWebHostEnvironment hostingEnvironment)
        {
            _context = context;
            _hostingEnvironment = hostingEnvironment;
        }

        // add a product to shopping cart
        public async Task<IActionResult> AddToCart(int? id)
        {
            if (id == null)
            {
                return RedirectToAction(nameof(Index));
            }

            var product = await _context.tabItems.FirstOrDefaultAsync(i => i.ItemID == id);

            if (product == null)
            {
                return RedirectToAction(nameof(Index));
            }

            // call to method to retrieve cart object from session state

            Cart aCart = GetCart();

            aCart.AddItem(product);

            // call to method to save cart object to session state

            SaveCart(aCart);

            return RedirectToAction(nameof(MyCart));
        }

        private Cart GetCart()
        {
            Cart aCart = HttpContext.Session.GetObject<Cart>("Cart") ?? new Cart();
            return aCart;
        }

        private void SaveCart(Cart aCart)
        {
            HttpContext.Session.SetObject("Cart", aCart);
        }

        public IActionResult MyCart()
        {
            Cart aCart = GetCart();

            if (aCart.CartItems().Any())
            {
                return View(aCart);
            }

            // if the cart is empty

            return RedirectToAction(nameof(Index));
        }

        // GET: Item
        public async Task<IActionResult> Index()
        {
            ViewData["cart"] = GetCart();
            return _context.tabItems != null ?
                    View(await _context.tabItems.ToListAsync()) :
                    View("Index", "Home");
                    //Problem("Entity set 'Team108DBContext.tabItems'  is null.");
        }

        // GET: Item/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return RedirectToAction(nameof(Index));
            }

            var img = _context.tabItems.FirstOrDefault(f => f.ItemID == id);

            if (img == null)
            {
                return RedirectToAction(nameof(Index));
            }

            ViewData["ImageName"] = img.ImageName;
            ViewData["ItemID"] = img.ItemID;
            ViewData["ProductImage"] = img.ProductImage;

            var reviews = _context.tabReviews
                .Include(r=>r.ReviewByNavigation)
                .Where(r => r.OnItem == id)
                .OrderByDescending(r => r.Date);

            return View(await reviews.ToListAsync());
        }

        // GET: Item/Create
        [Authorize(Roles = "Seller")]
        public IActionResult Create()
        {
            return View();
        }

        // POST: Item/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("UnitPrice,Description,ImageName")] tabItem tabItem, IFormFile file)
        {
            if (ModelState.IsValid)
            {
                //string filePath = Path.GetFileName(file.FileName);
                //var filePath = Path.Combine(Directory.GetCurrentDirectory(), @"wwwroot/images/", Path.GetFileName(file.FileName));
                string[] permittedExtensions = { ".jpg", ".jpeg", ".png" };

                var fileName = Path.GetFileName(file.FileName);
                var filePath = Path.Combine(_hostingEnvironment.WebRootPath, "images", fileName);
                var ext = Path.GetExtension(fileName).ToLowerInvariant();

                if(!string.IsNullOrEmpty(ext) && permittedExtensions.Contains(ext) && fileName.Length < 2048)
                {
                    using (var fileStream = new FileStream(filePath, FileMode.Create))
                    {
                        await file.CopyToAsync(fileStream);
                    }

                    string digitalSign = HelperClass.newGetDigitalSignature(filePath);

                    var duplicateItem = await _context.tabItems.FirstOrDefaultAsync(i => i.DigitalSignature == digitalSign);
                    if (duplicateItem != null)
                    {
                        //failed to add item because of duplicacy
                        TempData["message"] = "Image is already listed. Failed upload";
                        System.Diagnostics.Debug.WriteLine("\n\n\n\n\n\n\n\n\nImage is duplicate. Failed upload");
                        return RedirectToAction("Index", "Item");
                    }
                    else
                    {
                        int userPK = Int32.Parse(HttpContext.User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Sid).Value);
                        tabItem.DigitalSignature = digitalSign;
                        tabItem.Sold = 0;
                        //tabItem.ProductImage = filePath;
                        tabItem.ProductImage = file.FileName;
                        tabItem.CreatedBy = userPK;
                        _context.Add(tabItem);
                        await _context.SaveChangesAsync();
                        TempData["success"] = "Successfully listed image";
                        return RedirectToAction("Index", "Item");
                    }
                }
                else
                {
                    TempData["message"] = "Image is not compatible for upload. Make sure jpg pr png image is used and is under 2 MB";
                    return RedirectToAction("Index", "Item");
                }
            }

            return RedirectToAction("Create", "Item");


            //if (ModelState.IsValid)
            //{
            //    string imgURL = tabItem.ProductImage.ToString();
            //    digitalSign = HelperClass.GetDigitalSignature(imgURL);

            //    var duplicateItem = await _context.tabItems.FirstOrDefaultAsync(i => i.DigitalSignature == digitalSign);
            //    if (duplicateItem != null)
            //    {
            //        //failed to add item because of duplicacy
            //        TempData["message"] = "Image is duplicate. Failed upload";
            //        return RedirectToAction(nameof(Index));
            //    }
            //    else
            //    {
            //        tabItem.DigitalSignature= digitalSign;
            //        tabItem.Sold = 0;
            //        _context.Add(tabItem);
            //        await _context.SaveChangesAsync();
            //    }

            //    return RedirectToAction(nameof(Index));
            //}
            //return View(tabItem);
        }

        // GET: Item/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null || _context.tabItems == null)
            {
                return NotFound();
            }

            var tabItem = await _context.tabItems.FindAsync(id);
            if (tabItem == null)
            {
                return NotFound();
            }
            return View(tabItem);
        }

        // POST: Item/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("ItemID,UnitPrice,ImageName,Description")] tabItem tabItem)
        {
            if (id != tabItem.ItemID)
            {
                return NotFound();
            }

            var dbItem = await _context.tabItems.FirstOrDefaultAsync(m => m.ItemID == id);
            if(dbItem == null)
            {
                return RedirectToAction("Index", "Item");
            }

            if (ModelState.IsValid)
            {
                try
                {
                    dbItem.ImageName = tabItem.ImageName;
                    dbItem.UnitPrice = tabItem.UnitPrice;
                    dbItem.Description = tabItem.Description;
                    _context.Update(dbItem);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!tabItemExists(tabItem.ItemID))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(tabItem);
        }

        [HttpPost]
        public async Task<IActionResult> Index(string searchName, double? priceMin, double? priceMax)
        {
            // the ViewData elements are used to pass back the filter values to the FilterDemo View

            ViewData["NameFilter"] = searchName;
            ViewData["PriceMinFilter"] = priceMin;
            ViewData["PriceMaxFilter"] = priceMax;

            var products = from p in _context.tabItems select p;

            // depending on the filter values (received as parameters from the query string in the URL), where methods are used to filter the IQueryable object, products

            if (!String.IsNullOrEmpty(searchName))
            {
                products = products.Where(p => p.ImageName.Contains(searchName));
            }
            if (priceMin != null)
            {
                products = products.Where(p => p.UnitPrice >= priceMin);
            }
            if (priceMax != null)
            {
                products = products.Where(p => p.UnitPrice <= priceMax);
            }

            products = products.Include(p => p.CreatedByNavigation);

            return View(await products.ToListAsync());
        }

        // GET: Review/Create

        [Authorize]
        public IActionResult CreateReview(int? id)
        {
            //if id is null

            if (id == null)
            {
                return RedirectToAction("Index", "Item");
            }

            //if id is not valid

            var img = _context.tabItems.FirstOrDefault(f => f.ItemID == id);

            if (img == null)
            {
                return RedirectToAction("Index", "Home");
            }

            // retrieve user's PK from the Claims collection
            // since the PK is stored as a string, it has to be parsed to an integer

            int userPK = Int32.Parse(HttpContext.User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Sid).Value);

            // Check if user already has a review for film

            var uReview = _context.tabReviews.FirstOrDefault(r => r.OnItem == id && r.ReviewBy == userPK);

            // If user has a review, redirect to Edit

            if (uReview != null)
            {
                // return to item details page, where review will be visible
                return RedirectToAction(nameof(Details), new { id = img.ImageName });
            }

            //set ViewData to display film title in View

            ViewData["ImageName"] = img.ImageName;

            tabReview aReview = new tabReview { OnItem = img.ItemID };

            return View(aReview);
        }

        // POST: Review/Create

        [Authorize]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreateReview([Bind("OnItem,Review")] tabReview aReview)
        {
            var img = _context.tabItems.FirstOrDefault(i => i.ItemID == aReview.OnItem);

            if (img == null)
            {
                return RedirectToAction("Index", "Home");
            }

            if (ModelState.IsValid)
            {
                // retrieve user's PK from the Claims collection
                // since the PK is stored as a string, it has to be parsed to an integer

                int custID = Int32.Parse(HttpContext.User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Sid).Value);

                //set rest of the properties for the new review object

                aReview.ReviewBy = custID;
                aReview.Date = DateTime.Now;
                //aReview.ReviewUpdateDate = DateTime.Now;

                //save new review object

                try
                {
                    _context.Add(aReview);
                    await _context.SaveChangesAsync();
                }
                catch
                {
                    TempData["failure"] = $"Your review of {img.ImageName} not added";
                    return RedirectToAction(nameof(Details));
                }

                TempData["success"] = $"Your review of {img.ImageName} added";
                return RedirectToAction(nameof(Details));
            }

            // if the data is not valid

            //set ViewData to display film title in View

            ViewData["ImageName"] = img.ImageName;

            return View(aReview);
        }

        [HttpGet]
        public IActionResult FilterView()
        {
            List<tabItem> itemList = new();
            return View(itemList);
        }

        private bool tabItemExists(int id)
        {
          return (_context.tabItems?.Any(e => e.ItemID == id)).GetValueOrDefault();
        }


        [Authorize]
        public async Task<IActionResult> MyOrders()
        {
            PlaceOrderStateless();
            // retrieve the user's PK from the Claims collection
            // since the PK is stored as a string, it has to be parsed to an integer

            int userPK = Int32.Parse(HttpContext.User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Sid).Value);

            // retrieve the user's orders

            var orderDetails = _context.tabOrderLineItems.Include(
                oli => oli.ItemNameNavigation
            ).Include(
                oli => oli.OrderNameNavigation
            ).Where(
                u => u.OrderNameNavigation.CustomerFK == userPK
            ).OrderBy(
                d => d.OrderNameNavigation.OrderDate
            );

            System.Diagnostics.Debug.WriteLine("\n\n\n\n\norderss....\n\n\n\n");
            System.Diagnostics.Debug.WriteLine(Newtonsoft.Json.JsonConvert.SerializeObject(orderDetails));

            if (orderDetails == null)
            {
                TempData["message"] = "No orders found. Browse our catalog to buy something";
                return RedirectToAction(nameof(Index));
            }

            return View(await orderDetails.ToListAsync());
        }

        [Authorize]
        public async Task<IActionResult> Cancel(int? id)
        {
            if (id == null || _context.tabOrders == null)
            {
                return RedirectToAction(nameof(Index));
            }

            var order = await _context.tabOrders.FindAsync(id);

            System.Diagnostics.Debug.WriteLine("\n\n\n\n\nWriting order object on console....\n\n\n\n");
            System.Diagnostics.Debug.WriteLine(Newtonsoft.Json.JsonConvert.SerializeObject(order));


            if (order == null)
            {
                return RedirectToAction(nameof(Index));
            }

            try
            {
                var orderLineItem = await _context.tabOrderLineItems.FirstOrDefaultAsync(oli => oli.OrderName == id);
                if (orderLineItem == null)
                {
                    return RedirectToAction(nameof(Index));
                }
                else
                {
                    var item = await _context.tabItems.FirstOrDefaultAsync(i => i.ItemID == orderLineItem.ItemName);
                    if(item != null)
                    {
                        item.Sold = 0;
                        _context.Update(item);
                    }
                    _context.tabOrderLineItems.Remove(orderLineItem);
                    _context.tabOrders.Remove(order);
                    await _context.SaveChangesAsync();
                    TempData["message"] = $"Your order of {item.ImageName} is cancelled";
                }
            }
            catch(Exception ex) 
            {
                TempData["message"] = $"{order.OrderID} not cancelled. Exception details: {ex.StackTrace}";
            }

            return RedirectToAction(nameof(Index));
        }

        //[Authorize]
        //public async void ProcessOrder(int? orderID)
        //{
        //    if (orderID != null || _context.tabOrders != null)
        //    {
        //        var order = await _context.tabOrders.FindAsync(orderID);
        //        if (order != null)
        //        {
        //            order.Processed = 1;
        //            _context.Update(order);
        //            await _context.SaveChangesAsync();
        //        }
        //    }
        //}

        [Authorize]
        public async Task<IActionResult> ImageView(int? id)
        {
            System.Diagnostics.Debug.WriteLine(id + "orderID\n\n\n\n\n\n\n");

            if (id == null || _context.tabOrders == null)
            {
                return RedirectToAction(nameof(Index));
            }
            
            var order = await _context.tabOrders.FindAsync(id);
            if(order == null)
            {
                System.Diagnostics.Debug.WriteLine("\n\n\norder is null\n\n\n\n");
                return RedirectToAction(nameof(Index));
            }

            order.Processed = 1;
            _context.Update(order);
            await _context.SaveChangesAsync();
            
            var orderLineItem = await _context.tabOrderLineItems.Include(
                x=>x.ItemNameNavigation
            ).FirstOrDefaultAsync(
                oli => oli.OrderName == id
            );

            if (orderLineItem == null)
            {
                System.Diagnostics.Debug.WriteLine("\n\n\norderLineItem\n\n\n\n");
                return RedirectToAction(nameof(Index));
            }


            //original error occured here for which I printed the variable above.
            var item = orderLineItem.ItemNameNavigation.ItemID;
            var itemObject = await _context.tabItems.FindAsync(item);
            if(itemObject == null)
            {
                System.Diagnostics.Debug.WriteLine("\n\n\nitemObject is null\n\n\n\n");
                return RedirectToAction(nameof(Index));
            }

            System.Diagnostics.Debug.WriteLine("\n\n\nitemObject tracking: "+itemObject.Sold+"\ndiagnostics itemobject\n\n\n\n");

            itemObject.Sold = 1;
            _context.Update(itemObject);
            await _context.SaveChangesAsync();

            return View(itemObject);

            //return base.File(orderLineItem.ItemNameNavigation.ProductImage, "image/jpeg");
            //return base.File("https://cisweb.biz.colostate.edu/cis665/team108/images/watermark.jpg", "image/jpeg");
        }


        //[Authorize]
        //public IActionResult PlaceOrder()
        //{
        //    Cart aCart = GetCart();

        //    if (aCart.CartItems().Any())
        //    {
        //        int userPK = Int32.Parse(HttpContext.User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Sid).Value);

        //        // insert an order for each image
        //        int orderID;
        //        foreach (CartItem aItem in aCart.CartItems())
        //        {
        //            tabOrder aOrder = new() { CustomerFK = userPK, OrderDate = DateTime.Now };
        //            _context.Add(aOrder);
        //            _context.SaveChanges();
        //            orderID = aOrder.OrderID;

        //            tabOrderLineItem aDetail = new() { ItemName = aItem.Item.ItemID, OrderName = orderID };
        //            _context.Add(aDetail);
        //            _context.SaveChanges();
        //        }

        //        // remove all items from cart
        //        aCart.ClearCart();

        //        SaveCart(aCart);

        //        return View(nameof(MyOrders));
        //    }

        //    return RedirectToAction("Index", "Item");
        //}

        public void PlaceOrderStateless()
        {
            Cart aCart = GetCart();

            if (aCart.CartItems().Any())
            {
                int userPK = Int32.Parse(HttpContext.User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Sid).Value);

                // insert an order for each image
                int orderID;
                foreach (CartItem aItem in aCart.CartItems())
                {
                    tabOrder aOrder = new() { 
                        CustomerFK = userPK, 
                        OrderDate = DateTime.Now 
                    };
                    _context.Add(aOrder);
                    _context.SaveChanges();
                    orderID = aOrder.OrderID;

                    tabOrderLineItem aDetail = new() { 
                        OrderName = orderID,
                        ItemName = aItem.Item.ItemID, 
                        ItemPrice = aItem.Item.UnitPrice,
                        ItemTax = 1.2
                    };
                    _context.Add(aDetail);
                    _context.SaveChanges();
                }

                // remove all items from cart
                aCart.ClearCart();
                SaveCart(aCart);
            }
        }
    }
}
