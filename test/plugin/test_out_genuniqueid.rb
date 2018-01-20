# coding: utf-8
require 'helper'

class GenHashValueFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::GenHashValueFilter).configure(conf)
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

  data("base" => {"base64_enc" => false,
                  "base91_enc" => false,
                  "expected" => "94666f1c6ecde15a182a8a165bd9c2a0"},
       "base64_enc" => {"base64_enc" => true,
                        "base91_enc" => false,
                        "expected" => "lGZvHG7N4VoYKooWW9nCoA=="},
       "base91_enc" => {"base64_enc" => false,
                        "base91_enc" => true,
                        "expected" => "VT.Jo=nV~PT7k<Cg=K`T"}
       )
  def test_md5(data)
    d = create_driver(%[
      keys id, time, v, k
      hash_type md5 # md5 or sha1 or sha256 or sha512 or mur128
      base64_enc "#{data["base64_enc"]}"
      base91_enc "#{data["base91_enc"]}"
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ])
    time = event_time("2011-01-02 13:14:15 UTC")
    time2 = event_time

    d.run(default_tag: 'test', shutdown: false) do
      d.feed(time, {"id"=>1, "time"=>time, "v"=>"日本語", "k"=>"値"})
      d.feed(time, {"id"=>1, "time"=>time, "v"=>"日本語", "k"=>"値"})
    end

    # ### FileOutput#write returns path
    filtered = d.filtered
    assert_equal 1, filtered[0][1]['id']
    assert_equal data["expected"], filtered[0][1]['_id']
  end

  data("base" => {"base64_enc" => false,
                  "base91_enc" => false,
                  "expected" => "04b34892838c50d7e05b2d7ac471485e02323282"},
       "base64_enc" => {"base64_enc" => true,
                        "base91_enc" => false,
                        "expected" => "BLNIkoOMUNfgWy16xHFIXgIyMoI="},
       "base91_enc" => {"base64_enc" => false,
                        "base91_enc" => true,
                        "expected" => "t1mz#vxE?]UntYN+)Xb1PjgMM"}
       )
  def test_sha1(data)
    d = create_driver(%[
      keys id, time, v, k
      hash_type sha1 # md5 or sha1 or sha256 or sha512 or mur128
      base64_enc "#{data["base64_enc"]}"
      base91_enc "#{data["base91_enc"]}"
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ])
    time = event_time("2011-01-02 13:14:15 UTC")
    time2 = event_time

    d.run(default_tag: 'test') do
      d.feed(time, {"id"=>1, "time"=>time, "v"=>"日本語", "k"=>"値"})
    end

    # ### FileOutput#write returns path
    filtered = d.filtered
    assert_equal 1, filtered[0][1]['id']
    assert_equal data["expected"], filtered[0][1]['_id']
  end

  data("base" => {"base64_enc" => false,
                  "base91_enc" => false,
                  "expected" => "faf53c1c9cc89e896b812f90ac77ad04447faece9eff6cbf62975c618c5ffb1f"},
       "base64_enc" => {"base64_enc" => true,
                        "base91_enc" => false,
                        "expected" => "+vU8HJzInolrgS+QrHetBER/rs6e/2y/YpdcYYxf+x8="},
       "base91_enc" => {"base64_enc" => false,
                        "base91_enc" => true,
                        "expected" => "q(gFR&W^=@/E3Y~^urp\"|~B\"B\"B\"B\"B\"B\"B\"B\"B\"\"\""}
       )
  def test_sha256(data)
    d = create_driver(%[
      keys id, time, v, k
      hash_type sha256 # md5 or sha1 or sha256 or sha512 or mur128
      base64_enc "#{data["base64_enc"]}"
      base91_enc "#{data["base91_enc"]}"
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ])
    time = event_time("2016-10-23 13:14:15 UTC")
    time2 = event_time

    d.run(default_tag: 'test') do
      d.feed(time, {"id"=>1, "time"=>time, "time2"=>time2, "v"=>"日本語", "k"=>"値"})
    end

    # ### FileOutput#write returns path
    filtered = d.filtered
    assert_equal 1, filtered[0][1]['id']
    assert_equal data["expected"], filtered[0][1]['_id']
  end

  data("base" => {"base64_enc" => false,
                  "base91_enc" => false,
                  "expected" =>"a9188951cec474bf5a0704f3fefc00f9e903d0190c7daed5cca1a190346d508da640a939b25b2455d0acdd2ad6c49c218ac31e3fb6a70c7ae2838e4cfab955fc"},
       "base64_enc" => {"base64_enc" => true,
                        "base91_enc" => false,
                        "expected" => "qRiJUc7EdL9aBwTz/vwA+ekD0BkMfa7VzKGhkDRtUI2mQKk5slskVdCs3SrWxJwhisMeP7anDHrig45M+rlV/A=="},
       "base91_enc" => {"base64_enc" => false,
                        "base91_enc" => true,
                        "expected" => "J+go,3[a^sfK`hA\"/C1~)CZ3Mvj%X}J@M1Nbz4cmm4q[ks,Mj2u}NeKsQ_WOL<RWkWNu|*G^u6h_x]f"}
       )
  def test_sha512(data)
    d = create_driver(%[
      keys id, time, v, k
      hash_type sha512 # md5 or sha1 or sha256 or sha512 or mur128
      base64_enc "#{data["base64_enc"]}"
      base91_enc "#{data["base91_enc"]}"
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ])
    time = event_time("2016-10-23 13:14:15 UTC")
    time2 = event_time

    d.run(default_tag: 'test') do
      d.feed(time, {"id"=>1, "time"=>time, "time2"=>time2, "v"=>"日本語", "k"=>"値"})
    end

    # ### FileOutput#write returns path
    filtered = d.filtered
    assert_equal 1, filtered[0][1]['id']
    assert_equal data["expected"], filtered[0][1]['_id']
  end

  data("base" => {"base64_enc" => false,
                  "base91_enc" => false,
                  "expected" =>"c283c0806dc63da6f66eda61a044537c"},
       "base64_enc" => {"base64_enc" => true,
                        "base91_enc" => false,
                        "expected" => "woPAgG3GPab2btphoERTfA=="},
       "base91_enc" => {"base64_enc" => false,
                        "base91_enc" => true,
			"expected" => "1KU!R=v=s`F&[U3?S2_K"}
       )
  def test_mur128(data)
    d = create_driver(%[
      keys id, time, v, k
      hash_type mur128 # md5 or sha1 or sha256 or sha512 or mur128
      base64_enc "#{data["base64_enc"]}"
      base91_enc "#{data["base91_enc"]}"
      set_key _id
      separator ,
      inc_time_as_key false
      inc_tag_as_key false
    ])
    time = event_time("2016-10-23 13:14:15 UTC")
    time2 = event_time

    d.run(default_tag: 'test') do
      d.feed(time, {"id"=>1, "time"=>time, "time2"=>time2, "v"=>"日本語", "k"=>"値"})
    end

    # ### FileOutput#write returns path
    filtered = d.filtered
    assert_equal 1, filtered[0][1]['id']
    assert_equal data["expected"], filtered[0][1]['_id']
  end
end

