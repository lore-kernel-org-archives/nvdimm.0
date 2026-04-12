Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB4F81ACA
	for <nvdimm@lists.linux.dev>; Sun, 12 Apr 2026 06:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775976022; cv=pass; b=Fqik1Dha2v32wcZdw1QtmaBEBFQ2kCtK7q3BX/7czVm4+3voTjkkp0AJd1l4oMNWE60Q3k/B5kq2CkZls9Pkllrr7ktaeMrZ2fG691TcyHsMfbp6Ju2v8u2Yxzer66811kaQHIq3RIifgJCgfPLKgPEp4p7VhB6QvIXaCT/dSjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775976022; c=relaxed/simple;
	bh=a604DeiNAPyMT/Lkekno8TTnpz8UJxsFOLOcq9BBqxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R5Sgd615F0M/MEIjbLNkZRLHZqMlXspTKsvA81A3RMO8uXrsYuN3eJ1o4u1TKw9w3Lshf0MRFkBX7q5P9vEDw3Tyc/gB+tu0hDrGgoXRyLWHUDIqog1nKTcCxKU8Vm7iN2AQQJ88fT0fWSlxbhj2JszJV2yOnAmHbdqijrov4jc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mvXGBLz+; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mvXGBLz+"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-651b4d09141so755083d50.1
        for <nvdimm@lists.linux.dev>; Sat, 11 Apr 2026 23:40:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775976020; cv=none;
        d=google.com; s=arc-20240605;
        b=ZuEDFbH3Hfygxh42lNE8bjtHYdw07cIIk5/V/f17Uggb1uxY0IsiKVLyHZInjOcx/M
         hh8Tz+OW2fvBFKdDzs0X++i9I8QvPldW0djVcYHAqpONSAr6LUrlBrNI2GxHbbB/3X6u
         1/9+M5p+ekpbMeA3rHSoAg+7+S63B4Tl6UiuCZLQ2aObyhT8R4w1ahSVjcrXx5qwBPxI
         qGPmS2sifUyiJIKHf4FKCRkukQq9kr2wPfywCUJcokDD0UXv4aAt0G88VFtyiDJN516w
         PSTqTRvDlBOEXt3pyQZ0qU3zQ/Y8BoaaqRHQZX/tR1542HEaRIzuUiBFWc1Rr+Tr5e+A
         EtGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=353BGQR5E+FUbDTTQca9SIYSG89yYQ90FU4wNhB5wTM=;
        fh=hSREep0HZX8IkRWQ3WN26vSyjeHzZTQpa2e11IoSDGc=;
        b=ZPERqR+G1GCr3qGPeOidwYVUWnOQIzwLc5498o0DuX04yZCXLwqvFEs3YasGahWt/c
         7oNowD3Zk5DyMW6loTiXNp7zAqQhP8R+z7uF9vLT8q9JL+mdgmfJpAP/y56Og5up5xBO
         tlaVPTGlw7k4Ha3XSjeE70Oxcz1UmfybHktljwRShknGin87bZvbN3THUZFCRvFw4kqq
         8REsh0kNqgJHPIAHRdgUl/Zuz6rtNpuaXkhb2uuqj8H7xut6oA8uCHI+S0vFTd99m6xy
         HrWrSCBZinF89QU279rn/eBDDicZGdBn8OAWtvx642yv+iM9YVuh2iqq81fM9anNsc9r
         MXiw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775976020; x=1776580820; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=353BGQR5E+FUbDTTQca9SIYSG89yYQ90FU4wNhB5wTM=;
        b=mvXGBLz+/Entv5eJyauXXohrAwLxWygw65W9PmnDAlepdibnfryF2I9UAQUcd+DD3C
         PjKzFY4ESeknz3oyrIs/Zg2uLl1n+Ae5yxnUOrMrhTMmOOcM28Ej7ENy4yxfac933oJK
         N7eOh/Cp/WoYw6GLxfDZq9RgYG2GgXtlS/e6hHCD/nSp4AFpH3nf/F1m2ys7TzXzTTH/
         jA/ZXR4Q/fAJBS6iyaW10dh0JsrsGlglKfmUKQ7A08TfAmNqxRgSNMWtwFbYDAKv/ChS
         5eWeEtylU2LZKRgW6foxnZkFqPsMJQmtmUBSNXlhqnSh4DFp8kGm1Y7WTE5TFnyRjxH4
         qVYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775976020; x=1776580820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=353BGQR5E+FUbDTTQca9SIYSG89yYQ90FU4wNhB5wTM=;
        b=dCl81APDN7GkmOJRVtYdS/9Nf9ET/BazC+tyIbctMtzImRfb3x0+rX2TeBbuQIgaKA
         FGBvi2qslopiNc24rStTyGtSlbcHTeJpxUmtko5ToQJ01lzskDc1Q0pDQSZ14l/nHnHb
         WSKdqmrlufJIRh8v3/CSoCuTYD3r4WhpOQb0jy/ZAUQrD3HO7xt9N/IARc9Cvgg9GpZX
         WVQ9RshpInNMkUsYx7oec0xcZhZT/Z6FAxY9eeNZ2NRHvUTJ4T0dyAI8K4UCwcQPEl4Z
         svap3V+wTCbUoSn2ORlJseSHWQTaN2mRHWkMx/Spt5WDSqFIp5APOKxvpMO6HFczlCTt
         3gBA==
X-Forwarded-Encrypted: i=1; AFNElJ+Yvejx/X/a8XRViFQH7VRsEYPWGm+n4C0xsIaMJIHmyDB6xMfbJY6QkowDNt/MGn56ErGKI8k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6f/EjEtpthSViLewqI7CN3ZWqjK5suGaEKganx7Goz1okSy7P
	FdWjLgl8rISkQfGUgsMiV+LlbXXY8264/EbbxT6EpcNSsnbR663+MFHM0JXa6HAvu5QllYL+oBu
	+/Ma/d0t9wdk81tqMxHZ5eBsej8NEgik=
X-Gm-Gg: AeBDietNKmg7sO9tu56a1doH9dGBLPIqwjec62tLUPM6abxJzggjGsdpUiZRfL1UDKE
	OdUerI6s+0panx57oBrL3DM7kkz1t/9z96orZOJACq9FXls2iI1JmFrxw4TIKP7NSytfrFZB44D
	uHVgu8KZFXYKDr1PXC2SwQ9tYPaRZD/+sqbRPYhZn2KtPan9YuI4psecelAxGGU/+QwHxIoaue6
	rFv+zJhrEW1JaApwByb3Zr5q7b2uv3pMVBCu4ya7hp7Hhc31Ug9hAHdx/LRaAuW2liBelARIIeM
	GXJDNQ8=
X-Received: by 2002:a05:690e:d4a:b0:651:8abe:ce47 with SMTP id
 956f58d0204a3-6518abed70amr7968580d50.5.1775976019736; Sat, 11 Apr 2026
 23:40:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260411145726.2299438-1-lgs201920130244@gmail.com> <69dad954cbd27_fdcb41005c@djbw-dev.notmuch>
In-Reply-To: <69dad954cbd27_fdcb41005c@djbw-dev.notmuch>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Sun, 12 Apr 2026 14:40:08 +0800
X-Gm-Features: AQROBzBoQieHezjldgST08cWePETtgJOGA36kUbkZPgBK0CARxWtw3VoS8begvg
Message-ID: <CANUHTR8krObfwdkV9PFkfRcWgiVwSMfmKD0U=xY9_543KxZqTg@mail.gmail.com>
Subject: Re: [PATCH] device-dax: Fix refcount leak in __devm_create_dev_dax()
 error path
To: Dan Williams <djbw@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Thank you for the review and for pointing that out.

You are right that my changelog overstated the impact. I do not have a
concrete use-after-free case here, and the practical issue is simply
that after device_initialize(), the embedded struct device should be
released through the device core with put_device(), rather than
freeing dev_dax directly.

I also took a closer look at the release path. Since dev_dax_release()
already handles free_dev_dax_id(), kfree(dev_dax->pgmap), and
kfree(dev_dax), and put_dax() is NULL-safe, the post-initialization
failure paths can be simplified to explicit range cleanup plus
put_device(), once dev->type is assigned before device_initialize().

I'll send a v2 that tightens the changelog around the actual lifecycle
issue and cleans up the error paths accordingly.

Thanks again for the guidance.

Best regards,
Guangshuo

Dan Williams <djbw@kernel.org> =E4=BA=8E2026=E5=B9=B44=E6=9C=8812=E6=97=A5=
=E5=91=A8=E6=97=A5 07:29=E5=86=99=E9=81=93=EF=BC=9A
>
> Guangshuo Li wrote:
> > After device_initialize(), the lifetime of the embedded struct device i=
s
> > expected to be managed through the device core reference counting.
> >
> > In __devm_create_dev_dax(), several failure paths after
> > device_initialize() free dev_dax directly instead of releasing the
> > device reference with put_device(). This bypasses the normal device
> > lifetime rules and may leave the reference count of the embedded struct
> > device unbalanced, resulting in a refcount leak and potentially leading
> > to a use-after-free.
>
> Please do not list "theoretical" problems as justification. Point to
> real problems.
>
> > Fix this by assigning dev->type before device_initialize(), so the
> > release callback is available for put_device(), and use put_device() in
> > the post-initialization error paths. Keep dev_dax range cleanup explici=
t
> > in the error path.
>
> I see a more straightforward way to address just the practical problem
> that also incorporates the other feedback I have below. Can you spot
> that and fixup the changelog to address the practical impact?
>
> > Fixes: c2f3011ee697f ("device-dax: add an allocation interface for devi=
ce-dax instances")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
> >  drivers/dax/bus.c | 13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> > index fde29e0ad68b..8753115cd371 100644
> > --- a/drivers/dax/bus.c
> > +++ b/drivers/dax/bus.c
> > @@ -1453,6 +1453,7 @@ static struct dev_dax *__devm_create_dev_dax(stru=
ct dev_dax_data *data)
> >       }
> >
> >       dev =3D &dev_dax->dev;
> > +     dev->type =3D &dev_dax_type;
> >       device_initialize(dev);
> >       dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
> >
> > @@ -1499,7 +1500,6 @@ static struct dev_dax *__devm_create_dev_dax(stru=
ct dev_dax_data *data)
> >       dev->devt =3D inode->i_rdev;
> >       dev->bus =3D &dax_bus_type;
> >       dev->parent =3D parent;
> > -     dev->type =3D &dev_dax_type;
> >
> >       rc =3D device_add(dev);
> >       if (rc) {
> > @@ -1523,14 +1523,21 @@ static struct dev_dax *__devm_create_dev_dax(st=
ruct dev_dax_data *data)
> >
> >  err_alloc_dax:
> >       kfree(dev_dax->pgmap);
> > +     dev_dax->pgmap =3D NULL;
> > +
> >  err_pgmap:
> >       free_dev_dax_ranges(dev_dax);
> > +     put_device(dev);
> > +     return ERR_PTR(rc);
> > +
> >  err_range:
> > -     free_dev_dax_id(dev_dax);
> > +     put_device(dev);
> > +     return ERR_PTR(rc);
>
> Please no gotos with early returns, that makes a mess.
