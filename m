Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2BFD92194D3B8
 for <linux-nvdimm@lists.01.org>; Thu,  6 Jun 2019 03:58:57 -0700 (PDT)
Date: Thu, 6 Jun 2019 12:58:55 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC 07/10] fs/ext4: Fail truncate if pages are GUP pinned
Message-ID: <20190606105855.GG7433@quack2.suse.cz>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606014544.8339-8-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190606014544.8339-8-ira.weiny@intel.com>
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
To: ira.weiny@intel.com
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, John Hubbard <jhubbard@nvidia.com>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 05-06-19 18:45:40, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> If pages are actively gup pinned fail the truncate operation.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  fs/ext4/inode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 75f543f384e4..1ded83ec08c0 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4250,6 +4250,9 @@ int ext4_break_layouts(struct inode *inode, loff_t offset, loff_t len)
>  		if (!page)
>  			return 0;
>  
> +		if (page_gup_pinned(page))
> +			return -ETXTBSY;
> +
>  		error = ___wait_var_event(&page->_refcount,
>  				atomic_read(&page->_refcount) == 1,
>  				TASK_INTERRUPTIBLE, 0, 0,

This caught my eye. Does this mean that now truncate for a file which has
temporary gup users (such buffers for DIO) can fail with ETXTBUSY? That
doesn't look desirable. If we would mandate layout lease while pages are
pinned as I suggested, this could be dealt with by checking for leases with
pins (breaking such lease would return error and not break it) and if
breaking leases succeeds (i.e., there are no long-term pinned pages), we'd
just wait for the remaining references as we do now.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
