Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0CC65210FBF0B
 for <linux-nvdimm@lists.01.org>; Wed, 20 Jun 2018 08:17:51 -0700 (PDT)
Date: Wed, 20 Jun 2018 11:17:49 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 4/7] dm: prevent DAX mounts if not supported
Message-ID: <20180620151748.GA4847@redhat.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-5-ross.zwisler@linux.intel.com>
 <20180601215513.GA18712@redhat.com>
 <20180604231508.GA10666@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180604231508.GA10666@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Toshi Kani <toshi.kani@hpe.com>, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 04 2018 at  7:15pm -0400,
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> On Fri, Jun 01, 2018 at 05:55:13PM -0400, Mike Snitzer wrote:
> > On Tue, May 29 2018 at  3:51pm -0400,
> > Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> > 
> > > Currently the code in dm_dax_direct_access() only checks whether the target
> > > type has a direct_access() operation defined, not whether the underlying
> > > block devices all support DAX.  This latter property can be seen by looking
> > > at whether we set the QUEUE_FLAG_DAX request queue flag when creating the
> > > DM device.
> > 
> > Wait... I thought DAX support was all or nothing?
> 
> Right, it is, and that's what I'm trying to capture.  The point of this series
> is to make sure that we don't use DAX thru DM if one of the DM members doesn't
> support DAX.
> 
> This is a bit tricky, though, because as you've pointed out there are a lot of
> elements that go into a block device actually supporting DAX.  
> 
> First, the block device has to have a direct_access() operation defined in its
> struct dax_operations table.  This is a static definition in the drivers,
> though, so it's necessary but not sufficient.  For example, the PMEM driver
> always defines a direct_access() operation, but depending on the mode of the
> namespace (raw, fsdax or sector) it may or may not support DAX.
> 
> The next step is that a driver needs to say that he block queue supports
> QUEUE_FLAG_DAX.  This again is necessary but not sufficient.  The PMEM driver
> currently sets this for all namespace modes, but I agree that this should be
> restricted to modes that support DAX.  Even once we do that, though, for the
> block driver this isn't fully sufficient.  We'd really like users to call
> bdev_dax_supported() so it can run some additional tests to make sure that DAX
> will work.
> 
> So, the real test that filesystems rely on is bdev_dax_suppported().
> 
> The trick is that with DM we need to verify each block device via
> bdev_dax_supported() just like a filesystem would, and then have some way of
> communicating the result of all those checks to the filesystem which is
> eventually mounted on the DM device.  At DAX mount time the filesystem will
> call bdev_dax_supported() on the DM device, but it'll really only check the
> first device.  
> 
> So, the strategy is to have DM manually check each member device via
> bdev_dax_supported() then if they all pass set QUEUE_FLAG_DAX.  This then
> becomes our one source of truth on whether or not a DM device supports DAX.
> When the filesystem mounts with DAX support it'll also run
> bdev_dax_supported(), but if we have QUEUE_FLAG_DAX set on the DM device, we
> know that this check will pass.
> 
> > > This is problematic if we have, for example, a dm-linear device made up of
> > > a PMEM namespace in fsdax mode followed by a ramdisk from BRD.
> > > QUEUE_FLAG_DAX won't be set on the dm-linear device's request queue, but
> > > we have a working direct_access() entry point and the first member of the
> > > dm-linear set *does* support DAX.
> > 
> > If you don't have a uniformly capable device then it is very dangerous
> > to advertise that the entire device has a certain capability.  That
> > completely bit me in the past with discard (because for every IO I
> > wasn't then checking if the destination device supported discards).
> >
> > It is all well and good that you're adding that check here.  But what I
> > don't like is how you're saying QUEUE_FLAG_DAX implies direct_access()
> > operation exists.. yet for raw PMEM namespaces we just discussed how
> > that is a lie.
> 
> QUEUE_FLAG_DAX does imply that direct_access() exits.  However, as discussed
> above for a given bdev we really do need to check bdev_dax_supported().
> 
> > SO this type of change showcases how the QUEUE_FLAG_DAX doesn't _really_
> > imply direct_access() exists.
> > 
> > > This allows the user to create a filesystem on the dm-linear device, and
> > > then mount it with DAX.  The filesystem's bdev_dax_supported() test will
> > > pass because it'll operate on the first member of the dm-linear device,
> > > which happens to be a fsdax PMEM namespace.
> > > 
> > > All DAX I/O will then fail to that dm-linear device because the lack of
> > > QUEUE_FLAG_DAX prevents fs_dax_get_by_bdev() from working.  This means that
> > > the struct dax_device isn't ever set in the filesystem, so
> > > dax_direct_access() will always return -EOPNOTSUPP.
> > 
> > Now you've lost me... these past 2 paragraphs.  Why can a user mount it
> > is DAX mode?  Because bdev_dax_supported() only accesses the first
> > portion (which happens to have DAX capabilities?)
> 
> Right.  bdev_dax_supported() runs all of its checks, and because they are
> running against the first block device in the dm set, they all pass.  But the
> overall DM device does not actually support DAX.
> 
> > Isn't this exactly why you should be checking for QUEUE_FLAG_DAX in the
> > caller (bdev_dax_supported)?  Why not use bdev_get_queue() and verify
> > QUEUE_FLAG_DAX is set in there?
> 
> I'll look into that for the next revision, thanks.

Have you made any progress on a new revision?

> > > By failing out of dm_dax_direct_access() if QUEUE_FLAG_DAX isn't set we let
> > > the filesystem know we don't support DAX at mount time.  The filesystem
> > > will then silently fall back and remove the dax mount option, causing it to
> > > work properly.
> > 
> > This shouldn't be needed.  Again, QUEUE_FLAG_DAX wasn't set.. so don't
> > allow code to falsely try operations that should've been gated by the
> > fact it wasn't set.
> 
> Right, the goal is to make QUEUE_FLAG_DAX our one source of truth for whether
> DM devices support DAX, and not have it half defined by that and half by the
> DM_TYPE_DAX_BIO_BASED.

My hope is that you can ignore the DM-internal book-keeping
(DM_TYPE_DAX_BIO_BASED) for now and just focus on fixing the real issue
of needing proper checking (as well as properly _not_ setting
QUEUE_FLAG_DAX in the case of pmem "raw").

Please advise, thanks Ross!

Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
