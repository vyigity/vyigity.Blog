using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace vyigity.Blog.Models
{
    public class Article
    {
        public int ID { get; set; }
        public string TEXT { get; set; }
        public string TITLE { get; set; }
        public DateTime INSERT_DATE { get; set; }
        public string AUTHOR { get; set; }
        public int ACTIVE { get; set; }
        public int COMMENT_COUNT { get; set; }

        public List<Category> CATEGORIES = null;

        public List<Comment> COMMENTS = null;
    }
}