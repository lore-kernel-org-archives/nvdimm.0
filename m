Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 14 Dec 2016 13:41:18 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 1/3] dax: masking off __GFP_FS in fs DAX handlers
Message-ID: <20161214204118.GA14901@linux.intel.com>
References: <148174532372.194339.4875475197715168429.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148174532372.194339.4875475197715168429.stgit@djiang5-desk3.ch.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dave Jiang <dave.jiang@intel.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, hch@lst.de, linux-mm@kvack.org, tytso@mit.edu, ross.zwisler@linux.intel.com, dan.j.williams@intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 14, 2016 at 12:55:23PM -0700, Dave Jiang wrote:
> The callers into dax needs to clear __GFP_FS since they are responsible
> for acquiring locks / transactions that block __GFP_FS allocation. They
> will restore the lag when dax function return.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

This seems correct to me.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
