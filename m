Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E97821184AA7
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 06:27:44 -0800 (PST)
Date: Mon, 26 Nov 2018 06:27:43 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: FAILED: patch "[PATCH] dax: Avoid losing wakeup in
 dax_lock_mapping_entry" failed to apply to 4.19-stable tree
Message-ID: <20181126142743.GA25618@bombadil.infradead.org>
References: <154322882028207@kroah.com>
 <20181126122223.GG3065@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181126122223.GG3065@bombadil.infradead.org>
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
To: gregkh@linuxfoundation.org
Cc: stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 26, 2018 at 04:22:23AM -0800, Matthew Wilcox wrote:
> On Mon, Nov 26, 2018 at 11:40:20AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> The fix for 4.19 is rather more complex because we don't have the
> right information in the right places.  Dan, does this look right to you?

Wait, we can do it like this which should be simpler:

diff --git a/fs/dax.c b/fs/dax.c
index 0fb270f0a0ef6..b0cd1364c68fa 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -217,6 +217,9 @@ static inline void *unlock_slot(struct address_space *mapping, void **slot)
 	return (void *)entry;
 }
 
+static void put_unlocked_mapping_entry(struct address_space *mapping,
+				       pgoff_t index, void *entry);
+
 /*
  * Lookup entry in radix tree, wait for it to become unlocked if it is
  * exceptional entry and return it. The caller must call
@@ -256,8 +259,10 @@ static void *__get_unlocked_mapping_entry(struct address_space *mapping,
 		revalidate = wait_fn();
 		finish_wait(wq, &ewait.wait);
 		xa_lock_irq(&mapping->i_pages);
-		if (revalidate)
+		if (revalidate) {
+			put_unlocked_mapping_entry(mapping, index, entry);
 			return ERR_PTR(-EAGAIN);
+		}
 	}
 }
 

> > ------------------ original commit in Linus's tree ------------------
> > 
> > >From 25bbe21bf427a81b8e3ccd480ea0e1d940256156 Mon Sep 17 00:00:00 2001
> > From: Matthew Wilcox <willy@infradead.org>
> > Date: Fri, 16 Nov 2018 15:50:02 -0500
> > Subject: [PATCH] dax: Avoid losing wakeup in dax_lock_mapping_entry
> > 
> > After calling get_unlocked_entry(), you have to call
> > put_unlocked_entry() to avoid subsequent waiters losing wakeups.
> > 
> > Fixes: c2a7d2a11552 ("filesystem-dax: Introduce dax_lock_mapping_entry()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Matthew Wilcox <willy@infradead.org>
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index cf2394e2bf4b..9bcce89ea18e 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -391,6 +391,7 @@ bool dax_lock_mapping_entry(struct page *page)
> >  			rcu_read_unlock();
> >  			entry = get_unlocked_entry(&xas);
> >  			xas_unlock_irq(&xas);
> > +			put_unlocked_entry(&xas, entry);
> >  			rcu_read_lock();
> >  			continue;
> >  		}
> > 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
