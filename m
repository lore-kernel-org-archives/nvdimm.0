Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 27 May 2015 10:11:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Linux-nvdimm] [GIT PULL] PMEM driver for v4.1
Message-ID: <20150527081156.GA25375@lst.de>
References: <20150413093309.GA30219@gmail.com> <20150525181654.GE2729@linux.intel.com> <556431C5.2030704@plexistor.com> <20150526193147.GF2729@linux.intel.com> <55657BED.80503@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55657BED.80503@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 27, 2015 at 11:10:21AM +0300, Boaz Harrosh wrote:
> Hu funny I just looked and I see with ./check auto I get
> generic/018 1s ... [not run] defragmentation not supported for fstype "m1fs"
> generic/020 0s ... 0s
> 
> 019 is not even printing a skip. But if I run it directly I get:
> generic/019      [not run] /sys/kernel/debug/fail_make_request  not found. \
> 	Seems that CONFIG_FAIL_MAKE_REQUEST kernel config option not enabled
> 
> So my bad, I will try to properly configure and recreate this failure here
> as well.

It fails I/O above the driver.  Any failure in generic/019 is very unlіkely
to be driver related.
