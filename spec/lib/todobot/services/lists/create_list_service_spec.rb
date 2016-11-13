describe TodoBot::Lists::CreateListService do
  let(:service) { described_class.new(args) }
  let(:args) { {user: user, chat: chat, name: name} }
  let(:user) { create(:user) }
  let(:chat) { create(:chat) }
  let(:name) { 'list' }

  describe '#execute' do
    subject { service.execute }

    context 'when name doesn`t present' do
      let(:name) { nil }

      it do
        is_expected.to eq I18n.t('list.create')
        expect(chat.create_list?).to be_truthy
      end
    end

    context 'when name presents' do
      context 'when name is invalid' do
        let(:name) { 33.times.each_with_object('') { |_, result| result.concat('1') } }
        let(:error_message) do
          I18n.t('activerecord.errors.models.todo_bot/list.attributes.name.too_long')
        end

        it { is_expected.to include error_message }
      end

      context 'when name is valid' do
        context 'when all tasks names too long' do
          before do
            name = 32.times.each_with_object('') { |_, result| result.concat('1') }
            16.times { user.created_lists.create(chat: chat, name: name) }
          end

          it { is_expected.to eq I18n.t('activerecord.errors.models.todo_bot/list.too_long') }
        end

        it { is_expected.to eq I18n.t('list.created', list: name) }
      end
    end
  end
end
