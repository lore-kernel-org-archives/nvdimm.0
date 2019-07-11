Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A40A2212B7DB6
 for <linux-nvdimm@lists.01.org>; Thu, 11 Jul 2019 01:00:06 -0700 (PDT)
Date: Thu, 11 Jul 2019 09:48:59 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190711074859.GA8727@quack2.suse.cz>
References: <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org>
 <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
 <20190710190204.GB14701@quack2.suse.cz>
 <20190711030855.GO32320@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190711030855.GO32320@bombadil.infradead.org>
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

On Wed 10-07-19 20:08:55, Matthew Wilcox wrote:
> On Wed, Jul 10, 2019 at 09:02:04PM +0200, Jan Kara wrote:
> > @@ -848,7 +853,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
> >  	if (unlikely(dax_is_locked(entry))) {
> >  		void *old_entry = entry;
> >  
> > -		entry = get_unlocked_entry(xas);
> > +		entry = get_unlocked_entry(xas, 0);
> >  
> >  		/* Entry got punched out / reallocated? */
> >  		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
> 
> I'm not sure about this one.  Are we sure there will never be a dirty
> PMD entry?  Even if we can't create one today, it feels like a bit of
> a landmine to leave for someone who creates one in the future.

I was thinking about this but dax_writeback_one() doesn't really care what
entry it gets. Yes, in theory it could get a PMD when previously there was
PTE or vice-versa but we check that PFN's match and if they really do
match, there's no harm in doing the flushing whatever entry we got back...
And the checks are simpler this way.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
