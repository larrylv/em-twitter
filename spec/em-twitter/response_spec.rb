require 'spec_helper'

describe EM::Twitter::Response do

  describe '.new' do
    it 'initializes an empty body' do
      EM::Twitter::Response.new.body.should eq('')
    end

    it 'initializes with a body parameter' do
      EM::Twitter::Response.new('ohai').body.should eq('ohai')
    end
  end

  describe '#concat' do
    it 'sets the body when empty' do
      @response = EM::Twitter::Response.new
      @response.concat('{ "status" : true }')
      @response.body.should eq('{ "status" : true }')
    end

    it 'appends to an existing body' do
      @response = EM::Twitter::Response.new('{ "status" : true')
      @response.concat(', "enabled" : false }')
      @response.body.should eq('{ "status" : true, "enabled" : false }')
    end

    it 'only appends when passed json' do
      str = '{ "status" : true'
      @response = EM::Twitter::Response.new(str)
      @response.concat('ohai')
      @response.body.should eq(str)
    end

    it 'passively fails on nil' do
      @response = EM::Twitter::Response.new
      lambda {
        @response.concat(nil)
      }.should_not raise_error
    end

    it 'passively fails on empty strings' do
      @response = EM::Twitter::Response.new('ohai')
      @response.concat('')
      @response.body.should eq('ohai')
    end

    it 'passively fails on blank strings' do
      @response = EM::Twitter::Response.new('ohai')
      @response.concat('  ')
      @response.body.should eq('ohai')
    end

    it 'is aliased as <<' do
      @response = EM::Twitter::Response.new
      @response << '{ "status" : true }'
      @response.body.should eq('{ "status" : true }')
    end
  end

  describe '#complete?' do
    it 'returns false when an incomplete body' do
      EM::Twitter::Response.new('{ "status" : true').complete?.should be_false
    end

    it 'returns false when an complete body' do
      EM::Twitter::Response.new('{ "status" : true }').complete?.should be_true
    end
  end
end