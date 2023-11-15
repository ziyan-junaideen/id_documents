# frozen_string_literal: true

RSpec.describe IDDocuments::LKA::IDCard do
  subject { described_class.new(id_number).parse }

  context "when id number is in old format" do
    let(:id_number) { "741922757V" }

    it "is valid" do
      expect(subject).to be_a(IDDocuments::Result)
      expect(subject.valid?).to be_truthy
      expect(subject.metadata).to eq({
                                       id_format: :old,
                                       gender: :male,
                                       dob: Date.new(1974, 8, 11),
                                       sequence: 275,
                                       check: 7,
                                       voter: true
                                     })
    end
  end

  context "when id number is in new format" do
    let(:id_number) { "197419202757" }

    it "is valid" do
      expect(subject.valid?).to be_truthy
    end

    it "parses metadata" do
    end
  end

  context "when id number is invalid" do
    it "raises an error" do
      expect { described_class.new }.to raise_error(IDDocuments::InvalidFormatError)
    end
  end
end
