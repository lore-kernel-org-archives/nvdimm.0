Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8230E820AD
 for <linux-nvdimm@lists.01.org>; Fri, 23 Dec 2016 05:45:41 -0800 (PST)
Date: Fri, 23 Dec 2016 14:45:39 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/4] dax: kill uml support
Message-ID: <20161223134539.GH22679@quack2.suse.cz>
References: <1482441536-14550-1-git-send-email-ross.zwisler@linux.intel.com>
 <1482441536-14550-2-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1482441536-14550-2-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: linux-arch@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 22-12-16 14:18:53, Ross Zwisler wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> The lack of common transparent-huge-page helpers for UML is becoming
> increasingly painful for fs/dax.c now that it is growing more pmd
> functionality. Add UML to the list of unsupported architectures.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> [rez: squashed #ifdef removal into another patch in the series ]
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Fine by me. You can add:

Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index c2a377c..661931f 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -37,7 +37,7 @@ source "fs/f2fs/Kconfig"
>  config FS_DAX
>  	bool "Direct Access (DAX) support"
>  	depends on MMU
> -	depends on !(ARM || MIPS || SPARC)
> +	depends on !(ARM || MIPS || SPARC || UML)
>  	help
>  	  Direct Access (DAX) can be used on memory-backed block devices.
>  	  If the block device supports DAX and the filesystem supports DAX,
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
