Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE6C28EF
	for <nvdimm@lists.linux.dev>; Sun,  6 Aug 2023 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691335067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jmKB9tnmoSW66PnBBOCrXWK1ePidGDAnxGSMu5crApw=;
	b=dCwIKOi6roPJxSqUcHVHuUTE77CRU9R1fQI4zHN/SGnyaBOvdYFuenlZMOER3+UChPjH19
	HbhlaHxTM57sii206bphuyHZfA1zHJRUrCdwAy6PvjzT1fpUU9HC/iCXoZWqgY0ux/7KIF
	WI/xsg8qHc4a3zWDR8wcAn6pQuXHLpQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-wh9xSlCHMOGhWIYVS99XAA-1; Sun, 06 Aug 2023 11:17:46 -0400
X-MC-Unique: wh9xSlCHMOGhWIYVS99XAA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-94a34d3e5ebso241920066b.3
        for <nvdimm@lists.linux.dev>; Sun, 06 Aug 2023 08:17:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691335065; x=1691939865;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jmKB9tnmoSW66PnBBOCrXWK1ePidGDAnxGSMu5crApw=;
        b=hKXH0Lv6e8vGeyGujz8p7pS9QF/C6IgENPEOXVJFgD6cRr+l1ECraDuATaNZBQU+jZ
         1Fogl2+YFQ3qteGDDUN1sMVWfAQIIyRIPFWznItVUJEWH82nAnNdaI+nSFYaTclyMqFb
         Ae4wcjhn1VnK6KtgtwgtKDfgXNwYnHm1HozQPmdm6EnnuNRZNqQXnUy+XJ+WkD8a979k
         Dl9dEAu+GPS5GehX5YYCu0marQzsnlVjHkD7bRbnnCOK8cg3q5jzXWwlW81O1h6Jl6OR
         kILw4dIdtu6uRY7uWC5H78U7Ipp2F0xB6fK2QAj93tcWHAZkIJBMQmR7YdstLdIErOiI
         QOwQ==
X-Gm-Message-State: AOJu0YwNh0y+i6kxLSStzPaA6tDLApRkkCDuKzF1XVHmgG0eB0RWRn7y
	ePqNX4HV16gbfMsA3zAghylxd1My8a/MdF9x7RzsRltJvBY2JX+lYl9qovJ5VMCLYW9zWUt4dFQ
	Z6Mcv+pV6vqqQwMGj
X-Received: by 2002:a17:907:2bca:b0:97d:2bcc:47d5 with SMTP id gv10-20020a1709072bca00b0097d2bcc47d5mr6414187ejc.49.1691335064956;
        Sun, 06 Aug 2023 08:17:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtapW82Hb1Zd8BBSQHwutyuDtCwq2yQg3/1rQjZzPMqZ9Z/8LbFdyhFBBVmpsYlocZxyvMvg==
X-Received: by 2002:a17:907:2bca:b0:97d:2bcc:47d5 with SMTP id gv10-20020a1709072bca00b0097d2bcc47d5mr6414173ejc.49.1691335064609;
        Sun, 06 Aug 2023 08:17:44 -0700 (PDT)
Received: from redhat.com ([91.242.248.114])
        by smtp.gmail.com with ESMTPSA id bj10-20020a170906b04a00b0099bd6026f45sm4018477ejb.198.2023.08.06.08.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Aug 2023 08:17:43 -0700 (PDT)
Date: Sun, 6 Aug 2023 11:10:22 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>,
	"pankaj.gupta.linux@gmail.com" <pankaj.gupta.linux@gmail.com>,
	"houtao@huaweicloud.com" <houtao@huaweicloud.com>,
	"houtao1@huawei.com" <houtao1@huawei.com>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"kch@nvidia.com" <kch@nvidia.com>
Subject: Re: [PATCH v4] virtio_pmem: add the missing REQ_OP_WRITE for flush
 bio
Message-ID: <20230806110854-mutt-send-email-mst@kernel.org>
References: <CAM9Jb+g5rrvmw8xCcwe3REK4x=RymrcqQ8cZavwWoWu7BH+8wA@mail.gmail.com>
 <20230713135413.2946622-1-houtao@huaweicloud.com>
 <CAM9Jb+jjg_By+A2F+HVBsHCMsVz1AEVWbBPtLTRTfOmtFao5hA@mail.gmail.com>
 <47f9753353d07e3beb60b6254632d740682376f9.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <47f9753353d07e3beb60b6254632d740682376f9.camel@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Aug 04, 2023 at 09:03:20PM +0000, Verma, Vishal L wrote:
> On Fri, 2023-08-04 at 20:39 +0200, Pankaj Gupta wrote:
> > Gentle ping!
> > 
> > Dan, Vishal for suggestion/review on this patch and request for merging.
> > +Cc Michael for awareness, as virtio-pmem device is currently broken.
> 
> Looks good to me,
> 
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> 
> Dave, will you queue this for 6.6.


Generally if you expect me to merge a patch I should be CC'd.


> > 
> > Thanks,
> > Pankaj
> > 
> > > From: Hou Tao <houtao1@huawei.com>
> > > 
> > > When doing mkfs.xfs on a pmem device, the following warning was
> > > reported:
> > > 
> > >  ------------[ cut here ]------------
> > >  WARNING: CPU: 2 PID: 384 at block/blk-core.c:751 submit_bio_noacct
> > >  Modules linked in:
> > >  CPU: 2 PID: 384 Comm: mkfs.xfs Not tainted 6.4.0-rc7+ #154
> > >  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
> > >  RIP: 0010:submit_bio_noacct+0x340/0x520
> > >  ......
> > >  Call Trace:
> > >   <TASK>
> > >   ? submit_bio_noacct+0xd5/0x520
> > >   submit_bio+0x37/0x60
> > >   async_pmem_flush+0x79/0xa0
> > >   nvdimm_flush+0x17/0x40
> > >   pmem_submit_bio+0x370/0x390
> > >   __submit_bio+0xbc/0x190
> > >   submit_bio_noacct_nocheck+0x14d/0x370
> > >   submit_bio_noacct+0x1ef/0x520
> > >   submit_bio+0x55/0x60
> > >   submit_bio_wait+0x5a/0xc0
> > >   blkdev_issue_flush+0x44/0x60
> > > 
> > > The root cause is that submit_bio_noacct() needs bio_op() is either
> > > WRITE or ZONE_APPEND for flush bio and async_pmem_flush() doesn't assign
> > > REQ_OP_WRITE when allocating flush bio, so submit_bio_noacct just fail
> > > the flush bio.
> > > 
> > > Simply fix it by adding the missing REQ_OP_WRITE for flush bio. And we
> > > could fix the flush order issue and do flush optimization later.
> > > 
> > > Cc: stable@vger.kernel.org # 6.3+
> > > Fixes: b4a6bb3a67aa ("block: add a sanity check for non-write flush/fua bios")
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> > > Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> > > Tested-by: Pankaj Gupta <pankaj.gupta@amd.com>
> > > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > > ---
> > > v4:
> > >  * add stable Cc
> > >  * collect Rvb and Tested-by tags
> > > 
> > > v3: https://lore.kernel.org/linux-block/20230625022633.2753877-1-houtao@huaweicloud.com
> > >  * adjust the overly long lines in both commit message and code
> > > 
> > > v2: https://lore.kernel.org/linux-block/20230621134340.878461-1-houtao@huaweicloud.com
> > >  * do a minimal fix first (Suggested by Christoph)
> > > 
> > > v1: https://lore.kernel.org/linux-block/ZJLpYMC8FgtZ0k2k@infradead.org/T/#t
> > > 
> > >  drivers/nvdimm/nd_virtio.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> > > index c6a648fd8744..1f8c667c6f1e 100644
> > > --- a/drivers/nvdimm/nd_virtio.c
> > > +++ b/drivers/nvdimm/nd_virtio.c
> > > @@ -105,7 +105,8 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
> > >          * parent bio. Otherwise directly call nd_region flush.
> > >          */
> > >         if (bio && bio->bi_iter.bi_sector != -1) {
> > > -               struct bio *child = bio_alloc(bio->bi_bdev, 0, REQ_PREFLUSH,
> > > +               struct bio *child = bio_alloc(bio->bi_bdev, 0,
> > > +                                             REQ_OP_WRITE | REQ_PREFLUSH,
> > >                                               GFP_ATOMIC);
> > > 
> > >                 if (!child)
> > > --
> > > 2.29.2
> > > 
> 

