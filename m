Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A2ECC210ED10A
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 10:24:22 -0700 (PDT)
Date: Wed, 6 Jun 2018 11:24:21 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 5/7] dm: remove DM_TYPE_DAX_BIO_BASED dm_queue_mode
Message-ID: <20180606172421.GA2208@linux.intel.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-6-ross.zwisler@linux.intel.com>
 <20180601220443.GB18712@redhat.com>
 <20180604232416.GB10666@linux.intel.com>
 <20180605004558.GB6898@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180605004558.GB6898@redhat.com>
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 04, 2018 at 08:46:28PM -0400, Mike Snitzer wrote:
> On Mon, Jun 04 2018 at  7:24pm -0400,
> Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> 
> > On Fri, Jun 01, 2018 at 06:04:43PM -0400, Mike Snitzer wrote:
> > > On Tue, May 29 2018 at  3:51pm -0400,
> > > Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> > > 
> > > > The DM_TYPE_DAX_BIO_BASED dm_queue_mode was introduced to prevent DM
> > > > devices that could possibly support DAX from transitioning into DM devices
> > > > that cannot support DAX.
> > > > 
> > > > For example, the following transition will currently fail:
> > > > 
> > > >  dm-linear: [fsdax pmem][fsdax pmem] => [fsdax pmem][fsdax raw]
> > > > 	      DM_TYPE_DAX_BIO_BASED       DM_TYPE_BIO_BASED
> > > > 
> > > > but these will both succeed:
> > > > 
> > > >  dm-linear: [fsdax pmem][brd ramdisk] => [fsdax pmem][fsdax raw]
> > > >  	      DM_TYPE_DAX_BIO_BASED        DM_TYPE_BIO_BASED
> > > > 
> > > 
> > > I fail to see how this succeeds given
> > > drivers/md/dm-ioctl.c:is_valid_type() only allows transitions from:
> > > 
> > > DM_TYPE_BIO_BASED => DM_TYPE_DAX_BIO_BASED
> > 
> > Right, sorry, that was a typo.  What I meant was:
> > 
> > > For example, the following transition will currently fail:
> > > 
> > >  dm-linear: [fsdax pmem][fsdax pmem] => [fsdax pmem][fsdax raw]
> > >               DM_TYPE_DAX_BIO_BASED       DM_TYPE_BIO_BASED
> > > 
> > > but these will both succeed:
> > > 
> > >  dm-linear: [fsdax pmem][brd ramdisk] => [fsdax pmem][fsdax raw]
> > >                 DM_TYPE_BIO_BASED        DM_TYPE_BIO_BASED
> > > 
> > >  dm-linear: [fsdax pmem][fsdax raw] => [fsdax pmem][fsdax pmem]
> > >                 DM_TYPE_BIO_BASED        DM_TYPE_DAX_BIO_BASED
> > 
> > So we allow 2 of the 3 transitions, but the reason that we disallow the third
> > isn't fully clear to me.
> > 
> > > >  dm-linear: [fsdax pmem][fsdax raw] => [fsdax pmem][fsdax pmem]
> > > >  		DM_TYPE_BIO_BASED        DM_TYPE_DAX_BIO_BASED
> > > > 
> > > > This seems arbitrary, as really the choice on whether to use DAX happens at
> > > > filesystem mount time.  There's no guarantee that the in the first case
> > > > (double fsdax pmem) we were using the dax mount option with our file
> > > > system.
> > > > 
> > > > Instead, get rid of DM_TYPE_DAX_BIO_BASED and all the special casing around
> > > > it, and instead make the request queue's QUEUE_FLAG_DAX be our one source
> > > > of truth.  If this is set, we can use DAX, and if not, not.  We keep this
> > > > up to date in table_load() as the table changes.  As with regular block
> > > > devices the filesystem will then know at mount time whether DAX is a
> > > > supported mount option or not.
> > > 
> > > If you don't think you need this specialization that is fine.. but DM
> > > devices supporting suspending (as part of table reloads) so is there any
> > > risk that there will be inflight IO (say if someone did 'dmsetup suspend
> > > --noflush').. and then upon reload the device type changed out from
> > > under us.. anyway, I don't have all the PMEM DAX stuff paged back into
> > > my head yet.
> > > 
> > > But this just seems like we really shouldn't be allowing the
> > > transition from what was DM_TYPE_DAX_BIO_BASED back to DM_TYPE_BIO_BASED
> > 
> > I admit I don't fully understand all the ways that DM supports suspending and
> > resuming devices.  Is there actually a case where we can change out the DM
> > devices while I/O is running, and somehow end up trying to issue a DAX I/O to
> > a device that doesn't support DAX?
> 
> Yes, provided root permissions, it's very easy to dmsetup suspend/load/resume
> to replace any portion of the DM device's logical address space to map to an
> entirely different DM target (with a different backing store).  It's
> pretty intrusive to do such things, but easily done and powerful.
> 
> Mike

Hmmm, I don't understand how you can do this if there is a filesystem built on
your DM device?  Say you have a DM device, either striped or linear, that is
made up of 2 devices, and then you use dmsetup to replace one of the DM member
devices with something else.  You've just swapped out half of your LBA space
with new data, right? 

I don't understand how you can expect a filesystem built on the old DM device
to still work?  You especially can't do this while the filesystem is mounted -
all the in-core filesystem metadata would be garbage because the on-media data
would have totally changed.

So, when dealing with a filesystem, the flow must be:

unmount your filesystem
redo your DM device, changing out devices
reformat your filesystem on the new DM device
remount your filesystem

Right?  If so, then I don't see how a transition of the DM device from
supporting DAX to not supporting DAX or vice versa could harm us, as we can't
be doing filesystem I/O at the time when we change the composition of the DM
device.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
