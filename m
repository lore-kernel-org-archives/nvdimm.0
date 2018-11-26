Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
References: <20181126161240.GH3065@bombadil.infradead.org> <20181126171137.GD25835@quack2.suse.cz>
In-Reply-To: <20181126171137.GD25835@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Nov 2018 12:36:26 -0800
Message-ID: <CAPcyv4j8Qo0rZniWcjrtScBWNsG6=geyZU1yfRK=4wGsJ5=e8A@mail.gmail.com>
Subject: Re: dax_lock_mapping_entry was never safe
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Jiang <dave.jiang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 26, 2018 at 9:11 AM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 26-11-18 08:12:40, Matthew Wilcox wrote:
> >
> > I noticed this path while I was doing the 4.19 backport of
> > dax: Avoid losing wakeup in dax_lock_mapping_entry
> >
> >                 xa_unlock_irq(&mapping->i_pages);
> >                 revalidate = wait_fn();
> >                 finish_wait(wq, &ewait.wait);
> >                 xa_lock_irq(&mapping->i_pages);
>
> I guess this is a snippet from get_unlocked_entry(), isn't it?
>
> > It's not safe to call xa_lock_irq() if mapping can have been freed while
> > we slept.  We'll probably get away with it; most filesystems use a unique
> > slab for their inodes, so you'll likely get either a freed inode or an
> > inode which is now the wrong inode.  But if that page has been freed back
> > to the page allocator, that pointer could now be pointing at anything.
>
> Correct. Thanks for catching this bug!

Yes, nice catch!

>
> > Fixing this in the current codebase is no easier than fixing it in the
> > 4.19 codebase.  This is the best I've come up with.  Could we do better
> > by not using the _exclusive form of prepare_to_wait()?  I'm not familiar
> > with all the things that need to be considered when using this family
> > of interfaces.
> >
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 9bcce89ea18e..154b592b18eb 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -232,6 +232,24 @@ static void *get_unlocked_entry(struct xa_state *xas)
> >       }
> >  }
> >
> > +static void wait_unlocked_entry(struct xa_state *xas, void *entry)
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
> > +     /* We can no longer look at xas */
> > +     schedule();
> > +     finish_wait(wq, &ewait.wait);
> > +     if (waitqueue_active(wq))
> > +             __wake_up(wq, TASK_NORMAL, 1, &ewait.key);
> > +}
> > +
>
> The code looks good. Maybe can we call this wait_entry_unlocked() to stress
> that entry is not really usable after this function returns? And comment
> before the function that this is safe to call even if we don't have a
> reference keeping mapping alive?

Yes, maybe even something more ambiguous like "wait_entry_event()",
because there's no guarantee the entry is unlocked just that now is a
good time to try to interrogate the entry again.

>
> >  static void put_unlocked_entry(struct xa_state *xas, void *entry)
> >  {
> >       /* If we were the only waiter woken, wake the next one */
> > @@ -389,9 +407,7 @@ bool dax_lock_mapping_entry(struct page *page)
> >               entry = xas_load(&xas);
> >               if (dax_is_locked(entry)) {
> >                       rcu_read_unlock();
> > -                     entry = get_unlocked_entry(&xas);
> > -                     xas_unlock_irq(&xas);
> > -                     put_unlocked_entry(&xas, entry);
> > +                     wait_unlocked_entry(&xas, entry);
> >                       rcu_read_lock();
> >                       continue;
>
> The continue here actually is not safe either because if the mapping got
> freed, page->mapping will be NULL and we oops at the beginning of the loop.
> So that !dax_mapping() check should also check for mapping != NULL.

Yes.
