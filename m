Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9934821196802
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 07:55:01 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id f18so5475840otl.11
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 07:55:01 -0800 (PST)
MIME-Version: 1.0
References: <154353682674.1676897.15440708268545845062.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20181130154902.GL10377@bombadil.infradead.org>
In-Reply-To: <20181130154902.GL10377@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Nov 2018 07:54:49 -0800
Message-ID: <CAPcyv4iE375mP7eJP4nb76shWNaATy6FcZYi800wZ3iAJE8G8g@mail.gmail.com>
Subject: Re: [PATCH] dax: Fix Xarray conversion of dax_unlock_mapping_entry()
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 30, 2018 at 7:49 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Nov 29, 2018 at 04:13:46PM -0800, Dan Williams wrote:
> > Internal to dax_unlock_mapping_entry(), dax_unlock_entry() is used to
> > store a replacement entry in the Xarray at the given xas-index with the
> > DAX_LOCKED bit clear. When called, dax_unlock_entry() expects the unlocked
> > value of the entry relative to the current Xarray state to be specified.
> >
> > In most contexts dax_unlock_entry() is operating in the same scope as
> > the matched dax_lock_entry(). However, in the dax_unlock_mapping_entry()
> > case the implementation needs to recall the original entry. In the case
> > where the original entry is a 'pmd' entry it is possible that the pfn
> > performed to do the lookup is misaligned to the value retrieved in the
> > Xarray.
>
> So far, dax_unlock_mapping_entry only has the one caller.  I'd rather we
> returned the 'entry' to the caller, then had them pass it back to the
> unlock function.  That matches the flow in the rest of DAX and doesn't
> pose an undue burden to the caller.
>
> I plan to reclaim the DAX_LOCK bit (and the DAX_EMPTY bit for that
> matter), instead using a special DAX_LOCK value.  DAX is almost free of
> assumptions about the other bits in a locked entry, and this will remove
> the assuption that there's a PMD bit in the entry.
>
> How does this look?
>

Looks good to me, although can we make that cookie an actual type? I
think it's mostly ok to pass around (void *) for 'entry' inside of
fs/dax.c, but once an entry leaves that file I'd like it to have an
explicit type to catch people that might accidentally pass a (struct
page *) to the unlock routine.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
