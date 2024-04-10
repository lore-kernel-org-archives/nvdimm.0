Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7580326AFF
	for <nvdimm@lists.linux.dev>; Wed, 10 Apr 2024 05:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712728568; cv=none; b=O5POPhWk6b0/Q4cgWy8TSxcTrZ0CEC1UwspT20BzvcG4K8cO1IPw/o6iSNtg/S9KDfiw73HzoITYQE7XzJN+KRQRvnt6Z0kQNuOw67LXGJLtZYbJn3psOV8Fpv99u0CYpGIyIOFZz83yNPsV8n8th9lJ+OHPdE2oNgNIfWGCHMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712728568; c=relaxed/simple;
	bh=iRWSGvESmj50SK/3+gdejLYH0/TGzOFnE+pS8ZkDCcU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MpfM0eEN2JEdRRBpcNDs9748ysau9stc+74KWx9J6fPNUSYmKbHk8y0+zxXKEJaWDgxfuFyFsFp/5LpgmaPhICn/YlKaBQxcFcAgW9JUzy+9j812YGTOG1FcHYsIwyUZ1tDVdtHckATCWDgB6ij0iExWQoMZ3aN6lMRJf9Nw7n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Z5t4W4wL; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Z5t4W4wL"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-dd10ebcd702so6562977276.2
        for <nvdimm@lists.linux.dev>; Tue, 09 Apr 2024 22:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1712728565; x=1713333365; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IqGY/vGIyR9LCZTBxU/bq4zwRiV3ymHiMH0aV8SV/K8=;
        b=Z5t4W4wLRj3mvpojcmB3JwGpTZCEfTHJKFdMRl/cGpMfa/CIVvmiNO+kFCeFUMWVCw
         wFIBkuL4UacmWGh9aexGIJqWYpfTu+tUJ5mSyaDQ2Cihf90Pwoua8/boa90Q5p4kAUq1
         nvC0bW0oj7dgFM+FXa0ViT4Xre4a1YDH0IyF37UaUFjCH6nhTwItxXa19Mw2IFU4d/nB
         bPzKeOQ0ab3MgyTMKt4RIPzHqUuCQ7WO8N8oUDvsoN0flti9txSWRaJlCG0YtYrNN/rP
         LDkgSPzhP0dkxpHrqH0bRWd9EKLCUa3zfbPe6jyTckpumuJvTbaSesZx+Ouq+ZSm2R/h
         mU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712728565; x=1713333365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IqGY/vGIyR9LCZTBxU/bq4zwRiV3ymHiMH0aV8SV/K8=;
        b=EWU52Xq7jUaEgNIzVJ7ogGNzVEjzG4NJGisp3mC3KVfItt0FhMtUOXKsFJbMn30Eo2
         79xyofAJzy7mZr+iP0tDySvMo33w5T6I0IvcK5yg5OTH3TK2Y6t0sEpqGhBDNbiNkJCG
         3BZs0t0cm0PRUkAWEfGwyKPjNHI7GUo1zOkD2NXK2oAfOjzSqC2qtgjKFnhIUiApkR3W
         CUoanU8Plv5c6rwAPJnslxD1ZToRHO2pzRXVJROwKWljRCOug1k1im0UVQBeVrRy/wTI
         3zrMq1jANWk5BMY45ViCdF1g/CdZsnK0tg6ovtTpVcBG/6mqSzaaYSokP06EfAT22mHC
         hA9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWMxr61zmd1NyXVu19iseC55jcICJPNE7Ry5hXwJFCvV25OBvepUu0ybanJBaCsN9oospbhFhA7eYEVBNelavEqBsyOzD5L
X-Gm-Message-State: AOJu0YwalfUjKogrm5hRl9ykjUWmeeEPsfm5Bw/cIdCBOpwBth7Hq/iH
	RmQYaz2AXIqe3FJ4hQSCUkNsSti8tbT1HHDNaTDILp1tkgfcC2EXoeZ34C0G5uNfQipYJTlhSky
	lthEYFwJcfXB8zgGqLt8OBTP1DpfKceeSEN8hJQ==
X-Google-Smtp-Source: AGHT+IHeeE9q1+cJcZFRlCtvV1BbpZVxnUEWrSDgdRRs3q/CuKFEvKs0kmjhM3Z408INF7Cm0W+a8a8XNmlyII/QV0E=
X-Received: by 2002:a25:be92:0:b0:dcd:5635:5c11 with SMTP id
 i18-20020a25be92000000b00dcd56355c11mr1731856ybk.45.1712728565448; Tue, 09
 Apr 2024 22:56:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240405000707.2670063-1-horenchuang@bytedance.com>
 <20240405000707.2670063-3-horenchuang@bytedance.com> <20240405150244.00004b49@Huawei.com>
 <CAKPbEqpGM_nR+LKbsoFTviBZaKUKYqJ3zbJp9EOCJAGvuPy6aQ@mail.gmail.com> <87ttka54pr.fsf@yhuang6-desk2.ccr.corp.intel.com>
In-Reply-To: <87ttka54pr.fsf@yhuang6-desk2.ccr.corp.intel.com>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Tue, 9 Apr 2024 22:55:54 -0700
Message-ID: <CAKPbEqqH0nhVUAcJUxDc_bPewY85+TqhtO94MyypV35GBo33+A@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v11 2/2] memory tier: create CPUless memory
 tiers after obtaining HMAT info
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Gregory Price <gourry.memverge@gmail.com>, 
	aneesh.kumar@linux.ibm.com, mhocko@suse.com, tj@kernel.org, 
	john@jagalactic.com, Eishan Mirakhur <emirakhur@micron.com>, 
	Vinicius Tavares Petrucci <vtavarespetr@micron.com>, Ravis OpenSrc <Ravis.OpenSrc@micron.com>, 
	Alistair Popple <apopple@nvidia.com>, Srinivasulu Thanneeru <sthanneeru@micron.com>, 
	SeongJae Park <sj@kernel.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Linux Memory Management List <linux-mm@kvack.org>, "Ho-Ren (Jack) Chuang" <horenc@vt.edu>, 
	"Ho-Ren (Jack) Chuang" <horenchuang@gmail.com>, qemu-devel@nongnu.org, 
	Hao Xiang <hao.xiang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 9, 2024 at 7:33=E2=80=AFPM Huang, Ying <ying.huang@intel.com> w=
rote:
>
> "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com> writes:
>
> > On Fri, Apr 5, 2024 at 7:03=E2=80=AFAM Jonathan Cameron
> > <Jonathan.Cameron@huawei.com> wrote:
> >>
> >> On Fri,  5 Apr 2024 00:07:06 +0000
> >> "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com> wrote:
> >>
> >> > The current implementation treats emulated memory devices, such as
> >> > CXL1.1 type3 memory, as normal DRAM when they are emulated as normal=
 memory
> >> > (E820_TYPE_RAM). However, these emulated devices have different
> >> > characteristics than traditional DRAM, making it important to
> >> > distinguish them. Thus, we modify the tiered memory initialization p=
rocess
> >> > to introduce a delay specifically for CPUless NUMA nodes. This delay
> >> > ensures that the memory tier initialization for these nodes is defer=
red
> >> > until HMAT information is obtained during the boot process. Finally,
> >> > demotion tables are recalculated at the end.
> >> >
> >> > * late_initcall(memory_tier_late_init);
> >> > Some device drivers may have initialized memory tiers between
> >> > `memory_tier_init()` and `memory_tier_late_init()`, potentially brin=
ging
> >> > online memory nodes and configuring memory tiers. They should be exc=
luded
> >> > in the late init.
> >> >
> >> > * Handle cases where there is no HMAT when creating memory tiers
> >> > There is a scenario where a CPUless node does not provide HMAT infor=
mation.
> >> > If no HMAT is specified, it falls back to using the default DRAM tie=
r.
> >> >
> >> > * Introduce another new lock `default_dram_perf_lock` for adist calc=
ulation
> >> > In the current implementation, iterating through CPUlist nodes requi=
res
> >> > holding the `memory_tier_lock`. However, `mt_calc_adistance()` will =
end up
> >> > trying to acquire the same lock, leading to a potential deadlock.
> >> > Therefore, we propose introducing a standalone `default_dram_perf_lo=
ck` to
> >> > protect `default_dram_perf_*`. This approach not only avoids deadloc=
k
> >> > but also prevents holding a large lock simultaneously.
> >> >
> >> > * Upgrade `set_node_memory_tier` to support additional cases, includ=
ing
> >> >   default DRAM, late CPUless, and hot-plugged initializations.
> >> > To cover hot-plugged memory nodes, `mt_calc_adistance()` and
> >> > `mt_find_alloc_memory_type()` are moved into `set_node_memory_tier()=
` to
> >> > handle cases where memtype is not initialized and where HMAT informa=
tion is
> >> > available.
> >> >
> >> > * Introduce `default_memory_types` for those memory types that are n=
ot
> >> >   initialized by device drivers.
> >> > Because late initialized memory and default DRAM memory need to be m=
anaged,
> >> > a default memory type is created for storing all memory types that a=
re
> >> > not initialized by device drivers and as a fallback.
> >> >
> >> > Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
> >> > Signed-off-by: Hao Xiang <hao.xiang@bytedance.com>
> >> > Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
> >>
> >> Hi - one remaining question. Why can't we delay init for all nodes
> >> to either drivers or your fallback late_initcall code.
> >> It would be nice to reduce possible code paths.
> >
> > I try not to change too much of the existing code structure in
> > this patchset.
> >
> > To me, postponing/moving all memory tier registrations to
> > late_initcall() is another possible action item for the next patchset.
> >
> > After tier_mem(), hmat_init() is called, which requires registering
> > `default_dram_type` info. This is when `default_dram_type` is needed.
> > However, it is indeed possible to postpone the latter part,
> > set_node_memory_tier(), to `late_init(). So, memory_tier_init() can
> > indeed be split into two parts, and the latter part can be moved to
> > late_initcall() to be processed together.
>
> I don't think that it's good to move all memory_tier initialization in
> drivers to late_initcall().  It's natural to keep them in
> device_initcall() level.
>
> If so, we can allocate default_dram_type in memory_tier_init(), and call
> set_node_memory_tier() only in memory_tier_lateinit().  We can call
> memory_tier_lateinit() in device_initcall() level too.
>

It makes sense to me to leave only `default_dram_type ` and
hotplug_init() in memory_tier_init(), postponing all
set_node_memory_tier()s to memory_tier_late_init()

Would it be possible there is no device_initcall() calling
memory_tier_late_init()? If yes, I think putting memory_tier_late_init()
in late_init() is still necessary.

> --
> Best Regards,
> Huang, Ying
>
> > Doing this all memory-type drivers have to call late_initcall() to
> > register a memory tier. I=E2=80=99m not sure how many they are?
> >
> > What do you guys think?
> >
> >>
> >> Jonathan
> >>
> >>
> >> > ---
> >> >  mm/memory-tiers.c | 94 +++++++++++++++++++++++++++++++++++---------=
---
> >> >  1 file changed, 70 insertions(+), 24 deletions(-)
> >> >
> >> > diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> >> > index 516b144fd45a..6632102bd5c9 100644
> >> > --- a/mm/memory-tiers.c
> >> > +++ b/mm/memory-tiers.c
> >>
> >>
> >>
> >> > @@ -855,7 +892,8 @@ static int __init memory_tier_init(void)
> >> >        * For now we can have 4 faster memory tiers with smaller adis=
tance
> >> >        * than default DRAM tier.
> >> >        */
> >> > -     default_dram_type =3D alloc_memory_type(MEMTIER_ADISTANCE_DRAM=
);
> >> > +     default_dram_type =3D mt_find_alloc_memory_type(MEMTIER_ADISTA=
NCE_DRAM,
> >> > +                                                   &default_memory_=
types);
> >> >       if (IS_ERR(default_dram_type))
> >> >               panic("%s() failed to allocate default DRAM tier\n", _=
_func__);
> >> >
> >> > @@ -865,6 +903,14 @@ static int __init memory_tier_init(void)
> >> >        * types assigned.
> >> >        */
> >> >       for_each_node_state(node, N_MEMORY) {
> >> > +             if (!node_state(node, N_CPU))
> >> > +                     /*
> >> > +                      * Defer memory tier initialization on
> >> > +                      * CPUless numa nodes. These will be initializ=
ed
> >> > +                      * after firmware and devices are initialized.
> >>
> >> Could the comment also say why we can't defer them all?
> >>
> >> (In an odd coincidence we have a similar issue for some CPU hotplug
> >>  related bring up where review feedback was move all cases later).
> >>
> >> > +                      */
> >> > +                     continue;
> >> > +
> >> >               memtier =3D set_node_memory_tier(node);
> >> >               if (IS_ERR(memtier))
> >> >                       /*
> >>



--=20
Best regards,
Ho-Ren (Jack) Chuang
=E8=8E=8A=E8=B3=80=E4=BB=BB
