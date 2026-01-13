Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831E22BE644
	for <nvdimm@lists.linux.dev>; Tue, 13 Jan 2026 12:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768307961; cv=pass; b=cTEbt/D+c1V9ZLPOCKrHngW2LFuXRcITlKzbFFbFEFG5hA6syWRCWZocpiuJ+Vtnsej96VO+VN2tkAWzrm5KhAR4XQqhGADv2LoxF4CDflLUildnBaOADKlZsU9z48CXnBVeQyVs25GvgYuf2IyLYeZ5IjPUquMgnb7MC4lLHNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768307961; c=relaxed/simple;
	bh=pOjWJ5Gjpe3qb74TN79DpmnUI+l8GEc1aBiMzrWojko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ui5rpQUcJwDOsx0i024GD0vkouFQcMqcMGXxjPbwVKwKP7uhJmimG8r5s7TA1Y3ZHiop6DGYEuFNeCF5ND8mzHvh2PxTsvBv0GaBYR1IwLMzpKgtP3IgIhUY+j7grtVjE6l6Uw9Xv7Q3nz4xwTtnZ3KUHUq6ajFWgpJIXixg0Xo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hFLmJILt; arc=pass smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hFLmJILt"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-12331482a4dso2684c88.1
        for <nvdimm@lists.linux.dev>; Tue, 13 Jan 2026 04:39:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768307958; cv=none;
        d=google.com; s=arc-20240605;
        b=epMtlECYMXxMWqSn8zJU5RhCUVyiE38p86it+sjj2leAEXsBHUA3KTR6I+kkPb9adb
         YYIywJBk26qnGfeni6QjWZsFZcrwmZ+hYYlWuWjQJYIw1NBplxW9zjHi8Hx/QN9W44A0
         hhofmMUuh16cPKhN312mUVTOJQn/hHIXG+Gcz3lx9sSu3K26v2KPOu69yyBgBqQSbKQH
         jO5WC8r/QHOabrQw/3w05rZx0kS0z1C2U14c8Pr8TjJaTtgfoGF/hVSrVsTqNDbSO9Xr
         x/ZXW0By4/N6ZHdiaod6/Tlnzen7v7b/Zmuw+MK6BTm86v5fh2Z5dclYLO8r9i3IWUY9
         M86g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yD6l/EFVuVats+JPFtCFieZjEklbTnI9kzjwky2zMA0=;
        fh=eAKy52swdivqtuGftzqMf5wfzjCpvDvct/BpGQc8npY=;
        b=INl4lEWCeEUZyVun1brt0KGg4zbWljwlXNpT/SUKilcuTrafrNpQSxiGu8QiRSG7cq
         edjTa8zJ3UeaygYD5idwTh5ZrFY1S6qQEesyFabqtGnIBNUUcmXkucndqqziIsR1bv9e
         SiX2Zw/qjOCpx9Mqz8JK6UL0UGAwsS2XB34NalOq+zR4rSrhtUqPT1nr8jbfkXft4eae
         LbVU8k30zPB//ENDgXajzCs5wXBVIrjkODoHna2MVbmmHQ56wuLpIGv34XHHfFKRivHb
         ZfGQ8dC6/R4UEQt9tQS5E1bTpNdM5RJMx50Q3q5iKQ3Sh5sOiYNSURf6P4zjn9OpMZ8z
         FRzg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768307958; x=1768912758; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yD6l/EFVuVats+JPFtCFieZjEklbTnI9kzjwky2zMA0=;
        b=hFLmJILtQqT8RAwuTV7aeOnPfdvDpJWtT5iqwpeGWmWOU2Zh2HtunWtBS36liuiAYo
         f+kl9OCb662kJHL8IlbfuQTYFHuE9PV2WLYx9dcBXITJQY+Wuy2Mft4Arx+jL4mVZixK
         Pqg8WLnE0bINrhYTg9femSAg7ELWlSpp5GoKstU2FpQj9oDG4CgysTejLxAdJ+hGLnDd
         5435AsxMXamzaybjJTY3844hCm6xwRbQJ1CfmJAUR2RIE8J6oJt9v+d19qsGfbWertkZ
         SthAN+2g8RwnY9nMe41U/yWu2pTNS3qJp73BrttSRHAHMQUTwITCR0mAzDflqWamLcR4
         GTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768307958; x=1768912758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yD6l/EFVuVats+JPFtCFieZjEklbTnI9kzjwky2zMA0=;
        b=tZV+8bkuhmPq0QJ4TRYR/hVhoYBE2wjsqNyeoOsOaeFgxMumK5iazwwQIpM6kNhmR0
         U8baQRKnhTX/fd942EKdWkKOi62udPnGzMTFAnXScUrC+h1XqEEFgF+2sVRkwIADG9f/
         mQHZgS18vrkbYvFHieskkgu4IaqJs59FiFgk3h9FY+TcMKfyzIkUJvmh+JW4h0v7IRZZ
         R38kWSY3fIXiL3NlF26qyrtjZaf7q+mj/Y8sTSDllqfTNnh741xVoheGyvMVeeN4mQix
         QZnZrNMYacfmAE07lmoAS88Ns9XY6vMeBzpE5XeB2hsn3KrZ/AO2h6NU0kn8vPOugNuI
         m7tw==
X-Forwarded-Encrypted: i=1; AJvYcCV8pV8c3h2GkhEbwKUuw5WXSooXcrNmGENN0A9Gdrhlp/BSngil8atL+9lQs7v5n+jDncJAjSw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxt1i/fFoSViVob9D2o8x0s3FH+bshTl6S2wTq2+zBo9bHxLTMr
	k05Kn0P1UhPqYGtT2kCqVR8pAtR2MLCZeki3VZgGcX6c6/Qhg/KS15AXeuV0WPv1Arcokx0p4E0
	SFjd26naBX84MBl+Dh3WIS2yCP3G1yiaoaXEtq6UA
X-Gm-Gg: AY/fxX7Jx+3BbMfk85YnCpIMRTZ+u87lVlcjWJrvd1D/HVFF/DNFUeoTt2bjBbqurFj
	YFPfNNv/VSS2Ncwmv91zaX6CR+sGCZaG7OnSZ2dRBJhFmtQGR7q+lU+YVcPsfFTK3Rcy+CdMU6L
	jQTRwv1rftGb2bLSR31Wh7TvEToQMzIkhQbYWaKtO5TgNsoMSp8P2LK+sRx1nCkj5WVAg506g8I
	rmek78JXRMtbr6Qd9tVNHRXPZwq+mV2wj/2N7sY22Ut6Qt3jffxefiBhCq1tlVCFp/tcQ==
X-Received: by 2002:a05:7022:2488:b0:122:2e4:11db with SMTP id
 a92af1059eb24-1232be1d1e5mr111880c88.6.1768307956529; Tue, 13 Jan 2026
 04:39:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aLFdVX4eXrDnDD25@kernel.org> <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>
 <68d3465541f82_105201005@dwillia2-mobl4.notmuch> <CAAi7L5esz-vxbbP-4ay-cCfc1osXLkvGDx5thijuBXFBQNwiug@mail.gmail.com>
 <68d6df3f410de_1052010059@dwillia2-mobl4.notmuch> <CAAi7L5dWpzfodg3J4QqGP564qDnLmqPCKHJ-1BTmzwMUhz6rLg@mail.gmail.com>
 <68ddab118dcd4_1fa21007f@dwillia2-mobl4.notmuch> <CAAi7L5cpkYrf5KjKdX0tsRS2Q=3B_6NZ4urNG6EfjNYADqhYSA@mail.gmail.com>
 <6942201839852_1cee10044@dwillia2-mobl4.notmuch> <CAAi7L5e0gNYO=+4iYq1a+wgJmuXs8C0d=721YuKUKsHzQC6Y0Q@mail.gmail.com>
 <6965857b34958_f1ef61008b@iweiny-mobl.notmuch>
In-Reply-To: <6965857b34958_f1ef61008b@iweiny-mobl.notmuch>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Tue, 13 Jan 2026 13:39:05 +0100
X-Gm-Features: AZwV_Qj14zUo_Mf4GZAi9izNWA8_AFS2TrzUwTTRWaiJfVSfhstwad7qaVzXkYY
Message-ID: <CAAi7L5e3TFcuwpt5vzy_xOtDxX0AfgH3tDzZJM=uiJy4h9a08A@mail.gmail.com>
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices
To: Ira Weiny <ira.weiny@intel.com>
Cc: dan.j.williams@intel.com, Mike Rapoport <rppt@kernel.org>, 
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, jane.chu@oracle.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Tyler Hicks <code@tyhicks.com>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 12:33=E2=80=AFAM Ira Weiny <ira.weiny@intel.com> wr=
ote:
>
> Micha=C5=82 C=C5=82api=C5=84ski wrote:
> > On Wed, Dec 17, 2025 at 4:14=E2=80=AFAM <dan.j.williams@intel.com> wrot=
e:
> > >
> > > Micha=C5=82 C=C5=82api=C5=84ski wrote:
> > > [..]
> > > > > Sure, then make it 1280K of label space. There's no practical lim=
it in
> > > > > the implementation.
> > > >
> > > > Hi Dan,
> > > > I just had the time to try this out. So I modified the code to
> > > > increase the label space to 2M and I was able to create the
> > > > namespaces. It put the metadata in volatile memory.
> > > >
> > > > But the infoblocks are still within the namespaces, right? If I try=
 to
> > > > create a 3G namespace with alignment set to 1G, its actual usable s=
ize
> > > > is 2G. So I can't divide the whole pmem into 1G devices with 1G
> > > > alignment.
> > >
> > > Ugh, yes, I failed to predict that outcome.
> > >
> > > > If I modify the code to remove the infoblocks, the namespace mode
> > > > won't be persistent, right? In my solution I get that information f=
rom
> > > > the kernel command line, so I don't need the infoblocks.
> > >
> > > So, I dislike the command line option ABI expansion proposal enough t=
o
> > > invest some time to find an alternative. One observation is that the
> > > label is able to indicate the namespace mode independent of an
> > > info-block. The info-block is only really needed when deciding whethe=
r
> > > and how much space to reserve to allocate 'struct page' metadata.
> > >
> > > -- 8< --
> > > From 4f44cbb6e3bd4cac9481bdd4caf28975a4f1e471 Mon Sep 17 00:00:00 200=
1
> > > From: Dan Williams <dan.j.williams@intel.com>
> > > Date: Mon, 15 Dec 2025 17:10:04 -0800
> > > Subject: [PATCH] nvdimm: Allow fsdax and devdax namespace modes witho=
ut
> > >  info-blocks
> > > MIME-Version: 1.0
> > > Content-Type: text/plain; charset=3DUTF-8
> > > Content-Transfer-Encoding: 8bit
> > >
> > > Micha=C5=82 reports that the new ramdax facility does not meet his ne=
eds which
> > > is to carve large reservations of memory into multiple 1GB aligned
> > > namespaces/volumes. While ramdax solves the problem of in-memory
> > > description of the volume layout, the nvdimm "infoblocks" eat capacit=
y and
> > > destroy alignment properties.
> > >
> > > The infoblock serves 2 purposes, it indicates whether the namespace s=
hould
> > > operate in fsdax or devdax mode, Micha=C5=82 needs this, and it optio=
nally
> > > reserves namespace capacity for storing 'struct page' metadata, Micha=
=C5=82 does
> > > not need this. It turns out the mode information is already recorded =
in the
> > > namespace label, and if no reservation is needed for 'struct page' me=
tadata
> > > then infoblock settings can just be hard coded.
> > >
> > > Introduce a new ND_REGION_VIRT_INFOBLOCK flag for ramdax to indicate =
that
> > > all infoblocks be synthesized and not consume any capacity from the
> > > namespace.
> > >
> > > With that ramdax can create a full sized namespace:
> > >
> > > $ ndctl create-namespace -r region0 -s 1G -a 1G -M mem
> > > {
> > >   "dev":"namespace0.0",
> > >   "mode":"fsdax",
> > >   "map":"mem",
> > >   "size":"1024.00 MiB (1073.74 MB)",
> > >   "uuid":"c48c4991-86af-4de1-8c7c-8919358df1f9",
> > >   "sector_size":512,
> > >   "align":1073741824,
> > >   "blockdev":"pmem0"
> > > }
> >
> > Thank you for working on this.
> >
> > I tried it an indeed it works with fsdax. It doesn't seem to work with
> > devdax though.
> >
> > $ ndctl create-namespace -v -r region1 -m devdax -a 1G -M mem -s 1G
> > libndctl: ndctl_dax_enable: dax1.0: failed to enable
> >   Error: namespace1.1: failed to enable
> >
> > failed to create namespace: No such device or address
> >
> > $ dmesg | grep dax
> > [...]
> > [   29.504763] dax_pmem dax1.0: could not reserve metadata
> > [   29.504766] dax_pmem dax1.0: probe with driver dax_pmem failed with =
error -16
> > [   29.506553] probe of dax1.0 returned 16 after 1815 usecs
> > [...]
> >
> > I think the dax_pmem driver needs to be modified too.
>
> Micha=C5=82
>
> Did yall have a suggestion on how?  I lost track of this thread over the
> holidays and so I'm not sure where this stands.
>
> Ira

I think Dan's change needs to skip devm_request_mem_region if offset
=3D=3D 0 in __dax_pmem_probe in drivers/dax/pmem.c.
