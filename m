Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB24F1A1DF2
 for <linux-nvdimm@lists.01.org>; Wed, 17 Aug 2016 10:19:59 -0700 (PDT)
Date: Wed, 17 Aug 2016 19:19:55 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: allow DAX writeback for hole punch
Message-ID: <20160817171955.GA30893@quack2.suse.cz>
References: <20160817161102.2185-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160817161102.2185-1-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 17-08-16 10:11:02, Ross Zwisler wrote:
> Currently when doing a DAX hole punch with ext4 we fail to do a writeback.
> This is because the logic around filemap_write_and_wait_range() in
> ext4_punch_hole() only looks for dirty page cache pages in the radix tree,
> not for dirty DAX exceptional entries.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Thanks. The patch looks correct, you can add:

Reviewed-by: Jan Kara <jack@suse.cz>

Although why don't we just simplify the test below to
mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)? After all the mapping should
not have the dirty tag set if there are no pages / no entries?

								Honza

> @@ -3919,7 +3919,9 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>  	 * Write out all dirty pages to avoid race conditions
>  	 * Then release them.
>  	 */
> -	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> +	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
> +	    ((!dax_mapping(mapping) && mapping->nrpages) ||
> +	     (dax_mapping(mapping) && mapping->nrexceptional))) {
>  		ret = filemap_write_and_wait_range(mapping, offset,
>  						   offset + length - 1);
>  		if (ret)
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
