Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A72D21E082A6
 for <linux-nvdimm@lists.01.org>; Thu,  8 Mar 2018 06:45:38 -0800 (PST)
Date: Thu, 8 Mar 2018 06:51:53 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH] dm-writecache
Message-ID: <20180308145153.GB23262@infradead.org>
References: <alpine.LRH.2.02.1803080824210.2819@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1803080824210.2819@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/drivers/md/dm-writecache.c	2018-03-08 14:23:31.059999000 +0100
> @@ -0,0 +1,2417 @@
> +#include <linux/device-mapper.h>

missing copyright statement, or for those new-fashioned SPDX statement.

> +#define WRITEBACK_FUA			true

no business having this around.

> +#ifndef bio_set_dev
> +#define	bio_set_dev(bio, dev)	((bio)->bi_bdev = (dev))
> +#endif
> +#ifndef timer_setup
> +#define timer_setup(t, c, f)	setup_timer(t, c, (unsigned long)(t))
> +#endif

no business in mainline.

> +/*
> + * On X86, non-temporal stores are more efficient than cache flushing.
> + * On ARM64, cache flushing is more efficient.
> + */
> +#if defined(CONFIG_X86_64)
> +#define NT_STORE(dest, src)				\
> +do {							\
> +	typeof(src) val = (src);			\
> +	memcpy_flushcache(&(dest), &val, sizeof(src));	\
> +} while (0)
> +#define COMMIT_FLUSHED()	wmb()
> +#else
> +#define NT_STORE(dest, src)	WRITE_ONCE(dest, src)
> +#define FLUSH_RANGE		dax_flush
> +#define COMMIT_FLUSHED()	do { } while (0)
> +#endif

Please use proper APIs for this, this has no business in a driver.

And that's it for now.  This is clearly not submission ready, and I
should got back to my backlog of other things.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
