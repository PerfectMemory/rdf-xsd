$:.unshift "."
require 'spec_helper'

describe RDF::Literal do
  context "lookup" do
    {
      "xsd:hexBinary"    => RDF::Literal::HexBinary,
      "xsd:base64Binary" => RDF::Literal::Base64Binary,
    }.each do |qname, klass|
      it "finds #{klass} for #{qname}" do
        uri = RDF::XSD[qname.split(':').last]
        RDF::Literal("0", :datatype => uri).class.should == klass
      end
    end
  end

  describe RDF::Literal::HexBinary do
    %w(
      0FB7
      0fb7
      3f3c6d78206c657673726F693D6E3122302e20226E656F636964676e223D54552d4622383E3f
    ).each do |value|
      it "validates #{value}" do
        RDF::Literal::HexBinary.new(value).should be_valid
        RDF::Literal::HexBinary.new(value).should_not be_invalid
      end
      
      it "canoicalizes #{value} to #{value.downcase}" do
        RDF::Literal::HexBinary.new(value, :canonicalize => true).value.should == value.downcase
      end
    end

    %w(
      0FB7Z
    ).each do |value|
      it "invalidates #{value}" do
        RDF::Literal::YearMonth.new(value).should be_invalid
        RDF::Literal::YearMonth.new(value).should_not be_valid
      end
    end
  end

  describe RDF::Literal::Base64Binary do
    [
      "U2VuZCByZWluZm9yY2VtZW50cw==\n",
      "VGhpcyBpcyBsaW5lIG9uZQpUaGlzIGlzIGxpbmUgdHdvClRoaXMgaXMgbGluZSB0aHJlZQpBbmQgc28gb24uLi4K",
      "Tm93IGlzIHRoZSB0aW1lIGZvciBhbGwgZ29vZCBjb2RlcnMKdG8gbGVhcm4g",
      "TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlz
        IHNpbmd1bGFyIHBhc3Npb24gZnJvbSBvdGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2Yg
        dGhlIG1pbmQsIHRoYXQgYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGlu
        dWVkIGFuZCBpbmRlZmF0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGdlLCBleGNlZWRzIHRo
        ZSBzaG9ydCB2ZWhlbWVuY2Ugb2YgYW55IGNhcm5hbCBwbGVhc3VyZS4=",
      "YW55IGNhcm5hbCBwbGVhc3VyZS4=",
      "YW55IGNhcm5hbCBwbGVhc3VyZQ==",
      "YW55IGNhcm5hbCBwbGVhc3Vy",
      "YW55IGNhcm5hbCBwbGVhc3U=",
      "YW55IGNhcm5hbCBwbGVhcw=="
    ].each do |value|
      it "validates #{value} to #{Base64.decode64(value).inspect}" do
        RDF::Literal::Base64Binary.new(value).should be_valid
        RDF::Literal::Base64Binary.new(value).should_not be_invalid
      end
    end

    %w(
      0FB7Z
    ).each do |value|
      it "invalidates #{value}" do
        RDF::Literal::YearMonth.new(value).should be_invalid
        RDF::Literal::YearMonth.new(value).should_not be_valid
      end
    end
  end

end