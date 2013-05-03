fs = require 'fs'
_ = require 'underscore'

exports = module.exports = (files) ->
	regex = /[A-Z]+(?![a-z])|\b([A-Za-z][a-z]*)|(?![a-z0-9])([A-Z][a-z]+)/g
	fileCounts = (for filename in files
		contents = fs.readFileSync(filename).toString()
		words = contents.match regex
		words = _.map words, (word) -> word.toLowerCase()
		_.countBy words, _.identity)

	wordCounts = _.reduce fileCounts, ((memo, fileCount) ->
		for word, count of fileCount
			memo[word] = if memo[word]? then memo[word] + count else count
		memo
	), {}
	wordCounts = _.pairs wordCounts
	wordCounts = _.sortBy wordCounts, ([word, count]) -> -count
	return wordCounts