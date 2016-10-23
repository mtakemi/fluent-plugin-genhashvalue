# coding: utf-8
require 'helper'

class GenHashValueFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf = CONFIG, tag='test')
    Fluent::Test::FilterTestDriver.new(Fluent::GenHashValueFilter, tag).configure(conf)
  end

  def test_configure
    #### set configurations
    d = create_driver %[
      keys id, time
    ]
    #### check configurations
    assert_equal 'sha256', d.instance.hash_type
    assert_equal false, d.instance.base64_enc
    assert_equal '_', d.instance.separator
    assert_equal '_hash', d.instance.set_key
    assert_equal ['id', 'time'], d.instance.keys

    d = create_driver %[
      keys id2
      hash_type md5
      base64_enc true
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ]
    #### check configurations
    assert_equal 'md5', d.instance.hash_type
    assert_equal true, d.instance.base64_enc
    assert_equal ',', d.instance.separator
    assert_equal '_id', d.instance.set_key
    assert_equal ['id2'], d.instance.keys
  end


  def test_md5
    d = create_driver(%[
      keys id, time, v, k
      hash_type md5 # md5 or sha1 or sha256 or sha512
      base64_enc false
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ])
    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    time2 = Time.now.to_i

    d.run do
      d.emit({"id"=>1, "time"=>time, "v"=>"日本語", "k"=>"値"}, time)
      d.emit({"id"=>1, "time"=>time, "v"=>"日本語", "k"=>"値"}, time)
    end

    # ### FileOutput#write returns path
    filtered = d.filtered_as_array
    assert_equal 1, filtered[0][2]['id']
    assert_equal "94666f1c6ecde15a182a8a165bd9c2a0", filtered[0][2]['_id']

    d.instance.base64_enc = true

    d.run do
      d.emit({"id"=>1, "time"=>time, "v"=>"日本語", "k"=>"値"}, time)
    end
    filtered = d.filtered_as_array
    assert_equal 1, filtered[0][2]['id']
    assert_equal "lGZvHG7N4VoYKooWW9nCoA==", filtered[0][2]['_id']
  end

  def test_sha1
    d = create_driver(%[
      keys id, time, v, k
      hash_type sha1 # md5 or sha1 or sha256 or sha512
      base64_enc false
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ])
    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    time2 = Time.now.to_i

    d.run do
      d.emit({"id"=>1, "time"=>time, "v"=>"日本語", "k"=>"値"}, time)
    end

    # ### FileOutput#write returns path
    filtered = d.filtered_as_array
    assert_equal 1, filtered[0][2]['id']
    assert_equal "04b34892838c50d7e05b2d7ac471485e02323282", filtered[0][2]['_id']

    d.instance.base64_enc = true

    d.run do
      d.emit({"id"=>1, "time"=>time, "v"=>"日本語", "k"=>"値"}, time)
    end
    filtered = d.filtered_as_array
    assert_equal 1, filtered[0][2]['id']
    assert_equal "BLNIkoOMUNfgWy16xHFIXgIyMoI=", filtered[0][2]['_id']
  end

  def test_sha256
    d = create_driver(%[
      keys id, time, v, k
      hash_type sha256 # md5 or sha1 or sha256 or sha512
      base64_enc false
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ])
    time = Time.parse("2016-10-23 13:14:15 UTC").to_i
    time2 = Time.now.to_i

    d.run do
      d.emit({"id"=>1, "time"=>time, "time2"=>time2, "v"=>"日本語", "k"=>"値"}, time)
    end

    # ### FileOutput#write returns path
    filtered = d.filtered_as_array
    assert_equal 1, filtered[0][2]['id']
    assert_equal "faf53c1c9cc89e896b812f90ac77ad04447faece9eff6cbf62975c618c5ffb1f", filtered[0][2]['_id']

    d.instance.base64_enc = true

    d.run do
      d.emit({"id"=>1, "time"=>time, "v"=>"日本語", "k"=>"値"}, time)
    end
    filtered = d.filtered_as_array
    assert_equal 1, filtered[0][2]['id']
    assert_equal "+vU8HJzInolrgS+QrHetBER/rs6e/2y/YpdcYYxf+x8=", filtered[0][2]['_id']
  end

  def test_sha512
    d = create_driver(%[
      keys id, time, v, k
      hash_type sha512 # md5 or sha1 or sha256 or sha512
      base64_enc false
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ])
    time = Time.parse("2016-10-23 13:14:15 UTC").to_i
    time2 = Time.now.to_i

    d.run do
      d.emit({"id"=>1, "time"=>time, "time2"=>time2, "v"=>"日本語", "k"=>"値"}, time)
    end

    # ### FileOutput#write returns path
    filtered = d.filtered_as_array
    assert_equal 1, filtered[0][2]['id']
    assert_equal "a9188951cec474bf5a0704f3fefc00f9e903d0190c7daed5cca1a190346d508da640a939b25b2455d0acdd2ad6c49c218ac31e3fb6a70c7ae2838e4cfab955fc",
                 filtered[0][2]['_id']

    d.instance.base64_enc = true

    d.run do
      d.emit({"id"=>1, "time"=>time, "v"=>"日本語", "k"=>"値"}, time)
    end
    filtered = d.filtered_as_array
    assert_equal 1, filtered[0][2]['id']
    assert_equal "qRiJUc7EdL9aBwTz/vwA+ekD0BkMfa7VzKGhkDRtUI2mQKk5slskVdCs3SrWxJwhisMeP7anDHrig45M+rlV/A==", filtered[0][2]['_id']

    d.instance.keys = ['time2']
    d.instance.base64_enc = false
    d.run do
      d.emit({"id"=>1, "time"=>time, "time2"=>time2, "v"=>"日本語", "k"=>"値"}, time)
    end
    filtered = d.filtered_as_array
    assert_equal Digest::SHA512::hexdigest(time2.to_s), filtered[0][2]['_id']
  end
end
