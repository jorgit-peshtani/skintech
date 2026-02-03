import qrcode

data = "https://skintech.vercel.app"
filename = "C:/Users/jpesh/Desktop/diploma/skintech/frontend/public/skintech_qr.png"

qr = qrcode.QRCode(
    version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_H,
    box_size=10,
    border=4,
)
qr.add_data(data)
qr.make(fit=True)

img = qr.make_image(fill_color="black", back_color="white")
img.save(filename)
print(f"QR code saved to {filename}")
