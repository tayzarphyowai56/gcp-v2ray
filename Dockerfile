FROM alpine:latest

# Set working directory (ဖိုင်တွေ ရှုပ်ပွမနေအောင် သီးသန့်နေရာထားပါမယ်)
WORKDIR /app

# Install dependencies
# (ca-certificates ထပ်ထည့်ပေးထားပါတယ်၊ HTTPS ချိတ်ဆက်မှုတွေအတွက် အရေးကြီးလို့ပါ)
RUN apk add --no-cache \
    bash \
    curl \
    wget \
    unzip \
    ca-certificates

# Download and install v2ray (using v5.7.0 as per original script)
RUN wget -q https://github.com/v2fly/v2ray-core/releases/download/v5.7.0/v2ray-linux-64.zip && \
    unzip v2ray-linux-64.zip && \
    rm v2ray-linux-64.zip && \
    chmod +x v2ray

# Copy the modified config file
# (ဒါက အရေးအကြီးဆုံးပါ၊ ကျွန်တော်တို့ပြင်ထားတဲ့ config.json ကို Image ထဲထည့်ပါမယ်)
COPY config.json .

# Expose port (Cloud Run requires this)
ENV PORT=8080
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Start v2ray on port 8080
CMD ["./v2ray", "run", "-config", "config.json"]
