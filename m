Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Mon, 16 Jul 2018 19:41:32 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/5] radix tree test suite: fix mapshift build target
Message-ID: <20180717024132.GC7934@bombadil.infradead.org>
References: <20180503192430.7582-1-ross.zwisler@linux.intel.com>
 <20180503192430.7582-2-ross.zwisler@linux.intel.com>
 <20180715230052.GA6486@bombadil.infradead.org>
 <20180716160710.GA2287@linux.intel.com>
 <20180716195249.GA14380@bombadil.infradead.org>
 <20180716210820.GA17164@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180716210820.GA17164@linux.intel.com>
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

On Mon, Jul 16, 2018 at 03:08:20PM -0600, Ross Zwisler wrote:
> On Mon, Jul 16, 2018 at 12:52:49PM -0700, Matthew Wilcox wrote:
> > On Mon, Jul 16, 2018 at 10:07:10AM -0600, Ross Zwisler wrote:
> <>
> > OK ... what version of make are you using?  Because this works fine for me:
> > 
> > $ git clone linux clean
> > $ cd clean
> > $ git checkout v4.17
> > $ cd tools/testing/radix-tree/ 
> > $ git revert 8d9fa88edd5e360b71765feeadb915d4066c9684
> > $ make
> > 
> > $ make --version
> > GNU Make 4.1
> > Built for x86_64-pc-linux-gnu
> > 
> > It's Debian's Version: 4.1-9.1
> 
> $ make --version
> GNU Make 4.2.1
> Built for x86_64-redhat-linux-gnu
> 
> The one from Fedora 27.

Huh.  I just tried 4.2.1-1.1 from Debian unstable and that doesn't
produce the problem either.  I'm not sure how to proceed at this point.
I'm really not a makefile expert.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
