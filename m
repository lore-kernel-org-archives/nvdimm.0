Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DABE280332
	for <nvdimm@lists.linux.dev>; Wed, 22 Oct 2025 23:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761177249; cv=none; b=Z77f1td8gR4vhGmlfQk1i9HQ7BLMcDU8b8RHdoOWDvjXzPfnNlQw72icneXMaPH4PxnY0dp5c5TH+zv9KRWWYY61+VhaBN8SnKp6r+JNM8tz1XsUX9z2Fsk7r/422sg1ORN6fS0ASDbqXHhCezDGI179C+x9GhicSH3J93z0Zn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761177249; c=relaxed/simple;
	bh=nO5DHKyBlotpTFhDE7x2Z/A+Jp3/mi/ndcWWH+QPYVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ihc3Cql48/1BYZ7EEuA0OERKVl0W3aNvZtaQ6eDE1jq2Pb63qsdcquGObVI4eDsl5RsuUfqzExganKj+XyeOq8TZ4jbIu4/+GOboskozuytml2k9tsyGfaJFIT4oasKS4D+FDDv3aK5he0qR0sk2bjUeqXJ7dj9J4HPOnRx5cVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o5wworL5; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o5wworL5"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-62faa04afd9so2717a12.1
        for <nvdimm@lists.linux.dev>; Wed, 22 Oct 2025 16:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761177244; x=1761782044; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r6RHQchnkCCZHFiL1DU1wWeMfjedF3ffXwGFW4DpStk=;
        b=o5wworL5CwFb2TRugKL9QRocolCRgK0MoAfSeB8ULrdvIinEDxUpgefOVScFpWOf7u
         hBlhTzC+gln9v9kzjgQE1GVJS3nnz74l7pfCip2TRsqbdh/5Ryb82sAeUj7o+C0WWE6I
         q4EgScE+lUtGa7RSdPo0hj6uc/hSdm5l5eg323LRzlRG+v618OeOnRoKrqgDGK0HORw6
         SRGQaEFCPREWdEqCfmaRsPeCVoASKy/8mlNr2S8+9csmwe5IPR2mkI9MriT4uaeGx4Ay
         CRQ021xq38aihqJ18jKJVnhQIGpVZrNRhlwBuoFfEyEHNxjL0wy3F1WCtqJbDui/6p4m
         lvQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761177244; x=1761782044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r6RHQchnkCCZHFiL1DU1wWeMfjedF3ffXwGFW4DpStk=;
        b=pxcjl0pVIzyDZb/gZdq2CyVJkbSbxts2mYZZFdQ6e5PjNILknrSDhMksIy0livAA26
         YgCFVuiaShpS6I8Z4QTuYHWHoOPJt8UL+QX+CJDZK1vlSjbjLijxQ7FwH+n37EEOG/J5
         ZwSdHvT106ia+p4W2lecfVyerfHwKE3M5JoSZL89j7SWmW+h7eGY51rBN0GXiN1gzSuL
         L+pTcXAOVayyiuFE+LHEKPm3NmVO68qMOUTwB6N7zRGgYI4vY4shL7wOwdN12jKxwUTk
         qHcbjxADPD1V9Y0dzQCg0M8ata/61SPUnHMXNTSBmG2wvS7CtBPLuK/uoFXGTpR6Gwhi
         K1Eg==
X-Forwarded-Encrypted: i=1; AJvYcCW5bKvhcGcrU2+unBcTXpb4SdszLjRX1ckuYipapw7eUAAv3Aveqq1RVUbt58usZ0q2OHwBMgI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrlavWRGMcgPrG1vmwjnkcpv5MvGVuvz6g2Hvq1nYLBYfAUpta
	XM9P4BfeaCrutm5YkRFxbpxGho96aFMFNCKUvLrlHTZ4kvZAWaoB9fMAMyiKuN3n2iJi7ueAAPo
	6E+B4hHr3FSQUpn8Q0mhPjlky+EvANE5A8F10BHPe
X-Gm-Gg: ASbGncta5XVoIKYuOG8X0vbnWumlcKkK8QDy7QIaYNNTH65C7Fa3mzDjyYhk+mF6oE2
	mLXibnNGQGNkXRQ4JnDFqsn12ib0VA0/JHfx5K3mODRk0NDSA7Rg5fp/N95+4XjMJUzBZAPzP1S
	pyX4S0SwaggRte/f9Z1ST/PW4eIVau0Mxxenb9QCjwWHdg6onPrIPieoZO9Jc85cBDNInUZtl1V
	1RGxE3vjtb0FxaYd0D/po6TjiZX8ZoSvjzRzQYJ4rtaYTP1ncKRF+efK+Bf2L/9m2P8QCJx6Xgk
	DyzgUfJ227GjK08=
X-Google-Smtp-Source: AGHT+IEWd9FR9gKb9Zr14FO/SKIlqzxl6oi295G5iTkBVXoZe00E7i9wXEgtTQAijiYV0qbtiq+FZcMar8NwTFkA0k4=
X-Received: by 2002:aa7:d519:0:b0:62f:9f43:2117 with SMTP id
 4fb4d7f45d1cf-63e38faf5f8mr36697a12.0.1761177244223; Wed, 22 Oct 2025
 16:54:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251002131900.3252980-1-mclapinski@google.com> <68f96adc63d_10e9100fc@dwillia2-mobl4.notmuch>
In-Reply-To: <68f96adc63d_10e9100fc@dwillia2-mobl4.notmuch>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Wed, 22 Oct 2025 16:53:52 -0700
X-Gm-Features: AS18NWAykxizA4pVQXnJ4CA0IxhWYm4ch5MzN7bzmvn3HrW8QsvVciVZgzdKZZQ
Message-ID: <CAAi7L5eY898mdBLsW113c1VNdm9n+1rydT8WLLNJX86n8Q+zHQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] dax: add PROBE_PREFER_ASYNCHRONOUS to the pmem driver
To: dan.j.williams@intel.com
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2025 at 4:38=E2=80=AFPM <dan.j.williams@intel.com> wrote:
>
> Michal Clapinski wrote:
> > Comments in linux/device/driver.h say that the goal is to do async
> > probing on all devices. The current behavior unnecessarily slows down
> > the boot by synchronous probing dax_pmem devices, so let's change that.
> >
> > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> > ---
> >  drivers/dax/pmem.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> > index bee93066a849..737654e8c5e8 100644
> > --- a/drivers/dax/pmem.c
> > +++ b/drivers/dax/pmem.c
> > @@ -77,6 +77,7 @@ static struct nd_device_driver dax_pmem_driver =3D {
> >       .probe =3D dax_pmem_probe,
> >       .drv =3D {
> >               .name =3D "dax_pmem",
> > +             .probe_type =3D PROBE_PREFER_ASYNCHRONOUS,
> >       },
> >       .type =3D ND_DRIVER_DAX_PMEM,
> >  };
>
> Hi Michal,
>
> Apologies for not commenting earlier. When this first flew by I paused
> because libnvdimm predated some of the driver core work on asynchronous
> and has some local asynchronous registration.
>
> Can you say a bit more about how this patch in particular helps your
> case? For example, the pmem devices registered by memmap=3D (nd_e820
> driver), should end up in the nd_async_device_register() path.
>
> So even though the final attach is synchronous with device arrival, it
> should still be async with respect to other device probing.
>
> However, I believe that falls back to synchronous probing if the driver
> is loaded after the device has already arrived. Is that the case you are
> hitting?

Yes. I use all pmem/devdax modules built into the kernel so loading
them is in the critical path for kernel boot.
I use memmap=3D with devdax. So first, the pmem device is created
asynchronously, which means loading the nd_e820 module is always fast.
But then, the dax_pmem driver is loaded. If the dax device has not yet
been created by the async code, then loading this module is also fast.
But if the dax device has already been created, then attaching it to
the dax_pmem driver will be synchronous and on the critical boot path.

For thousands of dax devices, this increases the boot time by more
than a second. With the patch it takes ~10ms.

> I am ok with this in concept, but if we do this it should be done for
> all dax drivers, not just dax_pmem.

Will do in v2.
