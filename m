Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5DFEC2034A88C
 for <linux-nvdimm@lists.01.org>; Fri, 27 Oct 2017 02:09:17 -0700 (PDT)
Date: Fri, 27 Oct 2017 11:13:01 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 17/17] xfs: support for synchronous DAX faults
Message-ID: <20171027091301.GG31161@quack2.suse.cz>
References: <20171024152415.22864-1-jack@suse.cz>
 <20171024152415.22864-18-jack@suse.cz>
 <20171024222322.GX3666@dastard>
 <20171026154804.GF31161@quack2.suse.cz>
 <20171027064301.GC22931@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171027064301.GC22931@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri 27-10-17 08:43:01, Christoph Hellwig wrote:
> On Thu, Oct 26, 2017 at 05:48:04PM +0200, Jan Kara wrote:
> > But now that I look at XFS implementation again, it misses handling
> > of VM_FAULT_NEEDSYNC in xfs_filemap_pfn_mkwrite() (ext4 gets this right).
> > I'll fix this by using __xfs_filemap_fault() for xfs_filemap_pfn_mkwrite()
> > as well since it mostly duplicates it anyway... Thanks for inquiring!
> 
> My first patches move xfs_filemap_pfn_mkwrite to use __xfs_filemap_fault,
> but that didn't work.  Wish I'd remember why, though.

Maybe due to the additional check on IS_DAX(inode) in __xfs_filemap_fault()
which could do the wrong thing if per-inode DAX flag is switched? Because
otherwise __xfs_filemap_fault(vmf, PE_SIZE_PTE, true) does exactly the same
thing as xfs_filemap_pfn_mkwrite() did.

If we do care about per-inode DAX flag switching, I can just fixup
xfs_filemap_pfn_mkwrite() but my understanding was that we ditched the idea
at least until someone comes up with a reliable way to implement that...

							Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
