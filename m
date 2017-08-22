Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F4ED21E49BCA
 for <linux-nvdimm@lists.01.org>; Tue, 22 Aug 2017 03:15:34 -0700 (PDT)
Date: Tue, 22 Aug 2017 12:18:04 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 13/13] ext4: Support for synchronous DAX faults
Message-ID: <20170822101804.GG4909@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-14-jack@suse.cz>
 <20170821191948.GD26220@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170821191948.GD26220@linux.intel.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 21-08-17 13:19:48, Ross Zwisler wrote:
> On Thu, Aug 17, 2017 at 06:08:15PM +0200, Jan Kara wrote:
> > We return IOMAP_F_NEEDDSYNC flag from ext4_iomap_begin() for a
> > synchronous write fault when inode has some uncommitted metadata
> > changes. In the fault handler ext4_dax_fault() we then detect this case,
> > call vfs_fsync_range() to make sure all metadata is committed, and call
> > dax_pfn_mkwrite() to mark PTE as writeable. Note that this will also
> 
> Need to fix up the above line a little -
> s/dax_pfn_mkwrite/dax_insert_pfn_mkwrite/, and we insert the PTE as well as
> make it writeable.

Fixed up, thanks.

> >  	if (write) {
> > -		if (!IS_ERR(handle))
> > -			ext4_journal_stop(handle);
> > +		ext4_journal_stop(handle);
> > +		/* Write fault but PFN mapped only RO? */
> 
> The above comment is out of date.

Fixed.

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
> 
> In fs/dax.c we always use PMD_SIZE.  It looks like HPAGE_PMD_SIZE and PMD_SIZE
> are always the same (from include/linux/huge_mm.h, the only defintion of
> HPAGE_PMD_SIZE):
> 
> #define HPAGE_PMD_SHIFT PMD_SHIFT
> #define HPAGE_PMD_SIZE	((1UL) << HPAGE_PMD_SHIFT)
> 
> and AFAICT PMD_SIZE is defined to be 1<<PMD_SHIFT for all architectures as
> well.  I don't understand why we have both?
> 
> In any case, neither HPAGE_PMD_SIZE nor PMD_SIZE are used anywhere else in the
> ext4 code, so can we use PMD_SIZE here for consistency?  If they ever did
> manage to be different, I think we'd want PMD_SIZE anyway.

Yeah, I've changed that to PMD_SIZE.

> With those nits and an updated changelog:
> 
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Thanks!

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
