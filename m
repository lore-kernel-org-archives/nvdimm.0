Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150621101346.GF5915@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617235602.12943.24958.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150621101346.GF5915@lst.de>
Date: Sun, 21 Jun 2015 06:21:50 -0700
Message-ID: <CAPcyv4jjTU8MA1zWnbRsyxcnxC+EJK9pJdLBkYeGtgHXeDkKVQ@mail.gmail.com>
Subject: Re: [PATCH 14/15] libnvdimm: support read-only btt backing devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 21, 2015 at 3:13 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Jun 17, 2015 at 07:56:02PM -0400, Dan Williams wrote:
>> Upon detection of a read-only backing device arrange for the btt to
>> device to be read only.  Implement a catch for the BLKROSET ioctl and
>> only allow a btt-instance to become read-write when the backing-device
>> becomes read-write.  Conversely, if a backing-device becomes read-only
>> arrange for its parent btt to be marked read-only.  Synchronize these
>> changes under the bus lock.
>
> Eww.  I have to say the deeper I look into this code the more I hate
> the stacking nature of btt.  It seems more and more we should never
> attach pmem if we want to use a device with btt.

This question has come up before.  Making btt an internal property of
a device makes some things cleaner and others more messy.  We lose the
ability to place a btt instance on top of a partition, rather than a
whole disk.  If we ever need to access the raw device we no longer
have a direct block device to reference.  Linux has been doing stacked
configurations to change the personality of block devices since
forever (md, dm, bcache...), why invent something new to handle the
btt-personality of ->rw_bytes() devices?

BTT precludes DAX, if you want both modes on one pmem disk placing BTT
on a partition of the disk for fs metadata and DAX-capable data on the
rest is our proposed solution.  We chose this architecture after a
conversation with Dave Chinner about XFS's need to have atomic sector
guarantees for its metadata and wanting to simultaneously enable
XFS-DAX.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
