describe TodoBot::Commands::UndefinedCommandService do
  let(:service) { described_class.new(args) }
  let(:args) { {user: create(:user), chat: chat, command: command} }
  let(:command) { 'unrecognized_command' }
  let(:chat) { create(:chat, :with_list) }

  describe '#execute' do
    subject { service.execute }

    context 'when chat has status show_list' do
      before { chat.show_list! }

      context 'when command is number' do
        let(:command) { '/1' }

        it { is_expected.to eq TodoBot::Tasks::FinishTaskService.new(args.merge!(number: 1)).execute }
      end

      context 'when command is anything else' do
        let(:command) { '/aaa' }

        it { is_expected.to eq I18n.t('undefined_message') }
      end
    end

    context 'when chat has status show_lists' do
      before { chat.show_lists! }

      context 'when command is number' do
        let(:command) { '/1' }

        it { is_expected.to eq TodoBot::Lists::SetCurrentListService.new(args.merge!(number: 1)).execute }
      end

      context 'when command is anything else' do
        let(:command) { '/aaa' }

        it { is_expected.to eq I18n.t('undefined_message') }
      end
    end

    context 'when unrecognized command' do
      it { is_expected.to eq I18n.t('undefined_message') }
    end
  end
end
