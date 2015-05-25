Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 25 May 2015 14:16:54 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [Linux-nvdimm] [GIT PULL] PMEM driver for v4.1
Message-ID: <20150525181654.GE2729@linux.intel.com>
References: <20150413093309.GA30219@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150413093309.GA30219@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 13, 2015 at 11:33:09AM +0200, Ingo Molnar wrote:
> Please pull the latest x86-pmem-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-pmem-for-linus
> 
>    # HEAD: 4c1eaa2344fb26bb5e936fb4d8ee307343ea0089 drivers/block/pmem: Fix 32-bit build warning in pmem_alloc()
> 
> This is the initial support for the pmem block device driver: 
> persistent non-volatile memory space mapped into the system's physical 
> memory space as large physical memory regions.

Ingo, this sucks.  You collapsed all of the separate patches into a
single "add new driver" patch, which makes it impossible to bisect which
of the recent changes broke xfstests.  Please don't do this again.

> ------------------>
> Christoph Hellwig (1):
>       x86/mm: Add support for the non-standard protected e820 type
> 
> Ingo Molnar (1):
>       drivers/block/pmem: Fix 32-bit build warning in pmem_alloc()
> 
> Ross Zwisler (1):
>       drivers/block/pmem: Add a driver for persistent memory

