Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from tyo161.gate.nec.co.jp (tyo161.gate.nec.co.jp [114.179.232.161])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D4FE20968909
 for <linux-nvdimm@lists.01.org>; Mon, 16 Jul 2018 23:49:30 -0700 (PDT)
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH v6 05/13] mm, madvise_inject_error: Disable
 MADV_SOFT_OFFLINE for ZONE_DEVICE pages
Date: Tue, 17 Jul 2018 06:47:37 +0000
Message-ID: <20180717064736.GA27953@hori1.linux.bs1.fc.nec.co.jp>
References: <153154376846.34503.15480221419473501643.stgit@dwillia2-desk3.amr.corp.intel.com>
 <153154379606.34503.17311881160518829077.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153154379606.34503.17311881160518829077.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: ja-JP
Content-ID: <05DD4241F5D8DF4F92EBBCDB6A7040AD@gisp.nec.co.jp>
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
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "hch@lst.de" <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 13, 2018 at 09:49:56PM -0700, Dan Williams wrote:
> Given that dax / device-mapped pages are never subject to page
> allocations remove them from consideration by the soft-offline
> mechanism.
> 
> Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  mm/memory-failure.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 9d142b9b86dc..988f977db3d2 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1751,6 +1751,14 @@ int soft_offline_page(struct page *page, int flags)
>  	int ret;
>  	unsigned long pfn = page_to_pfn(page);
>  
> +	if (is_zone_device_page(page)) {
> +		pr_debug_ratelimited("soft_offline: %#lx page is device page\n",
> +				pfn);
> +		if (flags & MF_COUNT_INCREASED)
> +			put_page(page);

put_hwpoison_page(), which is just an alias of put_page(), is better
for consistency.
With this adjustment, feel free to add my ack.

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks,
Naoya Horiguchi

> +		return -EIO;
> +	}
> +
>  	if (PageHWPoison(page)) {
>  		pr_info("soft offline: %#lx page already poisoned\n", pfn);
>  		if (flags & MF_COUNT_INCREASED)
> 
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
