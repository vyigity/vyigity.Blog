using ProjectBase.Database;
using ProjectBase.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace vyigity.Blog.Code
{
    public class BlogAuthentication
    {
        public bool Login(string UserName, string Password)
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();
            
            gen.SelectText = "select count(*) from blog.user where ";
            gen.FilterText = "USER_NAME = :p1 and PASSWORD = :p2";
            gen.AddFilterParameter("p1", UserName);
            gen.AddFilterParameter("p2", Password);

            int i = Util.GetProperty<int>(db.GetSingleValue(gen.GetSelectCommandBasic()));

            if (i > 0)
            {
                HttpContext.Current.Session["UserName"] = UserName;
                return true;
            }

            return false;
        }

        public bool IsAuthenticated()
        {
            if (HttpContext.Current.Session["UserName"] != null)
            {
                return true;
            }

            return false;
        }

        public void LogOut()
        {
            HttpContext.Current.Session["UserName"] = null;
            HttpContext.Current.Session.Abandon();
        }
    }
}