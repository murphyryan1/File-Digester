require 'json'
require 'digest'

def walk(start)

  hash = Hash.new { |hash, key| hash[key] = Hash.new(&h.default_proc) }

  Dir.entries(start).each do |file|
    path = File.join(start, file)
    next if file == "." or file==".."
    next if File.symlink?(path)
    File.directory?(path) ?
        hash[file] = walk(path) :
        hash[file] = { md5: hash_digest(path, :md5), sha1: hash_digest(path, :sha1) }
  end
  hash
end

def hash_digest(source, format)
  chunk_size=1024
  format == :md5 ? hash_format = Digest::MD5.new : hash_format = Digest::SHA1.new
    open(source) do |s|
    while chunk=s.read(chunk_size)
      hash_format.update chunk
    end
  end
  hash_format.hexdigest
end

puts (walk(ARGV[0])).to_json


