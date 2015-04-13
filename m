Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 13 Apr 2015 11:35:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] PMEM driver for v4.1
Message-ID: <20150413093541.GA5147@lst.de>
References: <20150413093309.GA30219@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150413093309.GA30219@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boaz@plexistor.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 13, 2015 at 11:33:09AM +0200, Ingo Molnar wrote:
> Limitations: this is a regular block device, and since the pmem areas 
> are not struct page backed, they are invisible to the rest of the 
> system (other than the block IO device), so direct IO to/from pmem 
> areas, direct mmap() or XIP is not possible yet. The page cache will 
> also shadow and double buffer pmem contents, etc.

Unless you use the DAX support in ext2/4 and soon XFS, in which case
we avoid that double buffering when doing read/write and mmap
