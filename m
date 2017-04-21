Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4CEF42193DFAE
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 10:25:04 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id s131so17860478oia.3
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 10:25:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170421071219.18744-1-oohall@gmail.com>
References: <20170421071219.18744-1-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Apr 2017 10:25:03 -0700
Message-ID: <CAPcyv4iHaihE4g0odUtrWoL=PMWBkdyjTRUpXYK66tJv_1CNsQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ndctl, create-namespace: Allow 64K and 16M alignments
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 21, 2017 at 12:12 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
> These are needed on powerpc since 64K is the default page size and 16MB
> is the PMD size when using the hash MMU.
>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
>  ndctl/builtin-xaction-namespace.c | 2 ++
>  util/size.h                       | 1 +
>  2 files changed, 3 insertions(+)
>
> diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
> index 46d651e86153..d6c38dc15984 100644
> --- a/ndctl/builtin-xaction-namespace.c
> +++ b/ndctl/builtin-xaction-namespace.c
> @@ -494,7 +494,9 @@ static int validate_namespace_options(struct ndctl_region *region,
>
>                 switch (p->align) {
>                 case SZ_4K:
> +               case SZ_64K:
>                 case SZ_2M:
> +               case SZ_16M:
>                 case SZ_1G:
>                         break;
>                 default:

Following the comment on patch2, this is another location where it
would be useful to just ask the kernel for the supported alignments.
See how we do this for btt with the calls to
ndctl_btt_get_supported_sector_size() later in the function.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
