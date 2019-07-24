Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 23 Jul 2019 18:38:40 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm/memory-failure: Poison read receives SIGKILL instead
 of SIGBUS if mmaped more than once
Message-ID: <20190724013840.GS363@bombadil.infradead.org>
References: <1563925110-19359-1-git-send-email-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563925110-19359-1-git-send-email-jane.chu@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Jane Chu <jane.chu@oracle.com>
Cc: n-horiguchi@ah.jp.nec.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 23, 2019 at 05:38:30PM -0600, Jane Chu wrote:
> @@ -331,16 +330,21 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
>  		tk->size_shift = compound_order(compound_head(p)) + PAGE_SHIFT;
>  
>  	/*
> -	 * In theory we don't have to kill when the page was
> -	 * munmaped. But it could be also a mremap. Since that's
> -	 * likely very rare kill anyways just out of paranoia, but use
> -	 * a SIGKILL because the error is not contained anymore.
> +	 * Indeed a page could be mmapped N times within a process. And it's possible

You should run this patch through checkpatch.pl so I don't have to tell
you whats wrong with the trivial aspects of it ;-)
