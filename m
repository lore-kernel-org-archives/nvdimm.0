Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E7FC02119307D
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 12:18:27 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id w25so14711752otm.13
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 12:18:27 -0800 (PST)
MIME-Version: 1.0
References: <20181119080056.13386-1-oohall@gmail.com>
 <20181119080056.13386-4-oohall@gmail.com>
In-Reply-To: <20181119080056.13386-4-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 25 Nov 2018 12:18:16 -0800
Message-ID: <CAPcyv4jLP47oN3c2y+BaQw5cFYG+EP_LEF3pqhjyCckUj7BcDg@mail.gmail.com>
Subject: Re: [PATCH 4/4] ndctl/namespace: Validate alignment from the
 {pfn|dax} seed
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 19, 2018 at 12:11 AM Oliver O'Halloran <oohall@gmail.com> wrote:
>
> This patch adds support to the ndctl tool for validating that the
> namespace alignment is valid.
>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
>  ndctl/namespace.c | 32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 1e04f32c0e95..6f8dca288527 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -537,8 +537,18 @@ static int validate_namespace_options(struct ndctl_region *region,
>         }
>
>         if (param.align) {
> -               if (p->mode != NDCTL_NS_MODE_MEMORY &&
> -                   p->mode != NDCTL_NS_MODE_DAX) {
> +               int i, alignments;
> +
> +               switch (p->mode) {
> +               case NDCTL_NS_MODE_MEMORY:
> +                       alignments = ndctl_pfn_get_num_alignments(pfn);
> +                       break;
> +
> +               case NDCTL_NS_MODE_DAX:
> +                       alignments = ndctl_dax_get_num_alignments(dax);
> +                       break;
> +

This needs to be reworked after addressing the patch-2 comment because
the "(!pfn || !ndctl_pfn_has_align(pfn)))" was handling the
"memory-mode without pfn device" case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
