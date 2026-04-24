Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC1872618
	for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 20:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777060934; cv=pass; b=tqAqRDVlYGdJnvfulAKVWuoJFVhrbIHWpAqE9ZvvNCOfoypuUFjGT4KuALkLpT3f/Dha8r/2xnE6pS+5pg4vyJ5YIFCnsq5hX4SfbVqXi2eqw5a/yxEhLSI8DtiM1I948DDtS0i9yWm/KPgVVq1szOgHGUK1dryebwDdXQ5qsD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777060934; c=relaxed/simple;
	bh=opi3GnG+GYzn2UgzsBWPxwzmr8APgJV4zt/dGtJ+25c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ored/dyFXNCaM+xlf46uqWxRofUw1L9DlBFUSnsdAO64zeV+Mr7x33JUH+PYGHIWXMQ5jOnQIXIqlDpPdHbLAOgTaQv++cbgsuDBz/8k3oRGdiQ6/8Hsz+t+yEXCLq2UVztQq1mu6ISj1FTvaGD3gXswZpIydl1XypHZ3XANQ4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oBeaw3Vs; arc=pass smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oBeaw3Vs"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4891ca4ce02so701295e9.1
        for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 13:02:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777060932; cv=none;
        d=google.com; s=arc-20240605;
        b=V5pcMe8/ckHXo0WzRBNpUYW/6SFIN1lW6IHHDss1ytgbZfWMOUWjjn6MhOlwuCxqqb
         GUVBdUJdmd5WRpy7YyNN9ckAFSGfax8ujZy2OZg8WnxJ/8agaOS/bzZ39eOSon/YgDKg
         NMc+DEmiwsqHG+Is3TjDVgXwlp6PlkoT63C7ReN2HnIuOWtK5lFySamMQnJwltFveYNG
         xUQLi9MDrhxGXA7R+flFmOW7r3yo23iij3K3tlY75E94WwFFEUVgEVDdKiZgRWoy/dPq
         Dn6d10nF2+hcpt2ELoBvzp/n356paWZWAW/PQXCI7IYrJc1nmnj7DeT7E4hGWeSpbW1+
         /J0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=opi3GnG+GYzn2UgzsBWPxwzmr8APgJV4zt/dGtJ+25c=;
        fh=QC5Sndt7fywNHvZwGyzj019wXR+kqkZ4cF9FjB04qGY=;
        b=acJyV85xoAlTMoIweFk0thh9gdPSMOrh+f8u6YHGLRPcNxK4Q41XePKWA/r2QzQ9ue
         /fltIX377qitdLEPAkIW7ddpl3GXvIXv07jHhfb0Ym8od3wpBr89vSxqN3/NjS1KIMrk
         XrVsL3Zdv1cZlMvtnwpIa0rP5uffAI+SraCPqFNk+yWXwtW+UF6sGo21axi3p+YEcNe2
         Fp3RXH9q8ptfWRpLhBy2OPWgYR5D5Fy3+mjIougw7IHnrbRrQSB5v52YW40+dAN+MsyR
         nrbtQBDGPg6dOEPxrVHlU+uwZi3JQoQgdYsoZ9q1obBmvzhV2KG38HGihc7ZhQwAD6fT
         16kg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777060932; x=1777665732; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=opi3GnG+GYzn2UgzsBWPxwzmr8APgJV4zt/dGtJ+25c=;
        b=oBeaw3VsnJZwD7cf7NLIaGxZUmdf6bJf1+BUtJSlq6lU6VP5JLy1mGR8QFbmpgoSNJ
         CaHru/hCGrYPOlHAgrS6z7Ej0Io+YgjT4xm3Q4hlCKakO7ojVlXjAEYbaJAzDuDKMzlr
         VUJlxO3UDidw2v8QBuDkNb+hrB5kOYOunIzoUCXPy3/7nJlzMHYnQNpXrDbjmUacRFOq
         QDCMGojZiWXwFGGtHXrlTFRjJS7BxykNf2aOPFofT7auqvylUe9FBMiCcZENRBh8SeFa
         6vtuRbl8gk3nkiFJscBqVOpWpBBx/W38OwpWWVNIRgn2/JWPir0OAvFrBOZVrc1A/WCt
         FURA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777060932; x=1777665732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=opi3GnG+GYzn2UgzsBWPxwzmr8APgJV4zt/dGtJ+25c=;
        b=ZpTwlT7t1Sk0fzPt+Zd47Jttt5kJolJOSow80EQlTKBrauTCCV6n7bu7b6p5Hp2dw9
         UA/QWQTtcFKrFgf4dVZuWfe3JONbOmzdk85onutbLzAz67I8p3NQKXHPciM3SL7O8BB3
         5ctehATEliDVBHX8t3s63Lba6hmTE/9EP9tCbpM/PIJwoCtugFUq+jxQJWdfn5WhwJr0
         MIeirMgdurzBsuMyAVPp2zif3PgBhcD8bgVTMdwTf+F7QghDdfgyIjJg12PamYOxj7F0
         OwPYqA19zQNhGOdghezvnasy4FaHZmfvMHiRG5+X1gHy6AMIhRt6QQdNtVGFs1cGgHcx
         a7fw==
X-Forwarded-Encrypted: i=1; AFNElJ+pkc9wlAOD01zS5cEXcJTY0RM49FaZr2Xsah4JUyZfcKBNoThGBy5YyEQCEbLLky4e6NjnX/c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzfj2ZIifEhM/UaOvuY3JitU9Bqd/B1HGdU9GvUoGAoqHa649QI
	Yv5CvyPyVcwzS4/EDWTz0nu7iulAv4NOLuvWLCLmcsBQgcH68G9T1/QHGa84Bt/ma2dSg+yDp0C
	TpxXXpolnKYNceXoZQu1bhLfC5TqdduLq2AEVd1Ua
X-Gm-Gg: AeBDiev6mIMTyOx5yHPdVwCSy0bSRncWFmUcNwWbR8dwQsIwd9Jj/GSAYx7UCyzbCQj
	ysPqRaEkWev+YPG1K6FbvjhhigYsqhDf1/vvYVxgRRX/Ekh+S2tqXQOnKKC0ZVAsMQko28dQbaP
	sSQGZBAaJdm1EKSm+JRKxrsMNZIH5w4KTs+M7jmEmPFddCe6ol6J7ye5I+HFb5XAmHH+nJ4jOk3
	bRNZ02JVbNrTxY8nGkEPziXr33Vn6RRb6i32uIaGfvXIm70WI4o/tq7RBIqlvX5PNUmBcp0sQOI
	OhwfYZw/Jc8uO5Yh3BRbnok8TtE+/gO6rSzyFVo=
X-Received: by 2002:a7b:cc04:0:b0:486:f772:91c4 with SMTP id
 5b1f17b1804b1-4890099fc06mr5959995e9.8.1777060931354; Fri, 24 Apr 2026
 13:02:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260423170219.281618-1-dave.jiang@intel.com> <20260424172912.548636-1-fvdl@google.com>
 <0e831045-3b01-4934-bf43-b3ef01ce0158@intel.com>
In-Reply-To: <0e831045-3b01-4934-bf43-b3ef01ce0158@intel.com>
From: Frank van der Linden <fvdl@google.com>
Date: Fri, 24 Apr 2026 13:01:59 -0700
X-Gm-Features: AQROBzBNKCMWsvrneA4HKVPUSplj9uBs_lEv48Q-q2Gi0reTVyn2yTOOmiot4KI
Message-ID: <CAPTztWaXt8izKtpC=g4aOBddvSX9ViekxyPS8UnSBuqitGZuyw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, djbw@kernel.org, 
	iweiny@kernel.org, pasha.tatashin@soleen.com, mclapinski@google.com, 
	rppt@kernel.org, joao.m.martins@oracle.com, jic23@kernel.org, 
	gourry@gourry.net, john@groves.net, rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2026 at 11:23=E2=80=AFAM Dave Jiang <dave.jiang@intel.com> =
wrote:
>
>
>
> On 4/24/26 10:13 AM, Frank van der Linden wrote:
> > Dave Jiang <dave.jiang@intel.com> wrote:
> >> This RFC series is created as a proof of concept to connect device DAX=
 to guest
> >> memory by riding on top of guest memfd in order to prove out that devi=
ce DAX
> >> can be used as guest memory. The series seeks to jump start a discussi=
on on
> >> if there are interests in creating a DAX bridge to utilize CXL memory =
for guest
> >> memory until the N_PRIVATE implementation by Gregory [1] is available =
upstream
> >> and DAX users are ready to move to the new scheme. Once there's an est=
ablished
> >> consensus of interest, we can move the discussion to the best way to i=
mplement
> >> the DAX bridge and the future of device DAX as guest.
> >>
> >> I did the bare minimal to get the PoC to pass a modified version of KV=
M gmem
> >> selftest (guest_memfd_test) in order to prove out that DAX can go in t=
he gmem
> >> path. A DAX char dev is created and the fd is passed in user space wit=
h
> >> vm_set_user_memory_region2(). The DAX region is passed in as a whole w=
hen used
> >> unlike memfd where any size can be passed in to be allocated.
> >>
> >> The folks on the cc line are people that Dan Williams has mentioned th=
at may be
> >> of interest to this.
> >>
> >> [1]: https://lore.kernel.org/linux-cxl/aeWV1CvP9ImZ3eEG@gourry-fedora-=
PF4VCD3F/T/#t
> >
> > One of the main ideas behind guest_memfd is that the memory is managed
> > by the kernel only, so it knows what it has and that it can trust
> > the memory. This RFC passes an fd in via the ioctl(), which I think
> > breaks that model.
>
> Don't we issue KVM_CREATE_GUEST_MEMFD ioctl to get a fd in userspace to b=
e passed to KVM_SET_USER_MEMORY_REGION2 ioctl later? We are just passing in=
 a DAX fd instead of a guest mem fd.

Sorry, yes, I should have said "it passes in a *non-guest_memfd file
descriptor*" via the ioctl. I think the intent of the guest_memfd code
is that it can only bind to a guest_memfd file descriptor (hence the
check in kvm_gmem_bind()), otherwise its trust model would break. Of
course, I'm not a guest_memfd expert, the maintainers can give you the
definitive answer on this.

>
> >
> > Since there is interest for several different allocation backends
> > (default, hugetlb, zone_device), it might be better to use a model
> > where guest_memfd has the option for backend allocators to register
> > themselves in the kernel. The ioctl can then select one by their
> > id/name (could be just a string). They can be configured using
> > e.g. sysfs (like hugetlb already is).
> >
> > This would also allow easy experimentation with new allocators,
> > having an allocator with BPF control, etc.
>
> Agreed. Although my main intent is to see if there's interest with provid=
ing something to the usages already on the DAX path an ease of transition u=
ntil something like what's proposed above shows up. But if what I proposed =
will be a security issue then maybe not.

Sure, yes, understood that you're looking for a transitional solution.

- Frank
