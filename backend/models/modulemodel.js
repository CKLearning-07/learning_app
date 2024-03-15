const mongoose = require("mongoose");
const schema = mongoose.Schema;

const moduleSchema = new schema({
  isCaseStudyOpen: {
    type: Boolean,
  },
});

module.exports = mongoose.model("module", moduleSchema);
