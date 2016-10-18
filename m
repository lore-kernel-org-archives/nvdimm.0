Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 418A31A1E0F
 for <linux-nvdimm@lists.01.org>; Tue, 18 Oct 2016 12:53:33 -0700 (PDT)
Date: Tue, 18 Oct 2016 13:53:32 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 19/20] dax: Protect PTE modification on WP fault by radix
 tree entry lock
Message-ID: <20161018195332.GF7796@linux.intel.com>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-20-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1474992504-20133-20-git-send-email-jack@suse.cz>
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
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 27, 2016 at 06:08:23PM +0200, Jan Kara wrote:
> Currently PTE gets updated in wp_pfn_shared() after dax_pfn_mkwrite()
> has released corresponding radix tree entry lock. When we want to
> writeprotect PTE on cache flush, we need PTE modification to happen
> under radix tree entry lock to ensure consisten updates of PTE and radix
					consistent

> tree (standard faults use page lock to ensure this consistency). So move
> update of PTE bit into dax_pfn_mkwrite().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/dax.c    | 22 ++++++++++++++++------
>  mm/memory.c |  2 +-
>  2 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index c6cadf8413a3..a2d3781c9f4e 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1163,17 +1163,27 @@ int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
>  	struct file *file = vma->vm_file;
>  	struct address_space *mapping = file->f_mapping;
> -	void *entry;
> +	void *entry, **slot;
>  	pgoff_t index = vmf->pgoff;
>  
>  	spin_lock_irq(&mapping->tree_lock);
> -	entry = get_unlocked_mapping_entry(mapping, index, NULL);
> -	if (!entry || !radix_tree_exceptional_entry(entry))
> -		goto out;
> +	entry = get_unlocked_mapping_entry(mapping, index, &slot);
> +	if (!entry || !radix_tree_exceptional_entry(entry)) {
> +		if (entry)
> +			put_unlocked_mapping_entry(mapping, index, entry);

I don't think you need this call to put_unlocked_mapping_entry().  If we get
in here we know that 'entry' is a page cache page, in which case
put_unlocked_mapping_entry() will just return without doing any work.

With that nit & the spelling error above:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
