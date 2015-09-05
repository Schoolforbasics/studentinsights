require 'rails_helper'

describe HomeroomsController, :type => :controller do

  let!(:educator) { FactoryGirl.create(:educator_with_grade_5_homeroom) }
  let!(:educator_without_homeroom) { FactoryGirl.create(:educator) }

  describe '#show' do

    def make_request(slug = nil)
      request.env['HTTPS'] = 'on'
      get :show, id: slug
    end

    context 'when educator is not logged in' do
      it 'redirects to sign in page' do
        make_request(educator.homeroom.slug)
        expect(response).to redirect_to(new_educator_session_path)
      end
    end
    context 'when educator with homeroom is logged in' do
      before { sign_in(educator) }
      context 'no homeroom params' do
        before { make_request }
        it 'redirects to educator\'s homeroom' do
          expect(response).to redirect_to(homeroom_path(educator.homeroom))
        end
      end
      context 'homeroom params' do
        context 'garbage params' do
          it 'does not raise an error' do
            expect { make_request('garbage homeroom ids rule') }.not_to raise_error
          end
          it 'redirects to educator\'s homeroom' do
            make_request('garbage homeroom ids rule')
            expect(response).to redirect_to(homeroom_path(educator.homeroom))
          end
        end
        context 'homeroom belongs to educator' do
          it 'is successful' do
            make_request(educator.homeroom.slug)
            expect(response).to be_success
          end
          context 'when there are no students' do
            it 'assigns rows to empty' do
              make_request(educator.homeroom.slug)
              expect(assigns(:rows)).to be_empty
            end
          end
          context 'when there are students' do
            let!(:first_student) { FactoryGirl.create(:student, homeroom: educator.homeroom) }
            let!(:second_student) { FactoryGirl.create(:student, homeroom: educator.homeroom) }
            it 'assigns rows to a non-empty array' do
              make_request(educator.homeroom.slug)
              expect(assigns(:rows)).to be_a_kind_of Array
              expect(assigns(:rows)).to_not be_empty
            end
          end
        end
        context 'homeroom does not belong to educator' do
          context 'homeroom is grade level as educator\'s' do
            let(:homeroom) { FactoryGirl.create(:grade_5_homeroom) }
            it 'is successful' do
              make_request(homeroom.slug)
              expect(response).to be_success
            end
          end
          context 'homeroom is different grade level from educator\'s' do
            let(:homeroom) { FactoryGirl.create(:homeroom) }
            it 'redirects to educator\'s homeroom' do
              make_request(homeroom.slug)
              expect(response).to redirect_to(homeroom_path(educator.homeroom))
            end
          end
        end
      end
    end
    context 'when educator without homeroom is logged in' do
      before { sign_in(educator_without_homeroom) }
      context 'no homeroom params' do
        it 'raises a error' do
          expect { make_request }.to raise_error ActionController::RoutingError
        end
      end
      context 'homeroom params' do
        let!(:homeroom) { FactoryGirl.create(:homeroom) }
        it 'raises a error' do
          expect { make_request(homeroom.slug) }.to raise_error ActionController::RoutingError
        end
      end
    end
  end
end
