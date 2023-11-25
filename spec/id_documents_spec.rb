# frozen_string_literal: true

RSpec.describe IDDocuments do
  it "has a version number" do
    expect(IDDocuments::VERSION).not_to be nil
  end

  it "parses id number" do
    expect(IDDocuments.parse(:LKA, :national_id, "741922757V")).to be_a(IDDocuments::Result)
  end
end
