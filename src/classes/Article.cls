/**
 * Provides getHTML implementations for the content templates "ArticleSummary" and "ArticleDetail" as well as attribute
 * accessors for the Article content editor.
 */
global abstract with sharing class Article extends cms.ContentTemplateController {
    public String getArticleSummaryHtml() {
        String html = '';

        Boolean hasImage = !String.isBlank(thumbnailImageUrl);

        if(hasImage) {
            html += '<article>'
                    + '<a href="" class="ocms-title-taxonomy-detail-link">'
                        + '<img'
                            + ' src="' + thumbnailImageUrl.escapeHtml4() + '"'
                            + ' alt="' + thumbnailImageAlt.escapeHtml4() + '"'
                        + '>'
                        + '<h1>' + title.escapeHtml4() + '</h1>'
                        + '<p>' + summary.escapeHtml4() + '</p>'
                    + '</a>'
                + '</article>';
        } else { // !hasImage
            html += '<article>'
                + '<a href="" class="ocms-title-taxonomy-detail-link">'
                    + '<h1>' + title.escapeHtml4() + '</h1>'
                    + '<p>' + summary.escapeHtml4() + '</p>'
                + '</a>'
            + '</article>';
        }

        return html;
    }

    public String getArticleDetailHtml() {
        String html = '';

        html += '<article>'
            + '<h1>' + title.escapeHtml4() + '</h1>'
            + '<div>' + body + '</div>'
        + '</article>';

        return html;
    }

    /** A thumbnail image, used by ArticleSummary */
    public String thumbnailImageUrl {
        get {
            return getProperty('thumbnailImageUrl');
        } set;
    }

    /** Alternate text for a thumbnail image for screenreaders, used by ArticleSummary */
    public String thumbnailImageAlt {
        get {
            return getProperty('thumbnailImageAlt');
        } set;
    }

    /** The title of an article, used by ArticleSummary and ArticleDetail */
    public String title {
        get {
            return getProperty('title');
        } set;
    }

    /** A short summary of an article, used by ArticleSummary */
    public String summary {
        get {
            return getProperty('summary');
        } set;
    }

    /**
     * The number of body chunks in an article, used by ArticleDetail.
     *
     * @see #body
     */
    public Integer bodyChunkCount {
        get {
            String bodyChunkCountString = getProperty('bodyChunkCount');

            if(bodyChunkCountString == null) {
                // Default to 0 chunks (no body)
                return 0;
            }

            try {
                return Integer.valueOf(bodyChunkCountString);
            } catch(TypeException tex) {
                // Not a valid integer - assume no chunks
                return 0;
            }
        }
    }

    /**
     * A reassembled article body. Salesforce imposes a 32,768 character limit. To allow for longer articles,
     * the article body is split into 30,000-character chunks and reassembled for rendering.
     */
    public String body {
        get {
            if(body == null) {
                body = '';

                // Reassemble the chunked body
                for(Integer i = 0; i < bodyChunkCount; i++) {
                    String chunk = getProperty('body_' + i);

                    if(chunk != null) {
                        body += chunk;
                    }
                }
            }

            return body;
        } set;
    }

    /** Extension constructor for the Article edit page */
    global Article(cms.CreateContentController cc) {
        super(cc);
    }

    /** Extension constructor for Article generate pages (unused) */
    private Article(cms.GenerateContent gc) {
        super(gc);
    }

    /** Constructor for getHTML rendering */
    global Article() {
        super();
    }

    /** Blank getHTML - rendering is done by subclasses */
    global virtual override String getHTML() {
        return '';
    }
}
