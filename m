Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3182DF15F
	for <nvdimm@lists.linux.dev>; Mon,  1 Sep 2025 16:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756742500; cv=none; b=CKBHk665pqo88QM09MoGPC3xE6QawbCEATLu5yL3VEIzxvL63R1MSWDowmAii2Vmj8Pi4I6pclGFWul8Niu28eiSRGOOgVuIQn5gn4JihdBHktqk+gN55HMXctoJHY3Fso7El535oajwj1KKQps22n+ZqdGWP3wbpCuYCTpx2gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756742500; c=relaxed/simple;
	bh=8TyjAR1n0XSfbG60TdTWK/jacRRmZXapnaL2IGz/6Ag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cMumwHFZ+tlgumIWvVhqLxYm+dL73jR+ks185a1nkH8dzoPxUoxOvEWEdEUnlrliTs8GGhmlqxowcMD3TblJJfPRmltNt8sesq9d1OkrmGHaiQK2442mJMY9Wv9O0YEhvdmPJfH8rTsT3f+Gji5SPezWxZuBIn5NIBZ/GPMmHYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2GCRu3D4; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2GCRu3D4"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61c869b4623so13811a12.1
        for <nvdimm@lists.linux.dev>; Mon, 01 Sep 2025 09:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756742497; x=1757347297; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dZe1rDSyUDwGrcf6JDGl9NSkofhGepazU+Zm8DpoTMU=;
        b=2GCRu3D43MdWUZ8zNgOUHltdL/H3bgalZztRyy6+8VKaVl+42z13BfCNWeBbhD4h15
         bMzwsaUIycGqRgce6SnFSU1jiCMw+xtuikLmWvbeDwR5+lUpW8/VGL9AmJBleba23ZGR
         j8GMjE1u0BXfhcUGolEQZm4WsDKWAN3zixl7+hhywbULwRPG6/IsxBjWhX9b5htUOlH9
         8MhXM3dqPpqHbl+Brm+xqB4r5upz49dNzzPO9TfIwA2uWYSvxNKWmf/eoYwxDWsLk9Tf
         X77p7eN2xmm2U527TgsCqm0fmcrsJ8eeHj/teJG6ZLe2se+IaRw4kVKe+wklk1OYeT8p
         zSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756742497; x=1757347297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dZe1rDSyUDwGrcf6JDGl9NSkofhGepazU+Zm8DpoTMU=;
        b=Er/hfMnr5RK+AFCxQd6lPLmapiAk+7E7Q7F44HDrMbcV/jRGF6nWmh2a58aQTy+TKN
         d4fZLx8YSyqvFQxc38j3lTVNJkgKXXucJY3RBf/9HUAqdq1Xx0HLQFuUljpwafuiRm9c
         Tf1m4fcL53QBv4xt6Q1LG/N5+EUlFxT39UfxjnFkakMByfzEQOf/ezzaD5Ssl9iwe2Zq
         OSt7wM3kK2yGT0aerNgSG3PcxfCwBzLicznJgxaRcyZqhYBIsgcCxj35luvjtn/YuomY
         /Bmdvme6K9rFd4zvExUdqxj6banVq8F7C8q1yGOwORVby4G4/IPC1qZ5b7Hg5Nm2OWyg
         +plQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzTEIeZFiU4nH/JMFhE61i2aN/77dbM1NYcO0ScxcvnrgbXslhGXjijHgCo3i+W07QkCoD+nI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnmaGCM0cLSaUg4Qu5COLHTe+XgtIynv4yH1CjlVgaKUJjtJgc
	nai1X+MF/ksvB+JXxEK0bl3tDwkkwND7L3bv7t4SFbY6Wj9Eh1NpTISouUcwtFwPE+yBR/kza8c
	bBT2IC3wS/uR1r9ih7BVl8w/O6h5M7u7xk3LreCaf
X-Gm-Gg: ASbGncuKUa3IgZ8AeARky8+UjrRfH/7Xengftno9ni30KaEWAVuvI5ssarD+UZU6/1q
	67h4XeUSi7U58/xrA84gWcVWSzJNb8i9z1gn9VdO5Do/rd1ZciAMatrPPbpa/YKYT4mnUD23NVE
	I1DTJ5hfpS2BROdQVRXCoiG1JI8wA13aN/rjV6NPfT25UEzgp8tEIyZ6FQ+zi3JUF5KkyLMiv60
	KVW+fZCk+6fiAiuVYgUZgUa6i7iSddaoCNlcmw+XF9fkzgE9t7w
X-Google-Smtp-Source: AGHT+IFBPjo7BYjYjXhGo6U2wXlVhFIeOC8a9cufcwphz6VE6bbVgfUe4VeQNXzBXooQi/RcCrbbTira2IpHTqtwCBw=
X-Received: by 2002:a05:6402:2898:b0:61c:32fb:999b with SMTP id
 4fb4d7f45d1cf-61d21c8e8f7mr134455a12.1.1756742496601; Mon, 01 Sep 2025
 09:01:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250826080430.1952982-1-rppt@kernel.org> <20250826080430.1952982-2-rppt@kernel.org>
 <68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch> <aLFdVX4eXrDnDD25@kernel.org>
In-Reply-To: <aLFdVX4eXrDnDD25@kernel.org>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Mon, 1 Sep 2025 18:01:25 +0200
X-Gm-Features: Ac12FXzkGAkQY2x4K6zNLnLOx6A5Qe40b6_I_CpXPyMEmRkQBFx8GaoL9LPzUlo
Message-ID: <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices
To: Mike Rapoport <rppt@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, jane.chu@oracle.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Tyler Hicks <code@tyhicks.com>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2025 at 9:57=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Hi Ira,
>
> On Thu, Aug 28, 2025 at 07:47:31PM -0500, Ira Weiny wrote:
> > + Michal
> >
> > Mike Rapoport wrote:
> > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > >
> > > There are use cases, for example virtual machine hosts, that create
> > > "persistent" memory regions using memmap=3D option on x86 or dummy
> > > pmem-region device tree nodes on DT based systems.
> > >
> > > Both these options are inflexible because they create static regions =
and
> > > the layout of the "persistent" memory cannot be adjusted without rebo=
ot
> > > and sometimes they even require firmware update.
> > >
> > > Add a ramdax driver that allows creation of DIMM devices on top of
> > > E820_TYPE_PRAM regions and devicetree pmem-region nodes.
> >
> > While I recognize this driver and the e820 driver are mutually
> > exclusive[1][2].  I do wonder if the use cases are the same?
>
> They are mutually exclusive in the sense that they cannot be loaded
> together so I had this in Kconfig in RFC posting
>
> config RAMDAX
>         tristate "Support persistent memory interfaces on RAM carveouts"
>         depends on OF || (X86 && X86_PMEM_LEGACY=3Dn)
>
> (somehow my rebase lost Makefile and Kconfig changes :( )
>
> As Pasha said in the other thread [1] the use-cases are different. My goa=
l
> is to achieve flexibility in managing carved out "PMEM" regions and
> Michal's patches aim to optimize boot time by autoconfiguring multiple PM=
EM
> regions in the kernel without upcalls to ndctl.
>
> > From a high level I don't like the idea of adding kernel parameters.  S=
o
> > if this could solve Michal's problem I'm inclined to go this direction.
>
> I think it could help with optimizing the reboot times. On the first boot
> the PMEM is partitioned using ndctl and then the partitioning remains the=
re
> so that on subsequent reboots kernel recreates dax devices without upcall=
s
> to userspace.

Using this patch, if I want to divide 500GB of memory into 1GB chunks,
the last 128kB of every chunk would be taken by the label, right?

My patch disables labels, so we can divide the memory into 1GB chunks
without any losses and they all remain aligned to the 1GB boundary. I
think this is necessary for vmemmap dax optimization.

> [1] https://lore.kernel.org/all/CA+CK2bAPJR00j3eFZtF7WgvgXuqmmOtqjc8xO70b=
GyQUSKTKGg@mail.gmail.com/
