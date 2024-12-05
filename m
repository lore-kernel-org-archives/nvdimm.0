Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1471121C9E2
	for <nvdimm@lists.linux.dev>; Thu,  5 Dec 2024 16:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733415903; cv=none; b=AJHmcj9tDkQskgrtRbxAlZdOeN9c5jmRsMA0p0JJ16y3cZcD64L2GDSeOoOFYnnBS0FrSkEwwGKZNiezwAqE+WJq3dSMgoeEmQ7yApvYv+z0/uUnE21A2jpOwku1xEFckw4SRgE8AGFCtkDvfSkz8MtLE91ljR1IvLIB0Hmze+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733415903; c=relaxed/simple;
	bh=R7CVb9LI65y/3Qu32CYYXvSxOe5U0ZYewJNDLJ5FwCc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uOds6XBqdKSSI50l6Vk8HrCrzOGKPriq0uIqkRte1EuGUAEDP0sA0JabtMxUJ7W+OdOKKvpmmVBo/fyP1B/cYFKq2VkUtooV5wBDZiTYlfltIggschwYzmR03bNhx37pNpAeH09mw7fpcoKmt40X1sDuPrg8Fsb9HYXCpJmseYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=JOi/2xrL; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="JOi/2xrL"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-53dd668c5easo1268523e87.1
        for <nvdimm@lists.linux.dev>; Thu, 05 Dec 2024 08:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733415897; x=1734020697; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ItHEVA7I8S1EP8oyTKl1F93KEEHRVDFUauUtw/1Acb0=;
        b=JOi/2xrLgC8GT6huod23otLVEBuCUIyTKwJc/q1BEruE1jYzlIQuipfpWFRSaj5q+Z
         E7M5CEinAIpskDgM5tzKw35GP9wrEYX2INGAW+C2Dtb8/AvLL+GzCFjU2N/TOHg+/gS4
         EUAs2l/9NjumjK5KnZhIHqz4CeaOrjtB3v4l3NNbke2nyMMtfRbqcewQ2FU1Ji/dC2oA
         fUn9kFuqiGh13jnUk8mGwGKfl333hF+6V5dGSQtYOb+mlkyCf6RRA3faRj3klU5Tpw4K
         aQyuoLqPhPLpJ65X0vPEbAAYTZcJP/w8BiT4T13gZNh3L91vVxqjFtIxBscoT25N8XDw
         Cplg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733415897; x=1734020697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ItHEVA7I8S1EP8oyTKl1F93KEEHRVDFUauUtw/1Acb0=;
        b=OodHoy+TPPYdc+6H9XymqNgZhY0bNl0WE22kFHqsFpEcLlbKtEgJhYur2VII/PGFBT
         mT+Tp6zFQNBghd9ARDZwh1QjxJxm0DEF/LMyEzSIupt3aNQ9Zyb0e6Wa2lJSm/iaeW1o
         apkSVzE82wfToJFv7ZvXMtLzQ3w6zaIfp3pQ0GlpODMGjhPnkNGgwCFNixz6bcGXhbTT
         zJ2ygP4fhmAp3/iEjV4n3223T38uzQI6hyM4psG8HhfzGDaWJES4GWQCKwmKIW9+B101
         mctOPpOI1SjoqVz/DZ7DcUlh5BdQU06mfSMh99Do0PLV/9LQn//LNPsk1pThxIHbsAFK
         31Jw==
X-Forwarded-Encrypted: i=1; AJvYcCU/kFfB7OBtqQim/yLUzRne3JU8ojemmkhzbVFGUyILIP8xZ2Jxji+t2v9MZmVyNBi78zGkPqo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWFyRkN+BADNUfKhA3k3hPqDb0QgFK0extngw3LjIvBUBl2qT9
	EXC/tgcRtoaLQibvHb/kbbIPvl+S5mxCDIK1dkKpeiNOCgkCTC/HQchgh3Dv3dweCDVz0UXoabk
	ZCeEQ4UzE/NW9iDqFmcjKaw35dsFqtOBn+6Cmjw==
X-Gm-Gg: ASbGncv1bFJTOo2VYcVrTEVANikZ3ZXh0vTBpfRqlLoJDIPEUmH1LgznZKy8sOF2TcD
	K8DD3n9aGxDIncY6/hFDpIkfvL94b0xKYVbWIYUgQdCe861PB0awV6Jlz+vZAPg==
X-Google-Smtp-Source: AGHT+IErYJU9bnmgh/S4XgU0jcrMWfkUEiJSX94XfyJ1xliCjLlWQwaDM6P30GxT6teJ6fjjXCYzQKweIZQ1ynm3Yi8=
X-Received: by 2002:a05:6512:4006:b0:53d:f6bc:23ec with SMTP id
 2adb3069b0e04-53e216f74ecmr1077273e87.5.1733415897149; Thu, 05 Dec 2024
 08:24:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241205-const_dfc_done-v3-0-1611f1486b5a@quicinc.com> <20241205-const_dfc_done-v3-8-1611f1486b5a@quicinc.com>
In-Reply-To: <20241205-const_dfc_done-v3-8-1611f1486b5a@quicinc.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 5 Dec 2024 17:24:46 +0100
Message-ID: <CAMRc=Mf--vRm15N2au-zvP89obcxRuk+3OOLqFtrjgg61_LotA@mail.gmail.com>
Subject: Re: [PATCH v3 08/11] gpio: sim: Remove gpio_sim_dev_match_fwnode()
To: Zijun Hu <zijun_hu@icloud.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@kernel.org>, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-sound@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux1394-devel@lists.sourceforge.net, arm-scmi@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-gpio@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-mediatek@lists.infradead.org, 
	linux-hwmon@vger.kernel.org, linux-media@vger.kernel.org, 
	linux-pwm@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
	linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, 
	linux-usb@vger.kernel.org, linux-serial@vger.kernel.org, 
	netdev@vger.kernel.org, Zijun Hu <quic_zijuhu@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 1:15=E2=80=AFAM Zijun Hu <zijun_hu@icloud.com> wrote=
:
>
> From: Zijun Hu <quic_zijuhu@quicinc.com>
>
> gpio_sim_dev_match_fwnode() is a simple wrapper of device_match_fwnode()
> Remvoe the unnecessary wrapper.
>
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> ---
>  drivers/gpio/gpio-sim.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/gpio/gpio-sim.c b/drivers/gpio/gpio-sim.c
> index 370b71513bdb529112e157fa22a5451e02502a17..b1f33cbaaaa78aca324f99c45=
a868e7e79a9d672 100644
> --- a/drivers/gpio/gpio-sim.c
> +++ b/drivers/gpio/gpio-sim.c
> @@ -413,11 +413,6 @@ static int gpio_sim_setup_sysfs(struct gpio_sim_chip=
 *chip)
>         return devm_add_action_or_reset(dev, gpio_sim_sysfs_remove, chip)=
;
>  }
>
> -static int gpio_sim_dev_match_fwnode(struct device *dev, const void *dat=
a)
> -{
> -       return device_match_fwnode(dev, data);
> -}
> -
>  static int gpio_sim_add_bank(struct fwnode_handle *swnode, struct device=
 *dev)
>  {
>         struct gpio_sim_chip *chip;
> @@ -503,7 +498,7 @@ static int gpio_sim_add_bank(struct fwnode_handle *sw=
node, struct device *dev)
>         if (ret)
>                 return ret;
>
> -       chip->dev =3D device_find_child(dev, swnode, gpio_sim_dev_match_f=
wnode);
> +       chip->dev =3D device_find_child(dev, swnode, device_match_fwnode)=
;
>         if (!chip->dev)
>                 return -ENODEV;
>
>
> --
> 2.34.1
>
>

Please use get_maintainers.pl to get the complete list of addresses to Cc.

Bartosz
