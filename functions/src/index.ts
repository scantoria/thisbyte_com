import * as functions from 'firebase-functions';
import * as nodemailer from 'nodemailer';

// Email configuration for contact form
const EMAIL_USER = 'support@thisbyte.com';
const EMAIL_PASS = 'zrlb isrd bvpn elbr';
const RECIPIENT_EMAIL = 'support@thisbyte.com';

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: EMAIL_USER,
    pass: EMAIL_PASS,
  },
});

export const sendContactEmail = functions.https.onCall(async (request) => {
  const { name, email, company, message } = request.data;

  // Validate required fields
  if (!name || !email || !message) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Name, email, and message are required.'
    );
  }

  const mailOptions = {
    from: EMAIL_USER,
    to: RECIPIENT_EMAIL,
    replyTo: email,
    subject: `New Contact Form Submission from ${name}`,
    html: `
      <h2>New Contact Form Submission</h2>
      <p><strong>Name:</strong> ${name}</p>
      <p><strong>Email:</strong> ${email}</p>
      <p><strong>Company:</strong> ${company || 'Not provided'}</p>
      <p><strong>Message:</strong></p>
      <p>${message}</p>
    `,
  };

  try {
    await transporter.sendMail(mailOptions);
    return { success: true };
  } catch (error) {
    console.error('Error sending email:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send email');
  }
});
