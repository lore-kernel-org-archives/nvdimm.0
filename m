Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 16E0E21AEB0A7
 for <linux-nvdimm@lists.01.org>; Sat,  5 Aug 2017 02:43:45 -0700 (PDT)
Date: Sat, 5 Aug 2017 11:45:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] fs, xfs: introduce S_IOMAP_IMMUTABLE
Message-ID: <20170805094556.GA14930@lst.de>
References: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150135741519.35318.16765137368329971936.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1501516968.579311.1058393288.0714478A@webmail.messagingengine.com>
 <CAPcyv4h_YWaAXG5pfkOJ0M74i5yEke1SoC3ESErTh41hngtG-w@mail.gmail.com>
 <1501518747.586018.1058450568.4B6F28FB@webmail.messagingengine.com>
 <1501522933.602272.1058529880.6C4A2D98@webmail.messagingengine.com>
 <20170731182352.GE4477@magnolia>
 <1501553712.1055225.1059044352.109C04CB@webmail.messagingengine.com>
 <20170801024218.GN17762@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170801024218.GN17762@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Colin Walters <walters@verbum.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 01, 2017 at 12:42:18PM +1000, Dave Chinner wrote:
> I've outlined other use cases in previous discussions. To repeat
> myself, every so often we get someone with, say, a new high
> speed camera that want to dma the camera frames direct to the
> storage because they can't push 500,000 frames/s through the CPU
> to storage. Hence they want to bypass the OS and DMA the data direct
> to the storage. To do this they need a mechanism to freeze and unfreeze
> the block map of the file so that nothing modifies the block map
> while the camera hardware is dumping data direct to the storage.
> Immutable extent maps provide the functionality they need to
> implement this safely.

And we have such a mechanism already: it's called the iolock during
I/O, and dirct I/O.  I've worked on plenty such schemes and the proper way
works perfectly fine.  Just because people ask for stupid ways to
archives that doesn't mean they understand what they are doing.

> There's also other similar use cases for RDMA targets on PMEM
> (regardless of whether DAX is enabled or not), and I've come across
> a couple of requests for mechanisms to allow fabric based nvme
> storage to do direct data transfers between storage devices, too.
> All of these use cases can be safely implemented if there is a
> mechanism to mark extent maps as immutable for the duration of
> the operation they need to perform.

As someone who spent most of them time on the last 2 years in this
area: we have a massive problem discoverability and addressing
(lack of struct page) for p2p devices.  We have absolutely no problem
with the direct I/O model with them.

> DAX isn't the driver of that functionality, it's the other use cases
> that need it, and why the proposed "only remove flag if len == 0"
> API is a non-starter....

The other "use" cases are even more bullshit than the DAX one.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
