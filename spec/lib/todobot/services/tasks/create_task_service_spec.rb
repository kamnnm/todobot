describe TodoBot::Tasks::CreateTaskService do
  let(:service) { described_class.new(args) }
  let(:args) { {user: user, chat: chat, name: name} }
  let(:user) { create(:user) }

  let(:name) { 'task' }

  describe '#execute' do
    subject { service.execute }

    context 'when chat doesn`t contain list' do
      let(:chat) { create(:chat) }

      it { is_expected.to eq I18n.t('list.not_exists') }
    end

    context 'when chat contains list' do
      let(:chat) { create(:chat, :with_list) }

      context 'when name doesn`t present' do
        let(:name) { nil }

        it do
          is_expected.to eq I18n.t('task.create')
          expect(chat.create_task?).to be_truthy
        end
      end

      context 'when name presents' do
        context 'when name is invalid' do
          let(:name) { 513.times.each_with_object('') { |i, result| result.concat('1') } }
          let(:error_message) do
            I18n.t('activerecord.errors.models.todo_bot/task.attributes.name.too_long')
          end

          it { is_expected.to include error_message }
        end

        context 'when name is valid' do
          context 'when all tasks names too long' do
            before do
              name = 512.times.each_with_object('') { |i, result| result.concat('1') }
              4.times { chat.lists.first.tasks.create(name: name, user: user) }
            end

            it { is_expected.to eq I18n.t('activerecord.errors.models.todo_bot/task.too_long') }
          end

          it { is_expected.to eq "#{I18n.t('task.created', task: name)}\n\n/1. #{name}" }
        end
      end
    end
  end
end
