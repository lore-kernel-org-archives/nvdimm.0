Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8CF8D210F157A
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jul 2018 08:41:40 -0700 (PDT)
Date: Tue, 3 Jul 2018 09:41:37 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 1/2] dax: dax_layout_busy_page() warn on !exceptional
Message-ID: <20180703154137.GB13019@linux.intel.com>
References: <20180627212252.31032-1-ross.zwisler@linux.intel.com>
 <20180627212252.31032-2-ross.zwisler@linux.intel.com>
 <20180702221503.GA12830@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180702221503.GA12830@thunk.org>
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
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 02, 2018 at 06:15:03PM -0400, Theodore Y. Ts'o wrote:
> On Wed, Jun 27, 2018 at 03:22:51PM -0600, Ross Zwisler wrote:
> > Inodes using DAX should only ever have exceptional entries in their page
> > caches.  Make this clear by warning if the iteration in
> > dax_layout_busy_page() ever sees a non-exceptional entry, and by adding a
> > comment for the pagevec_release() call which only deals with struct page
> > pointers.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Thanks, applied (to the ext4 tree).  If someone thinks they should go
> in via some other tree, holler.
> 
> 					- Ted

Hey Ted,

It looks like you only picked up patch 1/2?  (I'm looking at the 'dev' branch
in your repo.)  Was that intentional?

You can find the final version of the 2nd patch here:

https://lists.01.org/pipermail/linux-nvdimm/2018-July/016602.html

Thanks,
- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
