Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DDF372034C083
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 06:13:58 -0700 (PDT)
Date: Thu, 19 Oct 2017 15:17:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/17] xfs: support for synchronous DAX faults
Message-ID: <20171019131735.GC20645@lst.de>
References: <20171019125817.11580-1-jack@suse.cz>
 <20171019125817.11580-18-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171019125817.11580-18-jack@suse.cz>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

> +#define XFS_MAP_SUPPORTED (LEGACY_MAP_MASK | MAP_SYNC)

I'd kill this define.  Also is there any good reason that we have
to add LEGACY_MAP_MASK instead of assuming it's supported in the
core?

>  #endif
>  	.mmap		= xfs_file_mmap,
> +	.mmap_supported_flags	= XFS_MAP_SUPPORTED,
>  	.open		= xfs_file_open,
>  	.release	= xfs_file_release,
>  	.fsync		= xfs_file_fsync,

I usually either reformat all members to be aligned again, or if that's
too much churn (in this case it probably is) just use a single space
before the = to minimize the alignment differences.

Otherwise your changes look good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
