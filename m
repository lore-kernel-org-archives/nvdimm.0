Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6691EFF8B
	for <nvdimm@lists.linux.dev>; Tue, 11 Mar 2025 07:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741676754; cv=none; b=VgaSbpSau5k3I0RIas60W1/la6HYtp5h614mx+HeXQqXL6LGspC2VB5hkswfBJIC03ZavKpha9k9DHVRJoiBXZRas9KxKGYhSUAlc2jnkGTUukBivJ+Kb7DH17Mn4f8BzmzVs8W32j7uWP9vq5PbBFmSNBrEzmSZtTxQU1SHYK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741676754; c=relaxed/simple;
	bh=ciUwCZPfi6ydUgg555AQMOLdMYISogolV9qW034+wN0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ML66Jx3J2+XF3sIgDUxOPLyeZfmZlaCHl7ke5Bdasft7J86YRtXHeWKRU/TSsPZXpVRM7sLVZgOyGbDvrNPBaRtVi4AzlWtjMduuBHKh3zcvzrL4/NXrjwLbnhfdSMJQpAY5pnYVpfISaGV/NLjzVo058lx7UwgRUnd0KKAiFPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dcyq43Ov; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dcyq43Ov"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-86d3907524cso2102730241.0
        for <nvdimm@lists.linux.dev>; Tue, 11 Mar 2025 00:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741676751; x=1742281551; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q31kVzsoBkQBSCd3vqptmMsYbS7RNSe4aJBdM93V6lM=;
        b=Dcyq43Ovyr9MDWbiGJGu5e1464I1rQlCc2Nsyx4P9X7Hlmtx1JPV/Yel7S3rXWEQIh
         uKZSVWwIdGL7pLOJVwJSFMU/wJ3VSufnxn10R/JDdX3P2zv16XZvg1tXK4qW6aCRfzGr
         LZAuaip9nXDKFdWAXzdYiwknJPVz2JprXbc3KfNAr4WGTg++wQVMKFhv4ATaco3E68wG
         mMpWFxnWJjKVqU+M85e1+/atyPoxvfdasw5kMmjRBRdj0KH8Qu/CFp271WScI17GrTNz
         xJv5TK5gysQK6sWJp5x4h7ccylh0YG+JMJN475GrVNfDw29lRaPD0GciShfZ4Bbtb2PD
         bzaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741676751; x=1742281551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q31kVzsoBkQBSCd3vqptmMsYbS7RNSe4aJBdM93V6lM=;
        b=IlxPKqDJrSF29mBfX+zPP6b1+TwYM3wh9bmEB/mZghgT82qllG0wNF400H2pDFNMGO
         cff6eDUz3AduI2hDMiQjWibVEFSweI1haNuuho5YWRLJssdGHH4IliAEJAVZLPcdkh1o
         BEKacPtXNDDCYsTCngCGiyQkZaN0+yNX5Yp4upuW6OwS7zjt+6G0srd9axwi16FqcpI2
         vW5bugsN1MgAksXH8D1Ni/s+EPUDpkBCq/A4UGV1eLsYRWSqDfSpD0+a8oJujqw3jlqx
         6A7yG5NE12XFFIsTElJCBRiw+o8y8mfFkL4AsyVRjnGKTwyT1IyOIO9Qf59Z5ISbA2Xc
         Uhew==
X-Forwarded-Encrypted: i=1; AJvYcCXUSgELlOHXjWk92SYg5BiQVl+xzOgUIMJOg3pVO/303hP6Yn2KFy/qPTLcBkeu/RP0b0hf1ZQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0UhAQkoTTadIscoRAKjS0M+9YMBVX+b7letJIeSyyzeklLI54
	/wpgWBhLoIUoR0hlUmDBjaVb9q9NhReVzM8AMTlzmvp0tm+aYxdeg2tItNdLusEglVJ+OGI5r0N
	M8y8rA54mScXww/67le2AoxDnjEg=
X-Gm-Gg: ASbGnct7TS7YQo23py0zTjCrNVTpCbDgMEhXHs7mYwRhZMZiugkEt1vbRM8Sg8z4zgU
	MdZFzvZhx2rSMQRMLr5jQAFfc58lu6FAEhYqAUkBo/nCVyxD71p4sjpSG5lhPVUXqEzrMZoXHe2
	dRMuSsRyk0WFc64dv4tiQ6Pkd7eQ==
X-Google-Smtp-Source: AGHT+IHAzH8jT0g+s0jDcfWjjdx0MoItO4/EnfD08W69uptTJjESTeNMzIUQijW2my5HNSH+Or9ehxFp9/SLkGNQOZs=
X-Received: by 2002:a05:6102:6cf:b0:4bb:cf34:374d with SMTP id
 ada2fe7eead31-4c30a6ad473mr10393207137.20.1741676750766; Tue, 11 Mar 2025
 00:05:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <20250307120141.1566673-3-qun-wei.lin@mediatek.com> <CAGsJ_4xtp9iGPQinu5DOi3R2B47X9o=wS94GdhdY-0JUATf5hw@mail.gmail.com>
 <7938f840136165be1c50050feb39fb14ee37721b.camel@mediatek.com>
In-Reply-To: <7938f840136165be1c50050feb39fb14ee37721b.camel@mediatek.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 11 Mar 2025 20:05:35 +1300
X-Gm-Features: AQ5f1JogAWL2F7qntgpMfCfk0eGiFWnmzClUe5D5QlYNBRZgUBUA-ZCMZhJ8AdU
Message-ID: <CAGsJ_4zzZdjbr2DbRybHYDmL2EuUBohOP1=ho7fjx1XWoKDDGw@mail.gmail.com>
Subject: Re: [PATCH 2/2] kcompressd: Add Kcompressd for accelerated zram compression
To: =?UTF-8?B?UXVuLXdlaSBMaW4gKOael+e+pOW0tCk=?= <Qun-wei.Lin@mediatek.com>
Cc: =?UTF-8?B?QW5kcmV3IFlhbmcgKOaliuaZuuW8tyk=?= <Andrew.Yang@mediatek.com>, 
	=?UTF-8?B?Q2FzcGVyIExpICjmnY7kuK3mpq4p?= <casper.li@mediatek.com>, 
	"chrisl@kernel.org" <chrisl@kernel.org>, =?UTF-8?B?SmFtZXMgSHN1ICjlvpDmhbbolrAp?= <James.Hsu@mediatek.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, 
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"dave.jiang@intel.com" <dave.jiang@intel.com>, 
	"schatzberg.dan@gmail.com" <schatzberg.dan@gmail.com>, 
	=?UTF-8?B?Q2hpbndlbiBDaGFuZyAo5by16Yym5paHKQ==?= <chinwen.chang@mediatek.com>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"minchan@kernel.org" <minchan@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, 
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"ying.huang@intel.com" <ying.huang@intel.com>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2025 at 2:26=E2=80=AFAM Qun-wei Lin (=E6=9E=97=E7=BE=A4=E5=
=B4=B4)
<Qun-wei.Lin@mediatek.com> wrote:
>
> On Sat, 2025-03-08 at 08:41 +1300, Barry Song wrote:
> >
> > External email : Please do not click links or open attachments until
> > you have verified the sender or the content.
> >
> >
> > On Sat, Mar 8, 2025 at 1:02=E2=80=AFAM Qun-Wei Lin <qun-wei.lin@mediate=
k.com>
> > wrote:
> > >
> > > Introduced Kcompressd to offload zram page compression, improving
> > > system efficiency by handling compression separately from memory
> > > reclaiming. Added necessary configurations and dependencies.
> > >
> > > Signed-off-by: Qun-Wei Lin <qun-wei.lin@mediatek.com>
> > > ---
> > >  drivers/block/zram/Kconfig      |  11 ++
> > >  drivers/block/zram/Makefile     |   3 +-
> > >  drivers/block/zram/kcompressd.c | 340
> > > ++++++++++++++++++++++++++++++++
> > >  drivers/block/zram/kcompressd.h |  25 +++
> > >  drivers/block/zram/zram_drv.c   |  22 ++-
> > >  5 files changed, 397 insertions(+), 4 deletions(-)
> > >  create mode 100644 drivers/block/zram/kcompressd.c
> > >  create mode 100644 drivers/block/zram/kcompressd.h
> > >
> > > diff --git a/drivers/block/zram/Kconfig
> > > b/drivers/block/zram/Kconfig
> > > index 402b7b175863..f0a1b574f770 100644
> > > --- a/drivers/block/zram/Kconfig
> > > +++ b/drivers/block/zram/Kconfig
> > > @@ -145,3 +145,14 @@ config ZRAM_MULTI_COMP
> > >           re-compress pages using a potentially slower but more
> > > effective
> > >           compression algorithm. Note, that IDLE page recompression
> > >           requires ZRAM_TRACK_ENTRY_ACTIME.
> > > +
> > > +config KCOMPRESSD
> > > +       tristate "Kcompressd: Accelerated zram compression"
> > > +       depends on ZRAM
> > > +       help
> > > +         Kcompressd creates multiple daemons to accelerate the
> > > compression of pages
> > > +         in zram, offloading this time-consuming task from the
> > > zram driver.
> > > +
> > > +         This approach improves system efficiency by handling page
> > > compression separately,
> > > +         which was originally done by kswapd or direct reclaim.
> >
> > For direct reclaim, we were previously able to compress using
> > multiple CPUs
> > with multi-threading.
> > After your patch, it seems that only a single thread/CPU is used for
> > compression
> > so it won't necessarily improve direct reclaim performance?
> >
>
> Our patch only splits the context of kswapd. When direct reclaim is
> occurred, it is bypassed, so direct reclaim remains unchanged, with
> each thread that needs memory directly reclaiming it.

Qun-wei, I=E2=80=99m getting a bit confused. Looking at the code in page_io=
.c,
you always call swap_writepage_bdev_async() no matter if it is kswapd
or direct reclaim:

- else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
+ else if (data_race(sis->flags & SWP_WRITE_SYNCHRONOUS_IO))
           swap_writepage_bdev_sync(folio, wbc, sis);
  else
            swap_writepage_bdev_async(folio, wbc, sis);

In zram, I notice you are bypassing kcompressd by:

+ if (!nr_kcompressd || !current_is_kswapd())
+        return -EBUSY;

How will this work if no one is calling __end_swap_bio_write(&bio),
which is present in swap_writepage_bdev_sync()?
Am I missing something? Or is it done by zram_bio_write() ?

On the other hand, zram is a generic block device, and coupling its
code with kswapd/direct reclaim somehow violates layering
principles :-)

>
> > Even for kswapd, we used to have multiple threads like [kswapd0],
> > [kswapd1],
> > and [kswapd2] for different nodes. Now, are we also limited to just
> > one thread?
>
> We only considered a single kswapd here and didn't account for multiple
> instances. Since I use kfifo to collect the bios, if there are multiple
> kswapds, we need to add a lock to protect the bio queue. I can revise
> this in the 2nd version, or do you have any other suggested approaches?

I'm wondering if we can move the code to vmscan/page_io instead
of zram. If we're using a sync I/O swap device or have enabled zswap,
we could run reclamation in this separate thread, which should also be
NUMA-aware.

I would definitely be interested in prototyping it when I have the time.

>
> > I also wonder if this could be handled at the vmscan level instead of
> > the zram
> > level. then it might potentially help other sync devices or even
> > zswap later.
> >
> > But I agree that for phones, modifying zram seems like an easier
> > starting
> > point. However, relying on a single thread isn't always the best
> > approach.
> >
> >
> > > +
> > > diff --git a/drivers/block/zram/Makefile
> > > b/drivers/block/zram/Makefile
> > > index 0fdefd576691..23baa5dfceb9 100644
> > > --- a/drivers/block/zram/Makefile
> > > +++ b/drivers/block/zram/Makefile
> > > @@ -9,4 +9,5 @@ zram-$(CONFIG_ZRAM_BACKEND_ZSTD)        +=3D
> > > backend_zstd.o
> > >  zram-$(CONFIG_ZRAM_BACKEND_DEFLATE)    +=3D backend_deflate.o
> > >  zram-$(CONFIG_ZRAM_BACKEND_842)                +=3D backend_842.o
> > >
> > > -obj-$(CONFIG_ZRAM)     +=3D      zram.o
> > > +obj-$(CONFIG_ZRAM)             +=3D zram.o
> > > +obj-$(CONFIG_KCOMPRESSD)       +=3D kcompressd.o
> > > diff --git a/drivers/block/zram/kcompressd.c
> > > b/drivers/block/zram/kcompressd.c
> > > new file mode 100644
> > > index 000000000000..195b7e386869
> > > --- /dev/null
> > > +++ b/drivers/block/zram/kcompressd.c
> > > @@ -0,0 +1,340 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Copyright (C) 2024 MediaTek Inc.
> > > + */
> > > +
> > > +#include <linux/module.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/bio.h>
> > > +#include <linux/bitops.h>
> > > +#include <linux/freezer.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/psi.h>
> > > +#include <linux/kfifo.h>
> > > +#include <linux/swap.h>
> > > +#include <linux/delay.h>
> > > +
> > > +#include "kcompressd.h"
> > > +
> > > +#define INIT_QUEUE_SIZE                4096
> > > +#define DEFAULT_NR_KCOMPRESSD  4
> > > +
> > > +static atomic_t enable_kcompressd;
> > > +static unsigned int nr_kcompressd;
> > > +static unsigned int queue_size_per_kcompressd;
> > > +static struct kcompress *kcompress;
> > > +
> > > +enum run_state {
> > > +       KCOMPRESSD_NOT_STARTED =3D 0,
> > > +       KCOMPRESSD_RUNNING,
> > > +       KCOMPRESSD_SLEEPING,
> > > +};
> > > +
> > > +struct kcompressd_para {
> > > +       wait_queue_head_t *kcompressd_wait;
> > > +       struct kfifo *write_fifo;
> > > +       atomic_t *running;
> > > +};
> > > +
> > > +static struct kcompressd_para *kcompressd_para;
> > > +static BLOCKING_NOTIFIER_HEAD(kcompressd_notifier_list);
> > > +
> > > +struct write_work {
> > > +       void *mem;
> > > +       struct bio *bio;
> > > +       compress_callback cb;
> > > +};
> > > +
> > > +int kcompressd_enabled(void)
> > > +{
> > > +       return likely(atomic_read(&enable_kcompressd));
> > > +}
> > > +EXPORT_SYMBOL(kcompressd_enabled);
> > > +
> > > +static void kcompressd_try_to_sleep(struct kcompressd_para *p)
> > > +{
> > > +       DEFINE_WAIT(wait);
> > > +
> > > +       if (!kfifo_is_empty(p->write_fifo))
> > > +               return;
> > > +
> > > +       if (freezing(current) || kthread_should_stop())
> > > +               return;
> > > +
> > > +       atomic_set(p->running, KCOMPRESSD_SLEEPING);
> > > +       prepare_to_wait(p->kcompressd_wait, &wait,
> > > TASK_INTERRUPTIBLE);
> > > +
> > > +       /*
> > > +        * After a short sleep, check if it was a premature sleep.
> > > If not, then
> > > +        * go fully to sleep until explicitly woken up.
> > > +        */
> > > +       if (!kthread_should_stop() && kfifo_is_empty(p-
> > > >write_fifo))
> > > +               schedule();
> > > +
> > > +       finish_wait(p->kcompressd_wait, &wait);
> > > +       atomic_set(p->running, KCOMPRESSD_RUNNING);
> > > +}
> > > +
> > > +static int kcompressd(void *para)
> > > +{
> > > +       struct task_struct *tsk =3D current;
> > > +       struct kcompressd_para *p =3D (struct kcompressd_para *)para;
> > > +
> > > +       tsk->flags |=3D PF_MEMALLOC | PF_KSWAPD;
> > > +       set_freezable();
> > > +
> > > +       while (!kthread_should_stop()) {
> > > +               bool ret;
> > > +
> > > +               kcompressd_try_to_sleep(p);
> > > +               ret =3D try_to_freeze();
> > > +               if (kthread_should_stop())
> > > +                       break;
> > > +
> > > +               if (ret)
> > > +                       continue;
> > > +
> > > +               while (!kfifo_is_empty(p->write_fifo)) {
> > > +                       struct write_work entry;
> > > +
> > > +                       if (sizeof(struct write_work) =3D=3D
> > > kfifo_out(p->write_fifo,
> > > +                                               &entry,
> > > sizeof(struct write_work))) {
> > > +                               entry.cb(entry.mem, entry.bio);
> > > +                               bio_put(entry.bio);
> > > +                       }
> > > +               }
> > > +
> > > +       }
> > > +
> > > +       tsk->flags &=3D ~(PF_MEMALLOC | PF_KSWAPD);
> > > +       atomic_set(p->running, KCOMPRESSD_NOT_STARTED);
> > > +       return 0;
> > > +}
> > > +
> > > +static int init_write_queue(void)
> > > +{
> > > +       int i;
> > > +       unsigned int queue_len =3D queue_size_per_kcompressd *
> > > sizeof(struct write_work);
> > > +
> > > +       for (i =3D 0; i < nr_kcompressd; i++) {
> > > +               if (kfifo_alloc(&kcompress[i].write_fifo,
> > > +                                       queue_len, GFP_KERNEL)) {
> > > +                       pr_err("Failed to alloc kfifo %d\n", i);
> > > +                       return -ENOMEM;
> > > +               }
> > > +       }
> > > +       return 0;
> > > +}
> > > +
> > > +static void clean_bio_queue(int idx)
> > > +{
> > > +       struct write_work entry;
> > > +
> > > +       while (sizeof(struct write_work) =3D=3D
> > > kfifo_out(&kcompress[idx].write_fifo,
> > > +                               &entry, sizeof(struct write_work)))
> > > {
> > > +               bio_put(entry.bio);
> > > +               entry.cb(entry.mem, entry.bio);
> > > +       }
> > > +       kfifo_free(&kcompress[idx].write_fifo);
> > > +}
> > > +
> > > +static int kcompress_update(void)
> > > +{
> > > +       int i;
> > > +       int ret;
> > > +
> > > +       kcompress =3D kvmalloc_array(nr_kcompressd, sizeof(struct
> > > kcompress), GFP_KERNEL);
> > > +       if (!kcompress)
> > > +               return -ENOMEM;
> > > +
> > > +       kcompressd_para =3D kvmalloc_array(nr_kcompressd,
> > > sizeof(struct kcompressd_para), GFP_KERNEL);
> > > +       if (!kcompressd_para)
> > > +               return -ENOMEM;
> > > +
> > > +       ret =3D init_write_queue();
> > > +       if (ret) {
> > > +               pr_err("Initialization of writing to FIFOs
> > > failed!!\n");
> > > +               return ret;
> > > +       }
> > > +
> > > +       for (i =3D 0; i < nr_kcompressd; i++) {
> > > +               init_waitqueue_head(&kcompress[i].kcompressd_wait);
> > > +               kcompressd_para[i].kcompressd_wait =3D
> > > &kcompress[i].kcompressd_wait;
> > > +               kcompressd_para[i].write_fifo =3D
> > > &kcompress[i].write_fifo;
> > > +               kcompressd_para[i].running =3D &kcompress[i].running;
> > > +       }
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static void stop_all_kcompressd_thread(void)
> > > +{
> > > +       int i;
> > > +
> > > +       for (i =3D 0; i < nr_kcompressd; i++) {
> > > +               kthread_stop(kcompress[i].kcompressd);
> > > +               kcompress[i].kcompressd =3D NULL;
> > > +               clean_bio_queue(i);
> > > +       }
> > > +}
> > > +
> > > +static int do_nr_kcompressd_handler(const char *val,
> > > +               const struct kernel_param *kp)
> > > +{
> > > +       int ret;
> > > +
> > > +       atomic_set(&enable_kcompressd, false);
> > > +
> > > +       stop_all_kcompressd_thread();
> > > +
> > > +       ret =3D param_set_int(val, kp);
> > > +       if (!ret) {
> > > +               pr_err("Invalid number of kcompressd.\n");
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       ret =3D init_write_queue();
> > > +       if (ret) {
> > > +               pr_err("Initialization of writing to FIFOs
> > > failed!!\n");
> > > +               return ret;
> > > +       }
> > > +
> > > +       atomic_set(&enable_kcompressd, true);
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static const struct kernel_param_ops
> > > param_ops_change_nr_kcompressd =3D {
> > > +       .set =3D &do_nr_kcompressd_handler,
> > > +       .get =3D &param_get_uint,
> > > +       .free =3D NULL,
> > > +};
> > > +
> > > +module_param_cb(nr_kcompressd, &param_ops_change_nr_kcompressd,
> > > +               &nr_kcompressd, 0644);
> > > +MODULE_PARM_DESC(nr_kcompressd, "Number of pre-created daemon for
> > > page compression");
> > > +
> > > +static int do_queue_size_per_kcompressd_handler(const char *val,
> > > +               const struct kernel_param *kp)
> > > +{
> > > +       int ret;
> > > +
> > > +       atomic_set(&enable_kcompressd, false);
> > > +
> > > +       stop_all_kcompressd_thread();
> > > +
> > > +       ret =3D param_set_int(val, kp);
> > > +       if (!ret) {
> > > +               pr_err("Invalid queue size for kcompressd.\n");
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       ret =3D init_write_queue();
> > > +       if (ret) {
> > > +               pr_err("Initialization of writing to FIFOs
> > > failed!!\n");
> > > +               return ret;
> > > +       }
> > > +
> > > +       pr_info("Queue size for kcompressd was changed: %d\n",
> > > queue_size_per_kcompressd);
> > > +
> > > +       atomic_set(&enable_kcompressd, true);
> > > +       return 0;
> > > +}
> > > +
> > > +static const struct kernel_param_ops
> > > param_ops_change_queue_size_per_kcompressd =3D {
> > > +       .set =3D &do_queue_size_per_kcompressd_handler,
> > > +       .get =3D &param_get_uint,
> > > +       .free =3D NULL,
> > > +};
> > > +
> > > +module_param_cb(queue_size_per_kcompressd,
> > > &param_ops_change_queue_size_per_kcompressd,
> > > +               &queue_size_per_kcompressd, 0644);
> > > +MODULE_PARM_DESC(queue_size_per_kcompressd,
> > > +               "Size of queue for kcompressd");
> > > +
> > > +int schedule_bio_write(void *mem, struct bio *bio,
> > > compress_callback cb)
> > > +{
> > > +       int i;
> > > +       bool submit_success =3D false;
> > > +       size_t sz_work =3D sizeof(struct write_work);
> > > +
> > > +       struct write_work entry =3D {
> > > +               .mem =3D mem,
> > > +               .bio =3D bio,
> > > +               .cb =3D cb
> > > +       };
> > > +
> > > +       if (unlikely(!atomic_read(&enable_kcompressd)))
> > > +               return -EBUSY;
> > > +
> > > +       if (!nr_kcompressd || !current_is_kswapd())
> > > +               return -EBUSY;
> > > +
> > > +       bio_get(bio);
> > > +
> > > +       for (i =3D 0; i < nr_kcompressd; i++) {
> > > +               submit_success =3D
> > > +                       (kfifo_avail(&kcompress[i].write_fifo) >=3D
> > > sz_work) &&
> > > +                       (sz_work =3D=3D
> > > kfifo_in(&kcompress[i].write_fifo, &entry, sz_work));
> > > +
> > > +               if (submit_success) {
> > > +                       switch (atomic_read(&kcompress[i].running))
> > > {
> > > +                       case KCOMPRESSD_NOT_STARTED:
> > > +                               atomic_set(&kcompress[i].running,
> > > KCOMPRESSD_RUNNING);
> > > +                               kcompress[i].kcompressd =3D
> > > kthread_run(kcompressd,
> > > +
> > > &kcompressd_para[i], "kcompressd:%d", i);
> > > +                               if
> > > (IS_ERR(kcompress[i].kcompressd)) {
> > > +
> > > atomic_set(&kcompress[i].running, KCOMPRESSD_NOT_STARTED);
> > > +                                       pr_warn("Failed to start
> > > kcompressd:%d\n", i);
> > > +                                       clean_bio_queue(i);
> > > +                               }
> > > +                               break;
> > > +                       case KCOMPRESSD_RUNNING:
> > > +                               break;
> > > +                       case KCOMPRESSD_SLEEPING:
> > > +
> > > wake_up_interruptible(&kcompress[i].kcompressd_wait);
> > > +                               break;
> > > +                       }
> > > +                       return 0;
> > > +               }
> > > +       }
> > > +
> > > +       bio_put(bio);
> > > +       return -EBUSY;
> > > +}
> > > +EXPORT_SYMBOL(schedule_bio_write);
> > > +
> > > +static int __init kcompressd_init(void)
> > > +{
> > > +       int ret;
> > > +
> > > +       nr_kcompressd =3D DEFAULT_NR_KCOMPRESSD;
> > > +       queue_size_per_kcompressd =3D INIT_QUEUE_SIZE;
> > > +
> > > +       ret =3D kcompress_update();
> > > +       if (ret) {
> > > +               pr_err("Init kcompressd failed!\n");
> > > +               return ret;
> > > +       }
> > > +
> > > +       atomic_set(&enable_kcompressd, true);
> > > +       blocking_notifier_call_chain(&kcompressd_notifier_list, 0,
> > > NULL);
> > > +       return 0;
> > > +}
> > > +
> > > +static void __exit kcompressd_exit(void)
> > > +{
> > > +       atomic_set(&enable_kcompressd, false);
> > > +       stop_all_kcompressd_thread();
> > > +
> > > +       kvfree(kcompress);
> > > +       kvfree(kcompressd_para);
> > > +}
> > > +
> > > +module_init(kcompressd_init);
> > > +module_exit(kcompressd_exit);
> > > +
> > > +MODULE_LICENSE("Dual BSD/GPL");
> > > +MODULE_AUTHOR("Qun-Wei Lin <qun-wei.lin@mediatek.com>");
> > > +MODULE_DESCRIPTION("Separate the page compression from the memory
> > > reclaiming");
> > > +
> > > diff --git a/drivers/block/zram/kcompressd.h
> > > b/drivers/block/zram/kcompressd.h
> > > new file mode 100644
> > > index 000000000000..2fe0b424a7af
> > > --- /dev/null
> > > +++ b/drivers/block/zram/kcompressd.h
> > > @@ -0,0 +1,25 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +/*
> > > + * Copyright (C) 2024 MediaTek Inc.
> > > + */
> > > +
> > > +#ifndef _KCOMPRESSD_H_
> > > +#define _KCOMPRESSD_H_
> > > +
> > > +#include <linux/rwsem.h>
> > > +#include <linux/kfifo.h>
> > > +#include <linux/atomic.h>
> > > +
> > > +typedef void (*compress_callback)(void *mem, struct bio *bio);
> > > +
> > > +struct kcompress {
> > > +       struct task_struct *kcompressd;
> > > +       wait_queue_head_t kcompressd_wait;
> > > +       struct kfifo write_fifo;
> > > +       atomic_t running;
> > > +};
> > > +
> > > +int kcompressd_enabled(void);
> > > +int schedule_bio_write(void *mem, struct bio *bio,
> > > compress_callback cb);
> > > +#endif
> > > +
> > > diff --git a/drivers/block/zram/zram_drv.c
> > > b/drivers/block/zram/zram_drv.c
> > > index 2e1a70f2f4bd..bcd63ecb6ff2 100644
> > > --- a/drivers/block/zram/zram_drv.c
> > > +++ b/drivers/block/zram/zram_drv.c
> > > @@ -35,6 +35,7 @@
> > >  #include <linux/part_stat.h>
> > >  #include <linux/kernel_read_file.h>
> > >
> > > +#include "kcompressd.h"
> > >  #include "zram_drv.h"
> > >
> > >  static DEFINE_IDR(zram_index_idr);
> > > @@ -2240,6 +2241,15 @@ static void zram_bio_write(struct zram
> > > *zram, struct bio *bio)
> > >         bio_endio(bio);
> > >  }
> > >
> > > +#if IS_ENABLED(CONFIG_KCOMPRESSD)
> > > +static void zram_bio_write_callback(void *mem, struct bio *bio)
> > > +{
> > > +       struct zram *zram =3D (struct zram *)mem;
> > > +
> > > +       zram_bio_write(zram, bio);
> > > +}
> > > +#endif
> > > +
> > >  /*
> > >   * Handler function for all zram I/O requests.
> > >   */
> > > @@ -2252,6 +2262,10 @@ static void zram_submit_bio(struct bio *bio)
> > >                 zram_bio_read(zram, bio);
> > >                 break;
> > >         case REQ_OP_WRITE:
> > > +#if IS_ENABLED(CONFIG_KCOMPRESSD)
> > > +               if (kcompressd_enabled() &&
> > > !schedule_bio_write(zram, bio, zram_bio_write_callback))
> > > +                       break;
> > > +#endif
> > >                 zram_bio_write(zram, bio);
> > >                 break;
> > >         case REQ_OP_DISCARD:
> > > @@ -2535,9 +2549,11 @@ static int zram_add(void)
> > >  #if ZRAM_LOGICAL_BLOCK_SIZE =3D=3D PAGE_SIZE
> > >                 .max_write_zeroes_sectors       =3D UINT_MAX,
> > >  #endif
> > > -               .features                       =3D
> > > BLK_FEAT_STABLE_WRITES        |
> > > -
> > > BLK_FEAT_READ_SYNCHRONOUS     |
> > > -
> > > BLK_FEAT_WRITE_SYNCHRONOUS,
> > > +               .features                       =3D
> > > BLK_FEAT_STABLE_WRITES
> > > +                                                 |
> > > BLK_FEAT_READ_SYNCHRONOUS
> > > +#if !IS_ENABLED(CONFIG_KCOMPRESSD)
> > > +                                                 |
> > > BLK_FEAT_WRITE_SYNCHRONOUS,
> > > +#endif
> > >         };
> > >         struct zram *zram;
> > >         int ret, device_id;
> > > --
> > > 2.45.2
> > >
> >

Thanks
Barry
