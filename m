Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 735D82096FACB
 for <linux-nvdimm@lists.01.org>; Sun, 15 Jul 2018 16:01:01 -0700 (PDT)
Date: Sun, 15 Jul 2018 16:00:52 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/5] radix tree test suite: fix mapshift build target
Message-ID: <20180715230052.GA6486@bombadil.infradead.org>
References: <20180503192430.7582-1-ross.zwisler@linux.intel.com>
 <20180503192430.7582-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180503192430.7582-2-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 03, 2018 at 01:24:26PM -0600, Ross Zwisler wrote:
> The following commit
> 
>   commit c6ce3e2fe3da ("radix tree test suite: Add config option for map
>   shift")
> 
> Introduced a phony makefile target called 'mapshift' that ends up
> generating the file generated/map-shift.h.  This phony target was then
> added as a dependency of the top level 'targets' build target, which is
> what is run when you go to tools/testing/radix-tree and just type 'make'.
> 
> Unfortunately, this phony target doesn't actually work as a dependency, so
> you end up getting:
> 
> $ make
> make: *** No rule to make target 'generated/map-shift.h', needed by 'main.o'.  Stop.
> make: *** Waiting for unfinished jobs....
> 
> Fix this by making the file generated/map-shift.h our real makefile target,
> and add this a dependency of the top level build target.

This commit breaks typing 'make SHIFT=6'.  It doesn't rebuild the
test suite any more.  If I revert this patch, it works.  Also, I can't
reproduce the problem you're reporting here.  So ... how do I reproduce
it?  Otherwise, I'm just going to revert this patch since it regresses
a feature I find useful.

> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  tools/testing/radix-tree/Makefile | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/radix-tree/Makefile b/tools/testing/radix-tree/Makefile
> index fa7ee369b3c9..db66f8a0d4be 100644
> --- a/tools/testing/radix-tree/Makefile
> +++ b/tools/testing/radix-tree/Makefile
> @@ -17,7 +17,7 @@ ifeq ($(BUILD), 32)
>  	LDFLAGS += -m32
>  endif
>  
> -targets: mapshift $(TARGETS)
> +targets: generated/map-shift.h $(TARGETS)
>  
>  main:	$(OFILES)
>  
> @@ -42,9 +42,7 @@ radix-tree.c: ../../../lib/radix-tree.c
>  idr.c: ../../../lib/idr.c
>  	sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < $< > $@
>  
> -.PHONY: mapshift
> -
> -mapshift:
> +generated/map-shift.h:
>  	@if ! grep -qws $(SHIFT) generated/map-shift.h; then		\
>  		echo "#define RADIX_TREE_MAP_SHIFT $(SHIFT)" >		\
>  				generated/map-shift.h;			\
> -- 
> 2.14.3
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
