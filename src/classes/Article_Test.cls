@isTest
private with sharing class Article_Test {
    private static String title = 'my_article_title';
    private static String summary = 'my_article_summary';
    private static String body = '<my><html><body>';
    private static String bodyChunkCount = '1';
    private static String thumbnailImageUrl = 'thumbnail_url';
    private static String thumbnailImageAlt = 'thumbnail_alt';

    private static String titleWithHtml = '<title><with><html>';
    private static String summaryWithHtml = '<summary><with><html>';
    private static String thumbnailImageUrlWithHtml = '<thumbnail><url><with><html>';
    private static String thumbnailImageAltWithHtml = '<thumbnail><alt><with><html>';

    private static testmethod void testGetArticleSummaryHtml_noThumbnail() {
        Article articleController = new Article();

        articleController.testAttributes = new Map<String, String> {
            'title' => title,
            'summary' => summary
        };

        String htmlResult = articleController.getArticleSummaryHtml();

        System.assert(htmlResult.contains(title), 'Summary HTML should contain the title');
        System.assert(htmlResult.contains(summary), 'Summary HTML should contain the summary text');
        System.assert(!htmlResult.contains('<img'), 'Summary HTML should not contain an image');
    }

    private static testmethod void testGetArticleSummaryHtml_thumbnail() {
        Article articleController = new Article();

        articleController.testAttributes = new Map<String, String> {
            'title' => title,
            'summary' => summary,
            'thumbnailImageUrl' => thumbnailImageUrl,
            'thumbnailImageAlt' => thumbnailImageAlt
        };

        String htmlResult = articleController.getArticleSummaryHtml();

        System.assert(htmlResult.contains(title), 'Summary HTML should contain the title');
        System.assert(htmlResult.contains(summary), 'Summary HTML should contain the summary text');
        System.assert(htmlResult.contains('<img'), 'Summary HTML should contain an image');
        System.assert(htmlResult.contains(thumbnailImageUrl), 'Summary HTML should contain the thumbnail URL');
        System.assert(htmlResult.contains(thumbnailImageAlt), 'Summary HTML should contain the thumbnail alt text');
    }

    private static testmethod void testGetArticleSummaryHtml_doesEscapeHtml() {
        Article articleController = new Article();

        articleController.testAttributes = new Map<String, String> {
            'title' => titleWithHtml,
            'summary' => summaryWithHtml,
            'thumbnailImageUrl' => thumbnailImageUrlWithHtml,
            'thumbnailImageAlt' => thumbnailImageAltWithHtml
        };

        String htmlResult = articleController.getArticleSummaryHtml();

        // All HTML should be escaped - we're verifying by checking for the original string here
        System.assert(!htmlResult.contains(titleWithHtml), 'Summary HTML should not contain an unescaped title');
        System.assert(!htmlResult.contains(summaryWithHtml), 'Summary HTML should not contain unescaped summary text');
        System.assert(!htmlResult.contains(thumbnailImageUrlWithHtml), 'Summary HTML should not contain an unescaped thumbnail URL');
        System.assert(!htmlResult.contains(thumbnailImageAltWithHtml), 'Summary HTML should not contain an unescaped thumbnail alt text');
    }

    private static testmethod void testGetArticleDetailHtml() {
        Article articleController = new Article();

        articleController.testAttributes = new Map<String, String> {
            'title' => title,
            'body_0' => body,
            'bodyChunkCount' => bodyChunkCount
        };

        String htmlResult = articleController.getArticleDetailHtml();

        System.assert(htmlResult.contains(title), 'Detail HTML should contain the title');
        System.assert(htmlResult.contains(body), 'Detail HTML should contain the body HTML');
    }

    private static testmethod void testBodyChunkCount_default() {
        Article articleController = new Article();

        articleController.testAttributes = new Map<String, String> {};

        System.assertEquals(0, articleController.bodyChunkCount, 'bodyChunkCount should default to 0');
    }

    private static testmethod void testBodyChunkCount_valid() {
        Article articleController = new Article();

        articleController.testAttributes = new Map<String, String> {
            'bodyChunkCount' => bodyChunkCount
        };

        System.assertEquals(Integer.valueOf(bodyChunkCount), articleController.bodyChunkCount, 'bodyChunkCount should parse correctly');
    }

    private static testmethod void testBodyChunkCount_invalid() {
        Article articleController = new Article();

        articleController.testAttributes = new Map<String, String> {
            'bodyChunkCount' => 'invalid'
        };

        System.assertEquals(0, articleController.bodyChunkCount, 'bodyChunkCount should default to 0 for a non-integer');
    }

    private static testmethod void testBody_chunking() {
        String body0 = '<p>Body 0</p>';
        String body1 = '<p>Body 1</p>';

        Article articleController = new Article();

        articleController.testAttributes = new Map<String, String> {
            'body_0' => body0,
            'body_1' => body1,
            'bodyChunkCount' => '2'
        };

        System.assertEquals(body0 + body1, articleController.body, 'body should reassemble any stored chunks');
    }
}
