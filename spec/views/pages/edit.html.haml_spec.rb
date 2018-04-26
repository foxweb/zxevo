require 'spec_helper'

describe 'pages/edit' do
  before(:each) do
    @page = assign(:page, stub_model(Page,
                                     title: 'MyString',
                                     slug: 'MyString',
                                     body: 'MyText',
                                     user: nil))
  end

  it 'renders the edit page form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form[action=?][method=?]', page_path(@page), 'post' do
      assert_select 'input#page_title[name=?]', 'page[title]'
      assert_select 'input#page_slug[name=?]', 'page[slug]'
      assert_select 'textarea#page_body[name=?]', 'page[body]'
      assert_select 'input#page_user[name=?]', 'page[user]'
    end
  end
end
