Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C89192095B9D8
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 00:15:47 -0700 (PDT)
Date: Thu, 24 Aug 2017 09:18:19 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 13/13] ext4: Support for synchronous DAX faults
Message-ID: <20170824071819.GC20465@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-14-jack@suse.cz>
 <20170823183714.GH13778@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170823183714.GH13778@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, Boaz Harrosh <boazh@netapp.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 23-08-17 11:37:14, Christoph Hellwig wrote:
> > +	pfn_t pfn;
> >  
> >  	if (write) {
> >  		sb_start_pagefault(sb);
> > @@ -287,16 +288,39 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
> >  		down_read(&EXT4_I(inode)->i_mmap_sem);
> >  		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
> >  					       EXT4_DATA_TRANS_BLOCKS(sb));
> > +		if (IS_ERR(handle)) {
> > +			up_read(&EXT4_I(inode)->i_mmap_sem);
> > +			sb_end_pagefault(sb);
> > +			return VM_FAULT_SIGBUS;
> > +		}
> >  	} else {
> >  		down_read(&EXT4_I(inode)->i_mmap_sem);
> >  	}
> > -	if (!IS_ERR(handle))
> > -		result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops, NULL);
> > -	else
> > -		result = VM_FAULT_SIGBUS;
> > +	result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops, &pfn);
> 
> Maybe split the error handling refactor into a simple prep patch to
> make this one more readable?

OK, will do.

> > +		/* Write fault but PFN mapped only RO? */
> > +		if (result & VM_FAULT_NEEDDSYNC) {
> > +			int err;
> > +			loff_t start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
> > +			size_t len = 0;
> > +
> > +			if (pe_size == PE_SIZE_PTE)
> > +				len = PAGE_SIZE;
> > +#ifdef CONFIG_FS_DAX_PMD
> > +			else if (pe_size == PE_SIZE_PMD)
> > +				len = HPAGE_PMD_SIZE;
> > +#endif
> > +			else
> > +				WARN_ON_ONCE(1);
> > +			err = vfs_fsync_range(vmf->vma->vm_file, start,
> > +					      start + len - 1, 1);
> > +			if (err)
> > +				result = VM_FAULT_SIGBUS;
> > +			else
> > +				result = dax_insert_pfn_mkwrite(vmf, pe_size,
> > +								pfn);
> > +		}
> 
> I think this needs to become a helper exported from the DAX code,
> way too much magic inside the file system as-is.

Good point, there isn't anything fs specific in there.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
