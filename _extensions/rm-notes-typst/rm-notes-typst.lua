-- Supprime les blocs .notes pour le rendu Typst.
function Div(el)
  if el.classes:includes("notes") then
    return {}
  end
end