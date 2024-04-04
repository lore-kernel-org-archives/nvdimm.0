Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ABA63A5
	for <nvdimm@lists.linux.dev>; Thu,  4 Apr 2024 00:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712190095; cv=none; b=G7tchhQgMQ9LZHxAQLMCCsS6vwh8cROx9KK3Ng+WTMxZ7AFVasBhgjd503eWk5dtqn6xzev+wCOpTbxi0qFynOz9eGzyY6G2MbCncaGhYnwXdDBBO2/uxXhLuwgWVhFiCHaHHkBpjjWHibn2d5vLVR3FCJrnUpxl+Ogh+P/JhnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712190095; c=relaxed/simple;
	bh=dOPbi2CUnvmLWksVT5BRSkZCsZq4DeT3G+zormngmU0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H+DGwNRmykNlIXEd8PFDT1oKT+st4pHuga2iiXc5lmt0+bpBAP++8JiJtqIX/uv7A02DS7CoKKvwe2bMib1fE/dansV4cBcF5cjhrikyvOz6ZWtFuwQV+IaNvT00MeQL3FWk0EC9qKAKeo9U1mNk2TCkCdEZCsRaRLpslwE9On0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=MbhKt6n7; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="MbhKt6n7"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-dc25e12cc63so1435199276.0
        for <nvdimm@lists.linux.dev>; Wed, 03 Apr 2024 17:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1712190092; x=1712794892; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qO60jqsH0RDRW8MepZgYWUNAloZS/uU+ZxX94+OfopY=;
        b=MbhKt6n7DZWI7Tzg9keN/aALhI8nR+vwDXAf9NAgQ9MZ0uj9f7dNNlxJag2qzHAPft
         E3IPy3evGYzQIqhQGhf7lMn5TwvN4gvPLKWwhE2olR/Rpxg02XDLuXieuCFJPtqGf3ms
         Di3u7W+vCVPNKolW1qq0qGcp43MVL1xqs5GxhDo/bC8knu9Yt5kMb44mKCr0kiU57Kqp
         hvK/gTd+0Gfgosz/UHLqsICS4F+pc+eBnoRoC2waEh05Po1qsFzRtHcgzknhH8rPVGBa
         7Uj33xxiSuF/x3Tnvi44upbfPXvP6n1cgOTTqXbB5De7dJ8hFNBO0elbM1gSy21UDvrr
         17KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712190092; x=1712794892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qO60jqsH0RDRW8MepZgYWUNAloZS/uU+ZxX94+OfopY=;
        b=q8ISRvFVIU4HOh1POeJPygcShQ5sgq7ODTR6ofv7Ba+Q9p0WuJyRHYIns4gulMG6pv
         JEAQ0Z29ezvWGg5UBISS9EBab/AwaLPfkhj6ZEzitfEX1JPmNsAUfs/i5k33T5gROel1
         ySpzT/ofDRXBXAuZaeLuZsS8bPeKB0471mIiROL6A9Csl1h9lyuo6bKz8XYWag52zdiW
         yWP1rmLkJ6ciCQCb0gTeXsNh96KTMNmzwOQmwp54fuDRVMxHaChb0Zp85fuXJ02+PQIC
         anTiUCxRcKy2ZsepDVwTkTXvh7mIsEagTQEv1AqurJn4sHgTbzi3mUS53pB4tLFw9znx
         Lcxw==
X-Forwarded-Encrypted: i=1; AJvYcCUxQFD4I/bw6XAjTCEErcNadBa0iPAcbIdyLGMM8n3llHm5aR5y3VBUHjtE1g9177TEWyXtsJVXfRNrDheDHPDHkqg6vhre
X-Gm-Message-State: AOJu0YxtMA4P5/qCQ1dxBUb/tss2NyeIQzVykQqpqq7N7oNFUQMQPi2l
	oqEOYDqdVhHeAvOybMjJ/x7Z+GO51hT9VZF7MVOMKb8Xu0OWn/HG8bx72fPukTfvFo5USOtoerG
	Tm81rEOT63dTkIr3zlID0M9v+ncA6WBHvrVzK2Q==
X-Google-Smtp-Source: AGHT+IHSYTr5M+525vcAEY5Aj2ib0qO6jpryNktw+PRCGQjz5qKA3WKMPc+zBf2F+1T8pwG+v1Tqmm74FhKD/Wr0Snw=
X-Received: by 2002:a05:6902:1029:b0:dc7:46fd:4998 with SMTP id
 x9-20020a056902102900b00dc746fd4998mr1050153ybt.13.1712190092377; Wed, 03 Apr
 2024 17:21:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240402001739.2521623-1-horenchuang@bytedance.com>
 <20240402001739.2521623-3-horenchuang@bytedance.com> <20240403180425.00003be0@Huawei.com>
In-Reply-To: <20240403180425.00003be0@Huawei.com>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Wed, 3 Apr 2024 17:21:21 -0700
Message-ID: <CAKPbEqoJZe+HWHhCvBTVSHXffGY2ign3Htp4pfbFb4YVJS_Q2A@mail.gmail.com>
Subject: Re: [PATCH v10 2/2] memory tier: create CPUless memory tiers after
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

Hi Jonathan,

Thank you for your feedback. I will fix them (inlined) in the next V11.

On Wed, Apr 3, 2024 at 10:04=E2=80=AFAM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> A few minor comments inline.
>
> > diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.=
h
> > index a44c03c2ba3a..16769552a338 100644
> > --- a/include/linux/memory-tiers.h
> > +++ b/include/linux/memory-tiers.h
> > @@ -140,12 +140,13 @@ static inline int mt_perf_to_adistance(struct acc=
ess_coordinate *perf, int *adis
> >       return -EIO;
> >  }
> >
> > -struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct li=
st_head *memory_types)
> > +static inline struct memory_dev_type *mt_find_alloc_memory_type(int ad=
ist,
> > +                                     struct list_head *memory_types)
> >  {
> >       return NULL;
> >  }
> >
> > -void mt_put_memory_types(struct list_head *memory_types)
> > +static inline void mt_put_memory_types(struct list_head *memory_types)
> >  {
> Why in this patch and not previous one?

I've also noticed this issue. I will fix it in the next V11.

> >
> >  }
> > diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> > index 974af10cfdd8..44fa10980d37 100644
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
>
> Does the rename add anything major to the patch?
> If not I'd leave it alone to reduce the churn and give
> a more readable patch.  If it is worth doing perhaps
> a precursor patch?
>

Either name works. Keeping it the same name will make the code
easier to follow. I agree! Thanks.

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
> > @@ -655,6 +672,33 @@ void mt_put_memory_types(struct list_head *memory_=
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
> > +             if (node_memory_types[nid].memtype =3D=3D NULL)
> > +                     /*
> > +                      * Some device drivers may have initialized memor=
y tiers
> > +                      * between `memory_tier_init()` and `memory_tier_=
late_init()`,
> > +                      * potentially bringing online memory nodes and
> > +                      * configuring memory tiers. Exclude them here.
> > +                      */
>
> Does the comment refer to this path, or to ones where memtype is set?
>

Yes, the comment is for explaining why the if condition is used.

> > +                     set_node_memory_tier(nid);
>
> Given the large comment I would add {} to help with readability.
> You could flip the logic to reduce indent
>         for_each_node_state(nid, N_MEMORY) {
>                 if (node_memory_types[nid].memtype)
>                         continue;
>                 /*
>                  * Some device drivers may have initialized memory tiers
>                  * between `memory_tier_init()` and `memory_tier_late_ini=
t()`,
>                  * potentially bringing online memory nodes and
>                  * configuring memory tiers. Exclude them here.
>                  */
>                 set_node_memory_tier(nid);
>
>

I will change it accordingly.

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
> > @@ -668,7 +712,7 @@ int mt_set_default_dram_perf(int nid, struct access=
_coordinate *perf,
> >  {
> >       int rc =3D 0;
> >
> > -     mutex_lock(&memory_tier_lock);
> > +     mutex_lock(&default_dram_perf_lock);
>
> As below, this is a classic case where guard() will help readability.
>

I will change it accordingly.

> >       if (default_dram_perf_error) {
> >               rc =3D -EIO;
> >               goto out;
> > @@ -716,23 +760,30 @@ int mt_set_default_dram_perf(int nid, struct acce=
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
>
> Looks like rc is set in all paths that reach where it issued.
>

Using guard(mutex), I will no longer need `int rc`.
Replace `rc =3D` with `return XXX`.

> >
> > -     if (default_dram_perf_ref_nid =3D=3D NUMA_NO_NODE)
> > -             return -ENOENT;
> > +     mutex_lock(&default_dram_perf_lock);
>
> This would benefit quite a lot from
> guard(mutex)(&default_dram_perf_lock);
> and direct returns throughout.
>

Got it. I will change it accordingly.

>
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
> > @@ -745,9 +796,10 @@ int mt_perf_to_adistance(struct access_coordinate =
*perf, int *adist)
> >               (default_dram_perf.read_latency + default_dram_perf.write=
_latency) *
> >               (default_dram_perf.read_bandwidth + default_dram_perf.wri=
te_bandwidth) /
> >               (perf->read_bandwidth + perf->write_bandwidth);
> > -     mutex_unlock(&memory_tier_lock);
> >
> > -     return 0;
> > +out:
> > +     mutex_unlock(&default_dram_perf_lock);
> > +     return rc;
> >  }
> >  EXPORT_SYMBOL_GPL(mt_perf_to_adistance);
> >
> > @@ -858,7 +910,8 @@ static int __init memory_tier_init(void)
> >        * For now we can have 4 faster memory tiers with smaller adistan=
ce
> >        * than default DRAM tier.
> >        */
> > -     default_dram_type =3D alloc_memory_type(MEMTIER_ADISTANCE_DRAM);
> > +     default_dram_type =3D mt_find_alloc_memory_type(MEMTIER_ADISTANCE=
_DRAM,
> > +                                                                     &=
default_memory_types);
>
> Unusual indenting.  Align with just after (
>

Aligning with "(" will exceed 100 columns. Would that be acceptable?

> >       if (IS_ERR(default_dram_type))
> >               panic("%s() failed to allocate default DRAM tier\n", __fu=
nc__);
> >
> > @@ -868,6 +921,14 @@ static int __init memory_tier_init(void)
> >        * types assigned.
> >        */
> >       for_each_node_state(node, N_MEMORY) {
> > +             if (!node_state(node, N_CPU))
> > +                     /*
> > +                      * Defer memory tier initialization on CPUless nu=
ma nodes.
> > +                      * These will be initialized after firmware and d=
evices are
>
> I think this wraps at just over 80 chars.  Seems silly to wrap so tightly=
 and not
> quite fit under 80. (this is about 83 chars.
>

I can fix this.
I have a question. From my patch, this is <80 chars. However,
in an email, this is >80 chars. Does that mean we need to
count the number of chars in an email, not in a patch? Or if I
missed something? like vim configuration or?

> > +                      * initialized.
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
