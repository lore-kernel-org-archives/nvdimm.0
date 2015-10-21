Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 21 Oct 2015 15:58:18 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: what's in nvdimm.git for v4.4?
Message-ID: <20151021215818.GA640@linux.intel.com>
References: <1445383903.6611.39.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1445383903.6611.39.camel@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "david@fromorbit.com" <david@fromorbit.com>, "jack@suse.cz" <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 20, 2015 at 11:31:45PM +0000, Williams, Dan J wrote:
> Here is a status summary of the topic-branches nvdimm.git is tracking
> for v4.4.  Unless indicated these branches are not present in -next.
> Please ACK, NAK, or ask for a re-post of any of the below to disposition
> it for the merge window.
> 
> ===
> for-4.4/dax-fixes:
> ===
<snip>
>         Ross Zwisler (2):
>               dax: dax_pfn_mkwrite() truncate race check

We can drop this patch for dax_pfn_mkwrite() as that whole function is going
away after we merge the locking fixes from XFS, ext2 and ext4.
