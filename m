Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D529E2C9C
	for <nvdimm@lists.linux.dev>; Fri,  4 Feb 2022 02:45:43 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id d18so3964655plg.2
        for <nvdimm@lists.linux.dev>; Thu, 03 Feb 2022 18:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8ybJv4007VY1nVqz0l0+c5F0IO2JpuCUf6LTy70kbUk=;
        b=WW0nPvokReJnYzJlT6bzNxjhgdJLwQxhUi5+wJj67wgjQBkMLkHkTqKyC5s0TKUXNy
         qvznZcNGeR9MUl0+7fWkjEMSs8TNCdLmPibjqsJP2GX4zA0jhvniADeMvSJGoBc+nWuv
         6eHdjEhadO10+CBzftQWedDygxk99FG8YMTxYgApAEm2uErs3kMSzwjiBozIh9ygq7/P
         5PE7EybSKgIE3G2HZyKBVY1lNTczXwMIr/kYaDwQGm95yEETcujXirRtllOVXSt1c0Ws
         ziQejWl947d5gGg0cXRNusmZW4+BTEfV5wfyGQeTOnhzaeQYgl1GcjRW9wSvhgMhS835
         b0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8ybJv4007VY1nVqz0l0+c5F0IO2JpuCUf6LTy70kbUk=;
        b=oPD2eLxHhZN57ZZrDy76l3OsRG27wIC6LWHEl90SD34pHwebgOdLFT8TIJ+dso33pP
         GrtPvue8FgfMTVSgyIGU+kUso1aNYSOwkDgZVfu17v9cJtCG+0nG4SQl4bYzQpT2PY1g
         iFy4mlJnKYkM4I6dzZuKpUtURt3olc8/0GpEWuMYqNRQfUo7UD92Xl+SPw0dq/ISWA4z
         UAe5wDn2MhAESp141RGf6CXumCIuIwMdwgkwbO8PToiDnMeiRu/FAFPHrUbaTkrdGpEZ
         kgWP91EtPXdaOyY5fZRbW6vTOOpsZqfo6J4QbnJ4vmtRcwufmSkqB2ZRndGLsxYDUypz
         H2KA==
X-Gm-Message-State: AOAM533UbY91raxNi84oOtGKXt12sfWsCRgeWiz2mV7iN6lrouwTVOz1
	ukrEw4HE/NHQOOwtuXC0ewLzJ62IFj1O3/vM0KBmcQ==
X-Google-Smtp-Source: ABdhPJzGR2iKkxbJY5KRKyOe32ftl29+6yRc08Uv9RS5UK6af4JeKS+PxqjGm2T6anVIFVtDn0pa/Rfbs7i78Olk5DA=
X-Received: by 2002:a17:90b:1bcc:: with SMTP id oa12mr754529pjb.93.1643942743215;
 Thu, 03 Feb 2022 18:45:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220128002707.391076-1-ben.widawsky@intel.com>
 <20220128002707.391076-3-ben.widawsky@intel.com> <CAPcyv4hHJcPLRJM-7z+wKhjBhp9HH2qXuEeC0VfDnD6yU9H-Wg@mail.gmail.com>
 <20220201231117.lksqoukbvss6e3ec@intel.com> <CAPcyv4iGQWXX8rzCH7BJUSyvDXbdiuHw4kLiuqGmVVBGTh2a1Q@mail.gmail.com>
 <20220203222300.gf4st36yoqjxq5q6@intel.com> <CAPcyv4icq8_9E+ziU5KKYrAepUtNP32Qf6wYGYpcUU2K1P4mAA@mail.gmail.com>
 <20220204001950.cxncxxxsmoyc6jcy@intel.com>
In-Reply-To: <20220204001950.cxncxxxsmoyc6jcy@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Feb 2022 18:45:30 -0800
Message-ID: <CAPcyv4gYzeYUNBDobktrNRsBvqx1YBchnLi3YN6fTqm0RxemWA@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] cxl/region: Introduce concept of region configuration
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	kernel test robot <lkp@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Bjorn Helgaas <helgaas@kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 3, 2022 at 4:20 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
[..]
> > > > Basic input validation to me is things like:
> > > >
> > > > - Don't allow writes while the region is active
> > > > - Check that values are in bound. So yes, the interleave-ways value=
 of
> > > > 3 would fail until the kernel supports it, and granularity values >
> > > > 16K would also fail.
> > > > - Check that memdevs are actually downstream targets of the given d=
ecoder
> > > > - Check that the region uuid is unique
> > >
> > > These are obviously easy and informative at attr store time (in fact,=
 active was
> > > meant to be checked already for many cases). So if we agree to codify=
 this at
> > > probe via WARN, and add it to kdoc, I've no problem with it.
> >
> > Why is WARN needed? Either the sysfs validation does it job correctly
> > or it doesn't. Also if sysfs didn't WARN when the bad input is
> > specified why would the core do anything higher than dev_err()?
> > Basically I think the bar for WARN is obvious kernel programming error
> > where only a kernel-developer will see it vs EINVAL at runtime
> > scenarios. I have seen Greg raise the bar for WARN in his reviews
> > given how many deployments turn on 'panic_on_warn'.
>
> Ultimately some checking will need to occur in one form or another in reg=
ion
> probe(). Either explicit via conditional: if (!is_valid(interleave_ways))=
 return
> -EINVAL, or implicitly, for example 1 << (rootd_ig - cxlr_ig) is some inv=
alid
> nonsense which later fails host bridge programming verification. Before
> discussing further, which are you suggesting?

Explicit validation at probe in addition to the explicit validation at
the sysfs boundary (as much as possible to report errors early). The
"at probe time" validation does not know if this was a new region, or
one enumerated from LSA or the configuration that the BIOS specified.
So I do expect validation overlap, but there will also be distinct
checks for those different scenarios. For example, see how NVDIMM
validates namespace configuration writes via sysfs, but does not
validate the LSA because it's writing the label and had better be
prepared to read what it writes.

>
> >
> > > > - Check that decoder has capacity
> > > > - Check that the memdev has capacity
> > > > - Check that the decoder to map the DPA is actually available given
> > > > decoders must be programmed in increasing DPA order
> > > >
> > > > Essentially any validation short of walking the topology to program
> > > > upstream decoders since those errors are only resolved by racing
> > > > region probes that try to grab upstream decoder resources.
> > > >
> > >
> > > I intentionally avoided doing a lot of these until probe because it s=
eemed like
> > > not a great policy to deny regions from being populated if another re=
gion
> > > utilizing those resources hasn't been bound yes. For a simple example=
, if x1
> > > region A is created and utilizes all of memdev =C9=91's capacity you =
block out any
> > > other region setup using memdev =C9=91, even if region A wasn't bound=
. There's a
> > > similar problem with specifying decoders as part of configuration.
> > >
> > > I'll infer from your comment that you are fine with this tradeoff, or=
 you have
> > > some other way to manage this in mind.
> >
> > It comes back to observability if threadA allocates all the DPA then
> > yes all other threads should see -ENOSPC. No different than if 3 fdisk
> > threads all tried to create a partition, the first one to the kernel
> > wins. If threadA does not end up activating that regionA's capacity
> > that's userspace's fault, and the admin needs to make sure that
> > configuration does not race itself. The kernel allocating DPA
> > immediately lets those races be found early such that threadB finds
> > all the DPA gone and stops trying to create the region.
>
> Okay. I don't have a strong opinion on how userspace should or shouldn't =
use
> this interface. It seems less friendly to do it this way, but per the fol=
lowing
> comment, if it's root only, it doesn't really matter.
>
> I was under the impression you expected userspace to manage the DPA as we=
ll. I
> don't really see any reason why the kernel should manage it if userspace =
is
> already handling all these other bits. Let userspace set the offset and s=
ize
> (can make a single device attr for it), and upon doing so it gets reserve=
d.

Userspace sense requests, kernel allocates or denies that request
after resolving races with other requesters. Yes, this makes the
interface stateful. Sysfs is not suited to stateless operation.
