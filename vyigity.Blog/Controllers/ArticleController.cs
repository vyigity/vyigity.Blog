using ProjectBase.Database;
using ProjectBase.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using vyigity.Blog.Models;

namespace vyigity.Blog.Controllers
{
    public class ArticleController : Controller
    {
        // GET: Article
        public ActionResult Index()
        {
            ProcessView();

            //Article arc = GetData();

            return View(new Article());
        }

        public ActionResult ArticleUpdate(int id)
        {
            ProcessView();

            List<Category> allcats = GetCategory();
            List<Category> loadedcats = GetLoadedCategory(id);

            ViewData["unloadedCategory"] = allcats.Where(r => !loadedcats.Any(z => z.ID == r.ID)).ToList();
            ViewData["loadedCats"] = loadedcats;

            Article arc = GetData(id);

            return View("ArticleUpdate", arc);
        }

        [ValidateInput(false)]
        public ActionResult UpdateArticle(int ARTICLE_ID, string TITLE, string CONTENT, int[] CATEGORIES)
        {
            try
            {
                IDatabase2 db = DatabaseFactory.GetDbObject(DbSettings.TransactionMode);
                IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();

                gen.TableName = "article";

                gen.AddDataParameter("TITLE", TITLE);
                gen.AddDataParameter("TEXT", CONTENT);
                gen.AddDataParameter("UPDATE_DATE", DateTime.Now);
                gen.AddDataParameter("AUTHOR", "vyigity");

                gen.FilterText = " where ID=:p1";

                gen.AddFilterParameter("p1", ARTICLE_ID);

                db.ExecuteQuery(gen.GetUpdateCommand());

                db.ExecuteQuery("delete from article_category where article_id = " + ARTICLE_ID);

                if (CATEGORIES != null && CATEGORIES.Length > 0)
                {
                    foreach (int i in CATEGORIES)
                    {
                        IQueryGenerator gen3 = QueryGeneratorFactory.GetDbObject();
                        gen3.TableName = "article_category";

                        gen3.AddDataParameter("ARTICLE_ID", ARTICLE_ID);
                        gen3.AddDataParameter("CATEGORY_ID", i);

                        db.ExecuteQuery(gen3.GetInsertCommand());
                    }
                }

                db.Commit();

                return RedirectToAction("ManageArticle");
            }
            catch
            {
                return RedirectToAction("ArticleUpdate");
            }
        }

        public ActionResult ManageArticle()
        {
            ProcessView();

            List<Article> arcs = GetAllData();

            return View(arcs);
        }

        private List<Article> GetAllData()
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();

            gen.SelectText = "select * from article order by INSERT_DATE desc";

            List<Article> sonuc = db.GetObjectList<Article>(gen.GetSelectCommandBasic());

            return sonuc;
        }

        private Article GetData(int id)
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();

            gen.SelectText = "select * from article where ";
            gen.FilterText = "id=:p1";

            gen.AddFilterParameter("p1", id);

            Article sonuc = db.GetObject<Article>(gen.GetSelectCommandBasic());

            return sonuc;
        }

        private void ProcessView()
        {
            ViewData["Category"] = GetCategory();
        }

        private static List<Category> GetCategory()
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            List<Category> aList = db.GetObjectList<Category>(
                "select c.*, (select count(*) from article_category a where a.category_id = c.id) ARTICLE_COUNT from category c order by LABEL_TEXT");
            return aList;
        }

        private static List<Category> GetLoadedCategory(int id)
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();
            gen.SelectText = "select c.* from category c, article_category ac where ";
            gen.FilterText = "c.id = ac.category_id and ac.article_id = :p1 ";
            gen.SelectTail = "order by c.LABEL_TEXT";

            gen.AddFilterParameter("p1", id);

            List<Category> aList = db.GetObjectList<Category>(gen.GetSelectCommandBasic());
            return aList;
        }

        [ValidateInput(false)]
        public ActionResult AddArticle(string TITLE, string CONTENT, int[] CATEGORIES)
        {
            try
            {
                string nGuid = Guid.NewGuid().ToString("N");

                IDatabase2 db = DatabaseFactory.GetDbObject(DbSettings.TransactionMode);
                IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();

                gen.TableName = "article";

                gen.AddDataParameter("TITLE", TITLE);
                gen.AddDataParameter("TEXT", CONTENT);
                gen.AddDataParameter("INSERT_DATE", DateTime.Now);
                gen.AddDataParameter("AUTHOR", "vyigity");
                gen.AddDataParameter("ID_GUID", nGuid);

                db.ExecuteQuery(gen.GetInsertCommand());

                IQueryGenerator gen2 = QueryGeneratorFactory.GetDbObject();
                gen2.SelectText = "select ID from article where ";
                gen2.FilterText = "ID_GUID = :p1";
                gen2.AddFilterParameter("p1", nGuid);

                if (CATEGORIES != null && CATEGORIES.Length > 0)
                {
                    int id = Util.GetProperty<int>(db.GetSingleValue(gen2.GetSelectCommandBasic()));

                    foreach (int i in CATEGORIES)
                    {
                        IQueryGenerator gen3 = QueryGeneratorFactory.GetDbObject();
                        gen3.TableName = "article_category";

                        gen3.AddDataParameter("ARTICLE_ID", id);
                        gen3.AddDataParameter("CATEGORY_ID", i);

                        db.ExecuteQuery(gen3.GetInsertCommand());
                    }
                }

                db.Commit();

                ProcessView();

                return RedirectToAction("ManageArticle");
            }
            catch
            {
                return RedirectToAction("Index");
            }
        }

        public ActionResult ProcessArticle(int ARTICLE_ID, int ISLEM)
        {
            try
            {
                IDatabase2 db = DatabaseFactory.GetDbObject(DbSettings.TransactionMode);
                IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();

                gen.TableName = "article";

                gen.AddDataParameter("ACTIVE", ISLEM);

                gen.FilterText = "where ID=:p1";

                gen.AddFilterParameter("p1", ARTICLE_ID);

                db.ExecuteQuery(gen.GetUpdateCommand());

                db.Commit();

                return RedirectToAction("ManageArticle");
            }
            catch
            {
                return RedirectToAction("ManageArticle");
            }
        }
    }
}