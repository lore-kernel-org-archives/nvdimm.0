Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x232.google.com (mail-ot0-x232.google.com
 [IPv6:2607:f8b0:4003:c0f::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F53C21A00AE5
 for <linux-nvdimm@lists.01.org>; Mon, 26 Jun 2017 15:12:09 -0700 (PDT)
Received: by mail-ot0-x232.google.com with SMTP id r67so10680561ota.1
 for <linux-nvdimm@lists.01.org>; Mon, 26 Jun 2017 15:13:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170626220828.29641-1-vishal.l.verma@intel.com>
References: <20170626220828.29641-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Jun 2017 15:13:38 -0700
Message-ID: <CAPcyv4hkTcuCJM+YyZdzgnRt8Bh+X-vbMYtywOs-b8++QsbxqA@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm, btt: BTT updates for UEFI 2.7 format
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

On Mon, Jun 26, 2017 at 3:08 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The UEFI 2.7 specification defines an updated BTT metadata format,
> bumping the revision to 2.0. Add support for the new format, while
> retaining compatibility for the old 1.1 format.
>
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Cc: Linda Knippers <linda.knippers@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>
> v2:
>  - Don't enforce new BTTs being v2, base that decision on the holder class (Dan)
>  - Refactor nd_btt_version slightly, and get rid of the version enum.
>

Looks good one more small change:

> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> index 31d875a..cd0718e 100644
> --- a/drivers/nvdimm/btt_devs.c
> +++ b/drivers/nvdimm/btt_devs.c
> @@ -260,20 +260,56 @@ bool nd_btt_arena_is_valid(struct nd_btt *nd_btt, struct btt_sb *super)
>  }
>  EXPORT_SYMBOL(nd_btt_arena_is_valid);
>
> +int nd_btt_version(struct nd_btt *nd_btt, struct nd_namespace_common *ndns,
> +               struct btt_sb *btt_sb)
> +{
> +       /*
> +        * At this point, the claim class can only be 'BTT' or 'NONE'. BTT
> +        * implies a BTT v2.0 and none implies v1.1
> +        */
> +       if (ndns->claim_class == NVDIMM_CCLASS_BTT) {

I think we need NVDIMM_CCLASS_BTT2 for this. I think it is valid to
enforce BTT1 vs BTT2 format even with v1.2 labels.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
