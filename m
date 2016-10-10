Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 70E6D1A1E3D
 for <linux-nvdimm@lists.01.org>; Mon, 10 Oct 2016 08:50:06 -0700 (PDT)
Date: Mon, 10 Oct 2016 17:50:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 13/17] dax: dax_iomap_fault() needs to call iomap_end()
Message-ID: <20161010155004.GD19343@lst.de>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-14-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1475874544-24842-14-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 07, 2016 at 03:09:00PM -0600, Ross Zwisler wrote:
> Currently iomap_end() doesn't do anything for DAX page faults for both ext2
> and XFS.  ext2_iomap_end() just checks for a write underrun, and
> xfs_file_iomap_end() checks to see if it needs to finish a delayed
> allocation.  However, in the future iomap_end() calls might be needed to
> make sure we have balanced allocations, locks, etc.  So, add calls to
> iomap_end() with appropriate error handling to dax_iomap_fault().

Is there a way to just have a single call to iomap_end at the end of
the function, after which we just return a previosuly setup return
value?

e.g.

out:
	if (ops->iomap_end) {
		error = ops->iomap_end(inode, pos, PAGE_SIZE,
				PAGE_SIZE, flags, &iomap);
	}

	if (error == -ENOMEM)
		return VM_FAULT_OOM | major;
	if (error < 0 && error != -EBUSY)
		return VM_FAULT_SIGBUS | major;
	return ret;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
