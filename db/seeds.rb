# Create some users These shouldn't change after initial deploy

admin = User.create!(
    email:  "ciscawards@gmail.com",
    name: "CISC Awards Administrator",
    password_digest: "$2a$10$OTvrczPu1h5zpo8.b61peOm6hHNyvu9aji3R1rKCVoR/JhCpPwXee", #password
    activated: true,
    activated_at: Time.zone.now,
    role: 2
)
