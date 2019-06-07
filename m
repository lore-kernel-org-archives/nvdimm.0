Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BFDB521290D4C
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jun 2019 07:51:01 -0700 (PDT)
Date: Fri, 7 Jun 2019 07:52:13 -0700
From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190607145213.GB14559@iweiny-DESK2.sc.intel.com>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
 <20190606195114.GA30714@ziepe.ca>
 <20190606222228.GB11698@iweiny-DESK2.sc.intel.com>
 <20190607103636.GA12765@quack2.suse.cz>
 <20190607121729.GA14802@ziepe.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190607121729.GA14802@ziepe.ca>
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
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, John Hubbard <jhubbard@nvidia.com>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 07, 2019 at 09:17:29AM -0300, Jason Gunthorpe wrote:
> On Fri, Jun 07, 2019 at 12:36:36PM +0200, Jan Kara wrote:
> 
> > Because the pins would be invisible to sysadmin from that point on. 
> 
> It is not invisible, it just shows up in a rdma specific kernel
> interface. You have to use rdma netlink to see the kernel object
> holding this pin.
> 
> If this visibility is the main sticking point I suggest just enhancing
> the existing MR reporting to include the file info for current GUP
> pins and teaching lsof to collect information from there as well so it
> is easy to use.
> 
> If the ownership of the lease transfers to the MR, and we report that
> ownership to userspace in a way lsof can find, then I think all the
> concerns that have been raised are met, right?

I was contemplating some new lsof feature yesterday.  But what I don't think we
want is sysadmins to have multiple tools for multiple subsystems.  Or even have
to teach lsof something new for every potential new subsystem user of GUP pins.

I was thinking more along the lines of reporting files which have GUP pins on
them directly somewhere (dare I say procfs?) and teaching lsof to report that
information.  That would cover any subsystem which does a longterm pin.

> 
> > ugly to live so we have to come up with something better. The best I can
> > currently come up with is to have a method associated with the lease that
> > would invalidate the RDMA context that holds the pins in the same way that
> > a file close would do it.
> 
> This is back to requiring all RDMA HW to have some new behavior they
> currently don't have..
> 
> The main objection to the current ODP & DAX solution is that very
> little HW can actually implement it, having the alternative still
> require HW support doesn't seem like progress.
> 
> I think we will eventually start seein some HW be able to do this
> invalidation, but it won't be universal, and I'd rather leave it
> optional, for recovery from truely catastrophic errors (ie my DAX is
> on fire, I need to unplug it).

Agreed.  I think software wise there is not much some of the devices can do
with such an "invalidate".

Ira

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
