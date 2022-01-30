#### Это мой пет-проект на ruby on rails.

Основная задумка - клон [telegra.ph](https://telegra.ph/). Простенький сайт для быстрого создания аккуратных статей.
В качестве текстового редактора использовал [Quill](https://quilljs.com/).

Что тут есть:

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
    flash[:error] = 'wrong password'
    render :show, status: :unprocessable_entity
  end
end

def edit
  @article = Article.find(session[:article_custom_link])
end

def update
  @article = Article.find(session[:article_custom_link])
  if @article.update(article_params)
    clear_custom_link
    redirect_to @article
  else
    render :edit, status: :unprocessable_entity
  end
end
```

* Возможность установить на статью настраиваемую ссылку вида '/some_id-some_custom_link'. На статью нельзя попасть перебором id, т.к. в роутах используется только параметр `custom_link`. Если ссылка не установлена - вместо неё устанавливается голый id.
Для этого я написал вот такой метод:
```ruby
def clear_custom_link
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
  @article.save
end
```

* Quill подключается с помощью stimulus. С помощью экшенов стимулюс контроллера тело статьи загружется из окна редактора в `<%= form.hidden_field :body %>` при отправке формы, а при открытии страницы `/edit` наоборот выгружается из скрытого поля в окно редактора.
Вот как это реализовано:
```html
# in _form.html.erb
<div data-controller="quill">
  <div id="editor"></div>

  <%= form_with model: @article, data: {action: "quill#fill"} do |form| %>
    <%= form.hidden_field :body %>
    ...
```
```js
// in quill_controller.js
  // fill hidden form before submit
  fill() {
    document.getElementById('article_body').value = document.querySelector('.ql-editor').innerHTML
  }

  connect() {
    // Quill settings
    ...

    var container = document.getElementById('editor');

    var quill = new Quill(container, {
      theme: 'bubble',
      placeholder: 'Write',
      ...

    // fill Quill editor from article value in edit viev
    document.querySelector('.ql-editor').innerHTML = document.getElementById('article_body').value;

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