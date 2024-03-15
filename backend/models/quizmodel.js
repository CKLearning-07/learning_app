const mongoose = require("mongoose");

const Quiz = mongoose.model("question", {}, "questions");

const fetchQuestions = () => {
  return Quiz.find({})
    .exec()
    .then((questions) => questions) // Assuming you want to wrap questions in an array
    .catch((err) => {
      console.error("Error fetching questions:", err);
      throw err; // Re-throw the error so it can be caught further up the call stack if needed
    });
};

module.exports = fetchQuestions;
