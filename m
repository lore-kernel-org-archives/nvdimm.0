Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5B62F21F38832
 for <linux-nvdimm@lists.01.org>; Thu, 12 Oct 2017 08:49:05 -0700 (PDT)
Date: Thu, 12 Oct 2017 11:52:27 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 1/5] ext4: prevent data corruption with inline data +
 DAX
Message-ID: <20171012155227.o3dql7teq6gkghfo@thunk.org>
References: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
 <20170912050526.7627-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170912050526.7627-2-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 11, 2017 at 11:05:22PM -0600, Ross Zwisler wrote:
> If an inode has inline data it is currently prevented from using DAX by a
> check in ext4_set_inode_flags().  When the inode grows inline data via
> ext4_create_inline_data() or removes its inline data via
> ext4_destroy_inline_data_nolock(), the value of S_DAX can change.
> 
> Currently these changes are unsafe because we don't hold off page faults
> and I/O, write back dirty radix tree entries and invalidate all mappings.
> There are also issues with mm-level races when changing the value of S_DAX,
> as well as issues with the VM_MIXEDMAP flag:
> 
> https://www.spinics.net/lists/linux-xfs/msg09859.html
> 
> The unsafe transition of S_DAX can reliably cause data corruption, as shown
> by the following fstest:
> 
> https://patchwork.kernel.org/patch/9948381/
> 
> Fix this issue by preventing the DAX mount option from being used on
> filesystems that were created to support inline data.  Inline data is an
> option given to mkfs.ext4.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> CC: stable@vger.kernel.org

Thanks, applied.

					- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
