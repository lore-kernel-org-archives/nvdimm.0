Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D2351202E5446
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 11:36:23 -0700 (PDT)
Date: Wed, 18 Jul 2018 11:36:21 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] mm: disallow mapping that conflict for
 devm_memremap_pages()
Message-ID: <20180718183621.GE4949@bombadil.infradead.org>
References: <152909478401.50143.312364396244072931.stgit@djiang5-desk3.ch.intel.com>
 <x49efg04cx8.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49efg04cx8.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 18, 2018 at 02:27:31PM -0400, Jeff Moyer wrote:
> Hi, Dave,
> 
> Dave Jiang <dave.jiang@intel.com> writes:
> 
> > When pmem namespaces created are smaller than section size, this can cause
> > issue during removal and gpf was observed:
> >
> > Add code to check whether we have mapping already in the same section and
> > prevent additional mapping from created if that is the case.
> >
> > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > ---
> >
> > v2: Change dev_warn() to dev_WARN() to provide helpful backtrace. (Robert E)
> 
> OK, I can reproduce the issue.  What I don't like about your patch is
> that you can still get yourself into trouble.  Just create a namespace
> with a size that isn't aligned to 128MB, and then all further
> create-namespace operations will fail.  The only "fix" is to delete the
> odd-sized namespace and try again.  And that warning message doesn't
> really help the administrator to figure this out.
> 
> Why can't we simply round up to the next section automatically?  Either
> that, or have the kernel export a minimum namespace size of 128MB, and
> have ndctl enforce it?  I know we had some requests for 4MB namespaces,
> but it doesn't sound like those will be very useful if they're going to
> waste 124MB of space.
> 
> Or, we could try to fix this problem of having multiple namespace
> co-exist in the same memblock section.  That seems like the most obvious
> fix, but there must be a reason you didn't pursue it.
> 
> Dave, what do you think is the most viable option?

Just as a reminder, the desire for small pmem devices comes from cloud
usecases where you have teeny tiny layers, each of which might contain a
single package (eg a webserver or a database).  Because you're going to
run tens of thousands of instances, you don't want each machine to keep
a copy of the program text in pagecache; you want to have it in-memory
once and then DAX-map it in each guest.

While it's OK to waste a certain amount of each guest's physical memory,
when you have hundreds or thousands of these tiny layers, it adds up.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
