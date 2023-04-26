public with sharing class ManageQuoteController {

    @AuraEnabled(cacheable=true)
    public static QuoteDto getQuoteDetails( Id recordId) {
      return new QuoteDto([Select Id, Name,StartDate__c,EndDate__c,TotalQuotedAmount__c from Quote__c where Id =:recordId WITH SECURITY_ENFORCED]);
    }

    @AuraEnabled
    public static void updateQuoteDetails( String quoteDetailsJson) {
    try {
        system.debug(quoteDetailsJson);
        QuoteDto quoteDetails = (QuoteDto)JSON.deserialize(quoteDetailsJson, QuoteDto.class);
        system.debug(quoteDetails);
            Quote__c quote= QuoteDto.mapToQuote(quoteDetails);
            system.debug(quote);
            SObjectAccessDecision securityDecision = Security.stripInaccessible(
                                         AccessType.UPDATABLE, new List<Quote__c>{quote});

            // Secure update
            update securityDecision.getRecords();
        
        } catch (Exception e) {

            String errorMsg = e.getMessage();
            throw new AuraHandledException(ErrorMsg);
        }
    }
  
}