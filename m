Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E6C10F1
	for <nvdimm@lists.linux.dev>; Wed, 22 Jun 2022 03:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655868138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SnmpFslx4bnuHaAyB7sYVJCt/WlKAGOw6+XqvSCoZx0=;
	b=Gfun1pu9kPlbA3VKESUlXU4yvkjxDfHHIXp6oLHFnB3o1PQw1E217T3/wGOgYqm8sbb4Ik
	XXOJiyWFbgoj12jxwqXOyt+6nj2RsNqGLimmsKlmcTofnJY8fWfBcCHCPS8Nayp995pqFP
	Rf8cKgQFxlkgOcYIKtYV7jMY1kdZcsc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-Sj6M5_XUOxmg8qPGThCw6g-1; Tue, 21 Jun 2022 23:22:14 -0400
X-MC-Unique: Sj6M5_XUOxmg8qPGThCw6g-1
Received: by mail-lf1-f72.google.com with SMTP id bq4-20020a056512150400b0047f7f36efc6so1814540lfb.9
        for <nvdimm@lists.linux.dev>; Tue, 21 Jun 2022 20:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SnmpFslx4bnuHaAyB7sYVJCt/WlKAGOw6+XqvSCoZx0=;
        b=zTGScU3nB+97Q6MnUthgfexW5/3NLu26902tkUaTYo7fRVmKfFmieb7LbGvkd0K7yE
         79BwyWhuCzeDAARWbZxnHo2iMul4cQ6PUW7DfpvYeJZh+06BPirNf3ambmaMlKW2E1jV
         zmUgGtN5wJ1yj1Os+5QF1prYKntLTRqR5DTFuj4rGIS/Xi5vtMbhZrig9gHEi3XbDk75
         Hzl5LbJtM/k1uqDuq5Ol3IHPW+XfU8K9PL0HjkRZNdo0Rv6sr/DH/JpMTpfxlWcH3Zrz
         FrGiYk8r/8KFRI493Dud3t1Cszmx7B9TAWhsjkz7ukLjn97ZaWfZWMykKO5ExDUTmnSI
         Z/AQ==
X-Gm-Message-State: AJIora9uqtrkNiIHnYlJzugxBTSoOilRgjPjle/JucPbS3Xl/YoJJZy7
	hcEAsnGKgckYgVE+OktvJg8ou+Y+vCCjRQHH1z2itHxVRLmmFFfLLfmWnxFqpR3BBjf/pvKIiec
	Q2f1dBE/uybhr9LBdfDjXt61erILZJfO7
X-Received: by 2002:a2e:8417:0:b0:25a:7fa7:fe5a with SMTP id z23-20020a2e8417000000b0025a7fa7fe5amr653195ljg.323.1655868132145;
        Tue, 21 Jun 2022 20:22:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t/frWZNRtk8L3UkGe4WAgj478I0gEjlb7eeqzCxUDALH57QzdbpZAt++HRXXwuzU4w0RUbdsijdH1hKiE+NG8=
X-Received: by 2002:a2e:8417:0:b0:25a:7fa7:fe5a with SMTP id
 z23-20020a2e8417000000b0025a7fa7fe5amr653187ljg.323.1655868131933; Tue, 21
 Jun 2022 20:22:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220620081519.1494-1-jasowang@redhat.com> <62b2476ca8c21_892072947a@dwillia2-xfh.notmuch>
In-Reply-To: <62b2476ca8c21_892072947a@dwillia2-xfh.notmuch>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 22 Jun 2022 11:22:00 +0800
Message-ID: <CACGkMEsgMkA40UTr8v3PTH1PYZRVYwABuU-=pJJfrEkack7k0w@mail.gmail.com>
Subject: Re: [PATCH 1/2] virtio_pmem: initialize provider_data through nd_region_desc
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com, "Jiang, Dave" <dave.jiang@intel.com>, ira.weiny@intel.com, 
	nvdimm@lists.linux.dev, mst <mst@redhat.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jasowang@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 22, 2022 at 6:34 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Jason Wang wrote:
> > We used to initialize the provider_data manually after
> > nvdimm_pemm_region_create(). This seems to be racy if the flush is
>
> It would be nice to include the actual backtrace / bug signature that
> this fixes if it is available.

The bug was spotted during code review. But it can be reproduced by
adding a msleep() between nvdimm_pmem_region_create() and
nd_region->provider_data =
dev_to_virtio(nd_region->dev.parent->parent);

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 995b6cdc67ed..153d9dbfbe70 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -8,6 +8,7 @@
  */
 #include "virtio_pmem.h"
 #include "nd.h"
+#include <linux/delay.h>

 static struct virtio_device_id id_table[] = {
        { VIRTIO_ID_PMEM, VIRTIO_DEV_ANY_ID },
@@ -89,6 +90,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
                err = -ENXIO;
                goto out_nd;
        }
+       msleep(100 * 1000);
        nd_region->provider_data = dev_to_virtio(nd_region->dev.parent->parent);
        return 0;
 out_nd:

Then if we hotplug and try to do mkfs we get:

[   80.152281] nd_pmem namespace0.0: unable to guarantee persistence of writes
[   92.393956] BUG: kernel NULL pointer dereference, address: 0000000000000318
[   92.394551] #PF: supervisor read access in kernel mode
[   92.394955] #PF: error_code(0x0000) - not-present page
[   92.395365] PGD 0 P4D 0
[   92.395566] Oops: 0000 [#1] PREEMPT SMP PTI
[   92.395867] CPU: 2 PID: 506 Comm: mkfs.ext4 Not tainted 5.19.0-rc1+ #453
[   92.396365] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[   92.397178] RIP: 0010:virtio_pmem_flush+0x2f/0x1f0
[   92.397521] Code: 55 41 54 55 53 48 81 ec a0 00 00 00 65 48 8b 04
25 28 00 00 00 48 89 84 24 98 00 00 00 31 c0 48 8b 87 78 03 00 00 48
89 04 24 <48> 8b 98 18 03 00 00 e8 85 bf 6b 00 ba 58 00 00 00 be c0 0c
00 00
[   92.398982] RSP: 0018:ffff9a7380aefc88 EFLAGS: 00010246
[   92.399349] RAX: 0000000000000000 RBX: ffff8e77c3f86f00 RCX: 0000000000000000
[   92.399833] RDX: ffffffffad4ea720 RSI: ffff8e77c41e39c0 RDI: ffff8e77c41c5c00
[   92.400388] RBP: ffff8e77c41e39c0 R08: ffff8e77c19f0600 R09: 0000000000000000
[   92.400874] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8e77c0814e28
[   92.401364] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8e77c41e39c0
[   92.401849] FS:  00007f3cd75b2780(0000) GS:ffff8e7937d00000(0000)
knlGS:0000000000000000
[   92.402423] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   92.402821] CR2: 0000000000000318 CR3: 0000000103c80002 CR4: 0000000000370ee0
[   92.403307] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   92.403793] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   92.404278] Call Trace:
[   92.404481]  <TASK>
[   92.404654]  ? mempool_alloc+0x5d/0x160
[   92.404939]  ? terminate_walk+0x5f/0xf0
[   92.405226]  ? bio_alloc_bioset+0xbb/0x3f0
[   92.405525]  async_pmem_flush+0x17/0x80
[   92.405806]  nvdimm_flush+0x11/0x30
[   92.406067]  pmem_submit_bio+0x1e9/0x200
[   92.406354]  __submit_bio+0x80/0x120
[   92.406621]  submit_bio_noacct_nocheck+0xdc/0x2a0
[   92.406958]  submit_bio_wait+0x4e/0x80
[   92.407234]  blkdev_issue_flush+0x31/0x50
[   92.407526]  ? punt_bios_to_rescuer+0x230/0x230
[   92.407852]  blkdev_fsync+0x1e/0x30
[   92.408112]  do_fsync+0x33/0x70
[   92.408354]  __x64_sys_fsync+0xb/0x10
[   92.408625]  do_syscall_64+0x43/0x90
[   92.408895]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[   92.409257] RIP: 0033:0x7f3cd76c6c44

>
> > issued before the initialization of provider_data. Fixing this by
> > initialize the provider_data through nd_region_desc to make sure the
> > provider_data is ready after the pmem is created.
> >
> > Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/nvdimm/virtio_pmem.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > index 995b6cdc67ed..48f8327d0431 100644
> > --- a/drivers/nvdimm/virtio_pmem.c
> > +++ b/drivers/nvdimm/virtio_pmem.c
> > @@ -81,6 +81,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> >       ndr_desc.res = &res;
> >       ndr_desc.numa_node = nid;
> >       ndr_desc.flush = async_pmem_flush;
> > +     ndr_desc.provider_data = vdev;
>
> For my untrained eye, why not
> "dev_to_virtio(nd_region->dev.parent->parent)"? If that is indeed
> equivalent "vdev" then you can do a follow-on cleanup patch to reduce
> that syntax. Otherwise, if by chance they are not equivalent, then this
> conversion is introducing a new problem.

It is because nd_region hasn't been allocated at this time (which is
allocated by nd_region_create() afterwards).

Thanks

>
> Outside of that you can add:
>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>

