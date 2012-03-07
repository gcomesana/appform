package org.cnio.appform.util;

import java.util.Properties;
import java.util.Date;
import javax.mail.Session;
import javax.mail.Message;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.InternetAddress;
import javax.mail.Transport;


public class MailSender {

	private final String SMTP_SERVER = "smtp.cnio.es";
	private final String FROM = "gcomesana@cnio.es";
	private final String SUBJECT = "PanGene Application Form: New password as requested";
	private String msgBody="The new password for user %USER% is %PASSWD%";
	
	
	public MailSender () {
		
	}
	
	
/**
 * Send the new password message
 * @param to, the email of the user who requested new password
 * @param username, the username of this user
 * @param newPasswd, the new password
 */
	 public void send(String to, String username, String newPasswd)
	 {
	   try
	   {
	     Properties props = System.getProperties();
	// -- Attaching to default Session, or we could start a new one --
	     props.put("mail.smtp.host", SMTP_SERVER);
	     Session session = Session.getDefaultInstance(props, null);
	// -- Create a new message --
	     Message msg = new MimeMessage(session);
	// -- Set the FROM and TO fields --
	     msg.setFrom(new InternetAddress(FROM));
	     msg.setRecipients(Message.RecipientType.TO,
	       InternetAddress.parse(to, false));
	 // -- We could include CC recipients too --
	 // if (cc != null)
	 // msg.setRecipients(Message.RecipientType.CC
	 // ,InternetAddress.parse(cc, false));
	 // -- Set the subject and body text --
	     msg.setSubject(SUBJECT);
	     msgBody = msgBody.replaceFirst("%USER%", username);
	     msgBody = msgBody.replaceFirst("%PASSWD%", newPasswd);
	     msg.setText(msgBody);
	     // -- Set some other header information --
	//     msg.setHeader("X-Mailer", "LOTONtechEmail");
	     msg.setSentDate(new Date());
	     // -- Send the message --
	     
	     Transport.send(msg);
	//     System.out.println("Message sent OK.");
	   }
	   catch (Exception ex) {
	     ex.printStackTrace();
	   }
	}
}
	
