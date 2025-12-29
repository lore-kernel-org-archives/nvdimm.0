Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E292ECA5A
	for <nvdimm@lists.linux.dev>; Mon, 29 Dec 2025 16:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026388; cv=pass; b=qImKn+5RYbC1yzM5OcdCbxu2Oq74LIC84ty2SprXaWOv1pozBMiFQBgibIlEhnsL6TD8Lh6sR/R1Kq0q3PgRjWVxt4iCK3kao16eDcJ176COtts69EDfoZOhM03tI/IZFfktcjbNta1gHcC2z1/FaWvpAEGBynktSzWiJY7C3kE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026388; c=relaxed/simple;
	bh=OuP8C0WxdhdguSBG5j4dif/0tLfE5uBTZMXP6aDBYPM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PZGvhbldujw0nnBeOxZp8fpQ8M0i1gMvXear63jKOIeHyF8ZsDxmLXr4+dTVH4e3RpVP36CqisC6vN5xhSbWmVUet9UMB6JrKSzcwOG/UlngzPfVEuNseFZPkjzlsYrsAPdWKws9inCYKBNNJA5WKnheJ/QFApNwtBkBK0irCpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nseEYB8V; arc=pass smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nseEYB8V"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a0d06cfa93so1368815ad.1
        for <nvdimm@lists.linux.dev>; Mon, 29 Dec 2025 08:39:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767026386; cv=none;
        d=google.com; s=arc-20240605;
        b=ZbFbC3EBIKQo+HHi5HlT8nL1QFLKvJhuCKotBsFYxuNl55jl/hKGJBHNMobKs/9Qzu
         w9PS7Z4VhJhn2V6sqM0lFYVeOUcei4KggR3wENOI2v8zIWwRQFLojiN3TLdHvDACAM+A
         PHUU/w3lWkQUS36xsig9LhAg7Jgw5NINFfV6YEY7u/WTS9wfia7z+tbGhaMw5IHpoy4R
         FuuixgcZdAvNVS53HYeNzbcFQmULzuTXgilSeJce+2QubMCpRXTnzBr7qmUmemrMgIHr
         iuJVHK/bJGRFKW7PS8w6+lwvu/0QR/gMngIPCXFAnOJqKGrbc5h+kost0MIxmYgQ4xvB
         UCRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GrRVww3nf+cXb4RGZoskw+4mAPaULgjgSoLo9UYulcc=;
        fh=2/USEn4GzIjCxK2lFfL1neTTgO5yocMW4TrT2NuatIw=;
        b=PLYNhzYZLXK4jQQlJ1o4hk7VydSBb5Z0+v/j0nk8bb0SMB2MLMKeFfRwbZJxALg8nw
         R7KuT3P18j53BVvPx4W6mT6SPcTD89gbyiOTnYI6p+Hy4sJlBoRXA77QySlr3NIwWL3X
         rqadsOeN3J4TOYZzopyx+aqKu0aKfecUnZrTOfd8bfMI8twboOxyVNKh54G0EJ9sbqDW
         WA6EgHrEvZLGmMUjng+lpZzPBuYAhdBtClH9CtSziiGLZISu8SQlanDQdmTdhJtpA5Ag
         LHlnprFyjHDUscchrDaTR5oYIG2jjfHO8ZrWCHDRavMauNTaDXxP3YfwE01Sbq6ggfOL
         R0EQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767026386; x=1767631186; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GrRVww3nf+cXb4RGZoskw+4mAPaULgjgSoLo9UYulcc=;
        b=nseEYB8VA65pgz0zHh0q/Pr2buJ/Lq10cM0KyIVebDzQ6YRGzobqgrWXRgm+NnBulV
         sVdWxsiT1lY80bh8DEcvp1fkY4DbvdCtrfs69jmM1OlPpO7nqNqlB3797Br7TbqoIKSZ
         sUDuTTD0Fs8p/UL7dBNEYz+dVW7+4CyCZJqdxz2Sko9+Vee8oo+e26EuC4DA94GGLAVR
         C3tVRXBVKnXQbIHhb7foRX9ICCEt3ajuKBQW6y8S/c2NsXX5CylflRYSjJxdNK4rUxYj
         Ok9S1VL9dH4jI7Ivv1YEEmdq5mxPf6cJOOIU2+uBjygCtuGj8C+Ei5AfEFFN82leprkh
         Kk5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767026386; x=1767631186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GrRVww3nf+cXb4RGZoskw+4mAPaULgjgSoLo9UYulcc=;
        b=pEw0oHX+d+OMRlbbDX+czzdWeAqGWIW93KlU/jbaqfL9XQ6OWu6fKopcldQtclj6rT
         76DrvB7990mYx3VbjmQPjqN9qX3yXU1WReqiBuX8p9KYSqvGdzetYm0VT6qHQ5z+30Ek
         Xe45BEbRv/NEWOgSq7nr6YKRQsTOv/QsYaCfwqSVMq0T8qM8sjCV/ecLhZEUA+ueqf5W
         Jt3wNLgOUDz1M39QGj1hESbvdqSwJMmD1PbZQ4P2R88aRHVZ15xSUSEjWzeztPkq2ikO
         l8qgRjEJvRFtEwpOeOLGkHV4hlsbFMqA6x4PRN7uDPohvKQfY9s55h3FDhJk5SO0+QsD
         4VhA==
X-Forwarded-Encrypted: i=1; AJvYcCVHgH8Vhuu4aHaaSDONzAQXyYgPO/BVxXCFQlPFBYvb33uWTcK/hY1KwWicNuqSErlgefbQM60=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8StvEa2eTe5wBU5f2M05XtxhBizEdjLlYrCWUbCrPcS4udlg5
	I4FTn5eauLYMLBHkwja4YxRuMa1bH4wDTVx2Lw48PLpfD11KVnMuQ58zhQZZ9p9EulCHrh1pArm
	720uV2sQ6R8NYQNfTX7WDi2otsEec40jof0CniRa8
X-Gm-Gg: AY/fxX6j/ooROr2FjY3x+GSG5l/xugq95hzO1Xxy6UbBo01N4z49e+xb23hQ34tI0nh
	76AknRPFfDcEH/1yrbyHMSUPkLZhJLaiViB3L6sXfdy0QE/0e3S0vpzZAik0oqAzrhl9AJgA/oK
	JyCZkq6RdGYpBM4NrHretQ1lvc5Dt11fJkUb5AJgi1dX4vWA4c+P3A42L+ldwZRyw5cDYO4Y4EI
	perEwjkImQIRPqHfAeeV7uoEsx84q2KN+z8oPON4lGnjUg3hNDVzFSRC9BvRLCWOmv9jg==
X-Google-Smtp-Source: AGHT+IE5KGw/KSR+9kC9ErLwzqrs+SsJGK1bGbqWa1EN8t5SfrVwHWb/I5/A/SuFOQf4BgPaH7tJrIU4bSvPOleCSX8=
X-Received: by 2002:a05:7022:2489:b0:119:e56b:c1d5 with SMTP id
 a92af1059eb24-1219abcfd1dmr414608c88.0.1767026385794; Mon, 29 Dec 2025
 08:39:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250826080430.1952982-1-rppt@kernel.org> <20250826080430.1952982-2-rppt@kernel.org>
 <68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch> <aLFdVX4eXrDnDD25@kernel.org>
 <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>
 <68d3465541f82_105201005@dwillia2-mobl4.notmuch> <CAAi7L5esz-vxbbP-4ay-cCfc1osXLkvGDx5thijuBXFBQNwiug@mail.gmail.com>
 <68d6df3f410de_1052010059@dwillia2-mobl4.notmuch> <CAAi7L5dWpzfodg3J4QqGP564qDnLmqPCKHJ-1BTmzwMUhz6rLg@mail.gmail.com>
 <68ddab118dcd4_1fa21007f@dwillia2-mobl4.notmuch> <CAAi7L5cpkYrf5KjKdX0tsRS2Q=3B_6NZ4urNG6EfjNYADqhYSA@mail.gmail.com>
 <6942201839852_1cee10044@dwillia2-mobl4.notmuch>
In-Reply-To: <6942201839852_1cee10044@dwillia2-mobl4.notmuch>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Mon, 29 Dec 2025 17:39:33 +0100
X-Gm-Features: AQt7F2pxs3Yp6amNNw8an7kuRA6SpQqQgRyAheqI2td3xLGKObIJqcKF7-_TpHE
Message-ID: <CAAi7L5e0gNYO=+4iYq1a+wgJmuXs8C0d=721YuKUKsHzQC6Y0Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices
To: dan.j.williams@intel.com
Cc: Mike Rapoport <rppt@kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, jane.chu@oracle.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Tyler Hicks <code@tyhicks.com>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 4:14=E2=80=AFAM <dan.j.williams@intel.com> wrote:
>
> Micha=C5=82 C=C5=82api=C5=84ski wrote:
> [..]
> > > Sure, then make it 1280K of label space. There's no practical limit i=
n
> > > the implementation.
> >
> > Hi Dan,
> > I just had the time to try this out. So I modified the code to
> > increase the label space to 2M and I was able to create the
> > namespaces. It put the metadata in volatile memory.
> >
> > But the infoblocks are still within the namespaces, right? If I try to
> > create a 3G namespace with alignment set to 1G, its actual usable size
> > is 2G. So I can't divide the whole pmem into 1G devices with 1G
> > alignment.
>
> Ugh, yes, I failed to predict that outcome.
>
> > If I modify the code to remove the infoblocks, the namespace mode
> > won't be persistent, right? In my solution I get that information from
> > the kernel command line, so I don't need the infoblocks.
>
> So, I dislike the command line option ABI expansion proposal enough to
> invest some time to find an alternative. One observation is that the
> label is able to indicate the namespace mode independent of an
> info-block. The info-block is only really needed when deciding whether
> and how much space to reserve to allocate 'struct page' metadata.
>
> -- 8< --
> From 4f44cbb6e3bd4cac9481bdd4caf28975a4f1e471 Mon Sep 17 00:00:00 2001
> From: Dan Williams <dan.j.williams@intel.com>
> Date: Mon, 15 Dec 2025 17:10:04 -0800
> Subject: [PATCH] nvdimm: Allow fsdax and devdax namespace modes without
>  info-blocks
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
> Micha=C5=82 reports that the new ramdax facility does not meet his needs =
which
> is to carve large reservations of memory into multiple 1GB aligned
> namespaces/volumes. While ramdax solves the problem of in-memory
> description of the volume layout, the nvdimm "infoblocks" eat capacity an=
d
> destroy alignment properties.
>
> The infoblock serves 2 purposes, it indicates whether the namespace shoul=
d
> operate in fsdax or devdax mode, Micha=C5=82 needs this, and it optionall=
y
> reserves namespace capacity for storing 'struct page' metadata, Micha=C5=
=82 does
> not need this. It turns out the mode information is already recorded in t=
he
> namespace label, and if no reservation is needed for 'struct page' metada=
ta
> then infoblock settings can just be hard coded.
>
> Introduce a new ND_REGION_VIRT_INFOBLOCK flag for ramdax to indicate that
> all infoblocks be synthesized and not consume any capacity from the
> namespace.
>
> With that ramdax can create a full sized namespace:
>
> $ ndctl create-namespace -r region0 -s 1G -a 1G -M mem
> {
>   "dev":"namespace0.0",
>   "mode":"fsdax",
>   "map":"mem",
>   "size":"1024.00 MiB (1073.74 MB)",
>   "uuid":"c48c4991-86af-4de1-8c7c-8919358df1f9",
>   "sector_size":512,
>   "align":1073741824,
>   "blockdev":"pmem0"
> }

Thank you for working on this.

I tried it an indeed it works with fsdax. It doesn't seem to work with
devdax though.

$ ndctl create-namespace -v -r region1 -m devdax -a 1G -M mem -s 1G
libndctl: ndctl_dax_enable: dax1.0: failed to enable
  Error: namespace1.1: failed to enable

failed to create namespace: No such device or address

$ dmesg | grep dax
[...]
[   29.504763] dax_pmem dax1.0: could not reserve metadata
[   29.504766] dax_pmem dax1.0: probe with driver dax_pmem failed with erro=
r -16
[   29.506553] probe of dax1.0 returned 16 after 1815 usecs
[...]

I think the dax_pmem driver needs to be modified too.
