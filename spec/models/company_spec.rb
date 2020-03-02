# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'described_class should be' do
    it_behaves_like 'a mongoid_document', described_class
  end

  describe 'list attributes' do
    it_behaves_like 'number attributes on class', described_class, 3
    it { is_expected.to have_field(:_id).of_type(BSON::ObjectId) }
    it { is_expected.to have_field(:name).of_type(String) }
    it { is_expected.to have_field(:cnpj).of_type(String) }
  end

  describe 'list embeds objects' do
    it_behaves_like 'embed one object', described_class, :locale
  end

  describe 'validations' do
    describe 'presence of name' do
      context 'valid' do
        subject { build(:company) }
        it { expect(subject).to be_valid }
      end

      context 'invalid' do
        subject { build(:company, :without_name) }

        it { expect(subject).not_to be_valid }
        it 'errors must be populated' do
          subject.valid?
          expect(subject.errors.full_messages).to include('Name can\'t be blank')
        end
      end
    end
  end
end
