Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151202111656.GB22125@quack.suse.cz>
References: <20151201235836.36836.90416.stgit@dwillia2-desk3.jf.intel.com>
	<20151201235841.36836.69016.stgit@dwillia2-desk3.jf.intel.com>
	<20151202111656.GB22125@quack.suse.cz>
Date: Wed, 2 Dec 2015 07:37:58 -0800
Message-ID: <CAPcyv4j47YwQ2yexAB18wagN6WSmNn8v_pTwetc1OZdUzZBE8Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] block, fs: reliably communicate bdev end-of-life
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 2, 2015 at 3:16 AM, Jan Kara <jack@suse.cz> wrote:
>> generic_quiesce_super and generic_bdi_gone, are the default operations
>> when a filesystem does not implement ->quiesce(), ->bdi_gone().  They
>> invalidate inodes and unmap DAX-inodes respectively.  For now only
>> ->bdi_gone() has an associated super operation as xfs will implement
>> ->bdi_gone() in a later patch.
>
> So the patch looks good. Just for the callbacks to be generally useful we
> would need del_gendisk_queue() to be used for all devices, not just for
> pmem ones... But I guess this is better than nothing.

Once this goes in I'll go back and convert nvme and sd to
del_gendisk_queue.  That should give us coverage for the most
prominent block drivers.
