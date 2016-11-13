describe TodoBot::Lists::ShowListService do
  let(:service) { described_class.new(args) }
  let(:args) { {user: user, chat: chat} }
  let(:user) { create(:user) }

  describe '#execute' do
    subject { service.execute }

    context 'when chat doesn`t contain list' do
      let(:chat) { create(:chat) }

      it { is_expected.to eq I18n.t('list.not_exists') }
    end

    context 'when chat contains list' do
      let(:chat) { create(:chat, :with_list) }

      context 'when list doesn`t contain tasks' do
        it { is_expected.to eq I18n.t('task.not_exists') }
      end

      context 'when list contains tasks' do
        let(:list) { chat.lists.first }

        before do
          list.tasks.create(name: 1, user: user)
          list.tasks.create(name: 2, user: user)
        end

        it 'returns list of tasks', :aggregate_failures do
          tasks = TodoBot::CollectionToMessagePresenter.new(list.tasks).execute

          is_expected.to eq "#{list.name}\n\n#{tasks}"
          expect(chat.status).to eq 'show_list'
        end
      end
    end
  end
end
