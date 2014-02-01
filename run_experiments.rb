#!/usr/bin/env ruby

require 'benchmark'

root_dir = Dir.getwd
puts "Testing"
models = Dir[File.join(Dir.getwd, "../test-models/**/*.als")]
models = models.select{|a| a =~ /spl/ }
puts models

moolloy_executable = File.join(Dir.getwd, "dist/alloy-dev.jar")
models.each do |model|
  puts "Running #{model}"
  # Create a directory for the model
  Dir.mkdir(File.join(root_dir, File.basename(model)))
  Dir.chdir(File.join(root_dir, File.basename(model)))
  
  # Run Moolloy
  File.open(File.join(root_dir, File.basename(model), "time.out"), "w") do |f|
    f.puts Benchmark.measure {
      puts `java -jar "#{moolloy_executable}" --SingleSolutionPerParetoPoint "#{model}" > stdout.out 2> stderr.out`
    }
  end
end

