describe TodoBot::Lists::ShowListsService do
  let(:service) { described_class.new(args) }
  let(:args) { {user: create(:user), chat: chat} }

  describe '#execute' do
    subject { service.execute }

    context 'when chat doesn`t contain list' do
      let(:chat) { create(:chat) }

      it { is_expected.to eq I18n.t('list.not_exists') }
    end

    context 'when chat contains list' do
      let(:chat) { create(:chat, :with_list, lists_count: 3) }

      it 'returns tasks of list', :aggregate_failures do
        is_expected.to eq TodoBot::CollectionToMessagePresenter.new(chat.lists).execute
        expect(chat.status).to eq 'show_lists'
      end
    end
  end
end
