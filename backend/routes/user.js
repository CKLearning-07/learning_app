const express = require("express");
const bcrypt = require("bcrypt");
const router = express.Router();
const jwt = require("jsonwebtoken");
const User = require("../models/usermodel");
const Module = require("../models/modulemodel");

router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find the user by username
    const module = await Module.findOne({});
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Compare the provided password with the hashed password
    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Generate a JWT token
    const token = jwt.sign(
      { id: user._id, email: user.email },
      process.env.SECRET_KEY
    );

    let progress = 0;

    user.Module.forEach((ele) => {
      if (ele) {
        progress++;
      }
    });

    console.log(progress);

    res.json({
      token,
      email: user.email,
      phno: user.phno,
      userId: user._id,
      college: user.college,
      branch: user.branch,
      city: user.city,
      intro: user.introduction,
      username: user.username,
      progress: user.Module,
      caseStudy1: user.caseStudy1 === String,
      caseStudy2: user.caseStudy2 === String,
      caseStudy3: user.caseStudy3 === String,
      caseStudy4: user.caseStudy4 === String,
      caseStudy5: user.caseStudy5 === String,
      isQuiz1Finished: user.isQuiz1Finished,
      isQuiz2Finished: user.isQuiz2Finished,
      isQuiz3Finished: user.isQuiz3Finished,
      quiz1Retry: user.quiz1Retry,
      quiz2Retry: user.quiz2Retry,
      quiz3Retry: user.quiz3Retry,
      nop: user.nop,
      isCaseStudyOpen: module.isCaseStudyOpen,
    });

    //set the introduction to true

    if (user.introduction == true) {
      user.introduction = false;
      await user.save();
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

router.post("/register", async (req, res) => {
  try {
    const { username, email, phno, college, branch, city } = req.body;
    let { password } = req.body;

    // Check if username already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "Username already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    password = hashedPassword;

    const newUser = new User({
      username,
      email,
      password,
      phno,
      college,
      branch,
      city,
    });
    await newUser.save();
    console.log("user registered");
    res.status(201).json({ message: "User registered successfully" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

module.exports = router;
