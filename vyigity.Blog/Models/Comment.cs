using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace vyigity.Blog.Models
{
    public class Comment
    {
        public string ID { get; set; }
        public string COMMENT_TEXT { get; set; }
        public string USER_NAME { get; set; }
        public string ARTICLE_ID { get; set; }
        public DateTime INSERT_DATE { get; set; }
        public string ARTICLE_TITLE { get; set; }
        public bool CAUTION { get; set; }
    }
}