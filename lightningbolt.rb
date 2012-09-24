# LightningBolt - Centroid-based autosummarize for those who miss MS Word Autosummarize
# by Matt Parmett

# idf = log(N/n), N = number of words in document, n = number of occurrences of the word
# Assumptions:
#	Sentences are split by newlines (treats paragraphs as sentence units for now...less granularity but easier testing and possibly more coherent summaries)
#	Uses single-document frequency of words instead of a cluster of documents, therefore @centroid is not the true centroid

class LightningBolt
	attr_accessor :file_path, :file, :text, :words, :sentences, :centroid, :word_scores, :sentences, :sentence_scores, :summary
	
	def initialize(file_path)
		@file_path = file_path
		@file = File.open(@file_path, 'rb')
		@text = @file.read
		@words = @text.split(" ").map { |w| w.downcase.strip_punct }
		@sentences = @text.split("\n").map {|s| s.strip }
	end
	
	def calculate_freq(word)
		word = word.downcase.strip_punct
		occurrences = 0
		@words.each { |w| occurrences = occurrences + 1 if w == word }
		return occurrences
	end
	
	def calculate_idf(word)
		occurrences = self.calculate_freq(word)
		return Math.log(@words.length / occurrences)
	end
	
	def centroid(threshold_score = @words.length / 28)
		#Generate hash of words and scores
		@centroid = {}
		@word_scores = {}
		@words.each { |w| @word_scores[w] = 0 }
		
		@word_scores.each_pair do |word, score|
			word = word.downcase.strip_punct
			tfidf = self.calculate_freq(word) * self.calculate_idf(word)
			@word_scores[word] = tfidf
			@centroid[word] = tfidf if tfidf > threshold_score
		end
		
		return @centroid
	end
	
	def compute_sentence_scores()
		@sentence_scores = {}
		@sentences.each do |sentence|
			sentence_score = 0
			sentence.split(" ").each do |word|
				sentence_score = sentence_score + @centroid[word.downcase.strip_punct] if @centroid[word.downcase.strip_punct]
			end
			@sentence_scores[sentence] = sentence_score
		end
		return @sentence_scores
	end
	
	def summarize(threshold_score = @words.length / 28)
		# Generate centroid scores
		self.centroid(threshold_score)
		
		# Get hash of important sentences and their centroid scores
		sentences = self.compute_sentence_scores()
		
		# Construct summary
		summary_sentences = []
		sentences.each_pair do |sentence, score|
			summary_sentences << sentence if score > 50 * threshold_score
		end
		@summary = summary_sentences.join("\n\n")
		
		return @summary
	end
	
	def self.summarize(file_path, threshold_score)
		lb = self.new(file_path)
		return lb.summarize(threshold_score)
	end
end

class String
	def strip_punct()
		self.gsub(/[[:punct:]]/,'')
	end
end