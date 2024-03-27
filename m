Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9701DA22
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 06:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711522522; cv=none; b=c7UfChwca2ESzLflgMU76EtTtVF01j+HqoCf+dD+/lfUhIdXbj0obHVGdOuu+IaA6t4LIxSbLMbXW+eFSWmHOxgxOw/nBA4b5HTRL9vCyHfIMcoiHUKJNaZPImnyQ5xZ70bmwT+ZCZM9ck9A4BZD0u/1cCKu+uuWbTSAbhO3zQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711522522; c=relaxed/simple;
	bh=pou+ytS5UXL8DGmx9JFrYDp3iLEuHsSbSXo7hwooVB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UdSCyjynSCgNua+oErg/NoM8vkNL78T0/fgYU0Vzti34bOc3hSl0oATn6+7o16hfsDEVl+dCHMjKsHZdp/1aTA0LZDFaVjUrU87hEZYWjceyEcEI2YDk13FX/h0D+mHwpbouB4RbLwCHbY//Xp1A9JkfL/9VLOf2j33+8LjqEN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=J/vLbquD; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="J/vLbquD"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-611450d7f95so30360057b3.2
        for <nvdimm@lists.linux.dev>; Tue, 26 Mar 2024 23:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1711522519; x=1712127319; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gBdAxMvMnjsczXEA3QG1dVLh7HlPI7SpPCL+teq1rw=;
        b=J/vLbquD1vJRTW2XU1QCzpIK++XZaJpybgCcrUkq7h2y7Wfu8J6wswrY+H2jehsmZ/
         U544QLIh2F87X3geAtcgGRrmFGbF9gxbB8ZIubBVXKCjSOkKf9ONXA5OwED001AqL1y3
         M/XmCsaLIBe67SDCSeuJvOYh05V9KK8QqoCF5NsMAMIkz9H8EyyS7c5jItp8Ml0anZXM
         b0hR6lpEnNCxoGZ01d92ee7uznORjXI/LvAeaBktMW+69oRF7BnJTn/C8CWbBv941cPi
         fUqokL0E6USi3vvq7sUOkeitsWE3Wk4dON8do0cuDEZlb7ySPRzMlkWiucPafCmDb0bh
         efdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711522519; x=1712127319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2gBdAxMvMnjsczXEA3QG1dVLh7HlPI7SpPCL+teq1rw=;
        b=Nzm61jzWCGxvuTshUK51+Htmqgto5rjktWGufIr8SP7IUuLYI5tAys/CVa1MukiWWa
         JaGEZLSZMkRCwd34tIYxWR703vJetMwyckxI5d1MwxkUP6cvX7yDb9eM7txqeJIdy9XB
         BSzNoGlaAnQXnMABoFqNp0gD2y1zqHVcMBGpQSgwHoFSYmUpidH8CQBDug5Q0bCpVaIc
         ZWeOhaptm460UVDJcTak6WkF8SeXSxLlYZg+01vuOndTGyYODN0Fq00Dj4iwtG9XuMzZ
         QkHP144UjMM7211Thki3IDP+e3ES3kcFu3phhEcJ1c8gMaKykHF1N6GPValwlCOWDMpO
         k3qw==
X-Forwarded-Encrypted: i=1; AJvYcCVysIhLSWbd4ufbMpDQKLJ/BxTmn0GzIBrpFtHis78JOBA49fN0iIEdHc9MnsEmIPcwE6YyW5H7Nbp5RNZ7us1YPQ/BqiZ0
X-Gm-Message-State: AOJu0YzKvIhh70mC1udDQiIrVyeQVMWgDm2TDtM2zHCgu+jcxdCE+fJB
	Ui32y1PYyS+N1WHk5pIhqRtFfPtqdGVZlPf+DxeNflU4WVyOPQRXeB7IdreQNK3CsHhbdQkQMxY
	LCKOddV/sW8pmlDWMobn6gkKD+hf4bkFk72jgkA==
X-Google-Smtp-Source: AGHT+IGneaW9WE/Y0nsKRo0D7anGiHOi7fBK7mx80rP9apScsfFYIjDTSuH8hoPcCeMmppqQ4avESF7WEPInBimAGLE=
X-Received: by 2002:a25:a009:0:b0:dcf:b5b7:c72 with SMTP id
 x9-20020a25a009000000b00dcfb5b70c72mr2835965ybh.0.1711522518886; Tue, 26 Mar
 2024 23:55:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240327041646.3258110-1-horenchuang@bytedance.com>
 <20240327041646.3258110-3-horenchuang@bytedance.com> <874jcsnryv.fsf@yhuang6-desk2.ccr.corp.intel.com>
In-Reply-To: <874jcsnryv.fsf@yhuang6-desk2.ccr.corp.intel.com>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Tue, 26 Mar 2024 23:55:07 -0700
Message-ID: <CAKPbEqpbtkbcH2XoV2g3AFm1HtzOPjkNMa3AyTqWdd5MyvY9pg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v5 2/2] memory tier: create CPUless memory
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

On Tue, Mar 26, 2024 at 10:52=E2=80=AFPM Huang, Ying <ying.huang@intel.com>=
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
> > but also prevents holding a large lock simultaneously. Besides, this pa=
tch
> > slightly shortens the time holding the lock by putting the lock closer =
to
> > what it protects as well.
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
> > * Fix a deadlock bug in `mt_perf_to_adistance`
> > Because an error path was not handled properly in `mt_perf_to_adistance=
`,
> > unlock before returning the error.
> >
> > Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
> > Signed-off-by: Hao Xiang <hao.xiang@bytedance.com>
> > ---
> >  mm/memory-tiers.c | 85 +++++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 72 insertions(+), 13 deletions(-)
> >
> > diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> > index 974af10cfdd8..610db9581ba4 100644
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
> >
> > -     memtype =3D node_memory_types[node].memtype;
> > -     node_set(node, memtype->nodes);
> > -     memtier =3D find_create_memory_tier(memtype);
> > +     __init_node_memory_type(node, mtype);
> > +
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
> > @@ -668,7 +713,6 @@ int mt_set_default_dram_perf(int nid, struct access=
_coordinate *perf,
> >  {
> >       int rc =3D 0;
> >
> > -     mutex_lock(&memory_tier_lock);
> >       if (default_dram_perf_error) {
> >               rc =3D -EIO;
> >               goto out;
> > @@ -680,6 +724,7 @@ int mt_set_default_dram_perf(int nid, struct access=
_coordinate *perf,
> >               goto out;
> >       }
> >
> > +     mutex_lock(&default_dram_perf_lock);
>
> Why do you move the position of locking?  mutex_lock/unlock() will be
> unbalance for error path above.
>

Because you've mentioned below that moving the lock to the
beginning of the function will make the code easier to understand,
I will move the lock to the beginning of the function.

Perhaps the explanation may no longer be relevant; because reading
`default_dram_perf_error` and `perf->*` do not require
holding `default_dram_perf_lock`, but I forgot to replace
"rc =3D -EXXX ; goto out;" with return -EXXX.

> >       if (default_dram_perf_ref_nid =3D=3D NUMA_NO_NODE) {
> >               default_dram_perf =3D *perf;
> >               default_dram_perf_ref_nid =3D nid;
> > @@ -716,23 +761,26 @@ int mt_set_default_dram_perf(int nid, struct acce=
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
> > +     int rc =3D 0;
> > +
> >       if (default_dram_perf_error)
> >               return -EIO;
> >
> > -     if (default_dram_perf_ref_nid =3D=3D NUMA_NO_NODE)
> > -             return -ENOENT;
> > -
> >       if (perf->read_latency + perf->write_latency =3D=3D 0 ||
> >           perf->read_bandwidth + perf->write_bandwidth =3D=3D 0)
> >               return -EINVAL;
> >
> > -     mutex_lock(&memory_tier_lock);
> > +     mutex_lock(&default_dram_perf_lock);
>
> It may be a little better to move lock position at the begin of the
> function.  This will not avoid race condition (not harmful in practice)
> but it will make code easier to be understood.
>

No problem. I will move the lock to the beginning of the function and
take care of all error paths.

> > +     if (default_dram_perf_ref_nid =3D=3D NUMA_NO_NODE) {
> > +             rc =3D -ENOENT;
> > +             goto out;
> > +     }
> >       /*
> >        * The abstract distance of a memory node is in direct proportion=
 to
> >        * its memory latency (read + write) and inversely proportional t=
o its
> > @@ -745,8 +793,10 @@ int mt_perf_to_adistance(struct access_coordinate =
*perf, int *adist)
> >               (default_dram_perf.read_latency + default_dram_perf.write=
_latency) *
> >               (default_dram_perf.read_bandwidth + default_dram_perf.wri=
te_bandwidth) /
> >               (perf->read_bandwidth + perf->write_bandwidth);
> > -     mutex_unlock(&memory_tier_lock);
> > +     mutex_unlock(&default_dram_perf_lock);
> >
> > +out:
> > +     mutex_unlock(&default_dram_perf_lock);
> >       return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(mt_perf_to_adistance);
> > @@ -858,7 +908,8 @@ static int __init memory_tier_init(void)
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
> > @@ -868,6 +919,14 @@ static int __init memory_tier_init(void)
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
