describe TodoBot::Tasks::FinishTaskService do
  let(:service) { described_class.new(args) }
  let(:args) { {user: user, chat: chat, number: number} }
  let(:user) { create(:user) }
  let(:number) { 1 }

  describe '#execute' do
    subject { service.execute }

    context 'when chat doesn`t contain list' do
      let(:chat) { create(:chat) }

      it { is_expected.to eq I18n.t('list.not_exists') }
    end

    context 'when chat contains list' do
      let(:chat) { create(:chat, :with_list) }
      let(:list) { chat.lists.first }

      context 'when list doesn`t contain tasks' do
        it { is_expected.to eq I18n.t('task.not_found') }
      end

      context 'when list contains tasks' do
        before do
          list.tasks.create(name: '1', user: user)
          list.tasks.create(name: '2', user: user)
        end

        context 'when number of finished task out of tasks range' do
          let(:number) { 3 }

          it { is_expected.to eq I18n.t('task.not_found') }
        end

        context 'when number of finishing task in tasks range' do
          let(:tasks) { TodoBot::CollectionToMessagePresenter.new(list.tasks.uncompleted).execute }

          it { is_expected.to eq "#{I18n.t('task.finished', task: '1')}\n\n#{tasks}" }
        end
      end
    end
  end
end
