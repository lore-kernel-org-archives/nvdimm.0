Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 45F51212AB4DE
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jun 2019 09:39:13 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id s20so6603598otp.4
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jun 2019 09:39:13 -0700 (PDT)
MIME-Version: 1.0
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190627123415.GA4286@bombadil.infradead.org>
 <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
 <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
 <CAPcyv4h6HgNE38RF5TxO3C268ZvrxgcPNrPWOt94MnO5gP_pjw@mail.gmail.com>
 <CAPcyv4gwd1_VHk_MfHeNSxyH+N1=aatj9WkKXqYNPkSXe4bFDg@mail.gmail.com>
 <20190627195948.GB4286@bombadil.infradead.org>
 <CAPcyv4iB3f1hDdCsw=Cy234dP-RXpxGyXDoTwEU8nt5qUDEVQg@mail.gmail.com>
 <20190628163721.GC4286@bombadil.infradead.org>
In-Reply-To: <20190628163721.GC4286@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Jun 2019 09:39:01 -0700
Message-ID: <CAPcyv4jeRwhYWnGw9RrfDA54RRa9LK4JPuF3zQ-av=HdRqCTJw@mail.gmail.com>
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
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
Cc: Seema Pandit <seema.pandit@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 28, 2019 at 9:37 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Jun 27, 2019 at 07:39:37PM -0700, Dan Williams wrote:
> > On Thu, Jun 27, 2019 at 12:59 PM Matthew Wilcox <willy@infradead.org> wrote:
> > > On Thu, Jun 27, 2019 at 12:09:29PM -0700, Dan Williams wrote:
> > > > > This bug feels like we failed to unlock, or unlocked the wrong entry
> > > > > and this hunk in the bisected commit looks suspect to me. Why do we
> > > > > still need to drop the lock now that the radix_tree_preload() calls
> > > > > are gone?
> > > >
> > > > Nevermind, unmapp_mapping_pages() takes a sleeping lock, but then I
> > > > wonder why we don't restart the lookup like the old implementation.
> > >
> > > If something can remove a locked entry, then that would seem like the
> > > real bug.  Might be worth inserting a lookup there to make sure that it
> > > hasn't happened, I suppose?
> >
> > Nope, added a check, we do in fact get the same locked entry back
> > after dropping the lock.
>
> Okay, good, glad to have ruled that out.
>
> > The deadlock revolves around the mmap_sem. One thread holds it for
> > read and then gets stuck indefinitely in get_unlocked_entry(). Once
> > that happens another rocksdb thread tries to mmap and gets stuck
> > trying to take the mmap_sem for write. Then all new readers, including
> > ps and top that try to access a remote vma, then get queued behind
> > that write.
> >
> > It could also be the case that we're missing a wake up.
>
> That was the conclusion I came to; that one thread holding the mmap sem
> for read isn't being woken up when it should be.  Just need to find it ...
> obviously it's something to do with the PMD entries.

Can you explain to me one more time, yes I'm slow on the uptake on
this, the difference between xas_load() and xas_find_conflict() and
why it's ok for dax_lock_page() to use xas_load() while
grab_mapping_entry() uses xas_find_conflict()?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
