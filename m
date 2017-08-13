Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22f.google.com (mail-yw0-x22f.google.com
 [IPv6:2607:f8b0:4002:c05::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CC3232095E004
 for <linux-nvdimm@lists.01.org>; Sun, 13 Aug 2017 13:29:24 -0700 (PDT)
Received: by mail-yw0-x22f.google.com with SMTP id p68so45708598ywg.0
 for <linux-nvdimm@lists.01.org>; Sun, 13 Aug 2017 13:31:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170813092436.GB32112@lst.de>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com>
 <20170805095013.GC14930@lst.de>
 <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com>
 <20170811104429.GA13736@lst.de>
 <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ@mail.gmail.com>
 <20170812073349.GA12679@lst.de>
 <CAPcyv4iKG=Zoo1VXu23YBc6uWDFV4QSS+eAm9MSOynx2FjTHbw@mail.gmail.com>
 <20170813092436.GB32112@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 13 Aug 2017 13:31:45 -0700
Message-ID: <CAPcyv4ixTgSWG9K2Eg3XJmOvqJht81qL+Z3njoOjcXCD7XMpZw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Aug 13, 2017 at 2:24 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Sat, Aug 12, 2017 at 12:19:50PM -0700, Dan Williams wrote:
>> The application does not need to know the storage address, it needs to
>> know that the storage address to file offset is fixed. With this
>> information it can make assumptions about the permanence of results it
>> gets from the kernel.
>
> Only if we clearly document that fact - and documenting the permanence
> is different from saying the block map won't change.

I can get on board with that.

>
>> For example get_user_pages() today makes no guarantees outside of
>> "page will not be freed",
>
> It also makes the extremely important gurantee that the page won't
> _move_ - e.g. that we won't do a memory migration for compaction or
> other reasons.  That's why for example RDMA can use to register
> memory and then we can later set up memory windows that point to this
> registration from userspace and implement userspace RDMA.
>
>> but with immutable files and dax you now
>> have a mechanism for userspace to coordinate direct access to storage
>> addresses. Those raw storage addresses need not be exposed to the
>> application, as you say it doesn't need to know that detail. MAP_SYNC
>> does not fully satisfy this case because it requires agents that can
>> generate MMU faults to coordinate with the filesystem.
>
> The file system is always in the fault path, can you explain what other
> agents you are talking about?

Exactly the one's you mention below. SVM hardware can just use a
MAP_SYNC mapping and be sure that its metadata dirtying writes are
synchronized with the filesystem through the fault path. Hardware that
does not have SVM, or hypervisors like Xen that want to attach their
own static metadata about the file offset to physical block mapping,
need a mechanism to make sure the block map is sealed while they have
it mapped.

>> All I know is that SMB Direct for persistent memory seems like a
>> potential consumer. I know they're not going to use a userspace
>> filesystem or put an SMB server in the kernel.
>
> Last I talked to the Samba folks they didn't expect a userspace
> SMB direct implementation to work anyway due to the fact that
> libibverbs memory registrations interact badly with their fork()ing
> daemon model.  That being said during the recent submission of the
> RDMA client code some comments were made about userspace versions of
> it, so I'm not sure if that opinion has changed in one way or another.

Ok.

>
> Thay being said I think we absolutely should support RDMA memory
> registrations for DAX mappings.  I'm just not sure how S_IOMAP_IMMUTABLE
> helps with that.  We'll want a MAP_SYNC | MAP_POPULATE to make sure
> all the blocks are polulated and all ptes are set up.  Second we need
> to make sure get_user_page works, which for now means we'll need a
> struct page mapping for the region (which will be really annoying
> for PCIe mappings, like the upcoming NVMe persistent memory region),
> and we need to gurantee that the extent mapping won't change while
> the get_user_pages holds the pages inside it.  I think that is true
> due to side effects even with the current DAX code, but we'll need to
> make it explicit.  And maybe that's where we need to converge -
> "sealing" the extent map makes sense as such a temporary measure
> that is not persisted on disk, which automatically gets released
> when the holding process exits, because we sort of already do this
> implicitly.  It might also make sense to have explicitl breakable
> seals similar to what I do for the pNFS blocks kernel server, as
> any userspace RDMA file server would also need those semantics.

Ok, how about a MAP_DIRECT flag that arranges for faults to that range to:

    1/ only succeed if the fault can be satisfied without page cache

    2/ only install a pte for the fault if it can do so without
triggering block map updates

So, I think it would still end up setting an inode flag to make
xfs_bmapi_write() fail while any process has a MAP_DIRECT mapping
active. However, it would not record that state in the on-disk
metadata and it would automatically clear at munmap time. That should
be enough to support the host-persistent-memory, and
NVMe-persistent-memory use cases (provided we have struct page for
NVMe). Although, we need more safety infrastructure in the NVMe case
where we would need to software manage I/O coherence.

> Last but not least we have any interesting additional case for modern
> Mellanox hardware - On Demand Paging where we don't actually do a
> get_user_pages but the hardware implements SVM and thus gets fed
> virtual addresses directly.  My head spins when talking about the
> implications for DAX mappings on that, so I'm just throwing that in
> for now instead of trying to come up with a solution.

Yeah, DAX + SVM needs more thought.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
