Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <55657FAD.4020900@plexistor.com>
Date: Wed, 27 May 2015 11:26:21 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [Linux-nvdimm] [GIT PULL] PMEM driver for v4.1
References: <20150413093309.GA30219@gmail.com> <20150525181654.GE2729@linux.intel.com> <556431C5.2030704@plexistor.com> <20150526193147.GF2729@linux.intel.com> <55657BED.80503@plexistor.com> <20150527081156.GA25375@lst.de>
In-Reply-To: <20150527081156.GA25375@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 05/27/2015 11:11 AM, Christoph Hellwig wrote:
> On Wed, May 27, 2015 at 11:10:21AM +0300, Boaz Harrosh wrote:
>> Hu funny I just looked and I see with ./check auto I get
>> generic/018 1s ... [not run] defragmentation not supported for fstype "m1fs"
>> generic/020 0s ... 0s
>>
>> 019 is not even printing a skip. But if I run it directly I get:
>> generic/019      [not run] /sys/kernel/debug/fail_make_request  not found. \
>> 	Seems that CONFIG_FAIL_MAKE_REQUEST kernel config option not enabled
>>
>> So my bad, I will try to properly configure and recreate this failure here
>> as well.
> 
> It fails I/O above the driver.  Any failure in generic/019 is very unlіkely
> to be driver related.
> 

Hm, so then that would be expected right?
__blkdev_put fails to WARN_ON_ONCE(write_inode_now(inode, true))
because the test tells the Kernel to fail IO requests.

__blkdev_put then complains because it has no way to report
the error back to caller.

I would then say that 019 test should expect that this might
happen. Or it should somehow make sure to remove the requests
block before the umount.

Thanks
Boaz

