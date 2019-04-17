From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/18] dax: memcpy page in case of IOMAP_DAX_COW for mmap
 faults
Date: Wed, 17 Apr 2019 09:52:27 -0700
Message-ID: <20190417165227.GE4740@magnolia>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
 <20190416164154.30390-9-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190416164154.30390-9-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, nborisov-IBi9RG/b67k@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, dsterba-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Tue, Apr 16, 2019 at 11:41:44AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> 
> Change dax_iomap_pfn to return the address as well in order to
> use it for performing a memcpy in case the type is IOMAP_DAX_COW.
> 
> Question:
> The sequence of bdev_dax_pgoff() and dax_direct_access() is
> used multiple times to calculate address and pfn's. Would it make
> sense to call it while calculating address as well to reduce code?
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/dax.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 4b4ac51fbd16..45fc2e18969a 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -983,7 +983,7 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
>  }
>  
>  static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
> -			 pfn_t *pfnp)
> +			 pfn_t *pfnp, void **addr)
>  {
>  	const sector_t sector = dax_iomap_sector(iomap, pos);
>  	pgoff_t pgoff;
> @@ -995,7 +995,7 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
>  		return rc;
>  	id = dax_read_lock();
>  	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
> -				   NULL, pfnp);
> +				   addr, pfnp);
>  	if (length < 0) {
>  		rc = length;
>  		goto out;
> @@ -1280,6 +1280,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
>  	struct inode *inode = mapping->host;
>  	unsigned long vaddr = vmf->address;
> +	void *addr;
>  	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
>  	struct iomap iomap = { 0 };
>  	unsigned flags = IOMAP_FAULT;
> @@ -1369,16 +1370,23 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  	sync = dax_fault_is_synchronous(flags, vma, &iomap);
>  
>  	switch (iomap.type) {
> +	case IOMAP_DAX_COW:
>  	case IOMAP_MAPPED:
>  		if (iomap.flags & IOMAP_F_NEW) {
>  			count_vm_event(PGMAJFAULT);
>  			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
>  			major = VM_FAULT_MAJOR;
>  		}
> -		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
> +		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn, &addr);
>  		if (error < 0)
>  			goto error_finish_iomap;
>  
> +		if (iomap.type == IOMAP_DAX_COW) {
> +			if (iomap.inline_data)
> +				memcpy(addr, iomap.inline_data, PAGE_SIZE);

Same memcpy_mcsafe question from my reply to patch 4 applies here.

> +			else
> +				memset(addr, 0, PAGE_SIZE);
> +		}
>  		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
>  						 0, write && !sync);
>  
> @@ -1577,7 +1585,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  
>  	switch (iomap.type) {
>  	case IOMAP_MAPPED:
> -		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn);
> +		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn, NULL);

Same (unanswered) question from the v2 series -- doesn't a PMD fault
also require handling IOMAP_DAX_COW?

--D

>  		if (error < 0)
>  			goto finish_iomap;
>  
> -- 
> 2.16.4
> 
