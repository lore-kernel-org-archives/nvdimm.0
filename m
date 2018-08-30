Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 412D021107832
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 12:45:03 -0700 (PDT)
Date: Thu, 30 Aug 2018 15:44:57 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Snapshot target and DAX-capable devices
In-Reply-To: <20180830184907.GA14867@redhat.com>
Message-ID: <alpine.LRH.2.02.1808301537420.30950@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180827160744.GE4002@quack2.suse.cz>
 <e38303902267d2d8bae8b0c88da84a4ed668e9fb.camel@hpe.com>
 <20180828075025.GA17756@quack2.suse.cz> <20180828175630.GA1197@redhat.com>
 <20180830093028.GC1767@quack2.suse.cz>
 <20180830184907.GA14867@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



On Thu, 30 Aug 2018, Mike Snitzer wrote:

> On Thu, Aug 30 2018 at  5:30am -0400,
> Jan Kara <jack@suse.cz> wrote:
> 
> > On Tue 28-08-18 13:56:30, Mike Snitzer wrote:
> > > On Tue, Aug 28 2018 at  3:50am -0400,
> > > Jan Kara <jack@suse.cz> wrote:
> > > 
> > > > On Mon 27-08-18 16:43:28, Kani, Toshi wrote:
> > > > > On Mon, 2018-08-27 at 18:07 +0200, Jan Kara wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > I've been analyzing why fstest generic/081 fails when the backing device is
> > > > > > capable of DAX. The problem boils down to the failure of:
> > > > > > 
> > > > > > lvm vgcreate -f vg0 /dev/pmem0
> > > > > > lvm lvcreate -L 128M -n lv0 vg0
> > > > > > lvm lvcreate -s -L 4M -n snap0 vg0/lv0
> > > > > > 
> > > > > > The last command fails like:
> > > > > > 
> > > > > >   device-mapper: reload ioctl on (253:0) failed: Invalid argument
> > > > > >   Failed to lock logical volume vg0/lv0.
> > > > > >   Aborting. Manual intervention required.
> > > > > > 
> > > > > > And the core of the problem is that volume vg0/lv0 is originally of
> > > > > > DM_TYPE_DAX_BIO_BASED type but when the snapshot gets created, we try to
> > > > > > switch it to DM_TYPE_BIO_BASED because now the device stops supporting DAX.
> > > > > > The problem seems to be introduced by Ross' commit dbc626597 "dm: prevent
> > > > > > DAX mounts if not supported".
> > > > > > 
> > > > > > The question is whether / how this should be fixed. The current inability
> > > > > > to create snapshots of DAX-capable devices looks weird and the cryptic
> > > > > > failure makes it even worse (it took me quite a while to understand what is
> > > > > > failing and why). OTOH I see the rationale behind Ross' change as well.
> > > > > 
> > > > > Here are the dm-snap changes that went along with the original DAX
> > > > > support.
> > > > > 
> > > > > commit b5ab4a9ba55
> > > > > commit f6e629bd237
> > > > > 
> > > > > Basically, snapshots can be added/removed to DAX-capable devices, but
> > > > > snapshots need to be mounted without dax option.
> > > > 
> > > > Yes, and after these two commits things were working. But then commit
> > > > dbc626597 broke things again so currently snapshotting DAX-capable devices
> > > > does not work. Just try with 4.18...
> > > 
> > > Commit f6e629bd237 was a nasty hack, and commit dbc626597 exposed it as
> > > such.  But commit dbc626597 has caused us to regress.. so we need to fix
> > > it.
> > > 
> > > We could remove DM_TYPE_DAX_BIO_BASED completely.  But in the past I was
> > > reluctant to do so because it really is unclear how/if we can even
> > > support a device switching from DAX to non-DAX while IO is in-flight. DM
> > > supports suspending without flushing (via dmsetup suspend --noflush) and
> > > that could really be problematic if we leave DAX IO inflight and then
> > > switch the DM table such that the DM device no longer supports DAX.
> > 
> > Well, changing device from DAX-capable to DAX-incapable is problematic for
> > filesystem on top of it as well. Filesystems simply don't expect this
> > feature of a device can change so they would fail in unexpected ways. Also
> > PFNs from the pmem (DAX-capable) device that are already mapped to user page
> > tables won't magically become unmapped so those processes will still have
> > DAX access to those areas of the device.
> > 
> > But, if both original bdev and COW device are DAX-capable, we *should* be
> > able to support snapshotting (and refusing mixing of DAX-capable and
> > DAX-incapable devices in a snapshot is IMHO not very surprising to users).
> > When creating a snapshot of a device, we need to freeze the filesystem
> > using it. That will writeprotect all page tables so we are sure we'll get
> > page faults (and thus ->direct_access requests from DM POV) for each write
> > attempt to any mapping. Then ->direct_access method of snapshot-origin can
> > make sure to copy original contents to the COW-device before returning PFN
> > from ->direct_access. Similarly ->direct_access of COW-device can provide
> > remapped PFN so everything should work seamlessly from user POV.
> > 
> > So something like the above would seem like the best solution from user
> > POV.  Implementation of the above would not be completely trivial though as
> > far as I'm looking into DM code. We'd have to implement ->direct_access
> > paths for dm-snap and also I have a vague memory ->direct_access is not
> > allowed to sleep these days and DM uses sleeping locks all around... Dan
> > should know how big obstacle would it be to reintroduce the sleeping
> > possibility (I'm not currently aware of any particular problem with that
> > but I'm not paying close attention to those parts of NVDIMM code).
> 
> Thanks for these details Jan.  Think Dan is on sabbatical so we'll need
> Ross to weigh in.
> 
> As you point out, how are the upper layers (e.g. filesystems) supposed
> to reliably cope with this runtime switch to from DAX to non-DAX access?
> 
> It does look like we'll need the more elaborate work you outlined
> above.  It could be that Mikulas will have interest, DAX expertise and
> time to do the work.
> 
> Restating the issue: 4.18 commit dbc626597 switched
> drivers/md/dm-table.cdevice_supports_dax() to perform a much more
> detailed verification of the device's DAX capabilities by calling
> bdev_dax_supported() -- which will actually issue read IO via
> dax_direct_access() to validate the DAX support.  dm-snapshot-origin's
> origin_direct_access() returns -EIO.  When trying to create a snapshot
> of a DAX enabled linear device, this results in the following error:
>   kernel: device-mapper: ioctl: can't change device type (old=4 vs new=1) after initial table load.
> 
> This is because the active DM device's table is being switched from
> using the linear target to snapshot-origin.  Because the corresponding
> DM type switches from DM_TYPE_DAX_BIO_BASED to DM_TYPE_BIO_BASED
> (again because bdev_dax_supported()'s call to dm-snapshot-origin's
> origin_direct_access() returns -EIO).
> 
> In general I _never_ should have taken commit f6e629bd237 ("dm snap: add
> fake origin_direct_access").  It gave the elusion that DAX is supported
> by dm-snapshot-origin when in reality it simply returns -EIO.  Expecting
> that this will "just work" because the bio-based path would be used
> instead is extremely fragile.
> 
> Until we properly add DAX support to dm-snapshot I'm afraid we really do
> need to tolerate this "regression".  Since reality is the original
> support for snapshot of a DAX DM device never worked in a robust way.
> I'm running the risk of making peoples' heads explode but I cannot just
> drop everything and scramble to implement all the required DAX changes
> in dm-snapshot.
> 
> Contributions are welcome!
> 
> Mike

I think a proper fix would be to add functions such as start_dax(struct 
block_device *) and stop_dax(struct block_device *).

start_dax would be used by a (filesystem or other) driver that intends to 
use dax - stop_dax would be used when the driver is being unloaded and it 
no longer needs dax. Device mapper would then maintain a counter how many 
dax users are there and prevent reloading the table if there are any.

Do the persistent memory maintainers intend to add such functions?

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
