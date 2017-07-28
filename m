Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C124C21E2571F
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 02:37:58 -0700 (PDT)
Date: Fri, 28 Jul 2017 11:40:01 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/7] dax: Add sync argument to dax_iomap_fault()
Message-ID: <20170728094001.GC29433@quack2.suse.cz>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-3-jack@suse.cz>
 <20170727220637.GC22000@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170727220637.GC22000@linux.intel.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 27-07-17 16:06:37, Ross Zwisler wrote:
> On Thu, Jul 27, 2017 at 03:12:40PM +0200, Jan Kara wrote:
> > Add 'sync' argument to dax_iomap_fault(). It will be used to communicate
> > the fact that synchronous fault is requested.
> 
> I don't actually think you need to pass this 'sync' parameter around.  I think
> you can completely rely on IOMAP_F_NEEDSYNC being set in iomap.flags.  The DAX
> fault handlers can call ops->iomap_begin() and use that flag for all the
> tests and make it our once source of truth.
> 
> That flag also tells us that we are doing a write fault (from
> ext4_iomap_begin()):
> 
> 	if ((flags & IOMAP_FAULT) && (flags & IOMAP_WRITE) && IS_SYNC(inode) &&
> 	    !jbd2_transaction_committed(EXT4_SB(inode->i_sb)->s_journal,
> 					EXT4_I(inode)->i_datasync_tid))
> 		iomap->flags |= IOMAP_F_NEEDDSYNC;
> 
> So conditionals like this from dax_iomap_pte_fault():
> 
> 	force_ro = (vmf->flags & FAULT_FLAG_WRITE) && sync &&
> 			(iomap.flags & IOMAP_F_NEEDDSYNC);
> 
> can be simplified to:
> 
> 	force_ro = (iomap.flags & IOMAP_F_NEEDDSYNC);

Yeah, probably you're right. I'll look into changing this.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
