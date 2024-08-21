Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB0416FF3B
	for <nvdimm@lists.linux.dev>; Wed, 21 Aug 2024 21:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724275874; cv=none; b=PMSmfiLH1gTZe8icp6Ht8WSUwMozPO8oP77LHf6NDx1ZZ/U6Mo5UjVTwUWwZzexr48rjF2TGe/6uZ+kn+mTRED/1YDfM+EWQbpycXGte7X8diJAFgI5Isnih4Z2bNunyrWGgTxGtevb3h9K1uqpwUmFL8+1ouXpOxVeJzzq21IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724275874; c=relaxed/simple;
	bh=1HPbXZu26ylIr+VTL5kVcyFAqWx6XVIzYfT9vJGT7f0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ukavnbby1SY74pqF0s0DVi+h/ZPI+7SA/Qwui1D0khhQHZ0vapPKrV5a+Lzv1pl0UzipFMbsjm/kJqelX9cR1qJLU1Ppms3Mf2fOt1869pk4VP7Mc9ylJuPb+KvMSs8zGUb4quofjOHmkRm4ZczLx5IELPw2risvz/yb8g71J0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=P0ngnKqb; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="P0ngnKqb"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7a35eff1d06so12099885a.0
        for <nvdimm@lists.linux.dev>; Wed, 21 Aug 2024 14:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724275871; x=1724880671; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwfXYtq5H/Bwl31FSzM7tg0skZKB1oDTQ8t4Qt6Xu7Q=;
        b=P0ngnKqbREzeqF5f5dPDTfNILfVCCTOrjX2A+r9pF66dsXm2vUJ8lbhp0qKwSMVH26
         ziAE4ZokqEOJn3AFn2DuJCRB9N7frMansjbSVhSQ4xkw4a/RBk1ApP1x8SEFGDLP8RZJ
         M1brEI0C/5KXQkxHykEQNozNR6Tz0wnMsatM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724275871; x=1724880671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uwfXYtq5H/Bwl31FSzM7tg0skZKB1oDTQ8t4Qt6Xu7Q=;
        b=FrhXZStZwdBPQqTY7r5xCMSK0UR+dx3LPIRle7uoQxFQR5vNydUWNkzhOYjlPJ1M8k
         Atb/QgRWG4+ZvM7pttyqbu9ydizohuyKDRRpNU/zJAGbjn375deuNU55pvDhd4yJLjG8
         /hLu3j1V0A4zD95hN6ZZc6qlkd+Ovswz4MMvzRuvEMwlyN5IV+XGK9BRJFEa1FBtmWCJ
         TEXcniHr44ZXtm+d/f8hhXXOIAlg8fezkW4DhqHwTRnQiFL6LYXEVDZhfH9XkiV/2MuR
         g9dCbmNlwkv8MhWlnR1cag7ErJF4nfzraDyuqfVOd+5jwmqiqV5yWtBMVQKKtViYU+fz
         vqug==
X-Forwarded-Encrypted: i=1; AJvYcCW5NE/BZTISNM7CFvYpILVyJFiJhtJUcKpir6iolT1D+KZQZ+egCUX+636ON1u1O5AQ7R3tWJI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6AuRqZ5fkdiMafh+jJgRS4yJdHQ0d9iho8wPe605vg2CTcKeS
	0DSS9JTgELN/yhC0BhGoeS78EekchjKZso4T/+KYgAucWQ5tK//YIcw2/EZo8HMq8j7RAImPLiA
	3C3fxoNXNsLkd9K+4JK6cD5SdIpbslIb+4Rc6
X-Google-Smtp-Source: AGHT+IF/2t26ymLl1453TNbuqayvZbqevzagzBm58wCHeO+njmSvYDXpCN0QjxbJ2OFbF/nJXJO4NU7h/01hnI5dBhI=
X-Received: by 2002:a05:6214:4185:b0:6b7:ab98:b8b4 with SMTP id
 6a1803df08f44-6c15688e06fmr41700066d6.48.1724275870748; Wed, 21 Aug 2024
 14:31:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240820172256.903251-1-philipchen@chromium.org>
 <46eacc01-7b23-4f83-af3c-8c5897e44c90@intel.com> <CA+cxXhnrg8vipY37siXRudRiwLKFuyJXizH9EUczFFnB6iwQAg@mail.gmail.com>
 <66c6501536e2e_1719d294b1@iweiny-mobl.notmuch>
In-Reply-To: <66c6501536e2e_1719d294b1@iweiny-mobl.notmuch>
From: Philip Chen <philipchen@chromium.org>
Date: Wed, 21 Aug 2024 14:30:59 -0700
Message-ID: <CA+cxXhnb2i5O7_BiOfKLth5Zwp5T62d6F6c39vnuT53cUkU_uw@mail.gmail.com>
Subject: Re: [PATCH v2] virtio_pmem: Check device status before requesting flush
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	virtualization@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi

On Wed, Aug 21, 2024 at 1:37=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wro=
te:
>
> Philip Chen wrote:
> > Hi,
> >
> > On Tue, Aug 20, 2024 at 1:01=E2=80=AFPM Dave Jiang <dave.jiang@intel.co=
m> wrote:
> > >
> > >
> > >
> > > On 8/20/24 10:22 AM, Philip Chen wrote:
> > > > If a pmem device is in a bad status, the driver side could wait for
> > > > host ack forever in virtio_pmem_flush(), causing the system to hang=
.
> > > >
> > > > So add a status check in the beginning of virtio_pmem_flush() to re=
turn
> > > > early if the device is not activated.
> > > >
> > > > Signed-off-by: Philip Chen <philipchen@chromium.org>
> > > > ---
> > > >
> > > > v2:
> > > > - Remove change id from the patch description
> > > > - Add more details to the patch description
> > > >
> > > >  drivers/nvdimm/nd_virtio.c | 9 +++++++++
> > > >  1 file changed, 9 insertions(+)
> > > >
> > > > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.=
c
> > > > index 35c8fbbba10e..97addba06539 100644
> > > > --- a/drivers/nvdimm/nd_virtio.c
> > > > +++ b/drivers/nvdimm/nd_virtio.c
> > > > @@ -44,6 +44,15 @@ static int virtio_pmem_flush(struct nd_region *n=
d_region)
> > > >       unsigned long flags;
> > > >       int err, err1;
> > > >
> > > > +     /*
> > > > +      * Don't bother to submit the request to the device if the de=
vice is
> > > > +      * not acticated.
> > >
> > > s/acticated/activated/
> >
> > Thanks for the review.
> > I'll fix this typo in v3.
> >
> > In addition to this typo, does anyone have any other concerns?
>
> I'm not super familiar with the virtio-pmem workings and the needs reset
> flag is barely used.
>
> Did you actually experience this hang?  How was this found?  What is the
> user visible issue and how critical is it?

Yes, I experienced the problem when trying to enable hibernation for a VM.

In the typical hibernation flow, the kernel would try to:
(1) freeze the processes
(2) freeze the devices
(3) take a snapshot of the memory
(4) thaw the devices
(5) write the snapshot to the storage
(6) power off the system (or perform platform-specific action)

In my case, I see VMM fail to re-activate the virtio_pmem device in (4).
(And therefore the virtio_pmem device side sets VIRTIO_CONFIG_S_NEEDS_RESET=
.)
As a result, when the kernel tries to power off the virtio_pmem device
in (6), the system would hang in virtio_pmem_flush() if this patch is
not added.

To fix the root cause of this issue, I sent another patch to add
freeze/restore PM callbacks to the virtio_pmem driver:
https://lore.kernel.org/lkml/20240815004617.2325269-1-philipchen@chromium.o=
rg/
(Please also help review that patch.)

However, I think this patch is still helpful since the system
shouldn't hang in virtio_pmem_flush() regardless of the device state.

>
> Thanks,
> Ira
>
> >
> > >
> > > > +      */
> > > > +     if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RE=
SET) {
> > > > +             dev_info(&vdev->dev, "virtio pmem device needs a rese=
t\n");
> > > > +             return -EIO;
> > > > +     }
> > > > +
> > > >       might_sleep();
> > > >       req_data =3D kmalloc(sizeof(*req_data), GFP_KERNEL);
> > > >       if (!req_data)
>
>
