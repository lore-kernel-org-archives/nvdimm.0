Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1EDC5202E5474
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 14:23:31 -0700 (PDT)
Received: by mail-wr1-f67.google.com with SMTP id r16-v6so5367949wrt.11
 for <linux-nvdimm@lists.01.org>; Fri, 06 Jul 2018 14:23:30 -0700 (PDT)
Date: Fri, 6 Jul 2018 23:23:27 +0200
From: Oscar Salvador <osalvador@techadventures.net>
Subject: Re: [PATCH] mm/sparse.c: fix error path in sparse_add_one_section
Message-ID: <20180706212327.GA10824@techadventures.net>
References: <CAOxpaSVkLh23jN_=0GpZ77EhKdAYaiWKkppnxWwf_MRa5FvopA@mail.gmail.com>
 <20180706190658.6873-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180706190658.6873-1-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>, bhe@redhat.com, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, pasha.tatashin@oracle.com, Linux MM <linux-mm@kvack.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, osalvador@suse.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 06, 2018 at 01:06:58PM -0600, Ross Zwisler wrote:
> The following commit in -next:
> 
> commit 054620849110 ("mm/sparse.c: make sparse_init_one_section void and
> remove check")
> 
> changed how the error handling in sparse_add_one_section() works.
> 
> Previously sparse_index_init() could return -EEXIST, and the function would
> continue on happily.  'ret' would get unconditionally overwritten by the
> result from sparse_init_one_section() and the error code after the 'out:'
> label wouldn't be triggered.

My bad, I missed that.

> diff --git a/mm/sparse.c b/mm/sparse.c
> index 9574113fc745..d254bd2d3289 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -753,8 +753,12 @@ int __meminit sparse_add_one_section(struct pglist_data *pgdat,
>  	 * plus, it does a kmalloc
>  	 */
>  	ret = sparse_index_init(section_nr, pgdat->node_id);
> -	if (ret < 0 && ret != -EEXIST)
> -		return ret;
> +	if (ret < 0) {
> +		if (ret == -EEXIST)
> +			ret = 0;
> +		else
> +			return ret;
> +	}

sparse_index_init() can return:

-ENOMEM, -EEXIST or 0.

So what about this?:

diff --git a/mm/sparse.c b/mm/sparse.c
index f55e79fda03e..eb188eb6b82d 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -770,6 +770,7 @@ int __meminit sparse_add_one_section(struct pglist_data *pgdat,
        ret = sparse_index_init(section_nr, pgdat->node_id);
        if (ret < 0 && ret != -EEXIST)
                return ret;
+       ret = 0;

Does this look more clean?
-- 
Oscar Salvador
SUSE L3
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
