describe TodoBot::Task, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:list) }
    it { is_expected.to belong_to(:user) }
  end
end
