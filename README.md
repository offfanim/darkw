#### Это мой Ruby on Rails пет-проект.

Потрогать руками можно [здесь](https://darkwrite.herokuapp.com). Прочитать этот readme можно [там же](https://darkwrite.herokuapp.com/1)

Основная задумка - клон [telegra.ph](https://telegra.ph/). Простенький сайт для быстрого создания аккуратных статей.
В качестве текстового редактора использовал [Quill](https://quilljs.com/).

Что тут есть:

* Возможность установить на статью настраиваемую ссылку вида '/some_id-some_custom_link'. На статью нельзя попасть перебором id, т.к. в роутах используется только параметр `custom_link`. Если ссылка не установлена - вместо неё устанавливается голый id.
Для этого написал вот такой метод в сервис-объекте:
```ruby
# this method needs id, therefore it needs article.save before
def call
  custom_link = @article.custom_link
  id = @article.id.to_s

  if custom_link.blank?
    @article.custom_link = id
  else
    new_custom_link = custom_link.gsub(/[ _]/, '-').delete('^A-Za-z0-9-')

    if new_custom_link.blank?
      @article.custom_link = id
    else
      @article.custom_link = "#{id}-#{new_custom_link}"[0...100]
    end
  end
  return @article.custom_link if @article.save
end
```

* Возможность установить пароль на статью, чтобы редактировать её в дальнейшем. Если пароль не установлен - редактировать нельзя.
Реализовал следующим образом:
```ruby
# in article.rb
has_secure_password(validations: false)

# in routes.rb
post '/:custom_link/access_to_edit',
  to: 'articles#access_to_edit',
  as: 'access_to_edit_article'

# in articles_controller.rb
def access_to_edit
  @article = Article.find(params[:custom_link])
  if @article.authenticate(params[:password])
    session[:article_custom_link] = @article.custom_link
    redirect_to edit_article_path
  else
    flash.now[:error] = 'wrong password'
    render :show, status: :unprocessable_entity
  end
end

def edit
  @article = Article.find(session[:article_custom_link])
end
```

* Quill подключается с помощью stimulus. С помощью экшенов стимулюс контроллера тело статьи загружется из окна редактора в `<%= form.hidden_field :body %>` при отправке формы, а при открытии страницы `/edit` наоборот выгружается из скрытого поля в окно редактора.
Вот как это реализовано:
```html
# in _form.html.erb
<div data-controller='quill'>
  <div data-quill-target='editor'></div>

  <%= form_with model: @article, data: {action: 'quill#fill'} do |form| %>
      <%= form.hidden_field :body,
        data: {'quill-target' => 'article'}
      %>
  ...
```
```js
// in quill_controller.js
export default class extends Controller {
  static targets = [ "editor", "article" ]

  // fill hidden form before submit
  fill() {
    this.articleTarget.value = document.querySelector('.ql-editor').innerHTML
  }

  connect() {
    // some Quill settings...

    let container = this.editorTarget;

    let quill = new Quill(container, {
      theme: 'bubble',
      placeholder: 'Write',
      // some Quill settings...

    // fill Quill editor from article value in edit viev
    document.querySelector('.ql-editor').innerHTML = this.articleTarget.value;

    // focus on textarea after load page
    quill.focus();
  }
```

* Quill по умолчанию содержит в себе как минимум один тег `<p><br></p>`, поэтому валидацию я реализовал вот так:
```ruby
validates :body,
  format: { without: %r{\A(<p>[[:blank:]]*(<br>)?<\/p>)+\z}, message: "can't be blank" },
  on: :create
```
Но эта валидация не распространяется на экшн "edit" чтобы можно было стереть статью простым `Ctrl+A`+`Backspace`. Отдельной кнопки "Delete" не делал чтобы не плодить сущности и сохранить минималистичность.
