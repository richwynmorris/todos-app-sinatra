require "pg"

class DatabasePersistence

  def initialize(logger)
    @db = PG::connect(dbname: "todos")
    @logger = logger
  end

  def query(statement, *params)
    @logger.info "#{statement}: #{params}"
    @db.exec_params(statement, params)
  end

  def find_list(id)
    sql = "SELECT * FROM lists WHERE id = $1"
    result = query(sql, id)

    tuple = result.first
    todos = find_todos_for_list(tuple["id"])

    {id: tuple["id"], name: tuple["name"], todos: todos}
  end

  def all_lists
    sql = "SELECT * FROM lists"
    result = query(sql)

    result.map do |tuple|
      todos = find_todos_for_list(tuple["id"])
      {id: tuple["id"].to_i, name: tuple["name"], todos: todos}
    end
  end

  def create_new_list(list_name)
    # id = next_element_id(@session[:lists])
    # @session[:lists] << { id: id, name: list_name, todos: [] }
  end

  def delete_list(id)
    # @session[:lists].reject! { |list| list[:id] == id }
  end

  def update_list_name(id, list_name)
    # list = find_list(id)
    # list[:name] = list_name
  end

  def add_to_list(list_id, text)
    # list = find_list(list_id)
    # id = next_element_id(list[:todos])
    # list[:todos] << { id: id, name: text, completed: false }
  end

  def delete_todo_from_list(list_id, todo_id)
    # list = find_list(list_id)
    # list[:todos].reject! { |todo| todo[:id] == todo_id }
  end

  def update_todo_status(list_id, todo_id, status)
    # list = find_list(list_id)
    # todo = list[:todos].find { |t| t[:id] == todo_id }
    # todo[:completed] = status
  end

  def mark_all_todos_complete(list_id)
    # list = find_list(list_id)

    # list[:todos].each do |todo|
    #   todo[:completed] = true
    # end
  end

  private

  def find_todos_for_list(tuple_id)
    todo_sql = "SELECT * FROM todo WHERE list_id = $1"
    todo_result = query(todo_sql, tuple_id)

    todo_result.map do |todo_tuple|
      {id: todo_tuple["id"].to_i, name: todo_tuple["name"], completed: todo_tuple["completed"] == 't'}
    end
  end
end 