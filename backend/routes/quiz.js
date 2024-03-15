const express = require("express");
const User = require("../models/usermodel");
const router = express.Router();

router.post("/result", async (req, res) => {
  try {
    const { score, email } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: "user not found" });
    }
    user.Score = score;
    await user.save();
    res.status(200).json({ message: "Success" });
  } catch (error) {
    console.error("Error:", error);
    res.status(500).send("Internal Server Error");
  }
});

router.post("/complete/:number", async (req, res) => {
  try {
    const { email } = req.body;
    const number = req.params.number;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: "user not found" });
    }

    if (number == 1) {
      user.isQuiz1Finished = true;
    }
    
    if (number == 2) {
      user.isQuiz2Finished = true;
    }
    
    if (number == 3) {
      user.isQuiz3Finished = true;
    }

    await user.save();
    res.send();

  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "internal server error" });
  }
});

router.post("/retry/:number", async (req, res) => {
  try {
    const number = req.params.number;
    const { email } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: "user not found" });
    }
    if (number == 1) {
      user.quiz1Retry = user.quiz1Retry - 1;
    }
    if (number == 2) {
      user.quiz2Retry = user.quiz2Retry - 1;
    }
    if (number == 3) {
      user.quiz3Retry = user.quiz3Retry - 1;
    }
    await user.save();
    return res.status(200).send();
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "internal server error" });
  }
});

module.exports = router;
