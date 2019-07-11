Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 99BEF212AC478
 for <linux-nvdimm@lists.01.org>; Fri, 12 Jul 2019 02:16:23 -0700 (PDT)
Date: Thu, 11 Jul 2019 17:41:11 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190711154111.GA29284@quack2.suse.cz>
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
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190711152550.GT32320@bombadil.infradead.org>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Boaz Harrosh <openosd@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Seema Pandit <seema.pandit@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 11-07-19 08:25:50, Matthew Wilcox wrote:
> On Thu, Jul 11, 2019 at 07:13:50AM -0700, Matthew Wilcox wrote:
> > However, the XA_RETRY_ENTRY might be a good choice.  It doesn't normally
> > appear in an XArray (it may appear if you're looking at a deleted node,
> > but since we're holding the lock, we can't see deleted nodes).
> 
...

> @@ -254,7 +267,7 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
>  static void put_unlocked_entry(struct xa_state *xas, void *entry)
>  {
>  	/* If we were the only waiter woken, wake the next one */
> -	if (entry)
> +	if (entry && dax_is_conflict(entry))

This should be !dax_is_conflict(entry)...

>  		dax_wake_entry(xas, entry, false);
>  }

Otherwise the patch looks good to me so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

once you fix this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
