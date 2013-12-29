require 'spec_helper'
include Diaspider::Utils

describe Diaspider::Utils::Parsing do 
  describe '.resolve_url' do 
    context 'arguments' do
      it 'should accept Strings as arguments' do
        href = 'world'
        ab = 'http://hello.com'

        expect( Parsing.resolve_url href, ab).to eq 'http://hello.com/world'
      end

      it 'should accept URI as arguments' do
        href = URI.parse 'world'
        ab = Addressable::URI.parse 'http://hello.com'

        expect( Parsing.resolve_url href, ab).to eq 'http://hello.com/world'
      end

      describe 'error conditions' do
        context 'without exactly 2 arguments' do
          it 'should raise ArgumentError' do 
            expect{Parsing.resolve_url 'http://example.com' }.to raise_error ArgumentError
          end
        end

        context 'either argument is nil' do
          it 'should raise Argument Error' do
            expect{Parsing.resolve_url  nil, 'http://example.com'}.to raise_error ArgumentError
            expect{Parsing.resolve_url 'http://example.com', nil}.to raise_error ArgumentError
          end
        end

        context 'arguments are neither Strings nor URIs' do
          it 'should raise ArgumentError if arguments are not a String nor URI' do 
            expect{Parsing.resolve_url 42, 'http://example.com' }.to raise_error ArgumentError
          end
        end

        context 'second argument is not absolute URI' do
          it 'should raise ArgumentError' do
            expect{Parsing.resolve_url 'http://example.com', 'world.html' }.to raise_error ArgumentError
          end
        end
      end
    end

    describe 'absolute path resolution' do 
      context 'when first argument is absolute' do 
        it 'should be idempotent' do 
          expect(Parsing.resolve_url( 'http://propublican.org/', 'https://example.com')).to eq 'http://propublican.org/'
        end

        it 'should respect scheme of @page_url when //absolute path used' do 
          expect(Parsing.resolve_url( '//some.org/', 'https://secure.org')).to eq 'https://some.org/'
        end
      end

      context 'when first arg is relative' do
        context 'when 2nd arg has path with no trailing slash' do
          before do
            @page_url = 'http://www.propublica.org/index.html'
          end

          it 'should return @page_url when first arg is empty' do 
            expect(Parsing.resolve_url( '', @page_url)).to eq @page_url
          end

          it 'should return #hash page anchor ' do 
            expect(Parsing.resolve_url( '#bang', @page_url)).to eq 'http://www.propublica.org/index.html#bang'
          end

          it 'should return query params' do           
            expect(Parsing.resolve_url( '?q=1', @page_url)).to eq 'http://www.propublica.org/index.html?q=1'
          end

          it 'should append a root-level path to host' do 
            expect(Parsing.resolve_url( '/pages', @page_url)).to eq 'http://www.propublica.org/pages'
          end

          it 'should append a relative path to host/..' do 
            expect(Parsing.resolve_url( 'dir.html', @page_url)).to eq 'http://www.propublica.org/dir.html'
          end
        end

        context 'when 2nd arg has path w/ trailing slash, i.e. an actual directory' do 
          before do
            @page_url = 'http://www.propublica.org/pages/'
          end
          
          it 'should append a subdir path to existing path' do 
            expect(Parsing.resolve_url( 'dir', @page_url)).to eq 'http://www.propublica.org/pages/dir'
          end

          it 'should replace existing path with root level href path' do
            expect(Parsing.resolve_url('/dir', @page_url)).to eq 'http://www.propublica.org/dir'
          end
        end
      end
    end



    describe 'normalization' do
      it 'normalizes host names' do
        expect(Parsing.resolve_url 'world.html', 'http://WWW.HeLLO.coM/').to eq 'http://www.hello.com/world.html'
      end

      it 'escapes improper URI strings' do
        expect(Parsing.resolve_url 'you and me', 'http://hello.com').to eq 'http://hello.com/you%20and%20me'
      end
    end

  end
end