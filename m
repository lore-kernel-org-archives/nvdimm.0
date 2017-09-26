Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 26 Sep 2017 08:36:11 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/7] xfs: re-enable XFS per-inode DAX
Message-ID: <20170926063611.GD6870@lst.de>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com> <20170925231404.32723-8-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170925231404.32723-8-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 25, 2017 at 05:14:04PM -0600, Ross Zwisler wrote:
> Re-enable the XFS per-inode DAX flag, preventing S_DAX from changing when
> any mappings are present.

Before we re-enable it please come up with a coherent description
of the per-inode DAX flag that makes sense to a user.  We'll also need
to find a good place to document it, e.g. a new ioctl_setflags man
page.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
