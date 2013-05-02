glob = require 'glob'
path = require 'path'
printf = require 'printf'
_ = require 'underscore'

cwc = require './cwc-core'

normalizeSlashes = (string) -> string.replace(/\\/g, "/") #"#Fix syntax highlighting for broken editors
asArray = (input) ->
	return [] unless input?
	return input if _.isArray(input)
	return [input]

{argv, showHelp} = require('optimist')
	.describe('h', 'Show this help information.')
	.alias('h', '?')
	.alias('h', 'help')
	.describe('s', 'Files to count words in. This parameter may be specified multiple times. Supports wildcards.')
	.describe('d', 'Base directory for files.')
	.describe('n', 'Number of top results to show.')
	.default({'n': 25})
	.string(['s', 'd'])
	.boolean(['h'])
	.wrap(80)

if argv.h
	showHelp()
	return

maxCountsShown = argv.n
sources = (normalizeSlashes(source) for source in asArray(argv.s))
directory = normalizeSlashes(argv.d ? __dirname)
files = _.flatten(glob.sync(source, {cwd: directory}) for source in sources)
files = _.map files, (file) -> path.join directory, file

console.log "Counting in #{files.length} files"

wordCounts = cwc(files)
for [word, count] in _.first wordCounts, maxCountsShown
	console.log printf '% 10d :  %s', count, word
