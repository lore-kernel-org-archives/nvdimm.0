Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <552CB695.2020805@plexistor.com>
Date: Tue, 14 Apr 2015 09:41:25 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [Linux-nvdimm] [GIT PULL] PMEM driver for v4.1
References: <20150413093309.GA30219@gmail.com> <20150413093541.GA5147@lst.de> <20150413104531.GB30556@gmail.com> <CACTTzNYBUocOz7scco6x-22ngu9cMk5uXJnHgM5PGFBqD22X-A@mail.gmail.com> <20150413171907.GB14243@lst.de>
In-Reply-To: <20150413171907.GB14243@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Yigal Korman <yigal@plexistor.com>
Cc: linux-nvdimm@lists.01.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 04/13/2015 08:19 PM, Christoph Hellwig wrote:
> On Mon, Apr 13, 2015 at 02:11:56PM +0300, Yigal Korman wrote:
>> mlock()
> 
> DAX files always are in-memory so this just sounds like an oversight.
> method.

Yes mlock on DAX can just return true, but mlock implies MAP_POPULATE.

Which means "I would like to page-fault the all mmap range at mmap time
so at access time I'm guarantied not to sleep". This is usually done
for latency sensitive applications. 

But current code fails on MAP_POPULATE for DAX because it is only
implemented for pages, and therefor mlock fails as well.

One thing I do not understand. does mlock also protects against
truncate?

Thanks
Boaz

