Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E46B1B3F22;
	Mon,  9 Sep 2024 13:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725888423; cv=none; b=BxkyOb5lKW3nrXk6vV7pmQ0XQ4HcikyVE1SODCIR02Hz8ZZwQTReOP4rBVEH9ZZjeJLVEJRceeTt3nRUa7ZdMOU9uj5Cs7j7eYGHXxrJwkYCS47h8VmKYMefaHAT8AJc5d0R6vDtUqNyXEoVCf+XFx4KdcJ6qv33VeHFHzxXF+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725888423; c=relaxed/simple;
	bh=8NPuVW4r6t7ooWB4l704lARcRv+pYm5pldQ/0JNS5Ko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mx9YU7sq//HfiMWighroQmo3EE5AxUQpD6+Jr1XDRTgtWWtz5UpxEUvwvSNNjVvbiY1LiX4OlmGzSHJrDj/iT4CZ8CwTQiqW+tcdCGJki+HBosE/Fj5S3vUQTJGj8DFHwvldmoyGe71p39t/i8pVOLN9QmwApcARt/ECj8deFKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gSbXlP8z; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gSbXlP8z"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-846c4ec2694so1322884241.2;
        Mon, 09 Sep 2024 06:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725888421; x=1726493221; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RK2owrGqF5BPDXOzMjhXIFhBXeulK+IBCn+O/obzMo0=;
        b=gSbXlP8zKq6jaiqBGMbSBR/xpRxNAN4myoHhcnt1MoTCqTYRkPJi0wx/pz0atjCNfv
         uiLMSK6/zBBhS4VCQ9HgWIbNb5T/IBlg9fV7iCzPQpct2wvl2MY/lhF05F+r+6FrqvW+
         i+P8rIZXWLzuvS1LAUHxFoERSYzf3xi8XgcJvNBxO/DYfMB5tTKU9NH880+W7FJsOdF7
         XlLgDXfFAVneeV91wRLTDy5kPtDQcWIuACJKS45UZG1h5Lj4lRYGtbN4hqd9CiBFTCf9
         AM6qABDfEkt5FanFrW+A7VW5rYvvoPZR0uXy88V0cCGY90EEazdyUcGu976Bg2RHm2Sz
         jFtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725888421; x=1726493221;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RK2owrGqF5BPDXOzMjhXIFhBXeulK+IBCn+O/obzMo0=;
        b=JLzbfQCz23YtC7Hckb2Zf4aWSNm10W1/rfOT5PnSz5ZC6kuLlGZKPtVuszH7FFw4Mo
         nIN9OWSvOsyy49PHEgN0wtgp0aGGUL11eZEHWaPj8+aV3fIPGY1KwgIt7DMnqIP8W20o
         0cIcU9KNqmN2V60vIp+h/MhiT5ck4/lkN+WMLSBANfZOtBGXFHCetBKW6lcHczj0cWPE
         dWbEku4wJPFaj3ZOh15SaCQkKuu0okBHAPTY+NOgj8I2DxPVlzTL6YI7Gto0TK5eXYUl
         Lgsf7ergzyCKY4oabAoIzFnhWxLCLEXS/m9CUeoPx38r138C4rhv7sBSmRECUgqf9toI
         JbTg==
X-Forwarded-Encrypted: i=1; AJvYcCU86HmgmDtMaqd9mEo/3A8KpBUDbxGyqoS5yBhFJ+XUhiYRg8zSd3HEyNtAC6zglzUJmgT2PNNuBQ/ZbI8oRzw=@lists.linux.dev, AJvYcCUNmVziZ5T4atqIN7Y9DxwJhCzLwOPDYZe/NPas5t325YIMaKeTDma1qiE5sAeG+SIzql5gL80=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSSTbU4lHBt5Ae8XthH/2vjhq34kzf/+1hAnw+fF/ILCF+YEFW
	pNWpuh544MkOrPQhGeld3giOjVVkZ6k9AsYIFlkRsnv6tSn4Za+bnkgcs9ZRM9MlCRHqsBOpQPy
	i9zjkF1TCwL5SN7gN47j4esZSF24=
X-Google-Smtp-Source: AGHT+IFdN7CQlNG7Z4/pzQWiLsu0EFgNsMpPnKQE23XgLfB9rnTVGgJTc10xs6B0LLchx5XDjp3+ymefBefd4ATKd3M=
X-Received: by 2002:a05:6122:3104:b0:4f5:1978:d226 with SMTP id
 71dfb90a1353d-50207ebf230mr10711341e0c.3.1725888421147; Mon, 09 Sep 2024
 06:27:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240826215313.2673566-1-philipchen@chromium.org>
In-Reply-To: <20240826215313.2673566-1-philipchen@chromium.org>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Mon, 9 Sep 2024 15:26:49 +0200
Message-ID: <CAM9Jb+jRL9f-JH1WNx0m-ua=FX+ksr7SjUR46pGUG9W+7yj3Ng@mail.gmail.com>
Subject: Re: [PATCH v3] virtio_pmem: Check device status before requesting flush
To: Philip Chen <philipchen@chromium.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	virtualization@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"

+CC MST

> If a pmem device is in a bad status, the driver side could wait for
> host ack forever in virtio_pmem_flush(), causing the system to hang.
>
> So add a status check in the beginning of virtio_pmem_flush() to return
> early if the device is not activated.
>
> Signed-off-by: Philip Chen <philipchen@chromium.org>

Looks good to me.

Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com

> ---
> v3:
> - Fix a typo in the comment (s/acticated/activated/)
>
> v2:
> - Remove change id from the patch description
> - Add more details to the patch description
>
>  drivers/nvdimm/nd_virtio.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index 35c8fbbba10e..f55d60922b87 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -44,6 +44,15 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>         unsigned long flags;
>         int err, err1;
>
> +       /*
> +        * Don't bother to submit the request to the device if the device is
> +        * not activated.
> +        */
> +       if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RESET) {
> +               dev_info(&vdev->dev, "virtio pmem device needs a reset\n");
> +               return -EIO;
> +       }
> +
>         might_sleep();
>         req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
>         if (!req_data)
