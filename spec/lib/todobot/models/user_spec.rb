describe TodoBot::User, type: :model do
  describe 'relations' do
    it { is_expected.to have_many(:created_lists) }
  end
end
