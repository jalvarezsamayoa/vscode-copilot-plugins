#!/usr/bin/env ruby
# Example: Using temporary files in Ruby

require 'tempfile'
require 'tmpdir'
require 'fileutils'

puts "✓ Example 1: Temporary file with auto-cleanup"

# Method 1: Using Tempfile with block (recommended)
Tempfile.open('example') do |f|
  f.write("Sample data\nLine 1\nLine 2\n")
  f.flush
  f.rewind

  puts "  Created: #{f.path}"
  puts "  Content: #{f.gets}"
end
puts "  Auto-cleaned up on exit\n\n"

puts "✓ Example 2: Temporary file with manual cleanup"

# Method 2: Manual cleanup with ensure
temp_file = Tempfile.new('example')
begin
  puts "  Created: #{temp_file.path}"
  temp_file.write("Manual cleanup example\n")
  temp_file.flush
  temp_file.rewind

  puts "  Content: #{temp_file.read}"
ensure
  temp_file.close
  temp_file.unlink  # Delete the file
  puts "  Manually cleaned up\n\n"
end

puts "✓ Example 3: Temporary directory"

# Create temporary directory with auto-cleanup
temp_dir = Dir.mktmpdir('tempdir')
begin
  puts "  Created: #{temp_dir}"

  # Create multiple files
  (1..3).each do |i|
    File.write(File.join(temp_dir, "file#{i}.txt"), "File #{i} content\n")
  end

  # List files
  files = Dir.entries(temp_dir).reject { |f| f.start_with?('.') }
  puts "  Files created: #{files.join(', ')}"
ensure
  FileUtils.remove_entry(temp_dir)  # Cleanup
  puts "  Cleaned up\n\n"
end

puts "✓ Example 4: Temporary script creation"

# Create and execute a temporary script
script = Tempfile.new('script', '.rb')
script_path = script.path
script.write(<<~RUBY)
  #!/usr/bin/env ruby
  puts "Temporary script running with args: #{ARGV.inspect}"
  exit 0
RUBY
script.close

begin
  File.chmod(0o755, script_path)
  output = `ruby #{script_path} arg1 arg2`
  puts "  #{output.strip}"
ensure
  File.delete(script_path) if File.exist?(script_path)
  puts "  Cleaned up\n\n"
end

puts "✓ Example 5: Multiple temp files with cleanup registry"

# Create multiple temp files with coordinated cleanup
temp_files = []
begin
  (1..3).each do |i|
    f = Tempfile.new("file#{i}")
    f.write("Content for file #{i}\n")
    f.flush
    temp_files << f
  end

  puts "  Created #{temp_files.length} temporary files"
  temp_files.each { |f| puts "    - #{f.path}" }
ensure
  temp_files.each { |f| f.close; f.unlink }
  puts "  All cleaned up\n\n"
end

puts "✓ Example 6: Using Tempfile with automatic deletion"

# Tempfile with delete flag
temp_file = Tempfile.new('delete-example', delete: true)
begin
  temp_file.write("This file will auto-delete\n")
  temp_file.flush
  puts "  Created: #{temp_file.path}"
  puts "  File exists: #{File.exist?(temp_file.path)}"
ensure
  # delete: true means unlink is called automatically on close
  temp_file.close!
  puts "  File exists after close: #{File.exist?(temp_file.path)}\n\n"
end

puts "✓ All examples completed"
