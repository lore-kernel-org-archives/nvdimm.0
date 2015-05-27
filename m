Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 27 May 2015 09:50:42 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [Linux-nvdimm] [GIT PULL] PMEM driver for v4.1
Message-ID: <20150527075042.GA32160@gmail.com>
References: <20150413093309.GA30219@gmail.com>
 <20150525181654.GE2729@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150525181654.GE2729@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>


* Matthew Wilcox <willy@linux.intel.com> wrote:

> On Mon, Apr 13, 2015 at 11:33:09AM +0200, Ingo Molnar wrote:
> > Please pull the latest x86-pmem-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-pmem-for-linus
> > 
> >    # HEAD: 4c1eaa2344fb26bb5e936fb4d8ee307343ea0089 drivers/block/pmem: Fix 32-bit build warning in pmem_alloc()
> > 
> > This is the initial support for the pmem block device driver: 
> > persistent non-volatile memory space mapped into the system's physical 
> > memory space as large physical memory regions.
> 
> Ingo, this sucks.  You collapsed all of the separate patches into a single "add 
> new driver" patch, which makes it impossible to bisect which of the recent 
> changes broke xfstests.  Please don't do this again.

You ignored my previous reply, so let me ask this again more forcefully: what the 
hell are you talking about??

As you can see it from the fine commit 9e853f2313e5:

  Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
  Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
  Signed-off-by: Christoph Hellwig <hch@lst.de>
  Acked-by: Dan Williams <dan.j.williams@intel.com>
  ...
  Link: http://lkml.kernel.org/r/1427872339-6688-3-git-send-email-hch@lst.de
  [ Minor cleanups. ]
  Signed-off-by: Ingo Molnar <mingo@kernel.org>

I didn't do any 'collapsing' of patches, I applied the patches as sent by hch:

  9e853f2313e5 ("drivers/block/pmem: Add a driver for persistent memory")
  ec776ef6bbe1 ("x86/mm: Add support for the non-standard protected e820 type")

Thanks,

	Ingo
