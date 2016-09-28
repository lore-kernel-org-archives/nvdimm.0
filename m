Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
 [150.101.137.145]) by ml01.01.org (Postfix) with ESMTP id 931951A1E1F
 for <linux-nvdimm@lists.01.org>; Tue, 27 Sep 2016 17:20:51 -0700 (PDT)
Date: Wed, 28 Sep 2016 10:20:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] dax: Avoid page invalidation races and unnecessary
 radix tree traversals
Message-ID: <20160928002034.GF9806@dastard>
References: <1474994615-29553-1-git-send-email-jack@suse.cz>
 <1474994615-29553-7-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1474994615-29553-7-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 27, 2016 at 06:43:35PM +0200, Jan Kara wrote:
> @@ -1410,6 +1422,17 @@ iomap_dax_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED))
>  		return -EIO;
>  
> +	/*
> +	 * Write can allocate block for an area which has a hole page mapped
> +	 * into page tables. We have to tear down these mappings so that data
> +	 * written by write(2) is visible in mmap.
> +	 */
> +	if (iomap->flags & IOMAP_F_NEW && inode->i_mapping->nrpages) {

gcc should be throwing warnings about that:

	if ((iomap->flags & IOMAP_F_NEW) && inode->i_mapping->nrpages) {

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
