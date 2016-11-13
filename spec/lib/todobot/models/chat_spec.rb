describe TodoBot::Chat, type: :model do
  describe 'relations' do
    it { is_expected.to have_many(:lists) }
    it { is_expected.to belong_to(:list) }
  end
end
