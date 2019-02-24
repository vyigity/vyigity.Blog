using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace vyigity.Blog.Models
{
    public class Category
    {
        public int ID { get; set; }
        public string LABEL_TEXT { get; set; }
        public int ARTICLE_COUNT { get; set; }
    }
}