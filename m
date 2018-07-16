Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Mon, 16 Jul 2018 12:52:49 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/5] radix tree test suite: fix mapshift build target
Message-ID: <20180716195249.GA14380@bombadil.infradead.org>
References: <20180503192430.7582-1-ross.zwisler@linux.intel.com>
 <20180503192430.7582-2-ross.zwisler@linux.intel.com>
 <20180715230052.GA6486@bombadil.infradead.org>
 <20180716160710.GA2287@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180716160710.GA2287@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, kbuild-all@01.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 16, 2018 at 10:07:10AM -0600, Ross Zwisler wrote:
> On Sun, Jul 15, 2018 at 04:00:52PM -0700, Matthew Wilcox wrote:
> > On Thu, May 03, 2018 at 01:24:26PM -0600, Ross Zwisler wrote:
> > > Unfortunately, this phony target doesn't actually work as a dependency, so
> > > you end up getting:
> > > 
> > > $ make
> > > make: *** No rule to make target 'generated/map-shift.h', needed by 'main.o'.  Stop.
> > > make: *** Waiting for unfinished jobs....
> > > 
> > > Fix this by making the file generated/map-shift.h our real makefile target,
> > > and add this a dependency of the top level build target.
> > 
> > This commit breaks typing 'make SHIFT=6'.  It doesn't rebuild the
> > test suite any more.  If I revert this patch, it works.  Also, I can't
> > reproduce the problem you're reporting here.  So ... how do I reproduce
> > it?  Otherwise, I'm just going to revert this patch since it regresses
> > a feature I find useful.
> 
> The test suite builds fine for me in v4.17.  From a completely clean tree, in
> tools/testing/radix-tree:
> 
>   $ make
>   sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < ../../../lib/radix-tree.c > radix-tree.c
>   sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < ../../../lib/idr.c > idr.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o main.o main.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o linux.o linux.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o test.o test.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o find_bit.o ../../lib/find_bit.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o regression1.o regression1.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o regression2.o regression2.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o regression3.o regression3.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o tag_check.o tag_check.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o multiorder.o multiorder.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o idr-test.o idr-test.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o iteration_check.o iteration_check.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o benchmark.o benchmark.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o idr.o idr.c
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o radix-tree.o radix-tree.c
>   cc -fsanitize=address  multiorder.o radix-tree.o idr.o linux.o test.o find_bit.o  -lpthread -lurcu -o multiorder
>   cc -fsanitize=address  main.o radix-tree.o idr.o linux.o test.o find_bit.o regression1.o regression2.o regression3.o tag_check.o multiorder.o idr-test.o iteration_check.o benchmark.o  -lpthread -lurcu -o main
>   cc -fsanitize=address  idr-test.o radix-tree.o idr.o linux.o test.o find_bit.o  -lpthread -lurcu -o idr-test
> 
> and you can successfully run the radix tree test suite by running 'main'.
> 
> With the above mentioned commit reverted, this build fails:
> 
>   $ make
>   make: *** No rule to make target 'generated/map-shift.h', needed by 'main.o'.  Stop.
>   make: *** Waiting for unfinished jobs....

OK ... what version of make are you using?  Because this works fine for me:

$ git clone linux clean
$ cd clean
$ git checkout v4.17
$ cd tools/testing/radix-tree/ 
$ git revert 8d9fa88edd5e360b71765feeadb915d4066c9684
$ make

$ make --version
GNU Make 4.1
Built for x86_64-pc-linux-gnu

It's Debian's Version: 4.1-9.1

> If you want generated/map-shift.h to be rebuilt each time you run 'make' so
> that it can take a new SHIFT argument, that's fine, but let's not make users
> run 'make mapshift' before an actual 'make' will work, which is where we're at
> with v4.17 with my commit reverted.

I don't want it to be rebuilt, I want it to be checked before each
build, regenerated if SHIFT has changed, and everything to rebuild if
it has changed.

> Incidentally, in the current linux/master the radix tree test suite again
> fails to build:
> 
>   cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=address   -c -o radix-tree.o radix-tree.c
>   idr.c:7:10: fatal error: linux/xarray.h: No such file or directory
>    #include <linux/xarray.h>
>             ^~~~~~~~~~~~~~~~
>   compilation terminated.
>   make: *** [<builtin>: idr.o] Error 1
> 
> Can you look into this?  

Ah ... Andrew broke it fixing something else ;-)  The first commit in
my xarray branch fixes it -- looks like I tested my own commits but not
the commit I based on ;-)

diff --git a/tools/testing/radix-tree/linux/xarray.h b/tools/testing/radix-tree/linux/xarray.h
new file mode 100644
index 000000000000..df3812cda376
--- /dev/null
+++ b/tools/testing/radix-tree/linux/xarray.h
@@ -0,0 +1,2 @@
+#include "generated/map-shift.h"
+#include "../../../../include/linux/xarray.h"


> 0-day folks, would it be possible for you to add a radix tree build & test
> runs to your automated tests?  We would really appreciate any help in reducing
> this kind of breakage, which seems to happen pretty often.

Yeah, that would be good.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
