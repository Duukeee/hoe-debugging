class Hoe #:nodoc:

  # Whee, stuff to help when your codes are b0rked. Tasks provided:
  #
  # * <tt>test:gdb</tt>
  # * <tt>test:valgrind</tt>
  # * <tt>test:valgrind:mem</tt>
  # * <tt>test:valgrind:mem0</tt>

  module Debugging
    VERSION = "1.0.0" #:nodoc:

    ##
    # Optional: Used to add flags to GDB. [default: <tt>[]</tt>]

    attr_accessor :gdb_options

    ##
    # Optional: Used to add flags to valgrind. [default:
    # <tt>%w(--num-callers=50 --error-limit=no --partial-loads-ok=yes
    # --undef-value-errors=no)</tt>]

    attr_accessor :valgrind_options

    def initialize_debugging #:nodoc:
      self.gdb_options = []

      self.valgrind_options = ["--num-callers=50",
                               "--error-limit=no",
                               "--partial-loads-ok=yes",
                               "--undef-value-errors=no"]
    end

    def define_debugging_tasks #:nodoc:
      if File.directory? "test" then
        desc "Run the test suite under GDB."
        task "test:gdb" do
          sh "gdb #{gdb_options.join ' '} --args #{RUBY} #{make_test_cmd}"
        end

        desc "Run the test suite under Valgrind."
        task "test:valgrind" do
          sh "valgrind #{valgrind_options.join ' '} #{RUBY} #{make_test_cmd}"
        end

        desc "Run the test suite under Valgrind with memory-fill."
        task "test:valgrind:mem" do
          sh "valgrind #{valgrind_options.join ' '} " +
             "--freelist-vol=100000000 --malloc-fill=6D --free-fill=66 " +
             "#{RUBY} #{make_test_cmd}"
        end

        desc "Run the test suite under Valgrind with memory-zero."
        task "test:valgrind:mem0" do
          sh "valgrind #{valgrind_options.join ' '} " +
             "--freelist-vol=100000000 --malloc-fill=00 --free-fill=00 " +
             "#{RUBY} #{make_test_cmd}"
        end
      end
    end
  end
end