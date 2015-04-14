Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A89D80A@G9W0745.americas.hpqcorp.net>
References: <20150413093309.GA30219@gmail.com>
	<20150413093541.GA5147@lst.de>
	<20150413104531.GB30556@gmail.com>
	<20150413171805.GA14243@lst.de>
	<20150414124157.GA28544@gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295A89D80A@G9W0745.americas.hpqcorp.net>
Date: Tue, 14 Apr 2015 09:34:11 -0700
Message-ID: <CAPcyv4jqm3vd6awWHdU7pWHCLemjBfJLTUG7r98qZBs4r0RBMg@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [GIT PULL] PMEM driver for v4.1
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 14, 2015 at 7:08 AM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
>
>
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf
>> Of Ingo Molnar
>> Sent: Tuesday, April 14, 2015 7:42 AM
>> To: Christoph Hellwig
>> Subject: Re: [Linux-nvdimm] [GIT PULL] PMEM driver for v4.1
>>
>>
> ...
>> Since it's directly mapped it should just work for most things if it's
>> at least write-through cached (UC would be a horror), and it would
>> also solve all the size problems. With write-through caching it should
>> also be pretty OK performance-wise. The 64 bytes size is ideal as
>
> Are the WT support patches going to make it into 4.1?

Which patches are these?  Maybe I missed them, but I don't see
anything in the archives.
