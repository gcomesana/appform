package org.cnio.appform.util;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.mail.event.*;
import javax.activation.*;

/**
 * TransporSender class is a simple class to send a message through a corporative
 * mail system and uses authentication to be able to send emails out of the 
 * organization scope, as the corporative SMTP servers need authentication to do it.
 */
public class TransportSender implements ConnectionListener, TransportListener {
	
	private final String FROM = "noreply@cnio.es";
	private final String EMAIL_FROM = "Application Form System";
	private String strTo = "piribi@gmail.com";
	private final String SMTP_HOST = "smtp.cnio.es"; 
	
	private final String CLASSNAME = "TransportSender: ";
	private final String HOST_AUTH 	= "Run3ks_1";
	
	
	
	public TransportSender() {
	
	}
	
	
	
	public void send (String to, String subject, String body) throws java.io.UnsupportedEncodingException {
		Properties props = System.getProperties();
// parse the arguments
		InternetAddress[] addrs = null;
		InternetAddress from;
		boolean debug = false;
			
		props.put("mail.smtp.host", SMTP_HOST);
// parse the destination addresses
		try {
			addrs = InternetAddress.parse(to, false);
//			from = new InternetAddress(strFrom);
		} 
		catch (AddressException aex) {
			System.out.println("Invalid Address");
			aex.printStackTrace();
			return;
		}
// create some properties and get a Session
		Session session = Session.getInstance(props, null);
		session.setDebug(debug);

		TransportSender t = new TransportSender();
		t.go(session, addrs, subject, body);
	}


	
	
	public void go (Session session, InternetAddress[] toAddr, 
									String subject, String body) throws java.io.UnsupportedEncodingException {
		Transport trans = null;

		try {
			InternetAddress from = new InternetAddress (FROM, EMAIL_FROM);
			
// create a message
			Message msg = new MimeMessage(session);
			msg.setFrom(from);
			msg.setRecipients(Message.RecipientType.TO, toAddr);
//			msg.setSubject("JavaMail APIs transport.java Test");
			msg.setSubject(subject);
			msg.setSentDate(new Date()); // Date: header
//			msg.setContent(msgText + msgText2, "text/plain");
			msg.setContent(body, "text/plain;charset=UTF-8");
			msg.setReplyTo(null);
			msg.saveChanges();

			// get the smtp transport for the address
			trans = session.getTransport(toAddr[0]);

// register ourselves as listener for ConnectionEvents
// and TransportEvents
//			trans.addConnectionListener(this);
			trans.addTransportListener(this);

			// connect the transport
//			trans.connect();
			trans.connect(session.getProperty("mail.smtp.host"), "gcomesana", HOST_AUTH);

			// send the message
			trans.sendMessage(msg, toAddr);

			// give the EventQueue enough time to fire its events
			try {
				Thread.sleep(5);
			} catch (InterruptedException e) {
			}

		} 
		catch (MessagingException mex) {
			// give the EventQueue enough time to fire its events
			try {
				Thread.sleep(5);
			} 
			catch (InterruptedException e) {
			}

			System.out.println(CLASSNAME+"Sending failed with exception:");
			mex.printStackTrace();
			System.out.println();
			Exception ex = mex;
			do {
				if (ex instanceof SendFailedException) {
					SendFailedException sfex = (SendFailedException) ex;
					Address[] invalid = sfex.getInvalidAddresses();
					if (invalid != null) {
						System.out.println(CLASSNAME+"    ** Invalid Addresses");
						if (invalid != null) {
							for (int i = 0; i < invalid.length; i++)
								System.out.println(CLASSNAME+"         " + invalid[i]);
						}
					}
					Address[] validUnsent = sfex.getValidUnsentAddresses();
					if (validUnsent != null) {
						System.out.println(CLASSNAME+"    ** ValidUnsent Addresses");
						if (validUnsent != null) {
							for (int i = 0; i < validUnsent.length; i++)
								System.out.println(CLASSNAME+"         " + validUnsent[i]);
						}
					}
					Address[] validSent = sfex.getValidSentAddresses();
					if (validSent != null) {
						System.out.println(CLASSNAME+"    ** ValidSent Addresses");
						if (validSent != null) {
							for (int i = 0; i < validSent.length; i++)
								System.out.println(CLASSNAME+"         " + validSent[i]);
						}
					}
				}
				System.out.println();
				if (ex instanceof MessagingException)
					ex = ((MessagingException) ex).getNextException();
				else
					ex = null;
			} while (ex != null);
			
		} 
		finally {
			try {
				// close the transport
				if (trans != null)
					trans.close();
			} 
			catch (MessagingException mex) { /* ignore */
			}
		}
	}

	// implement ConnectionListener interface
	public void opened(ConnectionEvent e) {
		System.out.println(">>> ConnectionListener.opened()");
	}

	public void disconnected(ConnectionEvent e) {
	}

	public void closed(ConnectionEvent e) {
		System.out.println(">>> ConnectionListener.closed()");
	}

	// implement TransportListener interface
	public void messageDelivered(TransportEvent e) {
		System.out.println(CLASSNAME+">>> TransportListener.messageDelivered().");
		System.out.println(CLASSNAME+" Valid Addresses:");
		Address[] valid = e.getValidSentAddresses();
		if (valid != null) {
			for (int i = 0; i < valid.length; i++)
				System.out.println("    " + valid[i]);
		}
	}

	public void messageNotDelivered(TransportEvent e) {
		System.out.println(CLASSNAME+">>> TransportListener.messageNotDelivered().");
		System.out.println(CLASSNAME+" Invalid Addresses:");
		Address[] invalid = e.getInvalidAddresses();
		if (invalid != null) {
			for (int i = 0; i < invalid.length; i++)
				System.out.println("    " + invalid[i]);
		}
	}

	public void messagePartiallyDelivered(TransportEvent e) {
		System.out.println(CLASSNAME+">>> TransportListener.messagePartiallyDelivered().");
		System.out.println(CLASSNAME+" Valid Addresses:");
		Address[] valid = e.getValidSentAddresses();
		if (valid != null) {
			for (int i = 0; i < valid.length; i++)
				System.out.println("    " + valid[i]);
		}
		System.out.println(CLASSNAME+" Valid Unsent Addresses:");
		Address[] unsent = e.getValidUnsentAddresses();
		if (unsent != null) {
			for (int i = 0; i < unsent.length; i++)
				System.out.println(CLASSNAME+"    " + unsent[i]);
		}
		System.out.println(CLASSNAME+" Invalid Addresses:");
		Address[] invalid = e.getInvalidAddresses();
		if (invalid != null) {
			for (int i = 0; i < invalid.length; i++)
				System.out.println(CLASSNAME+"    " + invalid[i]);
		}
	}

	private static void usage() {
		System.out
				.println("usage: java transport \"<to1>[, <to2>]*\" <from> <smtp> true|false");
		System.out
				.println("example: java transport \"joe@machine, jane\" senderaddr smtphost false");
	}
}
