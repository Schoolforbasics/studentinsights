require 'rails_helper'

RSpec.describe FileImport do
  let(:log) { LogHelper::Redirect.instance.file }
  let(:mock_client) { double(:sftp_client, read_file: fake_data) }
  let(:fake_data) { File.open("#{Rails.root}/spec/fixtures/fake_students_export.txt") }
  let(:progress_bar_double) { double(:progress_bar, print: 'okay, i like to print!')}
  let(:importer) { double(:students_importer, log: log,
                                              remote_file_name: '',
                                              data_transformer: CsvTransformer.new,
                                              client: mock_client,
                                              progress_bar: true,
                                              filter: SchoolFilter.new(nil),
                                              import_row: 'woohoo, row imported!')
                 }

  subject { FileImport.new(importer) }

  describe '#import' do

    it 'runs the data through the CSV transformer' do
      expect_any_instance_of(CsvTransformer).to receive(:transform).and_return(fake_data)
      subject.import
    end

    it 'calls import_row with rows that the filter includes' do
      expect(importer).to receive(:import_row).exactly(3).times
      subject.import
    end

    it 'does not call import_row with rows that the filter excludes' do
      pending
    end

    it 'prints a new progress bar for each row' do
      expect(ProgressBar).to receive(:new).exactly(3).times
                                          .and_return(progress_bar_double)
      subject.import
    end

  end

end
