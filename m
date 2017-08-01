Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
 [150.101.137.143])
 by ml01.01.org (Postfix) with ESMTP id 05DF321E11D9F
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 19:40:12 -0700 (PDT)
Date: Tue, 1 Aug 2017 12:42:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] fs, xfs: introduce S_IOMAP_IMMUTABLE
Message-ID: <20170801024218.GN17762@dastard>
References: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150135741519.35318.16765137368329971936.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1501516968.579311.1058393288.0714478A@webmail.messagingengine.com>
 <CAPcyv4h_YWaAXG5pfkOJ0M74i5yEke1SoC3ESErTh41hngtG-w@mail.gmail.com>
 <1501518747.586018.1058450568.4B6F28FB@webmail.messagingengine.com>
 <1501522933.602272.1058529880.6C4A2D98@webmail.messagingengine.com>
 <20170731182352.GE4477@magnolia>
 <1501553712.1055225.1059044352.109C04CB@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1501553712.1055225.1059044352.109C04CB@webmail.messagingengine.com>
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
To: Colin Walters <walters@verbum.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 31, 2017 at 10:15:12PM -0400, Colin Walters wrote:
> On Mon, Jul 31, 2017, at 02:23 PM, Darrick J. Wong wrote:
> 
> > I don't think F_SEAL_{SHRINK,GROW} prevents reflinking or CoW of file data,
> > which are two things that cannot happen under S_IOMAP_IMMUTABLE that
> > aren't size changes.  From the implementation it looks like shrink and
> > grow are only supposed to disallow changes to i_size, not i_blocks (or
> > the file block map).
> 
> True. 
> 
> > Then again, I suppose F_SEAL_* only work on shmem, so maybe it simply
> > isn't defined for any other filesystem...?  e.g. it doesn't prohibit
> > reflink, but the only fs implementing seals doesn't support reflink.
> > 
> > <shrug>
> > 
> > Seals cannot be removed, which is too strict for the S_IOMAP_IMMUTABLE
> > user cases being presented.
> 
> To be clear, the set of use cases is swap files and DAX, right?  Or is there anything else?

I've outlined other use cases in previous discussions. To repeat
myself, every so often we get someone with, say, a new high
speed camera that want to dma the camera frames direct to the
storage because they can't push 500,000 frames/s through the CPU
to storage. Hence they want to bypass the OS and DMA the data direct
to the storage. To do this they need a mechanism to freeze and unfreeze
the block map of the file so that nothing modifies the block map
while the camera hardware is dumping data direct to the storage.
Immutable extent maps provide the functionality they need to
implement this safely.

There's also other similar use cases for RDMA targets on PMEM
(regardless of whether DAX is enabled or not), and I've come across
a couple of requests for mechanisms to allow fabric based nvme
storage to do direct data transfers between storage devices, too.
All of these use cases can be safely implemented if there is a
mechanism to mark extent maps as immutable for the duration of
the operation they need to perform.

> I can't imagine why anyone would want to turn a swap file back into a regular file.
> I haven't fully followed DAX, but I'd take your word for it if people want to
> be able to remove the flag after.

DAX isn't the driver of that functionality, it's the other use cases
that need it, and why the proposed "only remove flag if len == 0"
API is a non-starter....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
