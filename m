Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 777282194EB75
 for <linux-nvdimm@lists.01.org>; Tue, 16 Jul 2019 20:42:26 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id z23so23448523ote.13
 for <linux-nvdimm@lists.01.org>; Tue, 16 Jul 2019 20:39:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org>
 <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
 <20190710190204.GB14701@quack2.suse.cz>
 <20190710201539.GN32320@bombadil.infradead.org>
 <20190710202647.GA7269@quack2.suse.cz>
 <20190711141350.GS32320@bombadil.infradead.org>
 <20190711152550.GT32320@bombadil.infradead.org>
 <20190711154111.GA29284@quack2.suse.cz>
In-Reply-To: <20190711154111.GA29284@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Jul 2019 20:39:46 -0700
Message-ID: <CAPcyv4hA+44EHpGN9F5eQD5Y_AuyPTKmovNWvccAFGhF_O2JMg@mail.gmail.com>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
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
To: Jan Kara <jack@suse.cz>
Cc: Seema Pandit <seema.pandit@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Boaz Harrosh <openosd@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, Matthew Wilcox <willy@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 12, 2019 at 2:14 AM Jan Kara <jack@suse.cz> wrote:
>
> On Thu 11-07-19 08:25:50, Matthew Wilcox wrote:
> > On Thu, Jul 11, 2019 at 07:13:50AM -0700, Matthew Wilcox wrote:
> > > However, the XA_RETRY_ENTRY might be a good choice.  It doesn't normally
> > > appear in an XArray (it may appear if you're looking at a deleted node,
> > > but since we're holding the lock, we can't see deleted nodes).
> >
> ...
>
> > @@ -254,7 +267,7 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
> >  static void put_unlocked_entry(struct xa_state *xas, void *entry)
> >  {
> >       /* If we were the only waiter woken, wake the next one */
> > -     if (entry)
> > +     if (entry && dax_is_conflict(entry))
>
> This should be !dax_is_conflict(entry)...
>
> >               dax_wake_entry(xas, entry, false);
> >  }
>
> Otherwise the patch looks good to me so feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>

Looks good, and passes the test case. Now pushed out to
libnvdimm-for-next for v5.3 inclusion:

https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/commit/?h=libnvdimm-for-next&id=23c84eb7837514e16d79ed6d849b13745e0ce688
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
