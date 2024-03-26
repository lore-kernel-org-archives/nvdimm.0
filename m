Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E24812DD8C
	for <nvdimm@lists.linux.dev>; Tue, 26 Mar 2024 06:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711434411; cv=none; b=ZzDAGPrO/7w4TE5YbNIM0vVNh4XsqDQm1p/9PJ/HRBaIrHmKgMVg77EVkJCU+OLr06YSYUnlU6LxJk3xnGGyVLOyv7HCzhcJVK7Jj8IUnRNsqh9Bg3bX8AGKRidApWPsJSC2nbrZQEXhKDjsX7FRtbWVLsFRsqjEFwkuzQmbUik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711434411; c=relaxed/simple;
	bh=mI0fEQpmFbkA5lwQq3IVBvzYKtUf5Its1jGXpeWQgi0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SNFcmOelhyNfu7sUN3KmglsfPAzT6yxr3fiqseAtI1D0v6LMJdIsmQua/KQ4soPsMTwZ4CKPLUwv60c4hyuuRu+cqZLNVAC2wWw1f0OUv2zii4szQf9S2w4+/y4k3R5T8+ZsiUflpLgZ/+TqDZz+m5kHBkenHMVY90ZO2sJKC38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=QelV/Yf4; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="QelV/Yf4"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-dcc80d6004bso5061499276.0
        for <nvdimm@lists.linux.dev>; Mon, 25 Mar 2024 23:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1711434408; x=1712039208; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OrDj/ohWqSayAYgN1y4y/00hTnt9coGJh8fl1WRQsk8=;
        b=QelV/Yf4YjT5ChWgMjEKQWa5cMRsrY0RtMcvr/1i4QetiyUx5AKBDaj3K58nmq2Ia5
         OStSkjoVjzIHD+oCGdAuRxFhHBzkhhNczMpr0ACEOokH0nCUpsASBF2t4C+uEEbr4hMS
         Kwq7KdBFL8gif+9biJjcLRAAjzsaXZfF/K4cNcahyKDj9HNUUM8GMCY4PZSRwMpU13Lo
         NU7i0W2zCH9y3ZG62EFoof6ujh/9t45ApS6hpOGJFU9ieiWOOaEn1kpt6+7wwp/rIyoW
         /EGlX2CmgK2zVVp0Pv1QVJ6cuLgOZcrjU3smkjWfGE1nxHcCLkQWmvM5Xz/70qBuuBvF
         Cz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711434408; x=1712039208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OrDj/ohWqSayAYgN1y4y/00hTnt9coGJh8fl1WRQsk8=;
        b=a3qcV6JctW+DPtiliihwCskUViWzHMoMHjtIJBJ3aS9N/KJwIHWuPMe8w0zzoKx/Nw
         9mpW+tbXK/WR1gm/t3PNrcmNmR01an+SzgB87Nzj1jQ+6CfMJ2CikkrrhefZdhA5tyR4
         CU4FDXo+bBpptmGqrviJYXSsnTJGQADrOmgKCHpkKtFLnH2cS7Cxzl90nnvEowa5a/fy
         yleNcDWiFQ4+R7a5gXJA2HIfV8Ff45XlDKbUYWiBqYS3sYzrzuTLLDrvdrtglKJ2fkr+
         s1QFlvEQK//DyKxx3j6SVlPENPLLAzF+SB8yFbEhLFEp9AL8/giyV/lbautHT4yn5Cd5
         3uGA==
X-Forwarded-Encrypted: i=1; AJvYcCVBN9HbQpAvEo9VA/S8xc6ECalXFpWnY1uTwBKiMg/71L8yUHl3ZEBFOwfbCddc+eWk71tNvKMxLzjLFwc95j5cX44TQH/Q
X-Gm-Message-State: AOJu0YzdEJD36lb52m/F2HV6QA6bg0AhPCKNhWiRcUbBrthCWz+hcqdi
	EBrEP7dWNELGzTL4ZWAJyiDK/7PyWZ5OhYQGfrY2QosZ6IEr/oLJ+qUiLOjaKSO8NvTDpRLSQSB
	aHZMwZZ+lu10UCIf/FrgX4WHjJO2hkiSqvBHJ1Q==
X-Google-Smtp-Source: AGHT+IFqYJubvpJrV33NsKYE5RdyKpfAzoF/y4eVN226q4jsK0CwHN6aACNahCgxSadd6QR1OxZuc4Vlo+dxRXUA7L4=
X-Received: by 2002:a5b:20b:0:b0:dcc:744d:b486 with SMTP id
 z11-20020a5b020b000000b00dcc744db486mr7439625ybl.39.1711434408216; Mon, 25
 Mar 2024 23:26:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240322070356.315922-1-horenchuang@bytedance.com>
 <20240322070356.315922-3-horenchuang@bytedance.com> <87cyrmr773.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <CAKPbEqptUKhDdH0ke7PuFShTBFm-Y=NWDtMOWCXBQBe-mac88w@mail.gmail.com> <87ttktofoa.fsf@yhuang6-desk2.ccr.corp.intel.com>
In-Reply-To: <87ttktofoa.fsf@yhuang6-desk2.ccr.corp.intel.com>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Mon, 25 Mar 2024 23:26:37 -0700
Message-ID: <CAKPbEqqT+OPNtRzv4HK-O_cd8PWuhg6xRAtj4H9=A69HJob6Lg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v4 2/2] memory tier: create CPUless memory
 tiers after obtaining HMAT info
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Gregory Price <gourry.memverge@gmail.com>, aneesh.kumar@linux.ibm.com, mhocko@suse.com, 
	tj@kernel.org, john@jagalactic.com, Eishan Mirakhur <emirakhur@micron.com>, 
	Vinicius Tavares Petrucci <vtavarespetr@micron.com>, Ravis OpenSrc <Ravis.OpenSrc@micron.com>, 
	Alistair Popple <apopple@nvidia.com>, Srinivasulu Thanneeru <sthanneeru@micron.com>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	"Ho-Ren (Jack) Chuang" <horenc@vt.edu>, "Ho-Ren (Jack) Chuang" <horenchuang@gmail.com>, qemu-devel@nongnu.org, 
	Hao Xiang <hao.xiang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2024 at 8:08=E2=80=AFPM Huang, Ying <ying.huang@intel.com> =
wrote:
>
> "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com> writes:
>
> > On Fri, Mar 22, 2024 at 1:41=E2=80=AFAM Huang, Ying <ying.huang@intel.c=
om> wrote:
> >>
> >> "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com> writes:
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
> >> > ---
> >> >  mm/memory-tiers.c | 73 ++++++++++++++++++++++++++++++++++++++++----=
---
> >> >  1 file changed, 63 insertions(+), 10 deletions(-)
> >> >
> >> > diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> >> > index 974af10cfdd8..9396330fa162 100644
> >> > --- a/mm/memory-tiers.c
> >> > +++ b/mm/memory-tiers.c
> >> > @@ -36,6 +36,11 @@ struct node_memory_type_map {
> >> >
> >> >  static DEFINE_MUTEX(memory_tier_lock);
> >> >  static LIST_HEAD(memory_tiers);
> >> > +/*
> >> > + * The list is used to store all memory types that are not created
> >> > + * by a device driver.
> >> > + */
> >> > +static LIST_HEAD(default_memory_types);
> >> >  static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
> >> >  struct memory_dev_type *default_dram_type;
> >> >
> >> > @@ -108,6 +113,7 @@ static struct demotion_nodes *node_demotion __re=
ad_mostly;
> >> >
> >> >  static BLOCKING_NOTIFIER_HEAD(mt_adistance_algorithms);
> >> >
> >> > +static DEFINE_MUTEX(default_dram_perf_lock);
> >>
> >> Better to add comments about what is protected by this lock.
> >>
> >
> > Thank you. I will add a comment like this:
> > + /* The lock is used to protect `default_dram_perf*` info and nid. */
> > +static DEFINE_MUTEX(default_dram_perf_lock);
> >
> > I also found an error path was not handled and
> > found the lock could be put closer to what it protects.
> > I will have them fixed in V5.
> >
> >> >  static bool default_dram_perf_error;
> >> >  static struct access_coordinate default_dram_perf;
> >> >  static int default_dram_perf_ref_nid =3D NUMA_NO_NODE;
> >> > @@ -505,7 +511,8 @@ static inline void __init_node_memory_type(int n=
ode, struct memory_dev_type *mem
> >> >  static struct memory_tier *set_node_memory_tier(int node)
> >> >  {
> >> >       struct memory_tier *memtier;
> >> > -     struct memory_dev_type *memtype;
> >> > +     struct memory_dev_type *mtype;
> >>
> >> mtype may be referenced without initialization now below.
> >>
> >
> > Good catch! Thank you.
> >
> > Please check below.
> > I may found a potential NULL pointer dereference.
> >
> >> > +     int adist =3D MEMTIER_ADISTANCE_DRAM;
> >> >       pg_data_t *pgdat =3D NODE_DATA(node);
> >> >
> >> >
> >> > @@ -514,11 +521,20 @@ static struct memory_tier *set_node_memory_tie=
r(int node)
> >> >       if (!node_state(node, N_MEMORY))
> >> >               return ERR_PTR(-EINVAL);
> >> >
> >> > -     __init_node_memory_type(node, default_dram_type);
> >> > +     mt_calc_adistance(node, &adist);
> >> > +     if (node_memory_types[node].memtype =3D=3D NULL) {
> >> > +             mtype =3D mt_find_alloc_memory_type(adist, &default_me=
mory_types);
> >> > +             if (IS_ERR(mtype)) {
> >> > +                     mtype =3D default_dram_type;
> >> > +                     pr_info("Failed to allocate a memory type. Fal=
l back.\n");
> >> > +             }
> >> > +     }
> >> >
> >> > -     memtype =3D node_memory_types[node].memtype;
> >> > -     node_set(node, memtype->nodes);
> >> > -     memtier =3D find_create_memory_tier(memtype);
> >> > +     __init_node_memory_type(node, mtype);
> >> > +
> >> > +     mtype =3D node_memory_types[node].memtype;
> >> > +     node_set(node, mtype->nodes);
> >
> > If the `mtype` could be NULL, would there be a potential
> > NULL pointer dereference. Do you have a preferred idea
> > to fix this if needed?
>
> Initialize mtype with default_dram_type?
>

Sounds like a plan. Thank you. I'm working on V5.

>
> >> > +     memtier =3D find_create_memory_tier(mtype);
> >> >       if (!IS_ERR(memtier))
> >> >               rcu_assign_pointer(pgdat->memtier, memtier);
> >> >       return memtier;
> >> > @@ -655,6 +671,34 @@ void mt_put_memory_types(struct list_head *memo=
ry_types)
> >> >  }
> >> >  EXPORT_SYMBOL_GPL(mt_put_memory_types);
> >> >
>
> [snip]
>
> --
> Best Regards,
> Huang, Ying



--=20
Best regards,
Ho-Ren (Jack) Chuang
=E8=8E=8A=E8=B3=80=E4=BB=BB
