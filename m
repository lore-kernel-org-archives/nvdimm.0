Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28BA3019A1
	for <nvdimm@lists.linux.dev>; Wed, 22 Oct 2025 20:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761166692; cv=none; b=lKuKxQT84VW5NhPJuhaMfu+0oUGekfaagKY27QTH+5JHsj5wq3WqTwtQWeXv6E1J+BbxreJo2XnR1wTNDvA5Awl1qSvulsjKq5c3teOGFHHB+xkkYNM+6j8Mc7aRhMraaoJ82J+ngM5cWW+xBsEeRFtUJYTwoYuPxnO7+c1uXt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761166692; c=relaxed/simple;
	bh=TQpYo82do9fbPBhDgOo/xfuRqTcK0JdKSr5C7vhi+wM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ceNczwtQU+pgTHH5K+t4yOdVWejOQdaLSGuBnTJmfa1yUmUAmCYq/hL69Wlm2HqxCKnlxTfCUvmWNLTZn8xSsFjjz7+psomNleSphayYr4cyqvDYNkdue5D9nnCgaTq+c2xWWRD/A7SoUoyKizUhjXS+pvDwNspvl0pZJBnk5jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uAysWlLe; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uAysWlLe"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-62faa04afd9so1240a12.1
        for <nvdimm@lists.linux.dev>; Wed, 22 Oct 2025 13:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761166686; x=1761771486; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KntpGwyw2h1eRy075Psp2+8kVtmZoXi9VrfpKSJ4LV4=;
        b=uAysWlLe9sHX3FCOdr7WtSKGZAG6uqJiUs3CRQG14GnH0qR46aGvq7du9wFo93onmP
         ezk9TYajA3sJnNVznfO3k82rSBJTr3K71WNgUz9iDGJ1OFkIMtk3wBox0wTfi4MmfgJ1
         9WCgwIK2oc2VUhQJgce+OakBhf+h135SZJ3rwzxdNwO2tdM5GgBRJdPFb6aOC3FMUuvN
         fSXw8qSU5BqwlfyXhy3C7TbtXkbPkDxYivE0Fx52xN0BY20QAOdTVrtvMQve/RPSGRu0
         tuEj/IKLaoTVGs5aX3ND9VNTYz/NC4Lgb48hvHiL96RtflMFPFEKYV+IeEwq/2EMCOjx
         Skhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761166686; x=1761771486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KntpGwyw2h1eRy075Psp2+8kVtmZoXi9VrfpKSJ4LV4=;
        b=W8Pr/F0O492pQfgI8jRyz5XsYuqHnkcXQu0W6L08rrnQPwj8PJbalC0AECXFHrrY6t
         jQN/w4Bv08lqlv9sp54NmNPxpY9Al4hFdCf1Ry4KRnMYa4JPG0U8dEEa0O+zwINTAAfQ
         GTqA6e2z8J+rJURIzy4XqNzF5tVAa4OKVq+AHBsWPtk/ow2RCMleB/F+w3uvlYpiJ3lf
         h/rpkJPRx9p7pNesC3xe4pxO7kOtm4o04G2HT3jjTOH3+2cHDHsyZXnxlbwrjTDC6QLY
         Y1zU+9Q9x2QSf5IPgjYCwFHKcynMYGR7TNzI9Ekx2kHLao/kMj7Y/wWMS2uZ+wwjiDkF
         Rl7A==
X-Forwarded-Encrypted: i=1; AJvYcCXQ7PlGmccd+flU0cXVAuh1/YFk211+OSH2lxtlhhw3BjdQoaO1cAKCw1I9Le4DMjhYa9wLa7g=@lists.linux.dev
X-Gm-Message-State: AOJu0YwCCQaguBuTP131aV5it9SoGaGgLK5PPyIvDHR9Wh6lUr+l4Q+N
	2W4DBlew0z+CPw4BmtEeBMytdYYdG6BBZr9j3KeMqJShMs4g0zlFPGnMet5RIzFzT7G5FIx+inQ
	x15w1BgUbNKvP6estfL1r/3MFQ0aocIkbeBNX53Xi
X-Gm-Gg: ASbGncvEmS5stv01AD5Zgti0asWySzaKEvVKchT2MXJnB3+uyTWv6jkzluD8kGKYm8G
	ppYcnqQwLfg/bXZlWhHiztnTjqzjrmXDfLXRDVZvCiMDVJu/UoeaZcDkAhibA9oYc0dZ51ry+M5
	hcvcJ+QwV3dtMvulNOsv3r76Ct6fvnZaRLEn0Phbjjr2ml9q1gzClEG7E4X7I3utg08uwbMczw8
	Bd1RXxIyQ2IG3YE2akxB9bfOeof5kSuOJP6rzt8IkB4+THEPkLxSUNJzCGAb8SZC3eLdeAvdSs0
	NZ9frcdfC6kNvs4wmti1tYBQRQ==
X-Google-Smtp-Source: AGHT+IHgF4j/mUZEDqZAl++xOkAYLCnDO8Iy/nIey1xYjKyG9Wp2IkcKh6OYcT7hZgMYLxTQIiT4e0yyMs4NIgQAgdA=
X-Received: by 2002:a05:6402:461c:20b0:63e:11ae:ff2e with SMTP id
 4fb4d7f45d1cf-63e3dfecdf6mr6012a12.3.1761166686350; Wed, 22 Oct 2025 13:58:06
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251002131900.3252980-1-mclapinski@google.com>
In-Reply-To: <20251002131900.3252980-1-mclapinski@google.com>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Wed, 22 Oct 2025 13:57:55 -0700
X-Gm-Features: AS18NWD7w3Vu9VTTfAZBw3yA23oVp-mhN22JxweH_RPe5JsaBthUo_xHsiEjfTs
Message-ID: <CAAi7L5cJ=D76pD4tb5Bs0ULGXMEOM_yQcftFBQMZmzDJTzBZ+g@mail.gmail.com>
Subject: Re: [PATCH 1/1] dax: add PROBE_PREFER_ASYNCHRONOUS to the pmem driver
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ping

On Thu, Oct 2, 2025 at 6:19=E2=80=AFAM Michal Clapinski <mclapinski@google.=
com> wrote:
>
> Comments in linux/device/driver.h say that the goal is to do async
> probing on all devices. The current behavior unnecessarily slows down
> the boot by synchronous probing dax_pmem devices, so let's change that.
>
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> ---
>  drivers/dax/pmem.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> index bee93066a849..737654e8c5e8 100644
> --- a/drivers/dax/pmem.c
> +++ b/drivers/dax/pmem.c
> @@ -77,6 +77,7 @@ static struct nd_device_driver dax_pmem_driver =3D {
>         .probe =3D dax_pmem_probe,
>         .drv =3D {
>                 .name =3D "dax_pmem",
> +               .probe_type =3D PROBE_PREFER_ASYNCHRONOUS,
>         },
>         .type =3D ND_DRIVER_DAX_PMEM,
>  };
> --
> 2.51.0.618.g983fd99d29-goog
>
