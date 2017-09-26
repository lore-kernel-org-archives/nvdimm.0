Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF1672095E529
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 23:30:51 -0700 (PDT)
Date: Tue, 26 Sep 2017 08:34:02 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/7] mm, fs: introduce file_operations->post_mmap()
Message-ID: <20170926063402.GC6870@lst.de>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-7-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170925231404.32723-7-ross.zwisler@linux.intel.com>
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
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 25, 2017 at 05:14:03PM -0600, Ross Zwisler wrote:
> When mappings are created the vma->vm_flags that they use vary based on
> whether the inode being mapped is using DAX or not.  This setup happens in
> XFS via mmap_region()=>call_mmap()=>xfs_file_mmap().
> 
> For us to be able to safely use the DAX per-inode flag we need to prevent
> S_DAX transitions when any mappings are present, and we will do that by
> looking at the address_space->i_mmap tree and returning -EBUSY if any
> mappings are present.
> 
> Unfortunately at the time that the filesystem's file_operations->mmap()
> entry point is called the mapping has not yet been added to the
> address_space->i_mmap tree.  This means that at that point in time we
> cannot determine whether or not the mapping will be set up to support DAX.
> 
> Fix this by adding a new file_operations entry called post_mmap() which is
> called after the mapping has been added to the address_space->i_mmap tree.
> This post_mmap() op now happens at a time when we can be sure whether the
> mapping will use DAX or not, and we can set up the vma->vm_flags
> appropriately.

Just like in the read/write path we'll need a flag that is passed down
from the VM based on checking IS_DAX once and exactly once instead.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
