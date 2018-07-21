Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail03.adl6.internode.on.net (ipmail03.adl6.internode.on.net
 [150.101.137.143])
 by ml01.01.org (Postfix) with ESMTP id C5829210BFF74
 for <linux-nvdimm@lists.01.org>; Sat, 21 Jul 2018 16:45:53 -0700 (PDT)
Date: Sun, 22 Jul 2018 09:45:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] radix tree test suite: fix mapshift build target
Message-ID: <20180721234550.GB1691@dastard>
References: <20180503192430.7582-1-ross.zwisler@linux.intel.com>
 <20180503192430.7582-2-ross.zwisler@linux.intel.com>
 <20180715230052.GA6486@bombadil.infradead.org>
 <20180716160710.GA2287@linux.intel.com>
 <20180716195249.GA14380@bombadil.infradead.org>
 <20180716210820.GA17164@linux.intel.com>
 <20180717024132.GC7934@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180717024132.GC7934@bombadil.infradead.org>
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
Cc: Jan Kara <jack@suse.cz>, kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, kbuild-all@01.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 16, 2018 at 07:41:32PM -0700, Matthew Wilcox wrote:
> On Mon, Jul 16, 2018 at 03:08:20PM -0600, Ross Zwisler wrote:
> > On Mon, Jul 16, 2018 at 12:52:49PM -0700, Matthew Wilcox wrote:
> > > On Mon, Jul 16, 2018 at 10:07:10AM -0600, Ross Zwisler wrote:
> > <>
> > > OK ... what version of make are you using?  Because this works fine for me:
> > > 
> > > $ git clone linux clean
> > > $ cd clean
> > > $ git checkout v4.17
> > > $ cd tools/testing/radix-tree/ 
> > > $ git revert 8d9fa88edd5e360b71765feeadb915d4066c9684
> > > $ make
> > > 
> > > $ make --version
> > > GNU Make 4.1
> > > Built for x86_64-pc-linux-gnu
> > > 
> > > It's Debian's Version: 4.1-9.1
> > 
> > $ make --version
> > GNU Make 4.2.1
> > Built for x86_64-redhat-linux-gnu
> > 
> > The one from Fedora 27.
> 
> Huh.  I just tried 4.2.1-1.1 from Debian unstable and that doesn't
> produce the problem either.  I'm not sure how to proceed at this point.
> I'm really not a makefile expert.

This smells like a problem we just hit with make 4.2.1 in fedora 28
in fstests - the regex expanstion has been screwed up such that
things like [a-z] will match [A-Z] and other things as well. Debian
is unaffected, apparently fedora has a backport of stuff from the
as-yet-unreleased next version of make/glibc. See this thread:

https://www.spinics.net/lists/fstests/msg10200.html

Try setting LANG=C and seeing if the problem goes away....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
