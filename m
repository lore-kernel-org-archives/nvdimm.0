Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202C6CA4B
	for <nvdimm@lists.linux.dev>; Fri, 26 Sep 2025 12:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758890887; cv=none; b=cy1v4wyBB7Lxtscu9TQgfIp0S5S3ZKDdATg11G4qD6Ot9wsLTz3CSLSuTkLyedk5mGmtiDWFZR1onYs+wnnfha5lVcKa+lGLUmBPA+ubnVK6nsl0+vvT7sv6vHch9IZIniWJ2TRPt55T1BdjuYTXynG5H3mk34ksjdr3JFJ+slM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758890887; c=relaxed/simple;
	bh=wDKshemlL5U5B/GJnrGRfPCkhHwd7rDu7k4l0PfUsvw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cH2UNtYdoGIoD89aV2h0o/8zzWyi/RKLb1IJvxEc5n3oklCCWIJ4oZsBjVgrzB9HOl2IXfJbDiE9rhPu5COw7POK1TRJwribncgYq95J6NA19s3k/zSrP66/W9/NJdqA9BLR74bBYoT4R/l71ISlDyD5ujytQ5D/HTTZ7LSTmJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Oyi2lLyf; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Oyi2lLyf"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2681645b7b6so144995ad.1
        for <nvdimm@lists.linux.dev>; Fri, 26 Sep 2025 05:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758890885; x=1759495685; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZrwEv25cQ0grK7iOcD9QubzL1/i/aReMfkEmaJfNzXw=;
        b=Oyi2lLyfzqZVY82JWQ6veUqM3isuw5yzaM8cUEHaRVVKNCyZSRIyukAj0MaDSARJZ7
         AIt8uoRzys6LsPKYQVWBoldAqt3/4oBLDCN/njPopLtQ2qIsPYIgnnaoffpYNkpzi2MH
         lwF0VJw2wKPBHJM5tfUbJ6RzkOyui5MUis0aeljJ+Zb9PBeQL3iMjP3NYhmctSSTuFVF
         ncXKPDZfOKIBZ2wdsndg4YGCZE3XHuNeeQ9MseOjLamOFlAGzl6Gq13qiGPldJHFv4iu
         dCv/g5bFPawDdJDrCntgNVjSv5bqJx+yHDnpfFEovutE5m6zKXuYPaJmFtmSBxAelaGZ
         ZlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758890885; x=1759495685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZrwEv25cQ0grK7iOcD9QubzL1/i/aReMfkEmaJfNzXw=;
        b=gu1mwcgcJWbIbDjZMNGCcrCXHBN7ifVrgAUx4BD0p8QDjmNaMb2B2pFzZ5pxGtPbht
         k0EXFrG3HHUGPkXH4Ll0Ov3/I6ztE2tDCI+8JAN3Glrm1aOBFLea/M035NhiKOCEAOb4
         q9Df53tfHAlB225QblRR9og3dh51wXOAVYzYhn8eIYIPhXLN+ZOcRCFMYLbNlMsRbswr
         cZIj+XxpxbY4f7vljTAElGaLm9Pa1G567J8boy1hiwZ/ZXPybZCBWdk48QHA3PhBvYz6
         Ewfto9Lf/OAEhnhdO72BrgMvkHPEN/HMMRiJjvGB4O+L7BU/vf3V4zuD1vA6hC5bNm3J
         gu5g==
X-Forwarded-Encrypted: i=1; AJvYcCUZY8I2PvLWmNyL3ju8r0eBntzBZNpkECWPeEiBNtspyv24hNQYYelG/ljXBjPg6O0luwyDPKQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy46lfX4/mbCbiO21ljpKdTw14cKixIeh49QzhwA7WS3oS8K/UD
	wrG6rI0XdAS0SQCmskZZPia1ZCeGqzRa7GnQrS9jWmzdncXlXcl0hioZTS8SYaqX9ecCKIXbUA0
	2cFr/yl5VRhhO5uNQib+1+nQXdvMpGShbyq4WaXQM
X-Gm-Gg: ASbGnctBfjkvwEgl4Ra0XO02Mo5rEZLvmv5hzNQ9c3SCBkn2Gt29ttrNpnRxt3Th7po
	Egi4WNUEC8UjC3P/oII87Tu+c6QaE4/JrtRC51jMzWVQgtjYxk1FqE5z4zfQLSsNQ4LQnKJBcV+
	DB7tO1qafnrr5SEz7twfVow42JY/XkHN4+uU8ZoYvGt6gBldciZslxFyvg3wmpeMlZp1OMLAChW
	LsetjgKRfdo
X-Google-Smtp-Source: AGHT+IGwdqghIxlci7X2WO2dLE4ZaLoskjkwhRbj3i6/utTopC4KXFsjsT/EA7gdhJ9OERSjrTYwVtzSNXEeF2WoZhY=
X-Received: by 2002:a17:903:2407:b0:264:1805:df20 with SMTP id
 d9443c01a7336-27eec9d08c2mr4705495ad.4.1758890884978; Fri, 26 Sep 2025
 05:48:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250826080430.1952982-1-rppt@kernel.org> <20250826080430.1952982-2-rppt@kernel.org>
 <68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch> <aLFdVX4eXrDnDD25@kernel.org>
 <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com> <68d3465541f82_105201005@dwillia2-mobl4.notmuch>
In-Reply-To: <68d3465541f82_105201005@dwillia2-mobl4.notmuch>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Fri, 26 Sep 2025 14:47:50 +0200
X-Gm-Features: AS18NWCOMXVU2qFdCBMr9rLwHy_t9UgMSPpREpOCTYO-4GCDPj1tC7maU-IIh-M
Message-ID: <CAAi7L5esz-vxbbP-4ay-cCfc1osXLkvGDx5thijuBXFBQNwiug@mail.gmail.com>
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices
To: dan.j.williams@intel.com
Cc: Mike Rapoport <rppt@kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, jane.chu@oracle.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Tyler Hicks <code@tyhicks.com>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 3:16=E2=80=AFAM <dan.j.williams@intel.com> wrote:
>
> Micha=C5=82 C=C5=82api=C5=84ski wrote:
> > On Fri, Aug 29, 2025 at 9:57=E2=80=AFAM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > >
> > > Hi Ira,
> > >
> > > On Thu, Aug 28, 2025 at 07:47:31PM -0500, Ira Weiny wrote:
> > > > + Michal
> > > >
> > > > Mike Rapoport wrote:
> > > > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > > >
> > > > > There are use cases, for example virtual machine hosts, that crea=
te
> > > > > "persistent" memory regions using memmap=3D option on x86 or dumm=
y
> > > > > pmem-region device tree nodes on DT based systems.
> > > > >
> > > > > Both these options are inflexible because they create static regi=
ons and
> > > > > the layout of the "persistent" memory cannot be adjusted without =
reboot
> > > > > and sometimes they even require firmware update.
> > > > >
> > > > > Add a ramdax driver that allows creation of DIMM devices on top o=
f
> > > > > E820_TYPE_PRAM regions and devicetree pmem-region nodes.
> > > >
> > > > While I recognize this driver and the e820 driver are mutually
> > > > exclusive[1][2].  I do wonder if the use cases are the same?
> > >
> > > They are mutually exclusive in the sense that they cannot be loaded
> > > together so I had this in Kconfig in RFC posting
> > >
> > > config RAMDAX
> > >         tristate "Support persistent memory interfaces on RAM carveou=
ts"
> > >         depends on OF || (X86 && X86_PMEM_LEGACY=3Dn)
> > >
> > > (somehow my rebase lost Makefile and Kconfig changes :( )
> > >
> > > As Pasha said in the other thread [1] the use-cases are different. My=
 goal
> > > is to achieve flexibility in managing carved out "PMEM" regions and
> > > Michal's patches aim to optimize boot time by autoconfiguring multipl=
e PMEM
> > > regions in the kernel without upcalls to ndctl.
> > >
> > > > From a high level I don't like the idea of adding kernel parameters=
.  So
> > > > if this could solve Michal's problem I'm inclined to go this direct=
ion.
> > >
> > > I think it could help with optimizing the reboot times. On the first =
boot
> > > the PMEM is partitioned using ndctl and then the partitioning remains=
 there
> > > so that on subsequent reboots kernel recreates dax devices without up=
calls
> > > to userspace.
> >
> > Using this patch, if I want to divide 500GB of memory into 1GB chunks,
> > the last 128kB of every chunk would be taken by the label, right?
> >
> > My patch disables labels, so we can divide the memory into 1GB chunks
> > without any losses and they all remain aligned to the 1GB boundary. I
> > think this is necessary for vmemmap dax optimization.
>
> As Mike says you would lose 128K at the end, but that indeed becomes
> losing that 1GB given alignment constraints.
>
> However, I think that could be solved by just separately vmalloc'ing the
> label space for this. Then instead of kernel parameters to sub-divide a
> region, you just have an initramfs script to do the same.
>
> Does that meet your needs?

Sorry, I'm having trouble imagining this.
If I wanted 500 1GB chunks, I would request a region of 500GB+space
for the label? Or is that a label and info-blocks?
Then on each boot the kernel would check if there is an actual
label/info-blocks in that space and if yes, it would recreate my
devices (including the fsdax/devdax type)?

One of the requirements for live update is that the kexec reboot has
to be fast. My solution introduced a delay of tens of milliseconds
since the actual device creation is asynchronous. Manually dividing a
region into thousands of devices from userspace would be very slow but
I would have to do that only on the first boot, right?
