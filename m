Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [Linux-nvdimm] [GIT PULL] PMEM driver for v4.1
Date: Tue, 14 Apr 2015 14:08:31 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A89D80A@G9W0745.americas.hpqcorp.net>
References: <20150413093309.GA30219@gmail.com>
 <20150413093541.GA5147@lst.de> <20150413104531.GB30556@gmail.com>
 <20150413171805.GA14243@lst.de> <20150414124157.GA28544@gmail.com>
In-Reply-To: <20150414124157.GA28544@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf
> Of Ingo Molnar
> Sent: Tuesday, April 14, 2015 7:42 AM
> To: Christoph Hellwig
> Subject: Re: [Linux-nvdimm] [GIT PULL] PMEM driver for v4.1
> 
> 
...
> Since it's directly mapped it should just work for most things if it's
> at least write-through cached (UC would be a horror), and it would
> also solve all the size problems. With write-through caching it should
> also be pretty OK performance-wise. The 64 bytes size is ideal as

Are the WT support patches going to make it into 4.1?


