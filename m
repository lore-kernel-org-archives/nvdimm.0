From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Date: Sat, 10 Sep 2016 08:55:57 +1000
Message-ID: <20160909225557.GF30056@dastard>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473438884-674-7-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Sep 09, 2016 at 06:34:40PM +0200, Christoph Hellwig wrote:
> Very similar to the existing dax_fault function, but instead of using
> the get_block callback we rely on the iomap_ops vector from iomap.c.
> That also avoids having to do two calls into the file system for write
> faults.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Just noticed this on a quick initial browse...

> +	if (vmf->cow_page) {
> +		switch (iomap.type) {
> +		case IOMAP_HOLE:
> +		case IOMAP_UNWRITTEN:
> +			clear_user_highpage(vmf->cow_page, vaddr);
> +			break;
> +		case IOMAP_MAPPED:
> +			error = copy_user_dax(iomap.bdev, sector, PAGE_SIZE,
> +					vmf->cow_page, vaddr);
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			error = -EIO;
> +			break;
> +		}
> +
> +		if (error)
> +			goto unlock_entry;
> +		if (!radix_tree_exceptional_entry(entry)) {
> +			vmf->page = entry;
> +			return VM_FAULT_LOCKED;
> +		}
> +		vmf->entry = entry;
> +		return VM_FAULT_DAX_LOCKED;
> +	}
> +
> +	switch (iomap.type) {
> +	case IOMAP_MAPPED:
> +		if (iomap.flags & IOMAP_F_NEW) {
> +			count_vm_event(PGMAJFAULT);
> +			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
> +			major = VM_FAULT_MAJOR;
> +		}
> +		break;
> +	case IOMAP_UNWRITTEN:
> +	case IOMAP_HOLE:
> +		if (!(vmf->flags & FAULT_FLAG_WRITE))
> +			return dax_load_hole(mapping, entry, vmf);
> +	default:
> +		WARN_ON_ONCE(1);
> +		error = -EIO;
> +	}

THe errors from the above two cases are not acted on. they are
immediately overwritten by:

> +
> +	/* Filesystem should not return unwritten buffers to us! */
> +	error = dax_insert_mapping(mapping, iomap.bdev, sector, PAGE_SIZE,
> +			&entry, vma, vmf);
> +unlock_entry:
> +	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
> +out:
> +	if (error == -ENOMEM)
> +		return VM_FAULT_OOM | major;
> +	/* -EBUSY is fine, somebody else faulted on the same PTE */
> +	if (error < 0 && error != -EBUSY)
> +		return VM_FAULT_SIGBUS | major;
> +	return VM_FAULT_NOPAGE | major;
> +}

Is there a missing "if (error) goto out;" check somewhere here?

I'm also wondering if you've looked at supporting the PMD fault case
with iomap?

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
