describe TodoBot::List, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:chat) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:tasks) }
  end
end
