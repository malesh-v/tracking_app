require 'rails_helper'

shared_context 'comments page selectors' do
  it 'html' do
    comment_form = 'div#comments > div#comment-form > form'

    assert_selector('div#comments', text: 'Comments', count: 1)
    assert_selector(comment_form)

    #hidden input with ticket id
    find("#{comment_form} > input[value='#{ticket.id}'][type='hidden'][name='comment[ticket_id]']",
         visible: :all)

    #textarea input
    assert_selector("#{comment_form} > textarea.form-control[name='comment[content]']",
                    id: 'comment_content', count: 1)

    #button
    find("#{comment_form} > input.btn[type='submit'][name='commit'][value='Send comment']")

    #comments list
    assert_selector('div#comments > div#comments_list')
  end

end

shared_context 'shared comments page' do
  it 'comments page as staff' do
    assert_selector('div#comments > div#comments_list > div.container.comment',
                    count: 1)
  end
  include_context 'comments page selectors'

  it 'with blank input' do
    click_button 'Send comment'
    assert_selector('div.alert.alert-danger', count: 1,
                    text: 'Message can\'t be blank')

    click_button 'Send comment'
    click_button 'Send comment'

    assert_selector('div.alert.alert-danger', count: 1,
                    text: 'Message can\'t be blank')
  end
  include_context 'comments page selectors'

  it 'with non blank input' do
    fill_in 'comment_content', with: 'test comment for ticket'
    click_button 'Send comment'
    assert_selector('div.alert.alert-danger', count: 0)

    assert_selector('div.container.comment', count: 1, text: 'test comment for ticket')
    assert_selector('div#comments_list > h6')
  end
  include_context 'comments page selectors'
end


