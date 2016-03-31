/**
 * Provides a single entrypoint for OrchestraCMS to render an "ArticleDetail" content template.
 */
global with sharing class ArticleDetail extends Article {
    /** Delegates rendering to {@link Article#getArticleDetailHtml()} */
    global override String getHTML() {
        return getArticleDetailHtml();
    }
}
