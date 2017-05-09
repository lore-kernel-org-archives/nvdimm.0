Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9360E21A0BABF
 for <linux-nvdimm@lists.01.org>; Tue,  9 May 2017 05:14:47 -0700 (PDT)
Date: Tue, 9 May 2017 14:14:44 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] dax: Fix data corruption when fault races with write
Message-ID: <20170509121444.GD21467@quack2.suse.cz>
References: <20170505072500.25692-1-jack@suse.cz>
 <20170505072500.25692-5-jack@suse.cz>
 <20170508172527.GA18408@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170508172527.GA18408@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 08-05-17 11:25:27, Ross Zwisler wrote:
> On Fri, May 05, 2017 at 09:25:00AM +0200, Jan Kara wrote:
> > Currently DAX read fault can race with write(2) in the following way:
> > 
> > CPU1 - write(2)			CPU2 - read fault
> > 				dax_iomap_pte_fault()
> > 				  ->iomap_begin() - sees hole
> > dax_iomap_rw()
> >   iomap_apply()
> >     ->iomap_begin - allocates blocks
> >     dax_iomap_actor()
> >       invalidate_inode_pages2_range()
> >         - there's nothing to invalidate
> > 				  grab_mapping_entry()
> > 				  - we add zero page in the radix tree
> > 				    and map it to page tables
> > 
> > The result is that hole page is mapped into page tables (and thus zeros
> > are seen in mmap) while file has data written in that place.
> > 
> > Fix the problem by locking exception entry before mapping blocks for the
> > fault. That way we are sure invalidate_inode_pages2_range() call for
> > racing write will either block on entry lock waiting for the fault to
> > finish (and unmap stale page tables after that) or read fault will see
> > already allocated blocks by write(2).
> > 
> > Fixes: 9f141d6ef6258a3a37a045842d9ba7e68f368956
> > CC: stable@vger.kernel.org
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Yep, this looks correct to me.  Thanks!
> 
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Thanks. I'll add your reviewed-by tag and send patches to Andrew for
inclusion.
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
