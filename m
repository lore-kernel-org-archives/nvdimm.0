Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Fri, 21 Oct 2016 22:12:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] iopmem : A block device for PCIe memory
Message-ID: <20161021111253.GQ14023@dastard>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
 <CAPcyv4gJ_c-6s2BUjsu6okR1EF53R+KNuXnOc5jv0fuwJaa3cQ@mail.gmail.com>
 <20161019184814.GC16550@cgy1-donard.priv.deltatee.com>
 <20161020232239.GQ23194@dastard>
 <20161021095714.GA12209@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161021095714.GA12209@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: jgunthorpe@obsidianresearch.com, sbates@raithin.com, "Raj, Ashok  <ashok.raj@intel.com>, haggaie@mellanox.com, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, jim.macdonald@everspin.com, Stephen Bates <sbates@raithlin.com>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jens Axboe <axboe@fb.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 21, 2016 at 02:57:14AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 21, 2016 at 10:22:39AM +1100, Dave Chinner wrote:
> > You do realise that local filesystems can silently change the
> > location of file data at any point in time, so there is no such
> > thing as a "stable mapping" of file data to block device addresses
> > in userspace?
> > 
> > If you want remote access to the blocks owned and controlled by a
> > filesystem, then you need to use a filesystem with a remote locking
> > mechanism to allow co-ordinated, coherent access to the data in
> > those blocks. Anything else is just asking for ongoing, unfixable
> > filesystem corruption or data leakage problems (i.e.  security
> > issues).
> 
> And at least for XFS we have such a mechanism :)  E.g. I have a
> prototype of a pNFS layout that uses XFS+DAX to allow clients to do
> RDMA directly to XFS files, with the same locking mechanism we use
> for the current block and scsi layout in xfs_pnfs.c.

Oh, that's good to know - pNFS over XFS was exactly what I was
thinking of when I wrote my earlier reply. A few months ago someone
else was trying to use file mappings in userspace for direct remote
client access on fabric connected devices. I told them "pNFS on XFS
and write an efficient transport for you hardware"....

Now that I know we've got RDMA support for pNFS on XFS in the
pipeline, I can just tell them "just write an rdma driver for your
hardware" instead. :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
