Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id D37C11A20E7
 for <linux-nvdimm@lists.01.org>; Fri, 15 Apr 2016 13:12:23 -0700 (PDT)
Date: Fri, 15 Apr 2016 14:10:58 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] dax: integrate *sync code & multi-order radix tree
Message-ID: <20160415201058.GA20412@linux.intel.com>
References: <1460667804-21725-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460667804-21725-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 14, 2016 at 03:03:24PM -0600, Ross Zwisler wrote:
> With the new addition of the multi-order radix tree support we can simplify
> the DAX *sync PMD support a bit.  Instead of manually checking to see if
> our index is covered by a PMD entry we can rely on the new radix tree to
> return the PMD entry if present.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Sorry, I should have explicitly called out that this patch (indeed, all
multi-order uses of the radix tree) need to be built upon the recent
multi-order fixes from Matthew and me:

https://lkml.org/lkml/2016/4/14/481

I've posted a working tree here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_mo_radix

Thanks,
- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
