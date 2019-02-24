using ProjectBase.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using vyigity.Blog.Models;

namespace vyigity.Blog.Controllers
{
    public class CommentController : Controller
    {
        // GET: Comment
        public ActionResult Index()
        {
            List<Comment> cList = ProcessView();

            return View(cList);
        }

        private List<Comment> ProcessView()
        {
            List<Comment> cList = GetData();
            ViewData["Category"] = GetCategory();
            ControlComments(cList);
            return cList;
        }

        private static void ControlComments(List<Comment> cList)
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            List<BadWord> bwList = db.GetObjectList<BadWord>("select * from blog.bad_word");

            foreach (var item in cList)
            {
                item.CAUTION = false;
                
                foreach (var bw in bwList)
                {
                    List<string> strList = item.ARTICLE_TITLE.Split(' ').ToList();
                    strList.AddRange(item.COMMENT_TEXT.Split(' ').ToList());

                    foreach (string s in strList)
                    {
                        if (s.StartsWith(bw.WORD, StringComparison.CurrentCultureIgnoreCase))

                            item.CAUTION = true;
                    }
                }    
            }
        }

        private static List<Category> GetCategory()
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            List<Category> aList = db.GetObjectList<Category>(
                "select c.*, (select count(*) from article a, article_category ac where a.id = ac.article_id and a.ACTIVE=1 and ac.category_id = c.id) ARTICLE_COUNT from category c order by LABEL_TEXT");
            return aList;
        }

        private static List<Comment> GetData()
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();

            gen.SelectText = @"select c.*, a.TITLE ARTICLE_TITLE from blog.comment c, blog.article a 

                                where

                                c.ARTICLE_ID = a.ID and

                                c.APPROVED = 0 order by INSERT_DATE desc";

            return db.GetObjectList<Comment>(gen.GetSelectCommandBasic());
        }

        [HttpPost]
        public ActionResult AddComment(Comment param)
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();
            IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();

            gen.TableName = "comment";

            gen.AddDataParameter("ID", Guid.NewGuid().ToString("N"));
            gen.AddDataParameter("ARTICLE_ID", param.ARTICLE_ID);
            gen.AddDataParameter("COMMENT_TEXT", param.COMMENT_TEXT);
            gen.AddDataParameter("USER_NAME", param.USER_NAME);
            gen.AddDataParameter("INSERT_DATE", DateTime.Now);

            db.ExecuteQuery(gen.GetInsertCommand());

            return Json(new { });
        }

        public ActionResult Process(string ID, int ISLEM)
        {
            IDatabase2 db = DatabaseFactory.GetDbObject();

            IQueryGenerator gen = QueryGeneratorFactory.GetDbObject();
            gen.TableName = "comment";

            if (ISLEM == 1)
            {
                gen.AddDataParameter("APPROVED", 1);
            }
            else
            {
                gen.AddDataParameter("APPROVED", 2);
            }

            gen.FilterText = " WHERE ID=:p1";

            gen.AddFilterParameter("p1", ID);

            db.ExecuteQuery(gen.GetUpdateCommand());

            List<Comment> cList = ProcessView();

            return View("Index", cList);
        }
    }
}