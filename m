Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5E9E20986AB9
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 10:17:34 -0700 (PDT)
Date: Tue, 17 Jul 2018 11:17:24 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/5] radix tree test suite: fix mapshift build target
Message-ID: <20180717171724.GB2251@linux.intel.com>
References: <20180503192430.7582-1-ross.zwisler@linux.intel.com>
 <20180503192430.7582-2-ross.zwisler@linux.intel.com>
 <20180715230052.GA6486@bombadil.infradead.org>
 <20180716160710.GA2287@linux.intel.com>
 <20180717031811.GD7934@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180717031811.GD7934@bombadil.infradead.org>
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, kbuild-all@01.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 16, 2018 at 08:18:11PM -0700, Matthew Wilcox wrote:
> On Mon, Jul 16, 2018 at 10:07:10AM -0600, Ross Zwisler wrote:
> > Incidentally, in the current linux/master the radix tree test suite again
> > fails to build:
> > 
> >   $ make
> >   sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < ../../../lib/radix-tree.c > radix-tree.c
> >   sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < ../../../lib/idr.c > idr.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o main.o main.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o linux.o linux.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o test.o test.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o find_bit.o ../../lib/find_bit.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o regression1.o regression1.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o regression2.o regression2.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o regression3.o regression3.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o tag_check.o tag_check.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o multiorder.o multiorder.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o idr-test.o idr-test.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o iteration_check.o iteration_check.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o benchmark.o benchmark.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o idr.o idr.c
> >   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o radix-tree.o radix-tree.c
> >   idr.c:7:10: fatal error: linux/xarray.h: No such file or directory
> >    #include <linux/xarray.h>
> >             ^~~~~~~~~~~~~~~~
> >   compilation terminated.
> 
> Umm.  I think I know the problem here.  I have a suspicion that either
> Fedora or you have changed make to be parallel by default (or you're
> lying to me and saying you typed 'make' when you actually typed 'make
> -j4', but I'm pretty sure you wouldn't do that).  Because there's no
> way you'd get this output if you were compiling with make -j1.
> 
> Indeed, if I revert your commit and then build with make -j4, I see the
> same error as you.  I'll look at how to fix this properly tomorrow.

Ah, yep.

  $ alias make
  alias make='make -j32'

You've found it. :)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
