Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F382F26
	for <nvdimm@lists.linux.dev>; Fri, 29 Mar 2024 02:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711678722; cv=none; b=FKAGBEoFFuOLGjF7dTkbdZLS6P55FhkhW5NBEQJaiG9bXN5NYcp1MZ5NIbpoGWoJy3Yf1ZA9sPW5U2Bk4rXjx/3cKQlGCZI1e+Jx9CI96ODYY0F5gXuKehgQgKp4OuV64sDOVb169hLM4eZPS5tg4X70QuMdumOUIyz/zNpX2DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711678722; c=relaxed/simple;
	bh=ixXvF5fzYYfqG23SeBJ8LQFvVCfKVlJKg2/L7fNBr4g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p9ex3Iez5cqVXQ1Xa55TK1M/bZ5bVeBhUqlgEOTY46WKhXoBCKoqUImcfPMeq+2d5gaWa2VlAQaov/+LB4IKPWm/FD8bcOR8LcQzvYsVCxuTS1aYANrCtTv63KULmc0nPnqxAHXLR8TP1QyazwdARNgzqB9ysBKmftNbyo3KwWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Sd1Fhzbb; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Sd1Fhzbb"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-dbed0710c74so1435675276.1
        for <nvdimm@lists.linux.dev>; Thu, 28 Mar 2024 19:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1711678718; x=1712283518; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zz+IFMsejvdgnBBQBI80K+Iq8dC3px8n5nwWBHE6dsg=;
        b=Sd1FhzbbLqkESBJj7V6rxz84OJNV3uMIG4PnbUX8GNQHYnVxccY7/NNhkTRXB9qbtc
         Eqydi1aF0B64cxYb8twFlblLxKFxLTDIk/HkFrj05c9EV03FXBrF174npgLQj1wdhxkO
         Rba2XC61RG7QCHApDSnfMcNmbvCwquuHJrG5y7qZUyi/ObZVSgjZhYJLAyE1NOT7xTOK
         BT9VwefnJChl6Eay/9uN/vrl97pEQIwFRrBJDUrHw2oUbxHO6Tga7XGcsd06GYobFCBJ
         QZkkk+MNmuHXMz15YVqxbfRJ1GNJJJIrfCAOmhlM9/rdo8sHrK7bIEXWNA1jLdrXDUav
         CBHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711678718; x=1712283518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zz+IFMsejvdgnBBQBI80K+Iq8dC3px8n5nwWBHE6dsg=;
        b=Wa4B7xr4xrgvMc/Sy1sT+6eGst/23vKPvhmhdjr0IYHqer4Bz66pjlkRUDwtprdEJS
         9vyaI3vL9IKlZFGpFhtxkj2VGHPk4KbUahAP7SC5MvFn18fnbN+Mrwdd6FHAE2/b5/NQ
         3tma7296iQs9pf4FR7Snz1z/5uYJHZImMHm5i/64ns9QbBUvkgeS8pKTkEeG1OjsJv/I
         B4V/OOE3qprtcqUZEI1byIUo4Hiw5+CHz7xh91cJPufgxlSOVsOdqWnDcO/9mEnev1hD
         nMFGZhbTI9MPlwNa/6KHofrBkeNICO2ZOReOt98XXxA0jW4RwDT75awKPWqjPdHKT8Xl
         jwvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMMd3Rnj9M81ZgZgRdqamNSxb+Qpg1UC5d+Vq5sUhJJRhFHaPsOyG8E1Hl7TGL1iuJkhYhuopJqJu7/srdmvTwxLIborQ3
X-Gm-Message-State: AOJu0Yy6cXNp1EhkssT6br2kwHmjx8QmS4gmE8Z6sYfpySNcFt+gtnZw
	uccDEpMzntunokCZhETRYPKJDqmRxMrbocML61L5yPS26vKV6dCFFED9Yu93vXcKUc8ysYiVWLc
	CNaD3ZjpvVaYSHc8EsqDgUZrwDXU/Y/GaIovN7g==
X-Google-Smtp-Source: AGHT+IFYd8JxyWXHdbKnZHKq5kFPmf3FoQekqBFXakoWt1h4JqrJKVxHkVVGKjtXmHCUVmo4rQEvndpWqChKb7rs8bk=
X-Received: by 2002:a25:9249:0:b0:dcf:66d4:1766 with SMTP id
 e9-20020a259249000000b00dcf66d41766mr1221293ybo.52.1711678717879; Thu, 28 Mar
 2024 19:18:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240329004815.195476-1-horenchuang@bytedance.com>
 <20240329004815.195476-3-horenchuang@bytedance.com> <87a5mhlus5.fsf@yhuang6-desk2.ccr.corp.intel.com>
In-Reply-To: <87a5mhlus5.fsf@yhuang6-desk2.ccr.corp.intel.com>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Thu, 28 Mar 2024 19:18:27 -0700
Message-ID: <CAKPbEqp_4DnS_mYypFVNm39ApFd8YGWJonA6zbXayNLV+kqcLw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v8 2/2] memory tier: create CPUless memory
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

On Thu, Mar 28, 2024 at 5:59=E2=80=AFPM Huang, Ying <ying.huang@intel.com> =
wrote:
>
> "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com> writes:
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
> > ---
> >  mm/memory-tiers.c | 94 +++++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 78 insertions(+), 16 deletions(-)
> >
> > diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> > index 974af10cfdd8..e24fc3bebae4 100644
> > --- a/mm/memory-tiers.c
> > +++ b/mm/memory-tiers.c
> > @@ -36,6 +36,11 @@ struct node_memory_type_map {
> >
> >  static DEFINE_MUTEX(memory_tier_lock);
> >  static LIST_HEAD(memory_tiers);
> > +/*
> > + * The list is used to store all memory types that are not created
> > + * by a device driver.
> > + */
> > +static LIST_HEAD(default_memory_types);
> >  static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
> >  struct memory_dev_type *default_dram_type;
> >
> > @@ -108,6 +113,8 @@ static struct demotion_nodes *node_demotion __read_=
mostly;
> >
> >  static BLOCKING_NOTIFIER_HEAD(mt_adistance_algorithms);
> >
> > +/* The lock is used to protect `default_dram_perf*` info and nid. */
> > +static DEFINE_MUTEX(default_dram_perf_lock);
> >  static bool default_dram_perf_error;
> >  static struct access_coordinate default_dram_perf;
> >  static int default_dram_perf_ref_nid =3D NUMA_NO_NODE;
> > @@ -505,7 +512,8 @@ static inline void __init_node_memory_type(int node=
, struct memory_dev_type *mem
> >  static struct memory_tier *set_node_memory_tier(int node)
> >  {
> >       struct memory_tier *memtier;
> > -     struct memory_dev_type *memtype;
> > +     struct memory_dev_type *mtype =3D default_dram_type;
> > +     int adist =3D MEMTIER_ADISTANCE_DRAM;
> >       pg_data_t *pgdat =3D NODE_DATA(node);
> >
> >
> > @@ -514,11 +522,20 @@ static struct memory_tier *set_node_memory_tier(i=
nt node)
> >       if (!node_state(node, N_MEMORY))
> >               return ERR_PTR(-EINVAL);
> >
> > -     __init_node_memory_type(node, default_dram_type);
> > +     mt_calc_adistance(node, &adist);
> > +     if (node_memory_types[node].memtype =3D=3D NULL) {
> > +             mtype =3D mt_find_alloc_memory_type(adist, &default_memor=
y_types);
> > +             if (IS_ERR(mtype)) {
> > +                     mtype =3D default_dram_type;
> > +                     pr_info("Failed to allocate a memory type. Fall b=
ack.\n");
> > +             }
> > +     }
> > +
> > +     __init_node_memory_type(node, mtype);
> >
> > -     memtype =3D node_memory_types[node].memtype;
> > -     node_set(node, memtype->nodes);
> > -     memtier =3D find_create_memory_tier(memtype);
> > +     mtype =3D node_memory_types[node].memtype;
> > +     node_set(node, mtype->nodes);
> > +     memtier =3D find_create_memory_tier(mtype);
> >       if (!IS_ERR(memtier))
> >               rcu_assign_pointer(pgdat->memtier, memtier);
> >       return memtier;
> > @@ -655,6 +672,34 @@ void mt_put_memory_types(struct list_head *memory_=
types)
> >  }
> >  EXPORT_SYMBOL_GPL(mt_put_memory_types);
> >
> > +/*
> > + * This is invoked via `late_initcall()` to initialize memory tiers fo=
r
> > + * CPU-less memory nodes after driver initialization, which is
> > + * expected to provide `adistance` algorithms.
> > + */
> > +static int __init memory_tier_late_init(void)
> > +{
> > +     int nid;
> > +
> > +     mutex_lock(&memory_tier_lock);
> > +     for_each_node_state(nid, N_MEMORY)
> > +             if (!node_state(nid, N_CPU) &&
>
> It appears that you didn't notice my comments about this...
>
> https://lore.kernel.org/linux-mm/87v857kujp.fsf@yhuang6-desk2.ccr.corp.in=
tel.com/
>
Oops. I misunderstood your meaning.
I will then replace
-- if (!node_state(nid, N_CPU) &&
--                node_memory_types[nid].memtype =3D=3D NULL)
with
++ if (node_memory_types[nid].memtype =3D=3D NULL)"

> > +                     node_memory_types[nid].memtype =3D=3D NULL)
> > +                     /*
> > +                      * Some device drivers may have initialized memor=
y tiers
> > +                      * between `memory_tier_init()` and `memory_tier_=
late_init()`,
> > +                      * potentially bringing online memory nodes and
> > +                      * configuring memory tiers. Exclude them here.
> > +                      */
> > +                     set_node_memory_tier(nid);
> > +
> > +     establish_demotion_targets();
> > +     mutex_unlock(&memory_tier_lock);
> > +
> > +     return 0;
> > +}
> > +late_initcall(memory_tier_late_init);
> > +
> >  static void dump_hmem_attrs(struct access_coordinate *coord, const cha=
r *prefix)
> >  {
> >       pr_info(
> > @@ -668,7 +713,7 @@ int mt_set_default_dram_perf(int nid, struct access=
_coordinate *perf,
> >  {
> >       int rc =3D 0;
> >
> > -     mutex_lock(&memory_tier_lock);
> > +     mutex_lock(&default_dram_perf_lock);
> >       if (default_dram_perf_error) {
> >               rc =3D -EIO;
> >               goto out;
> > @@ -716,23 +761,30 @@ int mt_set_default_dram_perf(int nid, struct acce=
ss_coordinate *perf,
> >       }
> >
> >  out:
> > -     mutex_unlock(&memory_tier_lock);
> > +     mutex_unlock(&default_dram_perf_lock);
> >       return rc;
> >  }
> >
> >  int mt_perf_to_adistance(struct access_coordinate *perf, int *adist)
> >  {
> > -     if (default_dram_perf_error)
> > -             return -EIO;
> > +     int rc =3D 0;
> >
> > -     if (default_dram_perf_ref_nid =3D=3D NUMA_NO_NODE)
> > -             return -ENOENT;
> > +     mutex_lock(&default_dram_perf_lock);
> > +     if (default_dram_perf_error) {
> > +             rc =3D -EIO;
> > +             goto out;
> > +     }
> >
> >       if (perf->read_latency + perf->write_latency =3D=3D 0 ||
> > -         perf->read_bandwidth + perf->write_bandwidth =3D=3D 0)
> > -             return -EINVAL;
> > +         perf->read_bandwidth + perf->write_bandwidth =3D=3D 0) {
> > +             rc =3D -EINVAL;
> > +             goto out;
> > +     }
> >
> > -     mutex_lock(&memory_tier_lock);
> > +     if (default_dram_perf_ref_nid =3D=3D NUMA_NO_NODE) {
> > +             rc =3D -ENOENT;
> > +             goto out;
> > +     }
> >       /*
> >        * The abstract distance of a memory node is in direct proportion=
 to
> >        * its memory latency (read + write) and inversely proportional t=
o its
> > @@ -745,8 +797,9 @@ int mt_perf_to_adistance(struct access_coordinate *=
perf, int *adist)
> >               (default_dram_perf.read_latency + default_dram_perf.write=
_latency) *
> >               (default_dram_perf.read_bandwidth + default_dram_perf.wri=
te_bandwidth) /
> >               (perf->read_bandwidth + perf->write_bandwidth);
> > -     mutex_unlock(&memory_tier_lock);
> >
> > +out:
> > +     mutex_unlock(&default_dram_perf_lock);
> >       return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(mt_perf_to_adistance);
> > @@ -858,7 +911,8 @@ static int __init memory_tier_init(void)
> >        * For now we can have 4 faster memory tiers with smaller adistan=
ce
> >        * than default DRAM tier.
> >        */
> > -     default_dram_type =3D alloc_memory_type(MEMTIER_ADISTANCE_DRAM);
> > +     default_dram_type =3D mt_find_alloc_memory_type(MEMTIER_ADISTANCE=
_DRAM,
> > +                                                                     &=
default_memory_types);
> >       if (IS_ERR(default_dram_type))
> >               panic("%s() failed to allocate default DRAM tier\n", __fu=
nc__);
> >
> > @@ -868,6 +922,14 @@ static int __init memory_tier_init(void)
> >        * types assigned.
> >        */
> >       for_each_node_state(node, N_MEMORY) {
> > +             if (!node_state(node, N_CPU))
> > +                     /*
> > +                      * Defer memory tier initialization on CPUless nu=
ma nodes.
> > +                      * These will be initialized after firmware and d=
evices are
> > +                      * initialized.
> > +                      */
> > +                     continue;
> > +
> >               memtier =3D set_node_memory_tier(node);
> >               if (IS_ERR(memtier))
> >                       /*
>
> --
> Best Regards,
> Huang, Ying



--=20
Best regards,
Ho-Ren (Jack) Chuang
=E8=8E=8A=E8=B3=80=E4=BB=BB
