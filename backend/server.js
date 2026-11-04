const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const Contact = require("./Contact");

const app = express();
const PORT = 5000;

// Middleware
app.use(cors());
app.use(express.json());

// MongoDB connection
mongoose
  .connect("mongodb://mongodb:27017/contactdb")
  .then(() => console.log("MongoDB connected successfully"))
  .catch((error) => console.error("MongoDB connection error:", error));

// Create contact
app.post("/api/contacts", async (req, res) => {
  try {
    const { name, email, subject, message } = req.body;

    if (!name || !email || !subject || !message) {
      return res.status(400).json({
        message: "All fields are required",
      });
    }

    const contact = await Contact.create({
      name,
      email,
      subject,
      message,
    });

    res.status(201).json({
      message: "Contact submitted successfully",
      contact,
    });
  } catch (error) {
    res.status(500).json({
      message: "Failed to submit contact",
    });
  }
});

// Get all contacts
app.get("/api/contacts", async (req, res) => {
  try {
    const contacts = await Contact.find().sort({ createdAt: -1 });

    res.json(contacts);
  } catch (error) {
    res.status(500).json({
      message: "Failed to fetch contacts",
    });
  }
});

// Health check
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "Backend is healthy",
  });
});

app.listen(PORT, () => {
  console.log(`Backend running on port ${PORT}`);
});