Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22ABF21EC8CF3
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 10:13:27 -0700 (PDT)
Date: Tue, 26 Sep 2017 11:16:38 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/7] xfs: validate bdev support for DAX inode flag
Message-ID: <20170926171638.GA20159@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-3-ross.zwisler@linux.intel.com>
 <20170926063650.GE6870@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170926063650.GE6870@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 26, 2017 at 08:36:50AM +0200, Christoph Hellwig wrote:
> On Mon, Sep 25, 2017 at 05:13:59PM -0600, Ross Zwisler wrote:
> > Currently only the blocksize is checked, but we should really be calling
> > bdev_dax_supported() which also tests to make sure we can get a
> > struct dax_device and that the dax_direct_access() path is working.
> > 
> > This is the same check that we do for the "-o dax" mount option in
> > xfs_fs_fill_super().
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I think we just want to pick this up ASAP.  And between my vague
> memoried and that reviewed-by tag it already was part of a different
> series, wasn't it?

Yep, the first 2 patches were part of this series:

https://lkml.org/lkml/2017/9/7/552

which you reviewed.  I included them in this series because the later patches
needed to build on them.  It looks like they are now in Darrick's
xfs-4.14-fixes branch, but haven't yet made it upstream.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
