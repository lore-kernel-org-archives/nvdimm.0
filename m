Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3982321306CDA
 for <linux-nvdimm@lists.01.org>; Tue,  6 Aug 2019 14:08:08 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id q20so95959249otl.0
 for <linux-nvdimm@lists.01.org>; Tue, 06 Aug 2019 14:05:38 -0700 (PDT)
MIME-Version: 1.0
References: <1565112345-28754-1-git-send-email-jane.chu@oracle.com>
 <1565112345-28754-2-git-send-email-jane.chu@oracle.com>
In-Reply-To: <1565112345-28754-2-git-send-email-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Aug 2019 14:05:25 -0700
Message-ID: <CAPcyv4jv1Dr=mDkYZ62B=nZux=bFWxYFu3u_N+8Pr0i0jyM2Lg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] mm/memory-failure.c clean up around tk
 pre-allocation
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
Cc: Linux MM <linux-mm@kvack.org>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Jane, looks good. Checkpatch prompts me to point out a couple more fixups:

This patch is titled:

    "mm/memory-failure.c clean up..."

...to match the second patch it should be:

    "mm/memory-failure: clean up..."

On Tue, Aug 6, 2019 at 10:26 AM Jane Chu <jane.chu@oracle.com> wrote:
>
> add_to_kill() expects the first 'tk' to be pre-allocated, it makes
> subsequent allocations on need basis, this makes the code a bit
> difficult to read. Move all the allocation internal to add_to_kill()
> and drop the **tk argument.
>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  mm/memory-failure.c | 40 +++++++++++++---------------------------
>  1 file changed, 13 insertions(+), 27 deletions(-)
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index d9cc660..51d5b20 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -304,25 +304,19 @@ static unsigned long dev_pagemap_mapping_shift(struct page *page,
>  /*
>   * Schedule a process for later kill.
>   * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
> - * TBD would GFP_NOIO be enough?
>   */
>  static void add_to_kill(struct task_struct *tsk, struct page *p,
>                        struct vm_area_struct *vma,
> -                      struct list_head *to_kill,
> -                      struct to_kill **tkc)
> +                      struct list_head *to_kill)
>  {
>         struct to_kill *tk;
>
> -       if (*tkc) {
> -               tk = *tkc;
> -               *tkc = NULL;
> -       } else {
> -               tk = kmalloc(sizeof(struct to_kill), GFP_ATOMIC);
> -               if (!tk) {
> -                       pr_err("Memory failure: Out of memory while machine check handling\n");
> -                       return;
> -               }
> +       tk = kmalloc(sizeof(struct to_kill), GFP_ATOMIC);
> +       if (!tk) {
> +               pr_err("Memory failure: Out of memory while machine check handling\n");
> +               return;
>         }

checkpatch points out that this error message can be deleted.
According to the commit that added this check (ebfdc40969f2
"checkpatch: attempt to find unnecessary 'out of memory' messages")
the kernel already prints a message and a backtrace on these events,
so seems like a decent additional cleanup to fold.

With those fixups you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...along with Naoya's ack.

I would Cc: Andrew Morton on the v5 posting of these as he's the
upstream path for changes to this file.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
