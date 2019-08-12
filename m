Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DBD5F212AF0AA
 for <linux-nvdimm@lists.01.org>; Mon, 12 Aug 2019 08:53:35 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] mm/memremap: Fix reuse of pgmap instances with internal
 references
References: <156530042781.2068700.8733813683117819799.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Mon, 12 Aug 2019 11:51:12 -0400
In-Reply-To: <156530042781.2068700.8733813683117819799.stgit@dwillia2-desk3.amr.corp.intel.com>
 (Dan Williams's message of "Thu, 08 Aug 2019 14:43:49 -0700")
Message-ID: <x49blwuidqn.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> Currently, attempts to shutdown and re-enable a device-dax instance
> trigger:

What does "shutdown and re-enable" translate to?  If I disable and
re-enable a device-dax namespace, I don't see this behavior.

-Jeff

>
>     Missing reference count teardown definition
>     WARNING: CPU: 37 PID: 1608 at mm/memremap.c:211 devm_memremap_pages+0x234/0x850
>     [..]
>     RIP: 0010:devm_memremap_pages+0x234/0x850
>     [..]
>     Call Trace:
>      dev_dax_probe+0x66/0x190 [device_dax]
>      really_probe+0xef/0x390
>      driver_probe_device+0xb4/0x100
>      device_driver_attach+0x4f/0x60
>
> Given that the setup path initializes pgmap->ref, arrange for it to be
> also torn down so devm_memremap_pages() is ready to be called again and
> not be mistaken for the 3rd-party per-cpu-ref case.
>
> Fixes: 24917f6b1041 ("memremap: provide an optional internal refcount in struct dev_pagemap")
> Reported-by: Fan Du <fan.du@intel.com>
> Tested-by: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>
> Andrew, I have another dax fix pending, so I'm ok to take this through
> the nvdimm tree, holler if you want it in -mm.
>
>  mm/memremap.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 6ee03a816d67..86432650f829 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -91,6 +91,12 @@ static void dev_pagemap_cleanup(struct dev_pagemap *pgmap)
>  		wait_for_completion(&pgmap->done);
>  		percpu_ref_exit(pgmap->ref);
>  	}
> +	/*
> +	 * Undo the pgmap ref assignment for the internal case as the
> +	 * caller may re-enable the same pgmap.
> +	 */
> +	if (pgmap->ref == &pgmap->internal_ref)
> +		pgmap->ref = NULL;
>  }
>  
>  static void devm_memremap_pages_release(void *data)
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
