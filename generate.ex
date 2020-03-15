defmodule Generate do
  def tag(inner, tagName) do
    "<#{tagName}>#{inner}</#{tagName}>"
  end

  def tag(inner, tagName, key, val) do
    "<#{tagName} #{key}=#{val}>#{inner}</#{tagName}>"
  end

  def addLinkSection(body, names) do
    body <>
      Enum.reduce(names, "", fn name, acc ->
        linkTag = tag(name, "a", "href", "\"#{name}.html\"")
        acc <> tag(linkTag, "li") <> ""
      end)
  end

  def addPageWrapper(bodyText) do
    head = tag("Lorem's blog", "title") |> tag("head")
    bodyTag = tag(bodyText, "body")
    html = tag(head <> bodyTag, "html")
    "<!doctype html>" <> html
  end

  def markdownTags(textArr) do
    dict = %{"#" => "h1", "##" => "h3", "*" => "li"}

    Enum.reduce(textArr, "", fn line, acc ->
      case line do
        "" ->
          acc <> "<br>"

        x ->
          [prefix, text] = String.split(x, " ", parts: 2)

          case Map.fetch(dict, prefix) do
            {:ok, x} ->
              acc <> tag(text, x)

            :error ->
              acc <> prefix <> text
          end
      end
    end)
  end

  def gen do
    postNames =
      File.ls!("./markdown")
      |> Enum.map(fn filename -> String.slice(filename, 0..-4) end)

    Enum.map(postNames, fn postName ->
      page =
        File.read!("./markdown/#{postName}.md")
        |> String.split("\n", trim: false)
        |> markdownTags()
        |> addLinkSection(postNames)
        |> addPageWrapper()

      File.write("./static/#{postName}.html", page)
    end)
  end
end

Generate.gen()
