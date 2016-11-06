Return-Path: <linux-nvdimm-bounces@lists.01.org>
Message-ID: <b714bf30ee6577c5006f347b12b4f2fe.squirrel@webmail.raithlin.com>
In-Reply-To: <20161025211903.GD14023@dastard>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
 <CAPcyv4gJ_c-6s2BUjsu6okR1EF53R+KNuXnOc5jv0fuwJaa3cQ@mail.gmail.com>
 <20161019184814.GC16550@cgy1-donard.priv.deltatee.com>
 <20161020232239.GQ23194@dastard> <20161021095714.GA12209@infradead.org>
 <20161021111253.GQ14023@dastard>
 <20161025115043.GA14986@cgy1-donard.priv.deltatee.com>
 <20161025211903.GD14023@dastard>
Date: Sun, 6 Nov 2016 08:05:59 -0600
Subject: Re: [PATCH 0/3] iopmem : A block device for PCIe memory
From: "Stephen Bates" <sbates@raithlin.com>
MIME-Version: 1.0
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
Cc: linux-block@vger.kernel.org, sbates@raithin.com, "Raj, Ashok  <ashok.raj@intel.com>, haggaie@mellanox.com, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, jim.macdonald@everspin.com, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, Jens Axboe <axboe@fb.com>, David Woodhouse <dwmw2@infradead.org>, jgunthorpe@obsidianresearch.com
List-ID: <linux-nvdimm@lists.01.org>

On Tue, October 25, 2016 3:19 pm, Dave Chinner wrote:
> On Tue, Oct 25, 2016 at 05:50:43AM -0600, Stephen Bates wrote:
>>
>> Dave are you saying that even for local mappings of files on a DAX
>> capable system it is possible for the mappings to move on you unless the
>> FS supports locking?
>>
>
> Yes.
>
>
>> Does that not mean DAX on such FS is
>> inherently broken?
>
> No. DAX is accessed through a virtual mapping layer that abstracts
> the physical location from userspace applications.
>
> Example: think copy-on-write overwrites. It occurs atomically from
> the perspective of userspace and starts by invalidating any current
> mappings userspace has of that physical location. The location is changes,
> the data copied in, and then when the locks are released userspace can
> fault in a new page table mapping on the next access....

Dave

Thanks for the good input and for correcting some of my DAX
misconceptions! We will certainly be taking this into account as we
consider v1.

>
>>>> And at least for XFS we have such a mechanism :)  E.g. I have a
>>>> prototype of a pNFS layout that uses XFS+DAX to allow clients to do
>>>> RDMA directly to XFS files, with the same locking mechanism we use
>>>> for the current block and scsi layout in xfs_pnfs.c.
>>
>> Thanks for fixing this issue on XFS Christoph! I assume this problem
>> continues to exist on the other DAX capable FS?
>
> Yes, but it they implement the exportfs API that supplies this
> capability, they'll be able to use pNFS, too.
>
>> One more reason to consider a move to /dev/dax I guess ;-)...
>>
>
> That doesn't get rid of the need for sane access control arbitration
> across all machines that are directly accessing the storage. That's the
> problem pNFS solves, regardless of whether your direct access target is a
> filesystem, a block device or object storage...

Fair point. I am still hoping for a bit more discussion on the best choice
of user-space interface for this work. If/When that happens we will take
it into account when we look at spinning the patchset.


Stephen

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
