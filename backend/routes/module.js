const express = require("express");
const User = require("../models/usermodel");
const router = express.Router();
const Module = require("../models/modulemodel");

router.post("/complete", async (req, res) => {
  try {
    const { email, module } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: "user not found" });
    }
    if (user.Module[module] == false) {
      user.Module[module] = true;
      await user.save();
      res.status(200).send({ completed: false });
    } else {
      res.status(200).send({ completed: true });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "internal server error" });
  }
});

router.get("/check", async (req, res) => {
  try {
    const data = await Module.findOne({});
    res.json({ isCaseStudyOpen: data.isCaseStudyOpen });
  } catch (error) {
    res.status(400).json({ message: "Internal server error" });
  }
});

router.post("/NOP", async (req, res) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });
    res.json({ nop: user.nop });
  } catch (error) {
    console.log(error);
    res.status(400).json({ message: "Internal server error" });
  }
});

module.exports = router;
