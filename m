Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C572C21A07A82
 for <linux-nvdimm@lists.01.org>; Wed,  3 Oct 2018 17:16:11 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id e21-v6so7427406otk.10
 for <linux-nvdimm@lists.01.org>; Wed, 03 Oct 2018 17:16:11 -0700 (PDT)
MIME-Version: 1.0
References: <20181003222901.44438-1-elliott@hpe.com>
In-Reply-To: <20181003222901.44438-1-elliott@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 Oct 2018 17:15:59 -0700
Message-ID: <CAPcyv4gKt4Qfta9gSB2eidQsPT2DBp5-J2yKJr5ZhAQXh79KQQ@mail.gmail.com>
Subject: Re: [PATCH] ndctl, check-labels: correct check-labels message wording
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 3, 2018 at 3:26 PM Robert Elliott <elliott@hpe.com> wrote:
>
> ndctl check-labels prints the number of labels, not the number of
> nmems. Changed the print for:
>
> $ ndctl check-labels nmem0 nmem1
> from:
>     successfully verified 510 nmems
> to:
>     successfully verified 510 nmem labels

Looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Signed-off-by: Robert Elliott <elliott@hpe.com>
> ---
>  ndctl/dimm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> index a4203f3..699ab57 100644
> --- a/ndctl/dimm.c
> +++ b/ndctl/dimm.c
> @@ -1147,7 +1147,7 @@ int cmd_check_labels(int argc, const char **argv, void *ctx)
>         int count = dimm_action(argc, argv, ctx, action_check, base_options,
>                         "ndctl check-labels <nmem0> [<nmem1>..<nmemN>] [<options>]");
>
> -       fprintf(stderr, "successfully verified %d nmem%s\n",
> +       fprintf(stderr, "successfully verified %d nmem label%s\n",
>                         count >= 0 ? count : 0, count > 1 ? "s" : "");
>         return count >= 0 ? 0 : EXIT_FAILURE;
>  }
> --
> 2.14.4
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
