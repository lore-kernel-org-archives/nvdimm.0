Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22d.google.com (mail-ot0-x22d.google.com
 [IPv6:2607:f8b0:4003:c0f::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9243121A00AFE
 for <linux-nvdimm@lists.01.org>; Sun, 25 Jun 2017 11:58:57 -0700 (PDT)
Received: by mail-ot0-x22d.google.com with SMTP id 95so56800824ott.3
 for <linux-nvdimm@lists.01.org>; Sun, 25 Jun 2017 12:00:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170624021736.26632-1-vishal.l.verma@intel.com>
References: <20170624021736.26632-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 25 Jun 2017 12:00:23 -0700
Message-ID: <CAPcyv4iny0uz1=7tQhQKwYQ=Cg0ETDQcnwnNHddJuYZQsHrVBg@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm, btt: BTT updates for UEFI 2.7 format
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 23, 2017 at 7:17 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The UEFI 2.7 specification defines an updated BTT metadata format,
> bumping the revision to 2.0. Add support for the new format, while
> retaining compatibility for the old 1.1 format.
>
> New BTTs will be created using the newest (2.0 as of this writing)
> format.
>
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Cc: Linda Knippers <linda.knippers@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/nvdimm/btt.c      | 28 ++++++++++++++++++++--------
>  drivers/nvdimm/btt.h      |  7 +++++++
>  drivers/nvdimm/btt_devs.c | 44 +++++++++++++++++++++++++++++++++++++++-----
>  drivers/nvdimm/nd.h       |  1 +
>  4 files changed, 67 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 983718b..629c376 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
[..]
> @@ -576,8 +576,10 @@ static struct arena_info *alloc_arena(struct btt *btt, size_t size,
>         arena->internal_lbasize = roundup(arena->external_lbasize,
>                                         INT_LBASIZE_ALIGNMENT);
>         arena->nfree = BTT_DEFAULT_NFREE;
> -       arena->version_major = 1;
> -       arena->version_minor = 1;
> +
> +       /* New BTTs will always be v2.0 */
> +       arena->version_major = 2;
> +       arena->version_minor = 0;

I don't think this is correct. The v2.0 format is generally more
dangerous than v1.1 because its info block can coexist with other
nvdimm info-blocks and fs-super-blocks. So we should always default to
v1.1 unless explicitly forced into v2.0 mode with the claim-class /
address-abstraction-guid set in the v1.2 namespace label. Without that
indicator to tie break ambiguous situations we can't use the v2.0
format which is strictly for inter-OS / UEFI compatibility.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
