using ProjectBase.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using vyigity.Blog.Models;

namespace vyigity.Blog.Controllers
{
    public class CategoryController : Controller
    {
        // GET: Category
        public ActionResult Index()
        {
            List<Category> cList = ProcessView();

            return View(cList);
        }

        private List<Category> ProcessView()
        {
            List<Category> cList = GetData();

            ViewData["Category"] = GetCategory();

            return cList;
        }

        private static List<Category> GetCategory()
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            List<Category> aList = db.GetObjectList<Category>(
                "select c.*, (select count(*) from article a, article_category ac where a.id = ac.article_id and a.ACTIVE=1 and ac.category_id = c.id) ARTICLE_COUNT from category c order by LABEL_TEXT");
            return aList;
        }

        private static List<Category> GetData()
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();

            gen.SelectText = "select * from category order by LABEL_TEXT";

            return db.GetObjectList<Category>(gen.GetSelectCommandBasic());
        }

        [HttpPost]
        public ActionResult AddCategory(Category param)
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();

            gen.TableName = "category";

            gen.AddDataParameter("LABEL_TEXT", param.LABEL_TEXT);

            db.ExecuteQuery(gen.GetInsertCommand());

            List<Category> cList = ProcessView();

            return View("Index", cList);
        }

        public ActionResult DeleteCategory(int ID)
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();

            IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();
            gen.SelectText = "delete from category where ";
            gen.FilterText = "id = :p1";

            gen.AddFilterParameter("p1", ID);

            db.ExecuteQuery(gen.GetSelectCommandBasic());

            List<Category> cList = ProcessView();

            return View("Index", cList);
        }
    }
}