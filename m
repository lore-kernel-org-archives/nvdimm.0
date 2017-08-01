Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1749C21AEB0A8
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 10:58:10 -0700 (PDT)
Date: Tue, 1 Aug 2017 12:00:17 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] nvdimm: avoid bogus -Wmaybe-uninitialized warning
Message-ID: <20170801180017.GC20061@linux.intel.com>
References: <20170801114926.1171418-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170801114926.1171418-1-arnd@arndb.de>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 01, 2017 at 01:48:48PM +0200, Arnd Bergmann wrote:
> Removing the btt_rw_page/pmem_rw_page functions had a surprising
> side-effect of introducing a false-positive warning in another
> function, due to changed inlining decisions in gcc:
> 
> In file included from drivers/nvdimm/pmem.c:36:0:
> drivers/nvdimm/pmem.c: In function 'pmem_make_request':
> drivers/nvdimm/nd.h:407:2: error: 'start' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> drivers/nvdimm/pmem.c:174:16: note: 'start' was declared here
> In file included from drivers/nvdimm/btt.c:27:0:
> drivers/nvdimm/btt.c: In function 'btt_make_request':
> drivers/nvdimm/nd.h:407:2: error: 'start' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> drivers/nvdimm/btt.c:1202:16: note: 'start' was declared here
> 
> The problem is that gcc fails to track the value of the 'do_acct'
> variable here and has to read it back from stack, but it does
> remember that 'start' may be uninitialized sometimes.
> 
> This shuts up the warning by making nd_iostat_start() always
> initialize the 'start' variable. In those cases that gcc successfully
> tracks the state of the variable, this will have no effect.
> 
> Fixes: 503a5e89b1de ("drivers/nvdimm/btt.c: remove btt_rw_page()")
> Fixes: 58100d6e735e ("drivers/nvdimm/pmem.c: remove pmem_rw_page()")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This change looks fine:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

I believe the patches removing the btt_rw_page() and btt_rw_page() are on hold
until I can get some performance numbers to justify them.

Dan, do you want to take this as is, or do you want me to include it in my
larger rw_page() series if/when that gets revived?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
