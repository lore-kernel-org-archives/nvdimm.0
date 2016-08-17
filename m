Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id B416D1A1DF1
 for <linux-nvdimm@lists.01.org>; Wed, 17 Aug 2016 11:07:23 -0700 (PDT)
Date: Wed, 17 Aug 2016 12:07:22 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] ext4: allow DAX writeback for hole punch
Message-ID: <20160817180722.GB16779@linux.intel.com>
References: <20160817161102.2185-1-ross.zwisler@linux.intel.com>
 <20160817171955.GA30893@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160817171955.GA30893@quack2.suse.cz>
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
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 17, 2016 at 07:19:55PM +0200, Jan Kara wrote:
> On Wed 17-08-16 10:11:02, Ross Zwisler wrote:
> > Currently when doing a DAX hole punch with ext4 we fail to do a writeback.
> > This is because the logic around filemap_write_and_wait_range() in
> > ext4_punch_hole() only looks for dirty page cache pages in the radix tree,
> > not for dirty DAX exceptional entries.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Thanks. The patch looks correct, you can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Although why don't we just simplify the test below to
> mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)? After all the mapping should
> not have the dirty tag set if there are no pages / no entries?

Sure, that works.  I'll update to that in V2, and I'll add stable.  Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
