Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EF9F6207E4DE7
 for <linux-nvdimm@lists.01.org>; Thu, 17 May 2018 12:29:10 -0700 (PDT)
Date: Thu, 17 May 2018 13:29:10 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] dax: Fix use of zero page
Message-ID: <20180517192910.GA20262@linux.intel.com>
References: <20180517183711.GE26718@bombadil.infradead.org>
 <20180517192400.GA19772@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180517192400.GA19772@linux.intel.com>
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
Cc: Matthew Wilcox <willy@infradead.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 17, 2018 at 01:24:00PM -0600, Ross Zwisler wrote:
> On Thu, May 17, 2018 at 11:37:11AM -0700, Matthew Wilcox wrote:
> > 
> > I plucked this patch from my XArray work.  It seems self-contained enough
> > that it could go into the DAX tree for merging this cycle.
> > 
> > From 8cb56f4ba36af38814ca7b8ba030a66384e59a21 Mon Sep 17 00:00:00 2001
> > From: Matthew Wilcox <mawilcox@microsoft.com>
> > Date: Thu, 29 Mar 2018 22:41:18 -0400
> > Subject: [PATCH] dax: Fix use of zero page
> > 
> > Use my_zero_pfn instead of ZERO_PAGE, and pass the vaddr to it so it
> > works on MIPS and s390.
> > 
> > Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Yep, this looks fine.
> 
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Huh, actually, it looks like this relies on patch 01/63 of your full Xarray
series where you s/RADIX_DAX_ZERO_PAGE/DAX_ZERO_PAGE/g.

Ditto for the 2nd patch you sent today.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
