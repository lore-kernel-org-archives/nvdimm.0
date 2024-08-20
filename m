Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDB741C79
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 04:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724127382; cv=none; b=giCk66QXnnJ0mkGJYSwUbIFo4bTfmCcLZqvm16H0GQK5XO4/eZhqAuNjDqgtiv0hyPhBRm+ifuWXVxS2KCYdssik7D1irQ3yZq8sZVkvTZUbSed+M2DbEFuibgwSNic5Udrg8EaadTYXyk1JXoc3VBIaay9NzV9KAioiciwIyj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724127382; c=relaxed/simple;
	bh=GAY/p2+RIFAj4DrueEbtoLyRE4CtY/yinwNuslLZZmk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ea+c182WLRbkqzoDeDlNnk5AScHj2YfvRxT5qkmzsHCnhu1n7XItAO36Y81q88A6ozOA8PbTNKFkXBIeLiAa2mpzH1bXJj49J10sZofKlxvRoTR5H38Av7X2bqjYuYXZPpsMuxeIKOax4nYR7y2yJMvRPdd2kNZy0ADNDIRGy78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=bNXXsbni; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bNXXsbni"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e115c8be0deso573624276.2
        for <nvdimm@lists.linux.dev>; Mon, 19 Aug 2024 21:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724127379; x=1724732179; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=srakS6qJodiTLporsDBsy+02pc55aKhjRYvyA7MFvdA=;
        b=bNXXsbniGwQcwvmkGp5Jbw61OcVhWu1s9LJE/D/iOt96dnWqtb+yI1V44lYSxh6mCn
         nLHfRK6Od5r8baZfdfgR7iNUUcsh69LyTr1RBCOZYnldqmK+KG7vSf/CofglMN2oq0Ot
         l+Q3UhxenALl6sVmawxtQZg7429x9Sqt/8QrU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724127379; x=1724732179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=srakS6qJodiTLporsDBsy+02pc55aKhjRYvyA7MFvdA=;
        b=jo/5YSsTv8vz/ngi+ck2UpxxXH5SARtb/renfPpdXxoKTmqJJpNtPrQ58HEOhx3dvd
         BDNIm8QRgQXbcHc5uEPx4tL0R0C3aVcKur6wAKRJ2OSBjn+xrHOvxH49OHmABZ9utEdm
         dpXJcP7YXT7vwmvtRW60XVTXXjJ+WsbW0UvM2rJr/fDzpd0Y+B4LwxEjDad6iCpkojRQ
         Z04N5dzyDDjX6mPXXOKuswqT/UqhYOwKdftg3tBpHbUErZqMPDgHqXMLmwg1RmhOfEEn
         fPWkG8Oocf8uHC0EUl/FiMZbtyc0/c0IPyyTPf+WzIKDPpVh0tyEVtk//81UmpCMXDKp
         ompA==
X-Forwarded-Encrypted: i=1; AJvYcCUfMfIxlHw3ZolFMfJ8jU15EmZ5XoTaMZnUZYmtF+S3MzurWKJYhmaiIe7CaycMu4sI8Cjq6DJYgtxU7XMEERpPWLC0GdPh
X-Gm-Message-State: AOJu0YxUMqmzeEUbbTaHs1kYxi2XfT1Iriip/oLmXdhGLXlV78WSofVA
	9JXMTQF1ZTRKOh1yBzinZLgF4HCYvnt69QLs7wKMzuMdW6NJj9apzP31RwpGFseFBw0axlbcyu5
	w0AqcRMt0O6/Rz4jyy7v26gFsDIvYzxZ6SFSK
X-Google-Smtp-Source: AGHT+IEYHD2iKPECcKUGr0P+D5te+97WTsQEPEOCLu0NNZ6JYhTtWhlwpuEYA4h/4Hgf62190NgXJBrA2NJRQNfxAjw=
X-Received: by 2002:a05:6902:91b:b0:dfd:b41f:7f5c with SMTP id
 3f1490d57ef6-e1180f6c94emr6027691276.4.1724127379399; Mon, 19 Aug 2024
 21:16:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240815005704.2331005-1-philipchen@chromium.org> <66c3bf85b52e3_2ddc242941@iweiny-mobl.notmuch>
In-Reply-To: <66c3bf85b52e3_2ddc242941@iweiny-mobl.notmuch>
From: Philip Chen <philipchen@chromium.org>
Date: Mon, 19 Aug 2024 21:16:08 -0700
Message-ID: <CA+cxXhmg6y4xePSHO3+0V-Td4OarCS1e4qyOKUducFoETojqFw@mail.gmail.com>
Subject: Re: [PATCH] virtio_pmem: Check device status before requesting flush
To: Ira Weiny <ira.weiny@intel.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	virtualization@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2024 at 2:56=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wro=
te:
>
> Philip Chen wrote:
> > If a pmem device is in a bad status, the driver side could wait for
> > host ack forever in virtio_pmem_flush(), causing the system to hang.
>
> I assume this was supposed to be v2 and you resent this as a proper v2
> with a change list from v1?
Ah...yes, I'll fix it and re-send it as a v2 patch.
>
> Ira
>
> >
> > Signed-off-by: Philip Chen <philipchen@chromium.org>
> > ---
> >  drivers/nvdimm/nd_virtio.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> > index 35c8fbbba10e..3b4d07aa8447 100644
> > --- a/drivers/nvdimm/nd_virtio.c
> > +++ b/drivers/nvdimm/nd_virtio.c
> > @@ -44,6 +44,15 @@ static int virtio_pmem_flush(struct nd_region *nd_re=
gion)
> >       unsigned long flags;
> >       int err, err1;
> >
> > +     /*
> > +      * Don't bother to send the request to the device if the device i=
s not
> > +      * acticated.
> > +      */
> > +     if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RESET)=
 {
> > +             dev_info(&vdev->dev, "virtio pmem device needs a reset\n"=
);
> > +             return -EIO;
> > +     }
> > +
> >       might_sleep();
> >       req_data =3D kmalloc(sizeof(*req_data), GFP_KERNEL);
> >       if (!req_data)
> > --
> > 2.46.0.76.ge559c4bf1a-goog
> >
>
>
