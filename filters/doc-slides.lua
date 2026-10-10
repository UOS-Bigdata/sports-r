-- 한 개의 .qmd에서 HTML 문서와 revealjs 슬라이드를 함께 만들기 위한 필터
--   ::: {.doc}          문서(HTML)에서만 보임  (긴 설명, 표, 보충 내용)
--   ::: {.only-slides}  슬라이드에서만 보임    (단계별 애니메이션, 요약 슬라이드)
--   ::: {.notes}        발표자 노트 — 문서에서는 숨김

local is_slides = quarto.doc.is_format("revealjs")

function Div(el)
  -- ::: {.answer}  정답 블록: 문서 = 접힌 콜아웃, 슬라이드 = 클릭하면 나타나는 콜아웃
  if el.classes:includes("answer") then
    local title = el.attributes["title"] or "정답"
    if is_slides then
      -- 슬라이드에서는 정답을 다음 슬라이드로 분리
      local blocks = {pandoc.Header(2, pandoc.Inlines(title), pandoc.Attr("", {"answer-slide"}))}
      for _, b in ipairs(el.content) do table.insert(blocks, b) end
      return blocks
    end
    return pandoc.Div(el.content, pandoc.Attr("", {"callout-tip", "answer-box"}, {title = title, collapse = "true"}))
  end
  if el.classes:includes("doc") then
    if is_slides then return {} end
    return el.content
  end
  if el.classes:includes("only-slides") then
    if is_slides then return el.content end
    return {}
  end
  if el.classes:includes("notes") and not is_slides then
    return {}
  end
  return nil
end

function Span(el)
  if el.classes:includes("doc") then
    if is_slides then return {} end
    return el.content
  end
  if el.classes:includes("only-slides") then
    if is_slides then return el.content end
    return {}
  end
  return nil
end
