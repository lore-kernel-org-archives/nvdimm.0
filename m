Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C92621E2570E
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 16:02:37 -0700 (PDT)
Date: Thu, 27 Jul 2017 17:04:40 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 6/7] dax: Implement dax_pfn_mkwrite()
Message-ID: <20170727230440.GI22000@linux.intel.com>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-7-jack@suse.cz>
 <20170727225322.GG22000@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170727225322.GG22000@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Andy Lutomirski <luto@kernel.org>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 27, 2017 at 04:53:22PM -0600, Ross Zwisler wrote:
> On Thu, Jul 27, 2017 at 03:12:44PM +0200, Jan Kara wrote:
> > Implement a function that marks existing page table entry (PTE or PMD)
> > as writeable and takes care of marking it dirty in the radix tree. This
> > function will be used to finish synchronous page fault where the page
> > table entry is first inserted as read-only and then needs to be marked
> > as read-write.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
<>
> > +	radix_tree_tag_set(&mapping->page_tree, index, PAGECACHE_TAG_DIRTY);
> > +	entry = lock_slot(mapping, slot);
> > +	spin_unlock_irq(&mapping->tree_lock);
> > +	switch (pe_size) {
> > +	case PE_SIZE_PTE:
> > +		error = vm_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
> 
> This path goes through the 'mkwrite' branch in insert_pfn() where we validate
> that the PFN we are about to map matches the one pointed to by the existing
> PTE, but I don't see any checks in this path that validate against
> vmf->orig_pte?
> 
> This kind of check was done by the old
> dax_pfn_mkwrite()->finish_mkwrite_fault() path via the pte_same() check in
> finish_mkwrite_fault().
> 
> Do we need to add an equivalent check somewhere in this path, since we're
> going through the trouble of setting vmf->orig_pte in the DAX fault handlers?

Or, actually, does the fact that we do the PFN based sanity check in
insert_pfn() mean that we don't actually need to set vmf->orig_pte in the DAX
fault handlers at all?  We already sanity check the PFN of the RW PTE we
insert against what is already in the page table, and maybe we don't need to
keep another copy around in vmf->orig_pte to verify against?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
