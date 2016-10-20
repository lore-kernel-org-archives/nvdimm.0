Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
 [150.101.137.143]) by ml01.01.org (Postfix) with ESMTP id 1DFF91A1E31
 for <linux-nvdimm@lists.01.org>; Thu, 20 Oct 2016 16:33:20 -0700 (PDT)
Date: Fri, 21 Oct 2016 10:22:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] iopmem : A block device for PCIe memory
Message-ID: <20161020232239.GQ23194@dastard>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
 <CAPcyv4gJ_c-6s2BUjsu6okR1EF53R+KNuXnOc5jv0fuwJaa3cQ@mail.gmail.com>
 <20161019184814.GC16550@cgy1-donard.priv.deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161019184814.GC16550@cgy1-donard.priv.deltatee.com>
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
To: Stephen Bates <sbates@raithlin.com>
Cc: jgunthorpe@obsidianresearch.com, sbates@raithin.com, "Raj, Ashok  <ashok.raj@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, jim.macdonald@everspin.com, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, haggaie@mellanox.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 19, 2016 at 12:48:14PM -0600, Stephen Bates wrote:
> On Tue, Oct 18, 2016 at 08:51:15PM -0700, Dan Williams wrote:
> > [ adding Ashok and David for potential iommu comments ]
> >
> 
> Hi Dan
> 
> Thanks for adding Ashok and David!
> 
> >
> > I agree with the motivation and the need for a solution, but I have
> > some questions about this implementation.
> >
> > >
> > > Consumers
> > > ---------
> > >
> > > We provide a PCIe device driver in an accompanying patch that can be
> > > used to map any PCIe BAR into a DAX capable block device. For
> > > non-persistent BARs this simply serves as an alternative to using
> > > system memory bounce buffers. For persistent BARs this can serve as an
> > > additional storage device in the system.
> >
> > Why block devices?  I wonder if iopmem was initially designed back
> > when we were considering enabling DAX for raw block devices.  However,
> > that support has since been ripped out / abandoned.  You currently
> > need a filesystem on top of a block-device to get DAX operation.
> > Putting xfs or ext4 on top of PCI-E memory mapped range seems awkward
> > if all you want is a way to map the bar for another PCI-E device in
> > the topology.
> >
> > If you're only using the block-device as a entry-point to create
> > dax-mappings then a device-dax (drivers/dax/) character-device might
> > be a better fit.
> >
> 
> We chose a block device because we felt it was intuitive for users to
> carve up a memory region but putting a DAX filesystem on it and creating
> files on that DAX aware FS. It seemed like a convenient way to
> partition up the region and to be easily able to get the DMA address
> for the memory backing the device.

You do realise that local filesystems can silently change the
location of file data at any point in time, so there is no such
thing as a "stable mapping" of file data to block device addresses
in userspace?

If you want remote access to the blocks owned and controlled by a
filesystem, then you need to use a filesystem with a remote locking
mechanism to allow co-ordinated, coherent access to the data in
those blocks. Anything else is just asking for ongoing, unfixable
filesystem corruption or data leakage problems (i.e.  security
issues).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
