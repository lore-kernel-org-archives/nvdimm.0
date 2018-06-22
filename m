Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E204210D515A
 for <linux-nvdimm@lists.01.org>; Fri, 22 Jun 2018 01:25:35 -0700 (PDT)
Date: Fri, 22 Jun 2018 10:25:33 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: handle layout changes to pinned DAX mappings
Message-ID: <20180622082533.biejwdtrn4tymiy4@quack2.suse.cz>
References: <20180620221503.25237-1-ross.zwisler@linux.intel.com>
 <20180620221503.25237-3-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180620221503.25237-3-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 20-06-18 16:15:03, Ross Zwisler wrote:
> diff --git a/fs/ext4/truncate.h b/fs/ext4/truncate.h
> index 0cb13badf473..a3b78241e9f6 100644
> --- a/fs/ext4/truncate.h
> +++ b/fs/ext4/truncate.h
> @@ -12,6 +12,7 @@
>  static inline void ext4_truncate_failed_write(struct inode *inode)
>  {
>  	down_write(&EXT4_I(inode)->i_mmap_sem);
> +	ext4_break_layouts(inode);
>  	truncate_inode_pages(inode->i_mapping, inode->i_size);
>  	ext4_truncate(inode);
>  	up_write(&EXT4_I(inode)->i_mmap_sem);

One comment here: I don't think ext4_break_layouts() is necessary here.
ext4_truncate_failed_write() exists to truncate blocks beyond EOF. As such
these blocks could never be even mmaped, let alone pinned by GUP. Maybe
just add a comment that blocks we are truncating here were never visible to
userspace and so we don't need ext4_break_layouts() protection.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
