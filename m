Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F5622095E518
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 23:33:40 -0700 (PDT)
Date: Tue, 26 Sep 2017 08:36:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/7] xfs: validate bdev support for DAX inode flag
Message-ID: <20170926063650.GE6870@lst.de>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-3-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170925231404.32723-3-ross.zwisler@linux.intel.com>
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

On Mon, Sep 25, 2017 at 05:13:59PM -0600, Ross Zwisler wrote:
> Currently only the blocksize is checked, but we should really be calling
> bdev_dax_supported() which also tests to make sure we can get a
> struct dax_device and that the dax_direct_access() path is working.
> 
> This is the same check that we do for the "-o dax" mount option in
> xfs_fs_fill_super().
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

I think we just want to pick this up ASAP.  And between my vague
memoried and that reviewed-by tag it already was part of a different
series, wasn't it?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
