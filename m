Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 26 Oct 2015 08:22:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] block: enable dax for raw block devices
Message-ID: <20151025212247.GI19199@dastard>
References: <20151022064142.12700.11849.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151022064211.12700.77105.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151022093549.GE14445@quack.suse.cz>
 <1445529945.17208.4.camel@intel.com>
 <20151022210818.GC8670@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151022210818.GC8670@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 22, 2015 at 11:08:18PM +0200, Jan Kara wrote:
> Ugh2: Now I realized that DAX mmap isn't safe wrt fs freezing even for
> filesystems since there's nothing which writeprotects pages that are
> writeably mapped. In normal path, page writeback does this but that doesn't
> happen for DAX. I remember we once talked about this but it got lost.
> We need something like walk all filesystem inodes during fs freeze and
> writeprotect all pages that are mapped. But that's going to be slow...

fsync() has the same problem - we have no record of the pages that
need to be committed and then write protected when fsync() is called
after write()...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
