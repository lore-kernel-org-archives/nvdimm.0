Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EDC2281DFE
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 07:58:19 -0800 (PST)
Date: Mon, 23 Jan 2017 16:58:17 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/13] dax, pmem: move cpu cache maintenance to libnvdimm
Message-ID: <20170123155817.GA517@lst.de>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
 <BY2PR21MB0036C7BBC487D7C101F36DCFCB700@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170121175212.GA28180@lst.de>
 <BY2PR21MB00367799FE7B7E8302A99260CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170122162910.GA5267@lst.de>
 <BY2PR21MB00368E95CBB533D4C761C882CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170122183046.GA7359@lst.de>
 <BY2PR21MB0036CC7935BFE438EA001763CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170122184439.GA7603@lst.de>
 <BY2PR21MB0036CA85562DDD21814C0B27CB720@BY2PR21MB0036.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BY2PR21MB0036CA85562DDD21814C0B27CB720@BY2PR21MB0036.namprd21.prod.outlook.com>
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
To: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 23, 2017 at 06:37:18AM +0000, Matthew Wilcox wrote:
> Wow, DAX devices look painful and awful.  I certainly don't want to be
> exposing the memory fronted by my network filesystem to userspace to
> access.  That just seems like a world of pain and bad experiences.

So what is your interest in using DAX for your file system then instead
of a private mechanisms?

> Absolutely the filesystem (or perhaps better, the ACPI tables) need to
> mark that chunk of memory as reserved, but it's definitely not available
> for anyone to access without the filesystem being aware.

That does sounds like a massive special case all over the stack.
But until we see it I think we should simply ignore this case and
concentrate on what we have right now.

> Even if we let the filesystem create a DAX device that doesn't show
> up in /dev (for example), Dan's patches don't give us a way to go
> from a file on the filesystem to a set of dax_ops.

Which doesn't make sense any way.  The entry points into the file system
are read + write and mmap, and the file system might then use libraries
to implement different types of I/O, such as the page cache or DAX.

> And it does need to be a per-file operation, eg to support a file on
> an XFS volume which might be on a RT device or a normal device.
> That was why I leaned towards an address_space operation, but I'd be
> happy to see an inode_operation instead. 

Again, no.  The layers above the file system have absolutely no business
to even know if we're using DAX or pagecache access, nevermind how
in detail they are used.  Assuming you want to use DAX-like semantics
it's up to the lower level to expose the correct operations for
a given memory region.  Right now these would just be intel nfit or
legacy 820 + ADR for regions marked such in the memory map.  If say
a hypervisor wants to expose a region that needs a special flush
call or even has requirements on the type of memcpy it needs to
provide operations for this memory region.  The user of this region
(DAX-native file system pmem driver or device DAX) then needs
to use these methods.

And those pretty much are the methods Dan proposes here - it's
just that we should not tie them to block device operations, at
least not in the long run.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
