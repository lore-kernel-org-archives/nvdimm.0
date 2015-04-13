Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 13 Apr 2015 19:18:05 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] PMEM driver for v4.1
Message-ID: <20150413171805.GA14243@lst.de>
References: <20150413093309.GA30219@gmail.com> <20150413093541.GA5147@lst.de> <20150413104531.GB30556@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150413104531.GB30556@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 13, 2015 at 12:45:32PM +0200, Ingo Molnar wrote:
> Btw., what's the future design plan here? Enable struct page backing, 
> or provide special codepaths for all DAX uses like the special pte 
> based approach for mmap()s?

There are a couple approaches proposed, but we don't have consensus which
way to go yet (to put it mildly).

 - the old Intel patches just allocate pages for E820_PMEM regions.
   I think this is a good way forward for the "old-school" small
   pmem regions which usually are battery/capacitor + flash backed
   DRAM anyway.  This could easily be resurrected for the current code,
   but it couldn't be used for PCI backed pmem regions, and would work
   although waste a lot of resources for the gigantic pmem devices some
   Intel people talk about (400TB+ IIRC).

 - Intel has proposed changes that allow block I/O on regions that aren't
   page backed, by supporting PFN-based scatterlists which would have to be
   supported all over the I/O path. Reception of that code has been rather
   mediocre in general, although I wouldn't rule it out.

 - Boaz has shown code that creates pages dynamically for pmem regions.
   Unlike the old Intel e820 code that would also work for PCI backed
   pmem regions.  Boaz says he has such a card, but until someone actually
   publishes specs and/or the trivial pci_driver for them I'm inclined to
   just ignore that option.

 - There have been proposals for temporary struct page mappings, or
   variable sized pages, but as far as I can tell no code to actually
   implement these schemes.
