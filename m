Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 24A3C21195BF1
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 10:59:08 -0800 (PST)
Date: Tue, 27 Nov 2018 10:59:06 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: dax_lock_mapping_entry was never safe
Message-ID: <20181127185906.GE10377@bombadil.infradead.org>
References: <20181126161240.GH3065@bombadil.infradead.org>
 <20181126171137.GD25835@quack2.suse.cz>
 <CAPcyv4j8Qo0rZniWcjrtScBWNsG6=geyZU1yfRK=4wGsJ5=e8A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4j8Qo0rZniWcjrtScBWNsG6=geyZU1yfRK=4wGsJ5=e8A@mail.gmail.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 26, 2018 at 12:36:26PM -0800, Dan Williams wrote:
> On Mon, Nov 26, 2018 at 9:11 AM Jan Kara <jack@suse.cz> wrote:
> > The code looks good. Maybe can we call this wait_entry_unlocked() to stress
> > that entry is not really usable after this function returns? And comment
> > before the function that this is safe to call even if we don't have a
> > reference keeping mapping alive?
> 
> Yes, maybe even something more ambiguous like "wait_entry_event()",
> because there's no guarantee the entry is unlocked just that now is a
> good time to try to interrogate the entry again.

It _became_ unlocked ... it might be locked again, or have disappeared
by the time we get to it, but somebody called dax_wake_entry() for this
exact entry.  I mean, we could call it wait_entry_wake(), but I think
that's a little generic.  I'm going with Jan's version ;-)

> > The continue here actually is not safe either because if the mapping got
> > freed, page->mapping will be NULL and we oops at the beginning of the loop.
> > So that !dax_mapping() check should also check for mapping != NULL.
> 
> Yes.

Sigh.  I'll make that a separate patch so it applies cleanly to 4.19.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
