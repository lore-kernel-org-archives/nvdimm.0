Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ECFD2220D4BF6
 for <linux-nvdimm@lists.01.org>; Thu, 23 Nov 2017 00:25:29 -0800 (PST)
Date: Thu, 23 Nov 2017 00:29:46 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH 2/2] dm-writecache
Message-ID: <20171123082946.GB17859@infradead.org>
References: <alpine.LRH.2.02.1711222135371.2330@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1711222135371.2330@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

> +/*
> + * The clflushopt instruction is very slow on Broadwell, so we use non-temporal
> + * stores instead.
> + */
> +#ifdef CONFIG_X86_64
> +#define NT_STORE(dest, src)	asm ("movnti %1, %0" : "=m"(dest) : "r"(src))
> +#define FLUSH_RANGE(dax, ptr, size)  do { } while (0)
> +#define COMMIT_FLUSHED()	wmb()
> +#else
> +#define NT_STORE(dest, src)	ACCESS_ONCE(dest) = (src)
> +#define FLUSH_RANGE		dax_flush
> +#define COMMIT_FLUSHED()	do { } while (0)
> +#endif

Please go through the proper pmem APIs.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
