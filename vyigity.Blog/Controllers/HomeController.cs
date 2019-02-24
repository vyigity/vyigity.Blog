using ProjectBase.Database;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using vyigity.Blog.Code;
using vyigity.Blog.Models;

namespace vyigity.Blog.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            List<Article> aList = GetData();
            ViewData["Category"] = GetCategory();
            ViewData["ShowCommentForm"] = false;

            return View(aList);
        }

        private static List<Article> GetData()
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            List<Article> aList = db.GetObjectList<Article>("select a.*, (select count(*) from comment c where c.article_id = a.id and c.APPROVED = 1) COMMENT_COUNT from article a where ACTIVE=1 order by INSERT_DATE desc");
            FillCategory(db, aList);

            return aList;
        }

        private static void FillCategory(IDatabase2 db, List<Article> aList)
        {
            foreach (var arc in aList)
            {
                IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();
                gen.SelectText = "select * from category c ,article_category a where ";
                gen.FilterText = "a.category_id = c.id and  a.article_id = :p1";
                gen.SelectTail = "order by c.LABEL_TEXT";

                gen.AddFilterParameter("p1", arc.ID);

                List<Category> cList = db.GetObjectList<Category>(gen.GetSelectCommandBasic());

                arc.CATEGORIES = cList;
            }
        }

        private static List<Category> GetCategory()
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            List<Category> aList = db.GetObjectList<Category>(
                "select c.*, (select count(*) from article a, article_category ac where a.id = ac.article_id and a.ACTIVE=1 and ac.category_id = c.id) ARTICLE_COUNT from category c order by LABEL_TEXT");
            return aList;
        }

        private static List<Article> GetData(int id)
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            IQueryGenerator gen =  QueryGeneratorFactory.GetDbObject();

            gen.SelectText = "select a.*, (select count(*) from comment c where c.article_id = a.id and c.APPROVED = 1) COMMENT_COUNT from article a where a.ACTIVE=1 and ";
            gen.FilterText = "a.id = :p1";

            gen.AddFilterParameter("p1", id);

            List<Article> aList = db.GetObjectList<Article>(gen.GetSelectCommandBasic());

            FillCategory(db, aList);
            FillComments(db, aList.First());

            return aList;
        }

        private static void FillComments(IDatabase2 db, Article article)
        {

            IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();
            gen.SelectText = "select * from blog.comment c where c.APPROVED = 1 and ";
            gen.FilterText = "c.article_id = :p1 ";
            gen.SelectTail = "order by c.INSERT_DATE desc";

            gen.AddFilterParameter("p1", article.ID);

            List<Comment> cList = db.GetObjectList<Comment>(gen.GetSelectCommandBasic());

            article.COMMENTS = cList;
        }

        private static List<Article> GetDataWithCategory(int id)
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();

            gen.SelectText = "select a.*, (select count(*) from comment co where co.article_id = a.id and co.APPROVED = 1) COMMENT_COUNT from article a, article_category c where a.id = c.article_id and a.ACTIVE=1 and ";
            gen.FilterText = "c.category_id = :p1 order by a. INSERT_DATE desc";

            gen.AddFilterParameter("p1", id);

            List<Article> aList = db.GetObjectList<Article>(gen.GetSelectCommandBasic());

            FillCategory(db, aList);

            return aList;
        }

        private static List<Article> GetData(string searchText)
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();
            gen.SelectText = "select a.*,(select count(*) from comment c where c.article_id = a.id and c.APPROVED = 1) COMMENT_COUNT from article a where a.ACTIVE=1 and ";
            gen.FilterText = "TEXT like CONCAT('%',:p1,'%') ";
            gen.SelectTail = "order by INSERT_DATE desc";
            gen.AddFilterParameter("p1",searchText);
            List<Article> aList = db.GetObjectList<Article>(gen.GetSelectCommandBasic());

            FillCategory(db, aList);

            return aList;
        }

        public ActionResult Login(string userName, string password)
        {
            BlogAuthentication aut = new BlogAuthentication();
            aut.Login(userName, password);

            List<Article> aList = GetData();
            ViewData["Category"] = GetCategory();

            return View("Index",aList);
        }

        public ActionResult Logout()
        {
            BlogAuthentication aut = new BlogAuthentication();
            aut.LogOut();

            List<Article> aList = GetData();
            ViewData["Category"] = GetCategory();
            return View("Index", aList);
        }

        public ActionResult Search(string searchText)
        {
            List<Article> aList = GetData(searchText);
            ViewData["Category"] = GetCategory();
            ViewData["ShowCommentForm"] = false;

            return View("Index", aList);
        }

        public ActionResult Blog(int id)
        {
            List<Article> aList = GetData(id);
            ViewData["Category"] = GetCategory();
            ViewData["ShowCommentForm"] = true;

            return View("Index", aList);
        }

        public ActionResult Category(int id)
        {
            List<Article> aList = GetDataWithCategory(id);
            ViewData["Category"] = GetCategory();
            return View("Index", aList);
        }
    }
}