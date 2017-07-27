Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F1E621D491AB
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 06:10:46 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Date: Thu, 27 Jul 2017 15:12:38 +0200
Message-Id: <20170727131245.28279-1-jack@suse.cz>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hello,

after last discussions about whether / how to make flushing of DAX mappings
possible from userspace so that they can be flushed on finer than page
granularity and also avoid the overhead of a syscall, I've decided to give
a stab at implementing "synchronous page faults" idea for ext4 so that
we can see whether that is reasonably possible to implement and how would
such implementation look like. This patch set is the result.

So the functionality this patches implement: We have an inode flag (currently
I abuse S_SYNC inode flag for this and IMHO it kind of makes sense but if
people hate that I'm certainly open to using new flag in the final
implementation) that marks inode as requiring synchronous page faults.
The guarantee provided by this flag on inode is: While a block is writeably
mapped into page tables, it is guaranteed to be visible in the file at that
offset also after a crash.

How I implement this is that ->iomap_begin() indicates by a flag that inode
block mapping metadata is unstable and may need flushing (use the same test as
whether fdatasync() has metadata to write). If yes, DAX maps page table entries
read-only and returns special flag VM_FAULT_RO to the filesystem fault handler.
The handler then calls fdatasync() (vfs_fsync_range()) for the affected range
and after that calls DAX code to write-enable the page table entries.

>From my (fairly limited) knowledge of XFS it seems XFS should be able to do the
same and it should be even possible for filesystem to implement safe remapping
of a file offset to a different block (i.e. break reflink, do defrag, or
similar stuff) like:

1) Block page faults
2) fdatasync() remapped range (there can be outstanding data modifications
   not yet flushed)
3) unmap_mapping_range()
4) Now remap blocks
5) Unblock page faults

Basically we do the same on events like punch hole so there is not much new
there.

There are couple of open questions with this implementation:

1) Is it worth the hassle?
2) Is S_SYNC good flag to use or should we use a new inode flag?
3) VM_FAULT_RO and especially passing of resulting 'pfn' from
   dax_iomap_fault() through filesystem fault handler to dax_pfn_mkwrite() in
   vmf->orig_pte is a bit of a hack. So far I'm not sure how to refactor
   things to make this cleaner.

Anyway, here are the patches, comments are welcome.

								Honza
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
