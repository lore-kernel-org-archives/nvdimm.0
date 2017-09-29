Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9350321F303F9
 for <linux-nvdimm@lists.01.org>; Fri, 29 Sep 2017 10:34:37 -0700 (PDT)
Date: Fri, 29 Sep 2017 11:37:52 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 0/5] ext4: DAX data corruption fixes
Message-ID: <20170929173752.GA6155@linux.intel.com>
References: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 11, 2017 at 11:05:21PM -0600, Ross Zwisler wrote:
> This series prevents a pair of data corruptions with ext4 + DAX.  The first
> such corruption happens when combining the inline data feature with DAX,
> and the second happens when combining data journaling with DAX.
> 
> Both can be reliably reproduced with the fstests that I have posted here:
> 
> https://patchwork.kernel.org/patch/9948377/
> https://patchwork.kernel.org/patch/9948381/
> 
> My opinion is that the first three patches in this series should be applied
> to the v4.14 RC series and backported to stable.  The last two patches in
> this series are just cleanup and can probably wait until v4.15.
> 
> Ross Zwisler (5):
>   ext4: prevent data corruption with inline data + DAX
>   ext4: prevent data corruption with journaling + DAX
>   ext4: add sanity check for encryption + DAX
>   ext4: add ext4_should_use_dax()
>   ext4: remove duplicate extended attributes defs
> 
>  fs/ext4/ext4.h   | 37 -------------------------------------
>  fs/ext4/inline.c | 10 ----------
>  fs/ext4/inode.c  | 24 ++++++++++++++++--------
>  fs/ext4/ioctl.c  | 16 +++++++++++++---
>  fs/ext4/super.c  |  8 ++++++++
>  5 files changed, 37 insertions(+), 58 deletions(-)

Hey Ted,

I just wanted to ping this series, and see if at least the data corruption
fixes were headed for v4.14?  I don't think these have been merged into any of
the ext4 branches yet.

Thanks,
- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
