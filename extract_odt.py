from odf import text, teletype
from odf.opendocument import load

doc = load(r'lista_produkte.odt')
allparas = doc.getElementsByType(text.P)

with open('products_extracted.txt', 'w', encoding='utf-8') as f:
    for para in allparas:
        content = teletype.extractText(para)
        if content.strip():
            f.write(content + '\n')

print("Products extracted to products_extracted.txt")
