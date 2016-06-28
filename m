From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Date: Tue, 28 Jun 2016 15:10:59 +0200
Message-ID: <20160628131059.GA30475@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
 <20160623232446.GA12670@dastard> <20160624072612.GA22205@lst.de>
 <20160624230045.GG12670@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160624230045.GG12670@dastard>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Sat, Jun 25, 2016 at 09:00:45AM +1000, Dave Chinner wrote:
> > 
> > Sorry, but this is simply broken - allowing apps to opt-in behavior
> > (e.g. like we're using O_DIRECT) is always fine.  Requriring
> > filesystem-specific tuning that has affect outside the app to get
> > existing documented behavior is not how to design APIs.
> 
> Using DAX is an *admin decision*, not an application decision.

Of course - that's exactly my point.

> Indeed, it's a mount option right now, and that's most definitely not
> something the application can turn on or off! Inode flags allow the
> admin to decide that two apps working on the same filesystem can use
> (or not use) DAX independently, rather than needing to put them on
> different filesystems.

Right.  And an existing application can get DAX turned on under its
back, and will now suddently get different synchronization behavior.
That is if it's writes happen to be aligned to the fs block size.

> > Maybe we'll need to opt-in to use DAX for mmap, but giving the same
> > existing behavior for read and write and avoiding a copy to the pagecache
> > is an obvious win.
> 
> You can't use DAX just for mmap. It's an inode scope behaviour -
> once it's turned on, all accesses to that inode - regardless of user
> interface - must use DAX. It's all or nothing, not a per file
> descript/mmap context option.

Right now it is.  But when discussing mmap behavior one option was to
require an opt-in to get DAX-specific mmap semantics.  For plain
read/write we have no such option and thus absolutely need to behave as
all normal reads and writes behave.  If you think the exclusive lock
for writes hurts we have two options:
 
 a) implement range locks (although they might be more expensive for
    typical loads)
 b) add a new O_* or RWF_* option to not require the synchronization
    for apps that don't want it.

Neither of those cases really is DAX-specific.
