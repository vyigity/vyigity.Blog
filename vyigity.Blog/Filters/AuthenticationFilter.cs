using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Filters;
using System.Web.Routing;
using vyigity.Blog.Code;

namespace vyigity.Blog.Filters
{
    public class AuthenticationFilter : ActionFilterAttribute, IAuthenticationFilter
    {
        public void OnAuthentication(AuthenticationContext filterContext)
        {
            BlogAuthentication aut = new BlogAuthentication();

            if (filterContext.ActionDescriptor.ControllerDescriptor.ControllerName == "Comment" ||
                filterContext.ActionDescriptor.ControllerDescriptor.ControllerName == "Article" ||
                filterContext.ActionDescriptor.ControllerDescriptor.ControllerName == "Category")
            {
                if(!aut.IsAuthenticated())
                {
                    filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new { controller = "Home", action = "Index" }));
                }
            }
           
        }

        public void OnAuthenticationChallenge(AuthenticationChallengeContext filterContext)
        {
        
        }
    }
}