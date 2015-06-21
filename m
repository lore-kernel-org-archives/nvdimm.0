Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Sun, 21 Jun 2015 12:13:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/15] libnvdimm: support read-only btt backing devices
Message-ID: <20150621101346.GF5915@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com> <20150617235602.12943.24958.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150617235602.12943.24958.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, linux-nvdimm@lists.01.org, boaz@plexistor.com, toshi.kani@hp.com, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 17, 2015 at 07:56:02PM -0400, Dan Williams wrote:
> Upon detection of a read-only backing device arrange for the btt to
> device to be read only.  Implement a catch for the BLKROSET ioctl and
> only allow a btt-instance to become read-write when the backing-device
> becomes read-write.  Conversely, if a backing-device becomes read-only
> arrange for its parent btt to be marked read-only.  Synchronize these
> changes under the bus lock.

Eww.  I have to say the deeper I look into this code the more I hate
the stacking nature of btt.  It seems more and more we should never
attach pmem if we want to use a device with btt. 
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
