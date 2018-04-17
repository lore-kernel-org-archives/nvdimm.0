Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
 [150.101.137.129])
 by ml01.01.org (Postfix) with ESMTP id 8788B22590E08
 for <linux-nvdimm@lists.01.org>; Tue, 17 Apr 2018 16:36:21 -0700 (PDT)
Date: Wed, 18 Apr 2018 09:36:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ioctl FIBMAP for dax gone in v4.17-rc1
Message-ID: <20180417233618.GB27893@dastard>
References: <20180417144059.nwbbynhgq3k3i63q@XZHOUW.usersys.redhat.com>
 <20180417161056.GA24257@infradead.org>
 <CAPcyv4i05nP=wmOMwKFbdwqBrYXpcPBCmR4g2b4w8vOZaCBEnQ@mail.gmail.com>
 <20180417165756.GC24738@magnolia>
 <BE1492A6-DF52-428C-A3CE-E91F0ACC0ADA@dilger.ca>
 <20180417175007.GB5210@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180417175007.GB5210@magnolia>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Eric Sandeen <sandeen@sandeen.net>, fstests <fstests@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 17, 2018 at 10:50:07AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 17, 2018 at 11:40:00AM -0600, Andreas Dilger wrote:
> > On Apr 17, 2018, at 10:57 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > 
> > > On Tue, Apr 17, 2018 at 09:53:47AM -0700, Dan Williams wrote:
> > >> On Tue, Apr 17, 2018 at 9:10 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > >>> On Tue, Apr 17, 2018 at 10:40:59PM +0800, Xiong Zhou wrote:
> > >>>> We got these in v4.17-rc1:
> > >>>> 6e2608d xfs, dax: introduce xfs_dax_aops
> > >>>> fb094c9 ext2, dax: introduce ext2_dax_aops
> > >>>> 5f0663b ext4, dax: introduce ext4_dax_aops
> > >>>> 
> > >>>> And we don't have ->bmap call in these aops, which may lead
> > >>>> to the ioctl call failure.
> > >>>> 
> > >>>> Do we have any plan of adding/supporting it ?
> > >>>> 
> > >>>> xfstests generic/223 covers this issue. If we are not going
> > >>>> to support this call for dax, we need to fix the testcase.
> > >>> 
> > >>> Not supporting ->bmap is a good thing as it is hightly dangerous.
> > >> 
> > >> I take this to mean "don't fix, it is another casualty of dax being
> > >> experimental and it won't be coming back". I can get on board with
> > >> that.
> > >> 
> > >> Otherwise, I was about to send a series adding bmap to {xfs,ext2,ext4}_dax_ops.
> > > 
> > > Frankly I'd rather see the swapfile code learn how to iomap and then we
> > > can get rid of bmap in xfs entirely.
> > 
> > Is anyone still using LILO to boot?

Yup. I do.

[ because grub has a history of corrupting filesystems on my
machines with it's obnoxious "probe for bootable OS images on update
by attempting to mount every block device in the system" behaviour. ]

> > It needed FIBMAP support to map the
> > kernel image for booting.

There's a difference between FIBMAP and ->bmap. One's a syscall
parameter under ABI constraints and the other is an internal
implementation.

We have to keep supporting FIBMAP forever, but we can re-implement
it internally using ->fiemap pretty damn easily - just replace the
bmap() implementation with a ->fiemap call and replace all the
direct ->bmap() calls with bmap(). Hence FIBMAP will continue to
work on all filesystems (including DAX!) and we get the ->bmap
crap out of the kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
