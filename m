Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D2A1D31B5
	for <nvdimm@lists.linux.dev>; Wed, 11 Dec 2024 08:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733905113; cv=none; b=qZCm0nIIMdGXMxaoHPpmnlM3biB6rRdD3Z0oz5JMDu2NSa4hRuskmIBd6Cljkbdrx3eIf5bxDEjjfXoHP3AlA+sHHnm9+mszZrl0rGXmMjoWZBgMVn7D7pFMsFKPPC2habpnjy33qx5LDIGpMuw6sW87/eDtMMdZkFgXonBDmAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733905113; c=relaxed/simple;
	bh=XskHzUQ0wP3xisQAsDVTIVaMiwmap3TuSXWv2UwOOoE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aOORhf2tnNwyKGp2/E+QLyf14SSlD3xRXavPo/9VKBof+78BgUri07bKi+dkdnGNRjL9t0ck4r4xPX8LYHgtUUolgwIyWvrVvg9qLFx8ERjyjj1/+miqc0N/RQVzgSZwRth15KSbQmwj5zcbD8Ir/1CwUb2e02t8mqYykMDoIcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=jxqgUTfj; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="jxqgUTfj"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3003d7ca01cso40264441fa.0
        for <nvdimm@lists.linux.dev>; Wed, 11 Dec 2024 00:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733905108; x=1734509908; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XskHzUQ0wP3xisQAsDVTIVaMiwmap3TuSXWv2UwOOoE=;
        b=jxqgUTfj07mXSJmMxMf8zeUEAVr1z6yWih+p2e2bfFpUfMt2W1BDdRMmmB4Yi0Mc+o
         f05crafDW8zhFRacIe4tbegSAAUjfwoVN5xVw4V65PmecclXWu2foWBIlsVFqt1BoN6Z
         P4VZNS3RqTqJEaWQmPQ+d+X6CzyIT5eXbYfMrOzPb2gh0RW0Tnb1R39xSuNubYfw3cIJ
         o/FXVgUYhv8Y6RlGUZgFS9wWz7yHPDCBOJUMDYeOVFKy/klVo0o2qd1AM9BUmmcR6w11
         i8fHHrV2KUuHQ8E8497ACstp5eHKqv3yBKNG1k4aompeQvLx9TgWJ2OU4Oqy9TZeT8qp
         y4RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733905108; x=1734509908;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XskHzUQ0wP3xisQAsDVTIVaMiwmap3TuSXWv2UwOOoE=;
        b=Sr+HqeL310oWd3CceigKZWAMvPANAKAIJaqw1o7ss5ZHp2B5MM2IuT1ndYv5hXdX80
         F7OBsGW2YJ1vysLT73Nz5jpMkMl0/EtbYRhYDmOQGTVcWTWfW33eOQ5R+McYPwSF6uxK
         Adejfe8BKK54XsGo6sjxiQqnywYgGuFZBrTlj0sCTxRYSvilXcN7J+eG3OnmmU/ZLW5D
         0m71Qezo0h8WEZMOyVDHJM4Fv0j9Y86SNrPKiFGqqYd5dY6QcpmaFX3JP5AAC7fguj7S
         jlopNUFkiWEALJdFPInYX2K7KqidW7/BFe8JmtJS8qvwq1EwPyBOsQpTSj1e+AGqa+Wt
         rzhw==
X-Forwarded-Encrypted: i=1; AJvYcCX6nbmoa2G11LrtiGnW1bRkuePmFh3c5DL7GFP3PvYOjVMjYeCLv+EZiW/rsRFsmpjPc51a81w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHjApgkwGdVn7GDP9h82qUjgru4vcRABKh2a3O7Yn7eQgLa+8P
	I8pup0FoiX9d3JFUkmwCglhhvLmJRgHWnviL2KCxI52k1AmJzEaLCDaJBkIm3RQ6qqM78i9xlTK
	yCJ8pAXDRolC+BbNbEbWb1RF/pv0ZKvtUuExmTQ==
X-Gm-Gg: ASbGncu7umYw2gmS2g1rMkaUAWV2GZ0JS2QGqXfLicS2xoEzAc5s63/WdZJ8eKJl5bd
	+qboblrVQGEEDZUxsoohaTN+QUh+9I03wT3+iMz6ktneTRYzdTEiyNNBvN0iHVzSLFV0=
X-Google-Smtp-Source: AGHT+IEyqSnEBMMtZyEj5jF6bo6/CxMQUAS8l/Vem+Q0Tg0zwJltPimb/BXxYNi4dNa8OIsM4j3xdj7bHzlce3zdJRY=
X-Received: by 2002:a2e:bcc6:0:b0:2ff:c95a:a067 with SMTP id
 38308e7fff4ca-30240d08829mr5734311fa.13.1733905108362; Wed, 11 Dec 2024
 00:18:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241211-const_dfc_done-v4-0-583cc60329df@quicinc.com> <20241211-const_dfc_done-v4-8-583cc60329df@quicinc.com>
In-Reply-To: <20241211-const_dfc_done-v4-8-583cc60329df@quicinc.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 11 Dec 2024 09:18:17 +0100
Message-ID: <CAMRc=MdJuy9ghgLHxbygdHME2EkttZ7zBMJzCis=t94EUMbGiQ@mail.gmail.com>
Subject: Re: [PATCH v4 08/11] gpio: sim: Remove gpio_sim_dev_match_fwnode()
To: Zijun Hu <zijun_hu@icloud.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Walleij <linus.walleij@linaro.org>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@kernel.org>, 
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
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-serial@vger.kernel.org, netdev@vger.kernel.org, 
	Zijun Hu <quic_zijuhu@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 11, 2024 at 1:10=E2=80=AFAM Zijun Hu <zijun_hu@icloud.com> wrot=
e:
>
> From: Zijun Hu <quic_zijuhu@quicinc.com>
>
> gpio_sim_dev_match_fwnode() is a simple wrapper of API
> device_match_fwnode().
>
> Remove the needless wrapper and use the API instead.
>
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> ---

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
