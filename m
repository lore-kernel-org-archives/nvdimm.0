Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 16EEB211616BE
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 08:06:37 -0700 (PDT)
Date: Tue, 2 Oct 2018 08:06:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Message-ID: <20181002150634.GA22209@infradead.org>
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002121039.GA3274@linux-x5ow.site>
 <20181002142010.GB4963@linux-x5ow.site>
 <20181002144547.GA26735@infradead.org>
 <20181002150123.GD4963@linux-x5ow.site>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181002150123.GD4963@linux-x5ow.site>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: mhocko@suse.cz, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 02, 2018 at 05:01:24PM +0200, Johannes Thumshirn wrote:
> On Tue, Oct 02, 2018 at 07:45:47AM -0700, Christoph Hellwig wrote:
> > How does an application "make use of DAX"?  What actual user visible
> > semantics are associated with a file that has this flag set?
> 
> There may not be any user visible semantics of DAX, but there are
> promises we gave to application developers praising DAX as _the_
> method to map data on persistent memory and get around "the penalty of
> the page cache" (however big this is).

Who is "we"?  As someone involved with DAX code I think it is a steaming
pile of *****, and we are still looking for cases where it actually
works without bugs.  That's why the experimental tag still is on it
for example.

> As I said in another mail to this thread, applications have started to
> poke in procfs to see whether they can use DAX or not.

And what are they actually doing with that?

> 
> Party A has promised party B

We have never promised anyone anything.

> So technically e1fb4a086495 is a user visible regression and in the
> past we have reverted patches introducing these, even if the patch is
> generally correct and poking in /proc/self/smaps is a bad idea.

What actually stops working here and why?  If some stupid app doesn't work
without mixedmap and we want to apply the don't break userspace mantra
hard we should just always expose it.

> I just wanted to give them a documented way to check for this
> promise. Being neutral if this promise is right or wrong, good or bad,
> or whatever. That's not my call, but I prefer not having angry users,
> yelling at me because of broken applications.

There is no promise, sorry.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
