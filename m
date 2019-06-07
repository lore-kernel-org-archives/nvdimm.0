Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8FAD621148DBD
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jun 2019 13:23:35 -0700 (PDT)
Date: Fri, 7 Jun 2019 13:23:32 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 07/10] lib/memregion: Uplevel the pmem "region" ida to
 a global allocator
Message-ID: <20190607202332.GB32656@bombadil.infradead.org>
References: <155993563277.3036719.17400338098057706494.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155993567002.3036719.5748845658364934737.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <155993567002.3036719.5748845658364934737.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: x86@kernel.org, ard.biesheuvel@linaro.org, peterz@infradead.org, dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-efi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 07, 2019 at 12:27:50PM -0700, Dan Williams wrote:
> diff --git a/lib/memregion.c b/lib/memregion.c
> new file mode 100644
> index 000000000000..f6c6a94c7921
> --- /dev/null
> +++ b/lib/memregion.c
> @@ -0,0 +1,15 @@
> +#include <linux/idr.h>
> +
> +static DEFINE_IDA(region_ids);
> +
> +int memregion_alloc(gfp_t gfp)
> +{
> +	return ida_alloc(&region_ids, gfp);
> +}
> +EXPORT_SYMBOL(memregion_alloc);
> +
> +void memregion_free(int id)
> +{
> +	ida_free(&region_ids, id);
> +}
> +EXPORT_SYMBOL(memregion_free);

Does this trivial abstraction have to live in its own file?  I'd make
memregion_alloc/free static inlines that live in a header file, then
all you need do is find a suitable .c file to store memregion_ids in,
and export that one symbol instead of two.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
