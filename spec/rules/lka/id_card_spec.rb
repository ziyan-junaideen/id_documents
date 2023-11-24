# frozen_string_literal: true

RSpec.describe IDDocuments::LKA::IDCard do
  subject { described_class.new(id_number).parse }

  context "when id number is in old format" do
    let(:id_number) { "741922757V" }

    it "is valid" do
      expect(subject).to be_a(IDDocuments::Result)
      expect(subject.valid?).to be_truthy
      expect(subject.metadata[:id_format]).to eq(:old)
      expect(subject.metadata[:gender]).to eq(:male)
      expect(subject.metadata[:dob]).to eq(Date.new(1974, 7, 10))
      expect(subject.metadata[:voter_status]).to eq(:voter)
    end
  end

  context "when id number is in new format" do
    let(:id_number) { "197419202757" }

    it "is valid" do
      expect(subject.valid?).to be_truthy
    end

    it "parses metadata" do
      expect(subject.metadata[:id_format]).to eq(:new)
      expect(subject.valid?).to be_truthy
      expect(subject.metadata[:gender]).to eq(:male)
      expect(subject.metadata[:dob]).to eq(Date.new(1974, 7, 10))
      expect(subject.metadata[:voter_status]).to be nil
    end
  end

  context "when id number is invalid" do
    let(:id_number) { "12345678" }

    it "raises an error" do
      expect { subject }.to raise_error(IDDocuments::InvalidFormatError)
    end
  end
end
