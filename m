Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 725872194D387
 for <linux-nvdimm@lists.01.org>; Fri,  5 Jul 2019 12:10:07 -0700 (PDT)
Date: Fri, 5 Jul 2019 12:10:04 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190705191004.GC32320@bombadil.infradead.org>
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190703121743.GH1729@bombadil.infradead.org>
 <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Seema Pandit <seema.pandit@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Boaz Harrosh <openosd@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 04, 2019 at 04:27:14PM -0700, Dan Williams wrote:
> On Thu, Jul 4, 2019 at 12:14 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Jul 04, 2019 at 06:54:50PM +0200, Jan Kara wrote:
> > > On Wed 03-07-19 20:27:28, Matthew Wilcox wrote:
> > > > So I think we're good for all current users.
> > >
> > > Agreed but it is an ugly trap. As I already said, I'd rather pay the
> > > unnecessary cost of waiting for pte entry and have an easy to understand
> > > interface. If we ever have a real world use case that would care for this
> > > optimization, we will need to refactor functions to make this possible and
> > > still keep the interfaces sane. For example get_unlocked_entry() could
> > > return special "error code" indicating that there's no entry with matching
> > > order in xarray but there's a conflict with it. That would be much less
> > > error-prone interface.
> >
> > This is an internal interface.  I think it's already a pretty gnarly
> > interface to use by definition -- it's going to sleep and might return
> > almost anything.  There's not much scope for returning an error indicator
> > either; value entries occupy half of the range (all odd numbers between 1
> > and ULONG_MAX inclusive), plus NULL.  We could use an internal entry, but
> > I don't think that makes the interface any easier to use than returning
> > a locked entry.
> >
> > I think this iteration of the patch makes it a little clearer.  What do you
> > think?
> >
> 
> Not much clearer to me. get_unlocked_entry() is now misnamed and this

misnamed?  You'd rather it was called "try_get_unlocked_entry()"?

> arrangement allows for mismatches of @order argument vs @xas
> configuration.

> Can you describe, or even better demonstrate with
> numbers, why it's better to carry this complication than just
> converging the waitqueues between the types?

You've got the reproducer ;-)  It seems quite wrong to make a page fault
stall just because another task is working on a different page in the
same 2MB chunk.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
