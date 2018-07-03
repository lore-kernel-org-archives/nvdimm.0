Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D7712097F558
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jul 2018 10:44:15 -0700 (PDT)
Date: Tue, 3 Jul 2018 13:44:02 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 1/2] dax: dax_layout_busy_page() warn on !exceptional
Message-ID: <20180703174402.GD4384@thunk.org>
References: <20180627212252.31032-1-ross.zwisler@linux.intel.com>
 <20180627212252.31032-2-ross.zwisler@linux.intel.com>
 <20180702221503.GA12830@thunk.org>
 <20180703154137.GB13019@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180703154137.GB13019@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 03, 2018 at 09:41:37AM -0600, Ross Zwisler wrote:
> 
> It looks like you only picked up patch 1/2?  (I'm looking at the 'dev' branch
> in your repo.)  Was that intentional?

Actually, it was a mistake, in that if you looked at the commit, it's
currently an empty commit.  The patch failed to apply because the ext4
tree is still based on v4.17-rc4.

My current plan is to hold the two patches until I get the current
patch of fixes pushed to Linus (probably in the next day or two; I'll
drop the empty commit before I send a pull request to reduce
confusion).  I'll then reset the ext4 tree to be based on v4.17 (or
possibly v4.18-rcX if that is necessary) and then apply the two
patches in this series.

Apologies for the confusion....

						- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
