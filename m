Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4B71537D5
	for <nvdimm@lists.linux.dev>; Wed, 21 Aug 2024 02:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724208520; cv=none; b=Nh5/COjKjLveBA7VqnRjPyNna19ucpB8fJp9yoZoOxZCaZ9DdnAzPT2HTRVs7r91hWS1Hx6M6huo4B9ABokA8igV4ydwgqrmsvHB27bFovE1Lr0yE4jPlM0vDMvYNIxLfwQQvnWmJPsU4AggosK/mXpSQOJd5YmRQbM0vDkHxCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724208520; c=relaxed/simple;
	bh=3NT4ahnmFddHIRmFwjcHIuJmDlTvjANzEmVMo6qJ1Vc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZyUcRBnrsUraA08FIioLKSIAnLgUJTSCc7K9BJxOYL696wJvhQfJWQozTVDw8VrAreIVzS8uFqhRICMNND0Zsw61EQQe/cIsPuXywuGhw2x9/cfJSEpM318nFAGJ5iQvaRobeZGKLG18IowYUd1dWGTcqH8aFa8Sy/Cy/H+QtW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=cmDn/65s; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cmDn/65s"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-70b3b62025dso4261525a34.0
        for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 19:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724208518; x=1724813318; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P3aEXOpJkCyNHt+4mZOgRQw75y4G0b8DBrW8S6IF4dU=;
        b=cmDn/65ss0Ho65a3ndsLNBnk0XTN94RKEco1+qNj1SXny6xrmBm6osdqDBNzy6Irr/
         lxujfcwy07zQLcEy1e3ZF0iEHX5+miBbPtMmymuwVLCeXT6fbBXKmmzEdEhK+QQrs6ip
         mKUI/Zr4IEQkZMNIAwVYi9k9ds5Cub8XffmZc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724208518; x=1724813318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P3aEXOpJkCyNHt+4mZOgRQw75y4G0b8DBrW8S6IF4dU=;
        b=UTOwq3BTUPm9p8trZgB+4rtNmdE0gWAmh0QLfGv9dLuaSchADKIVgfn1xj5rdf8vBj
         nLgRLGj529ZYbJkq9Gd3RA16mSMXT78/T5LTIq9dd4DjUUNllJ/twygN9kxCMFa2PMQV
         4gFuLQXpSr3eetZPP33MjTaaY9inMMEf+x9hZ1cp7kfzwfT7XWG+cxGzIkY7XYXzSHg7
         GaLIMzPFVaGXS/kjkzerQHRM5NPaI6fKJPsa8mQRgrDXpI1iD2rK64snfl2WMIUqWkXG
         DoByIQlB3w4HyfBblUod+uzudiC4RposebzzG5b8AoJYCYzAWXBwVLagEFojT1W+giIk
         7w3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXOXMvcCPxw2QcPBEEUw02Al2MFyYSZzBIXOJQr6Aip/xaK7b6rwytWk50S/38v8m527sOdElM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5jkQHTuTHgkb2W/h7eC0bBCFHlFieKhWeD6zoJzK8U/Lv71M2
	M4xsFE9Mg0O0QX705RWN8DgI3Md3b/W6/PMc/mLjZF0ae6p4b+s71r7pl4UxWOE9C4D2Y38IhU8
	XncH/5LQPgRXLCh2NGV1lUDed3Ew+wrIkHkzs
X-Google-Smtp-Source: AGHT+IGw9BqTX5VOuQLmS/qKfOQP/sjqjFhw2dnBRfUPMUh9JrsC1327k3YS4AeZHPC9FiuuPKxEewNQSfw++XcuCcs=
X-Received: by 2002:a05:6358:57a3:b0:1ad:10eb:cd39 with SMTP id
 e5c5f4694b2df-1b59fc5cfc2mr159679855d.26.1724208517967; Tue, 20 Aug 2024
 19:48:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240820172256.903251-1-philipchen@chromium.org> <46eacc01-7b23-4f83-af3c-8c5897e44c90@intel.com>
In-Reply-To: <46eacc01-7b23-4f83-af3c-8c5897e44c90@intel.com>
From: Philip Chen <philipchen@chromium.org>
Date: Tue, 20 Aug 2024 19:48:27 -0700
Message-ID: <CA+cxXhnrg8vipY37siXRudRiwLKFuyJXizH9EUczFFnB6iwQAg@mail.gmail.com>
Subject: Re: [PATCH v2] virtio_pmem: Check device status before requesting flush
To: Dave Jiang <dave.jiang@intel.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	virtualization@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 20, 2024 at 1:01=E2=80=AFPM Dave Jiang <dave.jiang@intel.com> w=
rote:
>
>
>
> On 8/20/24 10:22 AM, Philip Chen wrote:
> > If a pmem device is in a bad status, the driver side could wait for
> > host ack forever in virtio_pmem_flush(), causing the system to hang.
> >
> > So add a status check in the beginning of virtio_pmem_flush() to return
> > early if the device is not activated.
> >
> > Signed-off-by: Philip Chen <philipchen@chromium.org>
> > ---
> >
> > v2:
> > - Remove change id from the patch description
> > - Add more details to the patch description
> >
> >  drivers/nvdimm/nd_virtio.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> > index 35c8fbbba10e..97addba06539 100644
> > --- a/drivers/nvdimm/nd_virtio.c
> > +++ b/drivers/nvdimm/nd_virtio.c
> > @@ -44,6 +44,15 @@ static int virtio_pmem_flush(struct nd_region *nd_re=
gion)
> >       unsigned long flags;
> >       int err, err1;
> >
> > +     /*
> > +      * Don't bother to submit the request to the device if the device=
 is
> > +      * not acticated.
>
> s/acticated/activated/

Thanks for the review.
I'll fix this typo in v3.

In addition to this typo, does anyone have any other concerns?

>
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
