Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 28 Nov 2018 12:53:30 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] dax: Don't access a freed inode
Message-ID: <20181128115330.GB15604@quack2.suse.cz>
References: <20181127211634.4995-1-willy@infradead.org>
 <20181127211634.4995-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127211634.4995-3-willy@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 27-11-18 13:16:34, Matthew Wilcox wrote:
> After we drop the i_pages lock, the inode can be freed at any time.
> The get_unlocked_entry() code has no choice but to reacquire the lock,
> so it can't be used here.  Create a new wait_entry_unlocked() which takes
> care not to acquire the lock or dereference the address_space in any way.
> 
> Fixes: c2a7d2a11552 ("filesystem-dax: Introduce dax_lock_mapping_entry()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthew Wilcox <willy@infradead.org>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

Just one nit below:

> +/*
> + * The only thing keeping the address space around is the i_pages lock
> + * (it's cycled in clear_inode() after removing the entries from i_pages)
> + * After we call xas_unlock_irq(), we cannot touch xas->xa.
> + */
> +static void wait_entry_unlocked(struct xa_state *xas, void *entry)
> +{
> +	struct wait_exceptional_entry_queue ewait;
> +	wait_queue_head_t *wq;
> +
> +	init_wait(&ewait.wait);
> +	ewait.wait.func = wake_exceptional_entry_func;
> +
> +	wq = dax_entry_waitqueue(xas, entry, &ewait.key);
> +	prepare_to_wait_exclusive(wq, &ewait.wait, TASK_UNINTERRUPTIBLE);
> +	xas_unlock_irq(xas);
> +	schedule();
> +	finish_wait(wq, &ewait.wait);

Can we add a comment here like:

	/*
	 * Entry lock waits are exclusive. Wake up the next waiter since we
	 * aren't sure we will acquire the entry lock and thus wake the
	 * next waiter up on unlock.
	 */

Because I always wonder for a moment why this is needed.

> +	if (waitqueue_active(wq))
> +		__wake_up(wq, TASK_NORMAL, 1, &ewait.key);
> +}
> +

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
