-- 2일차 문서: bookdown처럼 "장.절" 번호(예: 4.1, 4.1.2)를 제목 앞에 붙임
-- 문서 YAML에 chapter: 4 처럼 장 번호가 있을 때만 동작, {-} 또는 .unnumbered 제목은 건너뜀
function Pandoc(doc)
  if not doc.meta.chapter then return nil end
  local chap = pandoc.utils.stringify(doc.meta.chapter)
  local cnt = {0, 0, 0, 0, 0, 0}
  local function number(h)
    if h.level < 2 or h.classes:includes("unnumbered") then return nil end
    cnt[h.level] = cnt[h.level] + 1
    for k = h.level + 1, 6 do cnt[k] = 0 end
    local parts = {chap}
    for k = 2, h.level do table.insert(parts, tostring(cnt[k])) end
    local num = table.concat(parts, ".")
    h.content:insert(1, pandoc.Space())
    h.content:insert(1, pandoc.Span({pandoc.Str(num)}, pandoc.Attr("", {"header-section-number"})))
    return h
  end
  local out = {}
  for _, b in ipairs(doc.blocks) do
    if b.t == "Header" then b = number(b) or b end
    table.insert(out, b)
  end
  doc.blocks = pandoc.Blocks(out)

  -- 그림 설명 앞에 "그림 장.번호: " 붙이기 (bookdown 표기와 동일)
  local fig = 0
  local function prefix(inl)
    fig = fig + 1
    local p = pandoc.Inlines({pandoc.Str("그림"), pandoc.Space(), pandoc.Str(chap .. "." .. fig .. ":"), pandoc.Space()})
    p:extend(inl)
    return p
  end
  doc.blocks = doc.blocks:walk({
    Figure = function(f)
      if #f.caption.long > 0 then
        local first = f.caption.long[1]
        if first.content then first.content = prefix(first.content) end
        return f
      end
    end
  })
  return doc
end
