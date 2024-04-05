Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7752C1BA
	for <nvdimm@lists.linux.dev>; Fri,  5 Apr 2024 22:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712357040; cv=none; b=K6X5oU0Cq3nHYGuMdA17zHkc3KRY+WMJQQ8UTcQebvR6P8UGYCcQGxBnw7BrP8nIp/HUlQsGS4aPfXfjM0YiEk7Lv9fvbXq1v4xVLHUAA6qlOT1kJxdskcdPajXLetp6lSaeP8VTJfoi81SGRyKD4tdG5LOkFfGufdj8QZbDzR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712357040; c=relaxed/simple;
	bh=JrWgAMwL1kvDvWJdq7P6eEwvsYKZ6eqw3MbLIeb0B38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FUcc5GypffjCW370JGE1revYBANeTp32XOvB5mBaYxpiaSohvMoNKtVf4leE+FLWGjjBIStr/bxg9zaIlUJA3uuUSOwQkRkIBNkpayPd6OWWL575LlitmUeull826mx2/mGV9DQgWy0dWLoPmP2GS32u+1ao/XCbBuKKtbUOyrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Bc+zwdnz; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Bc+zwdnz"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-dd14d8e7026so2630026276.2
        for <nvdimm@lists.linux.dev>; Fri, 05 Apr 2024 15:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1712357038; x=1712961838; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hCBHfr4VKJb+nF0gfasAMfqJdSwuuy6m/sFNcO7Zez0=;
        b=Bc+zwdnza+cX2Snv6hkh5vS0J4cww74w1CGKMkSZgSc7RYmeVo7NZWkg15ZoQAOjPE
         X4TJ+sq0+ihWYKH+tyXLoQXBSHoIVFKYiBdh60lvvzHN5bYJVbsD2KKBoVxfPgE8/zXk
         +GcPoX6EwZHgV4GDxdGmbjb+6ZIiGhT3CEBOM6K2o2ZgbQ+qxYog5gVqWdLkKiLsVWdz
         FS41qO6MKfEJXGEDWZwVcvmk7biBWwuj8FFpXToi92sVjuD0tgC+/yBLiNkI86kHt1mR
         LpEk4Fu4V05sXrE/LqxKU0v2Jpt0Wqhnbig4lUyB9LPjoEa9YKPFFi+mWr7zLa2DODu1
         xOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712357038; x=1712961838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hCBHfr4VKJb+nF0gfasAMfqJdSwuuy6m/sFNcO7Zez0=;
        b=Wq2XZshUVRv/RpiRoZ0C+cjakGx6Yz5QeXOHHf5MgQy4z7c+pWVFGHifMre9JvRIp0
         h4Lo1MiI4PmcHHfzx7Fjo8iawwEm670v+4B2GScDWkelK5TRhPJwMfv0+y8BZysm7qld
         t/e3I1vq0QDjxjRCqq/g5Jb3DClbt8RGqbwAYsZnoMHDxR2Dj9sXhJ4XgrWCZDzQE2ka
         DupCbRd8qzM8RJtV4xof0cCSi2EWILWv7AkBq8RWCrvtooUpJLofhSjBfT8c9fSnwSJQ
         PxYdiBzgjEToeV+k+py2dnomCJsV4xiQn2xW6M6K27MKdvOhs+D4AcICY856COpxSnQE
         d95Q==
X-Forwarded-Encrypted: i=1; AJvYcCUeAju8mGeiJ+2nU+x/KtvDJ+5VXR8bCXYqycdsyzgOZ2rv5pBuPIBZ7XYnIkDGXzsZFqaGxbBHiJfILuq2PqqvBfpoyV5E
X-Gm-Message-State: AOJu0YyD//bP+QOlFKlz90heQrWjqVgX7E4ffGxIsr3O/WD3MJxU8yGn
	J6OwlXRtT86A2s/R4IWItXUFDpIpYObo23wBcxCXKYRVUK3i/JjS4pdwpQKL+MCwXri7gY1oGqI
	zHLnyNpKvDjbjeDMfPJHml3hhIupnyPyZk740cg==
X-Google-Smtp-Source: AGHT+IGkc0Q0l/mos/5NT0gBK0qJn5r1i2V05XNXtK/wcS38g1Oz3fhqPqidWAK23808M9UnRFIa1KWgPI5kzEPoB9g=
X-Received: by 2002:a25:6b51:0:b0:dc6:bbbc:80e4 with SMTP id
 o17-20020a256b51000000b00dc6bbbc80e4mr2701001ybm.4.1712357037795; Fri, 05 Apr
 2024 15:43:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240405000707.2670063-1-horenchuang@bytedance.com>
 <20240405000707.2670063-3-horenchuang@bytedance.com> <20240405150244.00004b49@Huawei.com>
In-Reply-To: <20240405150244.00004b49@Huawei.com>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Fri, 5 Apr 2024 15:43:47 -0700
Message-ID: <CAKPbEqpGM_nR+LKbsoFTviBZaKUKYqJ3zbJp9EOCJAGvuPy6aQ@mail.gmail.com>
Subject: Re: [PATCH v11 2/2] memory tier: create CPUless memory tiers after
 obtaining HMAT info
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, Gregory Price <gourry.memverge@gmail.com>, 
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

On Fri, Apr 5, 2024 at 7:03=E2=80=AFAM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Fri,  5 Apr 2024 00:07:06 +0000
> "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com> wrote:
>
> > The current implementation treats emulated memory devices, such as
> > CXL1.1 type3 memory, as normal DRAM when they are emulated as normal me=
mory
> > (E820_TYPE_RAM). However, these emulated devices have different
> > characteristics than traditional DRAM, making it important to
> > distinguish them. Thus, we modify the tiered memory initialization proc=
ess
> > to introduce a delay specifically for CPUless NUMA nodes. This delay
> > ensures that the memory tier initialization for these nodes is deferred
> > until HMAT information is obtained during the boot process. Finally,
> > demotion tables are recalculated at the end.
> >
> > * late_initcall(memory_tier_late_init);
> > Some device drivers may have initialized memory tiers between
> > `memory_tier_init()` and `memory_tier_late_init()`, potentially bringin=
g
> > online memory nodes and configuring memory tiers. They should be exclud=
ed
> > in the late init.
> >
> > * Handle cases where there is no HMAT when creating memory tiers
> > There is a scenario where a CPUless node does not provide HMAT informat=
ion.
> > If no HMAT is specified, it falls back to using the default DRAM tier.
> >
> > * Introduce another new lock `default_dram_perf_lock` for adist calcula=
tion
> > In the current implementation, iterating through CPUlist nodes requires
> > holding the `memory_tier_lock`. However, `mt_calc_adistance()` will end=
 up
> > trying to acquire the same lock, leading to a potential deadlock.
> > Therefore, we propose introducing a standalone `default_dram_perf_lock`=
 to
> > protect `default_dram_perf_*`. This approach not only avoids deadlock
> > but also prevents holding a large lock simultaneously.
> >
> > * Upgrade `set_node_memory_tier` to support additional cases, including
> >   default DRAM, late CPUless, and hot-plugged initializations.
> > To cover hot-plugged memory nodes, `mt_calc_adistance()` and
> > `mt_find_alloc_memory_type()` are moved into `set_node_memory_tier()` t=
o
> > handle cases where memtype is not initialized and where HMAT informatio=
n is
> > available.
> >
> > * Introduce `default_memory_types` for those memory types that are not
> >   initialized by device drivers.
> > Because late initialized memory and default DRAM memory need to be mana=
ged,
> > a default memory type is created for storing all memory types that are
> > not initialized by device drivers and as a fallback.
> >
> > Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
> > Signed-off-by: Hao Xiang <hao.xiang@bytedance.com>
> > Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
>
> Hi - one remaining question. Why can't we delay init for all nodes
> to either drivers or your fallback late_initcall code.
> It would be nice to reduce possible code paths.

I try not to change too much of the existing code structure in
this patchset.

To me, postponing/moving all memory tier registrations to
late_initcall() is another possible action item for the next patchset.

After tier_mem(), hmat_init() is called, which requires registering
`default_dram_type` info. This is when `default_dram_type` is needed.
However, it is indeed possible to postpone the latter part,
set_node_memory_tier(), to `late_init(). So, memory_tier_init() can
indeed be split into two parts, and the latter part can be moved to
late_initcall() to be processed together.

Doing this all memory-type drivers have to call late_initcall() to
register a memory tier. I=E2=80=99m not sure how many they are?

What do you guys think?

>
> Jonathan
>
>
> > ---
> >  mm/memory-tiers.c | 94 +++++++++++++++++++++++++++++++++++------------
> >  1 file changed, 70 insertions(+), 24 deletions(-)
> >
> > diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> > index 516b144fd45a..6632102bd5c9 100644
> > --- a/mm/memory-tiers.c
> > +++ b/mm/memory-tiers.c
>
>
>
> > @@ -855,7 +892,8 @@ static int __init memory_tier_init(void)
> >        * For now we can have 4 faster memory tiers with smaller adistan=
ce
> >        * than default DRAM tier.
> >        */
> > -     default_dram_type =3D alloc_memory_type(MEMTIER_ADISTANCE_DRAM);
> > +     default_dram_type =3D mt_find_alloc_memory_type(MEMTIER_ADISTANCE=
_DRAM,
> > +                                                   &default_memory_typ=
es);
> >       if (IS_ERR(default_dram_type))
> >               panic("%s() failed to allocate default DRAM tier\n", __fu=
nc__);
> >
> > @@ -865,6 +903,14 @@ static int __init memory_tier_init(void)
> >        * types assigned.
> >        */
> >       for_each_node_state(node, N_MEMORY) {
> > +             if (!node_state(node, N_CPU))
> > +                     /*
> > +                      * Defer memory tier initialization on
> > +                      * CPUless numa nodes. These will be initialized
> > +                      * after firmware and devices are initialized.
>
> Could the comment also say why we can't defer them all?
>
> (In an odd coincidence we have a similar issue for some CPU hotplug
>  related bring up where review feedback was move all cases later).
>
> > +                      */
> > +                     continue;
> > +
> >               memtier =3D set_node_memory_tier(node);
> >               if (IS_ERR(memtier))
> >                       /*
>


--=20
Best regards,
Ho-Ren (Jack) Chuang
=E8=8E=8A=E8=B3=80=E4=BB=BB
