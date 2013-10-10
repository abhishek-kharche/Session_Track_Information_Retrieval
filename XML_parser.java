import java.io.File;

import javax.xml.parsers.DocumentBuilder;							// XML parser in Java
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class XML_parser {

	public static void main(String[] args) throws Exception {
		int d = Integer.parseInt(args[0]);
		int d1 = Integer.parseInt(args[1]);
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();	// Create an instance to DocumentBuilderFactory package
		DocumentBuilder db = dbf.newDocumentBuilder();
		Document document = db.parse(new File("session.xml"));				// select xml file to be parsed
		
		Node rootNode = document.getDocumentElement();						// Package specific oo data type
		NodeList Sessiontrack = rootNode.getChildNodes();					// Package specific oo data type

		for(int i=1;i<Sessiontrack.getLength();i=i+2){
			
			Node session = Sessiontrack.item(i);
			NodeList Interactions = session.getChildNodes();

			for(int j=3;j<Interactions.getLength()-2;j=j+2){
				Node Interaction = Interactions.item(j);

				double max = -32768;
				int maxIndex = -1;
				NodeList Clicks = Interaction.getChildNodes().item(5).getChildNodes();
				
				if(Clicks.getLength() < 2 && i/2+1==d && j/2==d1)
				{
					System.out.println("0");
					continue;
				}

				for(int k=1;k<Clicks.getLength();k=k+2){
					Node click = Clicks.item(k);
				
					String str1 = click.getAttributes().getNamedItem("starttime").getNodeValue();	// Explore through tag attributes
					String str2 = click.getAttributes().getNamedItem("endtime").getNodeValue();		// Explore through tag attributes

					String minutes = str1.substring(3, 5);											// Select specific values
					int m = Integer.parseInt(minutes)*60;
					String seconds = str1.substring(6);
					double s = Double.parseDouble(seconds);
					double starttime = m+s;

					String minutes1 = str2.substring(3, 5);
					int m1 = Integer.parseInt(minutes1)*60;
					String seconds1 = str2.substring(6);
					double s1 = Double.parseDouble(seconds1);
					double endtime = m1+s1;

					double dwelltime = endtime - starttime;
					
					if(dwelltime > max)																// Finding maximum dwell time
					{
						max = dwelltime;
						maxIndex = Integer.parseInt( click.getChildNodes().item(1).getTextContent() );						
					}
				}

				NodeList Results = Interaction.getChildNodes().item(3).getChildNodes();
																									// Print formatted output
				for(int k=1;k<Results.getLength();k=k+2){
					Node result = Results.item(k);
					if(Integer.parseInt(result.getAttributes().getNamedItem("rank").getNodeValue()) == maxIndex)
					{						
						if (i/2+1==d && j/2==d1)
						{
												
							System.out.println(result.getChildNodes().item(3).getTextContent());
							System.out.println(result.getChildNodes().item(5).getTextContent());
						}
					}
				}
			}
		}
	}	
}

