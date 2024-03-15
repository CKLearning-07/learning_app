const mongoose = require("mongoose");
const schema = mongoose.Schema;

const userSchema = new schema(
  {
    username: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
    },
    college: {
      type: String,
      required: true,
    },
    branch: {
      type: String,
      required: true,
    },
    phno: {
      type: String,
      required: true,
    },
    city: {
      type: String,
      required: true,
    },
    password: {
      type: String,
      required: true,
    },
    otpSecret: {
      type: String,
    },
    Score: {
      type: Number,
      default: 0,
    },
    Module: {
      type: Array,
      default: Array(5).fill(false),
    },
    introduction: {
      type: Boolean,
      default: true,
    },
    isQuiz1Finished: {
      type: Boolean,
      default: false,
    },
    isQuiz2Finished: {
      type: Boolean,
      default: false,
    },
    isQuiz3Finished: {
      type: Boolean,
      default: false,
    },
    quiz1Retry: {
      type: Number,
      default: 3,
    },
    quiz2Retry: {
      type: Number,
      default: 3,
    },
    quiz3Retry: {
      type: Number,
      default: 3,
    },
    caseStudy1: {
      type: String,
    },
    caseStudy2: {
      type: String,
    },
    caseStudy3: {
      type: String,
    },
    caseStudy4: {
      type: String,
    },
    caseStudy5: {
      type: String,
    },
    nop: {
      type: Number,
      default: 0,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("users", userSchema);
