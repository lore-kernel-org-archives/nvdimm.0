Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7ADAE21290D33
 for <linux-nvdimm@lists.01.org>; Thu, 11 Jul 2019 07:16:19 -0700 (PDT)
Date: Thu, 11 Jul 2019 07:13:50 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190711141350.GS32320@bombadil.infradead.org>
References: <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org>
 <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
 <20190710190204.GB14701@quack2.suse.cz>
 <20190710201539.GN32320@bombadil.infradead.org>
 <20190710202647.GA7269@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190710202647.GA7269@quack2.suse.cz>
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
Cc: Seema Pandit <seema.pandit@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Boaz Harrosh <openosd@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 10, 2019 at 10:26:47PM +0200, Jan Kara wrote:
> On Wed 10-07-19 13:15:39, Matthew Wilcox wrote:
> > On Wed, Jul 10, 2019 at 09:02:04PM +0200, Jan Kara wrote:
> > > +#define DAX_ENTRY_CONFLICT dax_make_entry(pfn_to_pfn_t(1), DAX_EMPTY)
> > 
> > I was hoping to get rid of DAX_EMPTY ... it's almost unused now.  Once
> > we switch to having a single DAX_LOCK value instead of a single bit,
> > I think it can go away, freeing up two bits.
> > 
> > If you really want a special DAX_ENTRY_CONFLICT, I think we can make
> > one in the 2..4094 range.
> > 
> > That aside, this looks pretty similar to the previous patch I sent, so
> > if you're now happy with this, let's add
> > 
> > #define XA_DAX_CONFLICT_ENTRY xa_mk_internal(258)
> > 
> > to xarray.h and do it that way?
> 
> Yeah, that would work for me as well. The chosen value for DAX_ENTRY_CONFLICT
> was pretty arbitrary. Or we could possibly use:
> 
> #define DAX_ENTRY_CONFLICT XA_ZERO_ENTRY
> 
> so that we don't leak DAX-specific internal definition into xarray.h?

I don't want to use the ZERO entry as our conflict marker because that
could legitimately appear in an XArray.  Not the i_pages XArray today,
but I hold out hope for using that in place of the DAX_ZERO_PAGE bit too.
That's going to be a bit more tricky since we currently distinguish
between DAX_ZERO_PAGE and DAX_ZERO_PAGE | DAX_PMD.

However, the XA_RETRY_ENTRY might be a good choice.  It doesn't normally
appear in an XArray (it may appear if you're looking at a deleted node,
but since we're holding the lock, we can't see deleted nodes).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
