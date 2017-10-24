Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3978D21CEB121
 for <linux-nvdimm@lists.01.org>; Tue, 24 Oct 2017 14:25:25 -0700 (PDT)
Date: Tue, 24 Oct 2017 15:29:08 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 17/17] xfs: support for synchronous DAX faults
Message-ID: <20171024212908.GC1611@linux.intel.com>
References: <20171024152415.22864-1-jack@suse.cz>
 <20171024152415.22864-18-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171024152415.22864-18-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 24, 2017 at 05:24:14PM +0200, Jan Kara wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Return IOMAP_F_DIRTY from xfs_file_iomap_begin() when asked to prepare
> blocks for writing and the inode is pinned, and has dirty fields other
> than the timestamps.  In __xfs_filemap_fault() we then detect this case
> and call dax_finish_sync_fault() to make sure all metadata is committed,
> and to insert the page table entry.
> 
> Note that this will also dirty corresponding radix tree entry which is
> what we want - fsync(2) will still provide data integrity guarantees for
> applications not using userspace flushing. And applications using
> userspace flushing can avoid calling fsync(2) and thus avoid the
> performance overhead.
> 
> [JK: Added VM_SYNC flag handling]
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jan Kara <jack@suse.cz>

I don't know enough about XFS dirty inode handling to be able to comment on
the changes in xfs_file_iomap_begin(), but the rest looks good.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
