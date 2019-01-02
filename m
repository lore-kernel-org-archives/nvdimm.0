Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E0C821962301
 for <linux-nvdimm@lists.01.org>; Wed,  2 Jan 2019 07:35:11 -0800 (PST)
Date: Wed, 2 Jan 2019 16:35:09 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] dax: Use non-exclusive wait in wait_entry_unlocked()
Message-ID: <20190102153509.GB23089@quack2.suse.cz>
References: <154542108460.3682905.4453912339454331429.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <154542108460.3682905.4453912339454331429.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri 21-12-18 11:38:04, Dan Williams wrote:
> get_unlocked_entry() uses an exclusive wait because it is guaranteed to
> eventually obtain the lock and follow on with an unlock+wakeup cycle.
> The wait_entry_unlocked() path does not have the same guarantee. Rather
> than open-code an extra wakeup, just switch to a non-exclusive wait.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Matthew Wilcox <willy@infradead.org>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/dax.c |   16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)

Thanks for cleaning this up! The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 48132eca3761..042d3b31b413 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -246,18 +246,16 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
>  	ewait.wait.func = wake_exceptional_entry_func;
>  
>  	wq = dax_entry_waitqueue(xas, entry, &ewait.key);
> -	prepare_to_wait_exclusive(wq, &ewait.wait, TASK_UNINTERRUPTIBLE);
> +	/*
> +	 * Unlike get_unlocked_entry() there is no guarantee that this
> +	 * path ever successfully retrieves an unlocked entry before an
> +	 * inode dies. Perform a non-exclusive wait in case this path
> +	 * never successfully performs its own wake up.
> +	 */
> +	prepare_to_wait(wq, &ewait.wait, TASK_UNINTERRUPTIBLE);
>  	xas_unlock_irq(xas);
>  	schedule();
>  	finish_wait(wq, &ewait.wait);
> -
> -	/*
> -	 * Entry lock waits are exclusive. Wake up the next waiter since
> -	 * we aren't sure we will acquire the entry lock and thus wake
> -	 * the next waiter up on unlock.
> -	 */
> -	if (waitqueue_active(wq))
> -		__wake_up(wq, TASK_NORMAL, 1, &ewait.key);
>  }
>  
>  static void put_unlocked_entry(struct xa_state *xas, void *entry)
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
