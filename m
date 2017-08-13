Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCFD121DFC871
 for <linux-nvdimm@lists.01.org>; Sun, 13 Aug 2017 02:22:15 -0700 (PDT)
Date: Sun, 13 Aug 2017 11:24:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
Message-ID: <20170813092436.GB32112@lst.de>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com>
 <20170805095013.GC14930@lst.de>
 <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com>
 <20170811104429.GA13736@lst.de>
 <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ@mail.gmail.com>
 <20170812073349.GA12679@lst.de>
 <CAPcyv4iKG=Zoo1VXu23YBc6uWDFV4QSS+eAm9MSOynx2FjTHbw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iKG=Zoo1VXu23YBc6uWDFV4QSS+eAm9MSOynx2FjTHbw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Aug 12, 2017 at 12:19:50PM -0700, Dan Williams wrote:
> The application does not need to know the storage address, it needs to
> know that the storage address to file offset is fixed. With this
> information it can make assumptions about the permanence of results it
> gets from the kernel.

Only if we clearly document that fact - and documenting the permanence
is different from saying the block map won't change.

> For example get_user_pages() today makes no guarantees outside of
> "page will not be freed",

It also makes the extremely important gurantee that the page won't
_move_ - e.g. that we won't do a memory migration for compaction or
other reasons.  That's why for example RDMA can use to register
memory and then we can later set up memory windows that point to this
registration from userspace and implement userspace RDMA.

> but with immutable files and dax you now
> have a mechanism for userspace to coordinate direct access to storage
> addresses. Those raw storage addresses need not be exposed to the
> application, as you say it doesn't need to know that detail. MAP_SYNC
> does not fully satisfy this case because it requires agents that can
> generate MMU faults to coordinate with the filesystem.

The file system is always in the fault path, can you explain what other
agents you are talking about?

> All I know is that SMB Direct for persistent memory seems like a
> potential consumer. I know they're not going to use a userspace
> filesystem or put an SMB server in the kernel.

Last I talked to the Samba folks they didn't expect a userspace
SMB direct implementation to work anyway due to the fact that
libibverbs memory registrations interact badly with their fork()ing
daemon model.  That being said during the recent submission of the
RDMA client code some comments were made about userspace versions of
it, so I'm not sure if that opinion has changed in one way or another.

Thay being said I think we absolutely should support RDMA memory
registrations for DAX mappings.  I'm just not sure how S_IOMAP_IMMUTABLE
helps with that.  We'll want a MAP_SYNC | MAP_POPULATE to make sure
all the blocks are polulated and all ptes are set up.  Second we need
to make sure get_user_page works, which for now means we'll need a
struct page mapping for the region (which will be really annoying
for PCIe mappings, like the upcoming NVMe persistent memory region),
and we need to gurantee that the extent mapping won't change while
the get_user_pages holds the pages inside it.  I think that is true
due to side effects even with the current DAX code, but we'll need to
make it explicit.  And maybe that's where we need to converge - 
"sealing" the extent map makes sense as such a temporary measure
that is not persisted on disk, which automatically gets released
when the holding process exits, because we sort of already do this
implicitly.  It might also make sense to have explicitl breakable
seals similar to what I do for the pNFS blocks kernel server, as
any userspace RDMA file server would also need those semantics.

Last but not least we have any interesting additional case for modern
Mellanox hardware - On Demand Paging where we don't actually do a
get_user_pages but the hardware implements SVM and thus gets fed
virtual addresses directly.  My head spins when talking about the
implications for DAX mappings on that, so I'm just throwing that in
for now instead of trying to come up with a solution.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
