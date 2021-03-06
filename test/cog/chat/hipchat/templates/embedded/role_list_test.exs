defmodule Cog.Chat.HipChat.Templates.Embedded.RoleListTest do
  use Cog.TemplateCase

  test "role-list template" do
    data = %{"results" => [%{"name" => "foo"},
                           %{"name" => "bar"},
                           %{"name" => "baz"}]}

    expected = """
    <pre>+------+
    | Name |
    +------+
    | foo  |
    | bar  |
    | baz  |
    +------+
    </pre>\
    """

    assert_rendered_template(:hipchat, :embedded, "role-list", data, expected)
  end

end
