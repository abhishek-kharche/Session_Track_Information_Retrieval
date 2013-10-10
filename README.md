This project belongs to the field of Information Retrieval. The project contained numerous files and corpus of size over
100 GB. The corpus had several xml and html files collected from internet. These files were actually the session of
users on particular website (in our case on a page). XML files were populated with lot of information such as title of
website, dwell time, time for which user were on that page etc. These XML files were parsed and certain information was
collected to find IR measurements such as precision, recall and most powerful nDCG. Relevancy was calculated for these
documents against the user queries, title tag from XML file was used to find if the result retrieved is actually
relevant of not. This project has 4 files, out of them 2 are the XML parsers. XML_parser is written in Java, it has been
used to extract the title tags from XML files and then parseXML was used to process these title according to the 
dwell time they had. The result of relevancy is then calculated and sortedResults.final is the file for final results.
