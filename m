Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <556431C5.2030704@plexistor.com>
Date: Tue, 26 May 2015 11:41:41 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [Linux-nvdimm] [GIT PULL] PMEM driver for v4.1
References: <20150413093309.GA30219@gmail.com> <20150525181654.GE2729@linux.intel.com>
In-Reply-To: <20150525181654.GE2729@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 05/25/2015 09:16 PM, Matthew Wilcox wrote:
<>
> 
> Ingo, this sucks.  You collapsed all of the separate patches into a
> single "add new driver" patch, which makes it impossible to bisect which
> of the recent changes broke xfstests.  Please don't do this again.
> 

Matthew hi

Below is a splitout of the patches I sent to Christoph.
Christoph in his turn has added more changes.

I would please like to help. What is the breakage you
see with DAX.

I'm routinely testing with DAX so it is a surprise,
Though I'm testing with my version with pages and
__copy_from_user_nocache, and so on.
Or I might have missed it. What test are you failing?


Find patches at:
[web: http://git.open-osd.org/gitweb.cgi?p=pmem.git;a=shortlog;h=refs/tags/PMEM-SPLITOUT-4.0-rc5]
[git tag PMEM-SPLITOUT-4.0-rc5 on git://git.open-osd.org / pmem.git]

The interesting list for you:
bc465aa Linux 4.0-rc5
e489c02 x86: add support for the non-standard protected e820 type
8b06a64 SQUASHME: Don't let e820_PMEM section merge emulated segments.

    There were a few changes to what got upstream on top of these 2

a069890 pmem: Initial version of persistent memory driver

    This one already contains changes made by Christoph

d4f6df5 SQUASHME: pmem: Remove getgeo
2f3f1dd SQUASHME: pmem: Streamline pmem driver
c921d23 SQUSHME: pmem: Micro cleaning
bb373a7 SQUASHME: pmem: Remove SECTOR_SHIFT
ad0070e SQUASHME: pmem: Remove "heavily based on brd.c" + Copyright

   This is not the final pmem version that got merged, but these are the changes
   I made which got incorporated.

Thanks
Boaz

