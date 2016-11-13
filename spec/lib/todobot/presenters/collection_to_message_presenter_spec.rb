describe TodoBot::CollectionToMessagePresenter do
  subject { described_class.new(collection).execute }

  context 'when collection is empty' do
    let(:collection) { TodoBot::List.none }

    it 'returns empty string' do
      is_expected.to eq ''
    end
  end

  context 'when collection is nil' do
    let(:collection) { nil }

    it 'returns empty string' do
      is_expected.to eq ''
    end
  end

  context 'when collection present' do
    let(:collection) { TodoBot::List.all }

    it 'returns list' do
      create(:list, name: 'First')
      create(:list, name: 'Second')

      is_expected.to eq "/1. First\n/2. Second"
    end
  end
end
