# coding: utf-8
require 'helper'

class GenHashValueFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    log_level trace
    keys id, time
    hash_type md5 # md5 or sha1 or sha256 or sha512
    base64_enc true
    set_key _id
    separator ,
  ]

  def create_driver(conf = CONFIG, tag='test')
    Fluent::Test::FilterTestDriver.new(Fluent::GenHashValueFilter, tag).configure(conf)
  end

  def test_configure
    #### set configurations
    # d = create_driver %[
    #   path test_path
    #   compress gz
    # ]
    #### check configurations
    # assert_equal 'test_path', d.instance.path
    # assert_equal :gz, d.instance.compress
  end

  def test_format
    d = create_driver

    # time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    # d.emit({"a"=>1}, time)
    # d.emit({"a"=>2}, time)

    # d.expect_format %[2011-01-02T13:14:15Z\ttest\t{"a":1}\n]
    # d.expect_format %[2011-01-02T13:14:15Z\ttest\t{"a":2}\n]

    # d.run
  end

  def test_write
    d = create_driver

    time = Time.parse("2011-01-02 13:14:15 UTC").to_i

    d.run do
      d.emit({"id"=>10, "time"=>100}, time)
      d.emit({"id"=>1, "time"=>100}, time)
      d.emit({"id"=>1, "time"=>10}, time)

      (0...10).each do |n|
        d.emit({"id"=>1+n, "time"=>time, "v"=>"日本語", "k"=>"値"}, time)
      end
    end

    # ### FileOutput#write returns path
#    ret = d.run
    filtered = d.filtered_as_array
    p filtered
    #expect_path = "#{TMP_DIR}/out_file_test._0.log.gz"
    #assert_equal expect_path, path
  end
end
