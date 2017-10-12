Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 05FDB21F38831
 for <linux-nvdimm@lists.01.org>; Thu, 12 Oct 2017 10:38:22 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id q4so9718259oic.7
 for <linux-nvdimm@lists.01.org>; Thu, 12 Oct 2017 10:41:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171012142319.GA11254@lst.de>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012142319.GA11254@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Oct 2017 10:41:39 -0700
Message-ID: <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com>
Subject: Re: [PATCH v9 0/6] MAP_DIRECT for DAX userspace flush
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 12, 2017 at 7:23 AM, Christoph Hellwig <hch@lst.de> wrote:
> Sorry for chiming in so late, been extremely busy lately.
>
> From quickly glacing over what the now finally described use case is
> (which contradicts the subject btw - it's not about flushing, it's
> about not removing block mapping under a MR) and the previous comments
> I think that mmap is simply the wrong kind of interface for this.
>
> What we want is support for a new kinds of userspace memory registration in the
> RDMA code that uses the pnfs export interface, both getting the block (or
> rather byte in this case) mapping, and also gets the FL_LAYOUT lease for the
> memory registration.
>
> That btw is exactly what I do for the pNFS RDMA layout, just in-kernel.

...and this is exactly my plan.

So, you're jumping into this review at v9 where I've split the patches
that take an initial MAP_DIRECT lease out from the patches that take
FL_LAYOUT leases at memory registration time. You can see a previous
attempt in "[PATCH v8 00/14] MAP_DIRECT for DAX RDMA and userspace
flush" which should be in your inbox.

I'm not proposing mmap as the memory registration interface, it's the
"register for notification of lease break" interface. Here's my
proposed sequence:

addr = mmap(..., MAP_DIRECT.., fd); <- register a vma for "direct"
memory registrations with an FL_LAYOUT lease that at a lease break
event sends SIGIO on the fd used for mmap.

ibv_reg_mr(..., addr, ...); <- check for a valid MAP_DIRECT vma, and
take out another FL_LAYOUT lease. This lease force revokes the RDMA
mapping when it expires, and it relies on the process receiving SIGIO
as the 'break' notification.

fallocate(fd, PUNCH_HOLE...) <- breaks all the FL_LAYOUT leases, the
vma owner gets notified by fd.

Al, rightly points out that the fd may be closed by the time the event
fires since the lease follows the vma lifetime. I see two ways to
solve this, document that the process may get notifications on a stale
fd if close() happens before munmap(), or, similar to how we call
locks_remove_posix() in filp_close(), add a routine to disable any
lease notifiers on close(). I'll investigate the second option because
this seems to be a general problem with leases.

For RDMA I am presently re-working the implementation [1]. Inspired by
a discussion with Jason [2], I am going to add something like
ib_umem_ops to allow drivers to override the default policy of what
happens on a lease that expires. The default action is to invalidate
device access to the memory with iommu_unmap(), but I want to allow
for drivers to do something smarter or choose to not support DAX
mappings at all.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-October/012785.html
[2]: https://lists.01.org/pipermail/linux-nvdimm/2017-October/012793.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
