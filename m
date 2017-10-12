Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0801321F38854
 for <linux-nvdimm@lists.01.org>; Thu, 12 Oct 2017 09:15:30 -0700 (PDT)
Date: Thu, 12 Oct 2017 12:18:53 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 5/5] ext4: remove duplicate extended attributes defs
Message-ID: <20171012161853.4y4p3u5lsla2wqzx@thunk.org>
References: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
 <20170912050526.7627-6-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170912050526.7627-6-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Li Xi <lixi@ddn.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 11, 2017 at 11:05:26PM -0600, Ross Zwisler wrote:
> The following commit:
> 
> commit 9b7365fc1c82 ("ext4: add FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
> interface support")
> 
> added several defines related to extended attributes to ext4.h.  They were
> added within an #ifndef FS_IOC_FSGETXATTR block with the comment:
> 
> /* Until the uapi changes get merged for project quota... */
> 
> Those uapi changes were merged by this commit:
> 
> commit 334e580a6f97 ("fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR
> promotion")
> 
> so all the definitions needed by ext4 are available in
> include/uapi/linux/fs.h.  Remove the duplicates from ext4.h.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Cc: Li Xi <lixi@ddn.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@dilger.ca>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dave Chinner <dchinner@redhat.com>

Thanks, applied.

					- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
