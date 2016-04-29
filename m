Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 48D421A1F83
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 12:08:06 -0700 (PDT)
Date: Fri, 29 Apr 2016 13:08:05 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 11/18] dax: Fix condition for filling of PMD holes
Message-ID: <20160429190805.GF5888@linux.intel.com>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <1461015341-20153-12-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461015341-20153-12-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 18, 2016 at 11:35:34PM +0200, Jan Kara wrote:
> Currently dax_pmd_fault() decides to fill a PMD-sized hole only if
> returned buffer has BH_Uptodate set. However that doesn't get set for
> any mapping buffer so that branch is actually a dead code. The
> BH_Uptodate check doesn't make any sense so just remove it.

I'm not sure about this one.  In my testing (which was a while ago) I was
also never able to exercise this code path and create huge zero pages.   My
concern is that by removing the buffer_uptodate() check, we will all of a
sudden start running through a code path that was previously unreachable.

AFAICT the buffer_uptodate() was part of the original PMD commit.  Did we ever
get buffers with BH_Uptodate set?  Has this code ever been run?  Does it work?

I suppose this concern is mitigated by the fact that later in this series you 
disable the PMD path entirely, but maybe we should just leave it as is and
turn it off, then clean it up if/when we reenable it when we add multi-order
radix tree locking for PMDs?

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/dax.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 237581441bc1..42bf65b4e752 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -878,7 +878,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  		goto fallback;
>  	}
>  
> -	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
> +	if (!write && !buffer_mapped(&bh)) {
>  		spinlock_t *ptl;
>  		pmd_t entry;
>  		struct page *zero_page = get_huge_zero_page();
> -- 
> 2.6.6
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
