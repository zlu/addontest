require 'spec_helper'

describe Connfu::Dsl do
  class DslTest
    include Connfu::Dsl
  end

  before do
    Connfu.adaptor = TestConnection.new
    subject.stub(:wait)
  end

  subject {
    DslTest.new(:from => "server-address", :to => "client-address")
  }

  describe 'say' do
    it 'should send Say command to adaptor' do
      text = 'connfu is awesome'
      Connfu.adaptor.should_receive(:send_command).with(Connfu::Commands::Say.new(:text => text, :from => 'client-address', :to => 'server-address'))
      catch :waiting do
        subject.say(text)
      end
    end
  end

  describe 'hangup' do
    it 'should send Hangup command to adaptor' do
      Connfu.adaptor.should_receive(:send_command).with(Connfu::Commands::Hangup.new(:from => 'client-address', :to => 'server-address'))
      subject.hangup
    end
  end

  describe 'reject' do
    it 'should send Reject command to adaptor' do
      Connfu.adaptor.should_receive(:send_command).with(Connfu::Commands::Reject.new(:from => 'client-address', :to => 'server-address'))
      subject.reject
    end
  end

  describe 'redirect' do
    it 'should send Redirect command to adaptor' do
      redirect_to = 'sip:1652@connfu.com'
      Connfu.adaptor.should_receive(:send_command).with(Connfu::Commands::Redirect.new(:redirect_to => redirect_to, :from => 'client-address', :to => 'server-address'))
      subject.redirect(redirect_to)
    end
  end

  describe 'transfer' do
    before :each do
      subject.stub(:wait_for).and_return(Connfu::Event::TransferSuccess.new)
    end

    it 'should send Transfer command to adaptor' do
      transfer_to = 'sip:1652@connfu.com'
      Connfu.adaptor.should_receive(:send_command).with(Connfu::Commands::Transfer.new(:transfer_to => [transfer_to], :from => 'client-address', :to => 'server-address'))
      catch :waiting do
        subject.transfer(transfer_to)
      end
    end

    it 'should send Transfer command with optional timeout in milliseconds' do
      transfer_to = 'sip:1652@connfu.com'
      timeout_in_seconds = 5
      cmd = Connfu::Commands::Transfer.new(:transfer_to => [transfer_to], :from => 'client-address', :to => 'server-address', :timeout => (timeout_in_seconds * 1000))
      Connfu.adaptor.should_receive(:send_command).with(cmd)
      catch :waiting do
        subject.transfer(transfer_to, :timeout => timeout_in_seconds)
      end
    end
  end

  describe 'recording' do
    it 'should send a start command to adaptor' do
      subject.stub(:wait_for).and_return(Connfu::Event::Result.new)
      Connfu.adaptor.should_receive(:send_command).with(Connfu::Commands::Recording::Start.new(
        :from => 'client-address', :to => 'server-address'
      ))
      subject.start_recording
    end

    it 'should send a start command to adaptor with optional beep parameter' do
      subject.stub(:wait_for).and_return(Connfu::Event::Result.new)
      Connfu.adaptor.should_receive(:send_command).with(Connfu::Commands::Recording::Start.new(
        :from => 'client-address', :to => 'server-address', :beep => false
      ))
      subject.start_recording(:beep => false)
    end

    it 'should send a start command to adaptor with optional timeout in milliseconds' do
      max_length_in_seconds = 25
      subject.stub(:wait_for).and_return(Connfu::Event::Result.new, Connfu::Event::RecordingStopComplete.new)
      Connfu.adaptor.should_receive(:send_command).with(Connfu::Commands::Recording::Start.new(
        :from => 'client-address', :to => 'server-address', :max_length => (max_length_in_seconds * 1000)
      ))
      subject.record_for(max_length_in_seconds)
    end

    it 'should send a start command to adaptor with optional timeout in milliseconds and beep parameter' do
      max_length_in_seconds = 25
      subject.stub(:wait_for).and_return(Connfu::Event::Result.new, Connfu::Event::RecordingStopComplete.new)
      Connfu.adaptor.should_receive(:send_command).with(Connfu::Commands::Recording::Start.new(
        :from => 'client-address', :to => 'server-address', :max_length => (max_length_in_seconds * 1000), :beep => false
      ))
      subject.record_for(max_length_in_seconds, :beep => false)
    end

    it 'should send a stop command to adaptor' do
      subject.stub(:wait_for).and_return(Connfu::Event::RecordingStopComplete.new)
      subject.instance_eval { @ref_id = 'foo' }
      Connfu.adaptor.should_receive(:send_command).with(Connfu::Commands::Recording::Stop.new(:from => 'client-address', :to => 'server-address', :ref_id => 'foo'))
      subject.stop_recording
    end
  end

  describe 'say' do
    it 'should send Ask command to adaptor and respond with captured input' do
      text = 'enter your pin number'
      digits = 4
      caller_input = "9812"
      subject.stub(:wait_for).and_return(Connfu::Event::AskComplete.new(:call_id => "call-id", :captured_input => caller_input))
      Connfu.adaptor.should_receive(:send_command).with(Connfu::Commands::Ask.new(:prompt => text, :from => 'client-address', :to => 'server-address', :digits => digits))
      catch :waiting do
        captured_input = subject.ask(:prompt => text, :digits => digits)
        captured_input.should eq "9812"
      end
    end
  end
end