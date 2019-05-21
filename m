Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F3A5212746D8
 for <linux-nvdimm@lists.01.org>; Mon, 20 May 2019 21:14:29 -0700 (PDT)
Date: Tue, 21 May 2019 00:14:28 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <255137178.29997735.1558412068338.JavaMail.zimbra@redhat.com>
In-Reply-To: <1558403523-22079-1-git-send-email-jane.chu@oracle.com>
References: <1558403523-22079-1-git-send-email-jane.chu@oracle.com>
Subject: Re: [PATCH v2] mm, memory-failure: clarify error message
MIME-Version: 1.0
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
To: Jane Chu <jane.chu@oracle.com>
Cc: linux-mm@kvack.org, n-horiguchi@ah.jp.nec.com, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


> Some user who install SIGBUS handler that does longjmp out
> therefore keeping the process alive is confused by the error
> message
>   "[188988.765862] Memory failure: 0x1840200: Killing
>    cellsrv:33395 due to hardware memory corruption"
> Slightly modify the error message to improve clarity.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  mm/memory-failure.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fc8b517..c4f4bcd 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -216,7 +216,7 @@ static int kill_proc(struct to_kill *tk, unsigned long
> pfn, int flags)
>          short addr_lsb = tk->size_shift;
>          int ret;
>  
> -        pr_err("Memory failure: %#lx: Killing %s:%d due to hardware memory
> corruption\n",
> +        pr_err("Memory failure: %#lx: Sending SIGBUS to %s:%d due to hardware
> memory corruption\n",
>                  pfn, t->comm, t->pid);
>  
>          if ((flags & MF_ACTION_REQUIRED) && t->mm == current->mm) {
> --
> 1.8.3.1

This error message is helpful.

Acked-by: Pankaj Gupta <pagupta@redhat.com>

> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
