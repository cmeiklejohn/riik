require 'spec_helper'

module Riik

  class RiikDocument; include Riik::Document; property :number; end
  class RippleDocument; include Ripple::Document; property :number, Integer; end

  describe 'The performance' do 
    before do 
      WebMock.allow_net_connect!
    end

    after do 
      WebMock.disable_net_connect!
    end

    context 'when creating one record' do 
      it 'is faster than ripple' do 
        ripple_time = Benchmark.realtime do 
          RippleDocument.create(:number => 1)
        end
        riik_time = Benchmark.realtime do 
          RiikDocument.create(:number => 1)
        end
        riik_time.should < ripple_time
      end
    end

    context 'when creating 300 records' do 
      it 'is faster than ripple' do 
        ripple_time = Benchmark.realtime do 
          300.times.each do |i|
            RippleDocument.create(:number => i)
          end
        end
        riik_time = Benchmark.realtime do 
          300.times.each do |i|
            RiikDocument.create(:number => i)
          end
        end
        riik_time.should < ripple_time
      end
    end

    context 'when creating 1000 records' do 
      it 'is faster than ripple' do 
        ripple_time = Benchmark.realtime do 
          1000.times.each do |i|
            RippleDocument.create(:number => i)
          end
        end
        riik_time = Benchmark.realtime do 
          1000.times.each do |i|
            RiikDocument.create(:number => i)
          end
        end
        riik_time.should < ripple_time
      end
    end
  end

end
