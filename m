Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3EF5821B02822
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 09:08:53 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id v23so18777608otk.9
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 09:08:53 -0800 (PST)
MIME-Version: 1.0
References: <20181127211634.4995-1-willy@infradead.org>
 <20181127211634.4995-3-willy@infradead.org>
 <20181128115330.GB15604@quack2.suse.cz>
In-Reply-To: <20181128115330.GB15604@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Nov 2018 09:08:40 -0800
Message-ID: <CAPcyv4iqYNq1FMwU9W-oq+2mWGHotK=Ff9YvEyJOxRz3E+eDzQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] dax: Don't access a freed inode
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, stable <stable@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 28, 2018 at 3:54 AM Jan Kara <jack@suse.cz> wrote:
>
> On Tue 27-11-18 13:16:34, Matthew Wilcox wrote:
> > After we drop the i_pages lock, the inode can be freed at any time.
> > The get_unlocked_entry() code has no choice but to reacquire the lock,
> > so it can't be used here.  Create a new wait_entry_unlocked() which takes
> > care not to acquire the lock or dereference the address_space in any way.
> >
> > Fixes: c2a7d2a11552 ("filesystem-dax: Introduce dax_lock_mapping_entry()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Matthew Wilcox <willy@infradead.org>
>
> The patch looks good. You can add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
> Just one nit below:
>
> > +/*
> > + * The only thing keeping the address space around is the i_pages lock
> > + * (it's cycled in clear_inode() after removing the entries from i_pages)
> > + * After we call xas_unlock_irq(), we cannot touch xas->xa.
> > + */
> > +static void wait_entry_unlocked(struct xa_state *xas, void *entry)
> > +{
> > +     struct wait_exceptional_entry_queue ewait;
> > +     wait_queue_head_t *wq;
> > +
> > +     init_wait(&ewait.wait);
> > +     ewait.wait.func = wake_exceptional_entry_func;
> > +
> > +     wq = dax_entry_waitqueue(xas, entry, &ewait.key);
> > +     prepare_to_wait_exclusive(wq, &ewait.wait, TASK_UNINTERRUPTIBLE);
> > +     xas_unlock_irq(xas);
> > +     schedule();
> > +     finish_wait(wq, &ewait.wait);
>
> Can we add a comment here like:
>
>         /*
>          * Entry lock waits are exclusive. Wake up the next waiter since we
>          * aren't sure we will acquire the entry lock and thus wake the
>          * next waiter up on unlock.
>          */
>
> Because I always wonder for a moment why this is needed.

Looks good, I'll add that when applying.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
