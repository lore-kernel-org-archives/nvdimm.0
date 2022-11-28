Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFDE8F42
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 15:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669648818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZIdnnqvMc5cIRTMPhso6FvqNHNn8Nd8a+6iVlFTx5N8=;
	b=ebFxSldJG15fIBzCDngpnlItWI9VTIbep1E9HlBP9sh5Sp+3OaVIxOQshO/zYaS61Ic8Hi
	kafTG3bol2lrHAbhWxxyLTZlkv+11dUdUa1B3KjhpxPHovJnSqiLCWv4LCNDY9xIGktdXz
	FXaA8bjXNDMylpLxc3ner6L2UGIvm/4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-0mrKm-JVNmiGvACfrS40lQ-1; Mon, 28 Nov 2022 10:20:15 -0500
X-MC-Unique: 0mrKm-JVNmiGvACfrS40lQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36279886064;
	Mon, 28 Nov 2022 15:20:15 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A0034EA52;
	Mon, 28 Nov 2022 15:20:15 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: dan.j.williams@intel.com,  nvdimm@lists.linux.dev
Subject: Re: [bug report] libnvdimm: fix mishandled nvdimm_clear_poison() return value
References: <Y39FbkGEvQ8TcS1d@kili>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Mon, 28 Nov 2022 10:24:07 -0500
In-Reply-To: <Y39FbkGEvQ8TcS1d@kili> (Dan Carpenter's message of "Thu, 24 Nov
	2022 13:20:30 +0300")
Message-ID: <x49r0xnksq0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Dan Carpenter <error27@gmail.com> writes:

> Hello Dan Williams,
>
> The patch 868f036fee4b: "libnvdimm: fix mishandled
> nvdimm_clear_poison() return value" from Dec 16, 2016, leads to the
> following Smatch static checker warnings:
>
>     drivers/nvdimm/claim.c:287 nsio_rw_bytes() warn:
>     replace divide condition 'cleared / 512' with 'cleared >= 512'
>
>     drivers/nvdimm/bus.c:210 nvdimm_account_cleared_poison() warn:
>     replace divide condition 'cleared / 512' with 'cleared >= 512'
>
> drivers/nvdimm/claim.c
>     252 static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>     253                 resource_size_t offset, void *buf, size_t size, int rw,
>     254                 unsigned long flags)
>     255 {
>     256         struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
>     257         unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
>     258         sector_t sector = offset >> 9;
>     259         int rc = 0, ret = 0;
>     260 
>     261         if (unlikely(!size))
>     262                 return 0;
>     263 
>     264         if (unlikely(offset + size > nsio->size)) {
>     265                 dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
>     266                 return -EFAULT;
>     267         }
>     268 
>     269         if (rw == READ) {
>     270                 if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align)))
>     271                         return -EIO;
>     272                 if (copy_mc_to_kernel(buf, nsio->addr + offset, size) != 0)
>     273                         return -EIO;
>     274                 return 0;
>     275         }
>     276 
>     277         if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
>     278                 if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)
>     279                                 && !(flags & NVDIMM_IO_ATOMIC)) {
>     280                         long cleared;
>     281 
>     282                         might_sleep();
>     283                         cleared = nvdimm_clear_poison(&ndns->dev,
>     284                                         nsio->res.start + offset, size);
>     285                         if (cleared < size)
>     286                                 rc = -EIO;
> --> 287                         if (cleared > 0 && cleared / 512) {
>                                                    ^^^^^^^^^^^^^
> Smatch suggests changing this to "&& cleared >= 512" but it doesn't make
> sense to say if (cleared > 0 && cleared >= 512) {.  Probably what was
> instead intended was "if (cleared > 0 && (cleared % 512) == 0) {"?

No, it is correct as written.  cleared is the number of bytes cleared.
The badblocks_clear interface takes 512 byte sectors as an input.  We
only want to call badblocks_clear if we cleared /at least/ one sector.

It could probably use a comment, though.  :)

Cheers,
Jeff

>
>     288                                 cleared /= 512;
>     289                                 badblocks_clear(&nsio->bb, sector, cleared);
>     290                         }
>     291                         arch_invalidate_pmem(nsio->addr + offset, size);
>     292                 } else
>     293                         rc = -EIO;
>     294         }
>     295 
>     296         memcpy_flushcache(nsio->addr + offset, buf, size);
>     297         ret = nvdimm_flush(to_nd_region(ndns->dev.parent), NULL);
>     298         if (ret)
>     299                 rc = ret;
>     300 
>     301         return rc;
>     302 }
>
> regards,
> dan carpenter

