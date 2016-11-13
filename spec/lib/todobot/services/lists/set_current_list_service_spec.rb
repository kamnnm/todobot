describe TodoBot::Lists::SetCurrentListService do
  let(:service) { described_class.new(args) }
  let(:args) { {user: create(:user), chat: chat, number: number} }
  let(:number) { 1 }

  describe '#execute' do
    subject { service.execute }

    context 'when chat doesn`t contain list' do
      let(:chat) { create(:chat) }

      it { is_expected.to eq I18n.t('list.not_found') }
    end

    context 'when chat contains list' do
      let(:chat) { create(:chat, :with_list, lists_count: 3) }

      context 'when number out of range' do
        let(:number) { 4 }

        it { is_expected.to eq I18n.t('list.not_found') }
      end

      context 'when number in range' do
        let(:number) { 2 }

        it 'returns tasks of current list', :aggregate_failures do
          is_expected.to eq TodoBot::Lists::ShowListService.new(args).execute
          expect(chat.current_list).to eq chat.lists[1]
        end
      end
    end
  end
end
