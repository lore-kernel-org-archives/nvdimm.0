Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB36585C7F
	for <nvdimm@lists.linux.dev>; Wed, 20 Mar 2024 23:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710977295; cv=none; b=A4+stuWag/z8Nqa0R/vsTJV61qKeWjoL7A+DJGqi1ZQdE8ZyPYZMiA7aeVqlvHcfVKe4iNYLHyINzZzuoZjrj6s6/YhtqbOktdAe+215C+MNg+ceqY43nKyksQAgLXyOhCPsltjoRWwD8zBYzA+zscJTnFJh3N2D4Htj5gMnEXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710977295; c=relaxed/simple;
	bh=o1ryTSbHjTUNVk4pPbnjBHP+u+zATsLW0SPWxgM66LM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CMXcLOtSgRwaWXLGWnzcPttZELop6qz9sJ2+iC09ITKXE6+R7lGAjcnOAGoPRMbO+vNAnMkZV1BqwumzLToKCRz4mN985UHxHnXwGfEa/wmP9Ni2bMCwrTdVU78fwK5AJoya1o9I67kEEbYJN4SkqKdQAXJcppJAGy8GGz92MSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=XCSWyVZW; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="XCSWyVZW"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-dcbcea9c261so363594276.3
        for <nvdimm@lists.linux.dev>; Wed, 20 Mar 2024 16:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1710977291; x=1711582091; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zJzBq5JYuB2XAGJ0KALCMa2K2ac89AEZaVfd/fyT9P0=;
        b=XCSWyVZWMX6avMYafUjFgd0jOWqGD++saC7KTVjidWkZWyr5BWrE5zfNqGAiEHDqaw
         OC3oBynai6tYoqkYab2qAFfbYLGjMKjzdmDHjy5i8hhpu8T2kQqFv7iY+nXDkZw2P5JG
         BPKIDuHb5ejltVC2sgu/zq+YPUOBcnQ2zNZsfOdGMS1nIuWrg+kanvEe/i//1B4Zsosm
         DlYUlvfm6zXOCC4smVkhKdZPIJqG0BcQAy0ldRvxrAYTCPdpkXRqqTXuEHDQiMIXpcfV
         +UsLSry9r+C4E7iKxoHS0MqWHD/3PMs/Wyy2GydWUmSAVA5s5vpfAH8xQwYzaYYtIMDr
         dXiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710977291; x=1711582091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zJzBq5JYuB2XAGJ0KALCMa2K2ac89AEZaVfd/fyT9P0=;
        b=RsxFA5w6UNeEv2HkpV0Ba+gbKDyQXRLGJ5S2Lq+11kVBjzJ0rE6dni3k3f0RP9bQBC
         8RhzJjC1KQ+WjLCmlP8Xh8Tmlq3DtFhz+zJk9wGouTPW8yeYmm65Z3KwDm+j8a3J4mi8
         rPflv9Pq5GLvo7jrcKTfvH/jCSEw/+IjdrWKK70j+3q+ee4NLALnRY/kBOTGbxHAhLbD
         IbPPhBlltsrQd16QpVjVliIoBZ1CjWS6roTQvGCpvUTk6vBslSx3YLAN9xCHS2WC/OYi
         O7F0vQpwUNA5s8sOtXSncFiOQk4olm0BKu/BDEdHwAIDm7OUCDr7dwy86gtzxicQapzR
         KuCw==
X-Forwarded-Encrypted: i=1; AJvYcCWw9deMAe44Kgc+8PoBir3pz6o7E/r38uSpt5eb9ifcO6GU6TohrzxqHVdRKEGCEYOcZFAOIaXO6ITO2C4AvUOtDk1lxG2B
X-Gm-Message-State: AOJu0YwSkS26+h/CNIngwk1oZKV2GbGGnEvWDFQmEv3hLeokw+MCr3IL
	o5qwIbYmosPqP8w3UP8WAZHoAi3d9sCu2rsRQC67UQxnXwF9kwQsblVnSE2990VmMj2ci6i5vHl
	HZaTcq05Z+krX0XwsY6gecVNqjp5rH9/QV8Sc2g==
X-Google-Smtp-Source: AGHT+IFGJliSrDOUQ4ErqYoYgEzAjB2StnHNHTXjgXve2MnBnRyAPXbxRVaPnc6fOZEVfVxO8SzIJ0MjV2hraKOtNuk=
X-Received: by 2002:a25:fe03:0:b0:dd1:517b:571d with SMTP id
 k3-20020a25fe03000000b00dd1517b571dmr314816ybe.16.1710977290644; Wed, 20 Mar
 2024 16:28:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240320061041.3246828-1-horenchuang@bytedance.com>
 <20240320061041.3246828-2-horenchuang@bytedance.com> <87edc5s7ea.fsf@yhuang6-desk2.ccr.corp.intel.com>
In-Reply-To: <87edc5s7ea.fsf@yhuang6-desk2.ccr.corp.intel.com>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Wed, 20 Mar 2024 16:27:59 -0700
Message-ID: <CAKPbEqrfdJwHCuc9yvSBXa2jR-KwXwaa-dFD6iMmXT_OiweYmg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v3 1/2] memory tier: dax/kmem: create
 CPUless memory tiers after obtaining HMAT info
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

On Wed, Mar 20, 2024 at 12:15=E2=80=AFAM Huang, Ying <ying.huang@intel.com>=
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
> > More details:
>
> You have done several stuff in one patch.  So you need "more details".
> You may separate them into multiple patches.  One for echo "*" below.
> But I have no strong opinion on that.
>
> > * late_initcall(memory_tier_late_init);
> > Some device drivers may have initialized memory tiers between
> > `memory_tier_init()` and `memory_tier_late_init()`, potentially bringin=
g
> > online memory nodes and configuring memory tiers. They should be exclud=
ed
> > in the late init.
> >
> > * Abstract common functions into `mt_find_alloc_memory_type()`
> > Since different memory devices require finding or allocating a memory t=
ype,
> > these common steps are abstracted into a single function,
> > `mt_find_alloc_memory_type()`, enhancing code scalability and concisene=
ss.
> >
> > * Handle cases where there is no HMAT when creating memory tiers
> > There is a scenario where a CPUless node does not provide HMAT informat=
ion.
> > If no HMAT is specified, it falls back to using the default DRAM tier.
> >
> > * Change adist calculation code to use another new lock, `mt_perf_lock`=
.
> > In the current implementation, iterating through CPUlist nodes requires
> > holding the `memory_tier_lock`. However, `mt_calc_adistance()` will end=
 up
> > trying to acquire the same lock, leading to a potential deadlock.
> > Therefore, we propose introducing a standalone `mt_perf_lock` to protec=
t
> > `default_dram_perf`. This approach not only avoids deadlock but also
> > prevents holding a large lock simultaneously.
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
> > ---
> >  drivers/dax/kmem.c           | 13 +----
> >  include/linux/memory-tiers.h |  7 +++
> >  mm/memory-tiers.c            | 94 +++++++++++++++++++++++++++++++++---
> >  3 files changed, 95 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> > index 42ee360cf4e3..de1333aa7b3e 100644
> > --- a/drivers/dax/kmem.c
> > +++ b/drivers/dax/kmem.c
> > @@ -55,21 +55,10 @@ static LIST_HEAD(kmem_memory_types);
> >
> >  static struct memory_dev_type *kmem_find_alloc_memory_type(int adist)
> >  {
> > -     bool found =3D false;
> >       struct memory_dev_type *mtype;
> >
> >       mutex_lock(&kmem_memory_type_lock);
> > -     list_for_each_entry(mtype, &kmem_memory_types, list) {
> > -             if (mtype->adistance =3D=3D adist) {
> > -                     found =3D true;
> > -                     break;
> > -             }
> > -     }
> > -     if (!found) {
> > -             mtype =3D alloc_memory_type(adist);
> > -             if (!IS_ERR(mtype))
> > -                     list_add(&mtype->list, &kmem_memory_types);
> > -     }
> > +     mtype =3D mt_find_alloc_memory_type(adist, &kmem_memory_types);
> >       mutex_unlock(&kmem_memory_type_lock);
> >
> >       return mtype;
>
> It seems that there's some miscommunication about my previous comments
> about this.  What I suggested is to create one separate patch, which
> moves mt_find_alloc_memory_type() and mt_put_memory_types() into
> memory-tiers.c.  And make this patch the first one of the series.
>

I will make mt_find_alloc/mt_put_memory_type changes as
a separate patch and the first of my patch series. Thanks.


> > diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.=
h
> > index 69e781900082..b2135334ac18 100644
> > --- a/include/linux/memory-tiers.h
> > +++ b/include/linux/memory-tiers.h
> > @@ -48,6 +48,8 @@ int mt_calc_adistance(int node, int *adist);
> >  int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
> >                            const char *source);
> >  int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
> > +struct memory_dev_type *mt_find_alloc_memory_type(int adist,
> > +                                                     struct list_head =
*memory_types);
> >  #ifdef CONFIG_MIGRATION
> >  int next_demotion_node(int node);
> >  void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
> > @@ -136,5 +138,10 @@ static inline int mt_perf_to_adistance(struct acce=
ss_coordinate *perf, int *adis
> >  {
> >       return -EIO;
> >  }
> > +
> > +struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct li=
st_head *memory_types)
> > +{
> > +     return NULL;
> > +}
> >  #endif       /* CONFIG_NUMA */
> >  #endif  /* _LINUX_MEMORY_TIERS_H */
> > diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> > index 0537664620e5..d9b96b21b65a 100644
> > --- a/mm/memory-tiers.c
> > +++ b/mm/memory-tiers.c
> > @@ -6,6 +6,7 @@
> >  #include <linux/memory.h>
> >  #include <linux/memory-tiers.h>
> >  #include <linux/notifier.h>
> > +#include <linux/acpi.h>
>
> We don't need this anymore.
>

Thanks. I will remove it.

> >  #include "internal.h"
> >
> > @@ -36,6 +37,11 @@ struct node_memory_type_map {
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
> > @@ -505,7 +511,8 @@ static inline void __init_node_memory_type(int node=
, struct memory_dev_type *mem
> >  static struct memory_tier *set_node_memory_tier(int node)
> >  {
> >       struct memory_tier *memtier;
> > -     struct memory_dev_type *memtype;
> > +     struct memory_dev_type *memtype, *mtype =3D NULL;
>
> It seems unnecessary to introduce another variable, just use memtype?
>

Yes, I will consolidate them.


> > +     int adist =3D MEMTIER_ADISTANCE_DRAM;
> >       pg_data_t *pgdat =3D NODE_DATA(node);
> >
> >
> > @@ -514,7 +521,18 @@ static struct memory_tier *set_node_memory_tier(in=
t node)
> >       if (!node_state(node, N_MEMORY))
> >               return ERR_PTR(-EINVAL);
> >
> > -     __init_node_memory_type(node, default_dram_type);
> > +     mt_calc_adistance(node, &adist);
> > +     if (adist !=3D MEMTIER_ADISTANCE_DRAM &&
> > +                     node_memory_types[node].memtype =3D=3D NULL) {
> > +             mtype =3D mt_find_alloc_memory_type(adist, &default_memor=
y_types);
> > +             if (IS_ERR(mtype)) {
> > +                     mtype =3D default_dram_type;
> > +                     pr_info("Failed to allocate a memory type. Fall b=
ack.\n");
> > +             }
> > +     } else
> > +             mtype =3D default_dram_type;
>
> This can be simplified to
>
>         mt_calc_adistance(node, &adist);
>         if (node_memory_types[node].memtype =3D=3D NULL) {
>                 mtype =3D mt_find_alloc_memory_type(adist, &default_memor=
y_types);
>                 if (IS_ERR(mtype)) {
>                         mtype =3D default_dram_type;
>                         pr_info("Failed to allocate a memory type. Fall b=
ack.\n");
>                 }
>         }
>

Sounds good! I will do.


> > +     __init_node_memory_type(node, mtype);
> >
> >       memtype =3D node_memory_types[node].memtype;
> >       node_set(node, memtype->nodes);
> > @@ -623,6 +641,55 @@ void clear_node_memory_type(int node, struct memor=
y_dev_type *memtype)
> >  }
> >  EXPORT_SYMBOL_GPL(clear_node_memory_type);
> >
> > +struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct li=
st_head *memory_types)
> > +{
> > +     bool found =3D false;
> > +     struct memory_dev_type *mtype;
> > +
> > +     list_for_each_entry(mtype, memory_types, list) {
> > +             if (mtype->adistance =3D=3D adist) {
> > +                     found =3D true;
> > +                     break;
> > +             }
> > +     }
> > +     if (!found) {
> > +             mtype =3D alloc_memory_type(adist);
> > +             if (!IS_ERR(mtype))
> > +                     list_add(&mtype->list, memory_types);
> > +     }
> > +
> > +     return mtype;
> > +}
> > +EXPORT_SYMBOL_GPL(mt_find_alloc_memory_type);
> > +
> > +/*
> > + * This is invoked via late_initcall() to create
> > + * CPUless memory tiers after HMAT info is ready or
> > + * when there is no HMAT.
>
> Better to avoid HMAT in general code.  How about something as below?
>
> This is invoked via late_initcall() to initialize memory tiers for
> CPU-less memory nodes after drivers initialization.  Which is
> expect to provide adistance algorithms.
>

Got it. Thanks.
"
This is invoked via `late_initcall()` to initialize memory tiers for
CPU-less memory nodes after driver initialization, which is
expected to provide `adistance` algorithms.
"


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
> > @@ -631,12 +698,16 @@ static void dump_hmem_attrs(struct access_coordin=
ate *coord, const char *prefix)
> >               coord->read_bandwidth, coord->write_bandwidth);
> >  }
> >
> > +/*
> > + * The lock is used to protect the default_dram_perf.
> > + */
> > +static DEFINE_MUTEX(mt_perf_lock);
>
> Miscommunication here too.  Should be moved to near the
> "default_dram_perf" definition.  And it protects not only
> default_dram_perf.
>

I will move it closer to default_dram_perf*.
And change it to:
+/*
+ * The lock is used to protect default_dram_perf*.
+ */


> >  int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
> >                            const char *source)
> >  {
> >       int rc =3D 0;
> >
> > -     mutex_lock(&memory_tier_lock);
> > +     mutex_lock(&mt_perf_lock);
> >       if (default_dram_perf_error) {
> >               rc =3D -EIO;
> >               goto out;
> > @@ -684,7 +755,7 @@ int mt_set_default_dram_perf(int nid, struct access=
_coordinate *perf,
> >       }
> >
> >  out:
> > -     mutex_unlock(&memory_tier_lock);
> > +     mutex_unlock(&mt_perf_lock);
> >       return rc;
> >  }
> >
> > @@ -700,7 +771,7 @@ int mt_perf_to_adistance(struct access_coordinate *=
perf, int *adist)
> >           perf->read_bandwidth + perf->write_bandwidth =3D=3D 0)
> >               return -EINVAL;
> >
> > -     mutex_lock(&memory_tier_lock);
> > +     mutex_lock(&mt_perf_lock);
> >       /*
> >        * The abstract distance of a memory node is in direct proportion=
 to
> >        * its memory latency (read + write) and inversely proportional t=
o its
> > @@ -713,7 +784,7 @@ int mt_perf_to_adistance(struct access_coordinate *=
perf, int *adist)
> >               (default_dram_perf.read_latency + default_dram_perf.write=
_latency) *
> >               (default_dram_perf.read_bandwidth + default_dram_perf.wri=
te_bandwidth) /
> >               (perf->read_bandwidth + perf->write_bandwidth);
> > -     mutex_unlock(&memory_tier_lock);
> > +     mutex_unlock(&mt_perf_lock);
> >
> >       return 0;
> >  }
> > @@ -826,7 +897,8 @@ static int __init memory_tier_init(void)
> >        * For now we can have 4 faster memory tiers with smaller adistan=
ce
> >        * than default DRAM tier.
> >        */
> > -     default_dram_type =3D alloc_memory_type(MEMTIER_ADISTANCE_DRAM);
> > +     default_dram_type =3D mt_find_alloc_memory_type(
> > +                                     MEMTIER_ADISTANCE_DRAM, &default_=
memory_types);
> >       if (IS_ERR(default_dram_type))
> >               panic("%s() failed to allocate default DRAM tier\n", __fu=
nc__);
> >
> > @@ -836,6 +908,14 @@ static int __init memory_tier_init(void)
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
