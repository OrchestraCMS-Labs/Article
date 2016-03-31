/**
 * Provides a single entrypoint for OrchestraCMS to render an "ArticleSummary" content template.
 */
global with sharing class ArticleSummary extends Article {
    /** Delegates rendering to {@link Article#getArticleSummaryHtml()} */
    global override String getHTML() {
        return getArticleSummaryHtml();
    }
}
