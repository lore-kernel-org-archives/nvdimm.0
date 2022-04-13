Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CBE2F23
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 21:43:59 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id n22so2800520pfa.0
        for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 14:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a64lyEjoCz+sNKGggmaIK+RCZ9sGDKCWpc5k1FbkImc=;
        b=3YT1NAYEmFgYYpwJAJpO2IbGfiAUogw+QHX1Ef+ed27J6Dxo8PL85+Yj9F2ajWbTZx
         OjXbi8L6chYGttC4q/kdAejMluO96gNiFEHvPQ0R4NAM2uTWT+Jk4Uh6oUbMTmygv9ji
         K6o1INMOAKgNK3PdWYGMzJ1QSEzH4lIhnFDxRjlzwUPnsKAffkrBMnmVnR+BtnBERi2L
         M04MwPx7hAdtVPdOxX7FxUL983VCKzyCz8c3T/fhbFI0Hg5FfvDG+SGbKp9quWa5FXQr
         MmTl98OzxdEeWBDPjyomcerMJ+2jG3+i/Sbmy26j09Fdstm+dt91cSaR8OEgC10/r6wq
         aXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a64lyEjoCz+sNKGggmaIK+RCZ9sGDKCWpc5k1FbkImc=;
        b=BsDJH3+NV9aPMjBWJ4djMKTR4liSLDKs9tBTHusMQdDbxEKtd9toifP1wmKfoxoP+h
         BTeFPtDtLpzAqorIDOv2dw7S2sYcg7FxZ/TXuiljqlFlOoYZIDoSEIntYg7//9I5x164
         jcL9iE6wuu0hw+V/mguBlXmvF0zKba60WLsstnDNeHpsWhl9s2tCV+MR1N9SC/oYIhTs
         1jGloZaBG+MNJqhIWXcDW81iNBpXQAkPE2jfm9I5Wsx+dqieAbr0FYTn0FQICllOfXxI
         loD37lgBnDuFCpmJKasg+V2oS2sBPyWKOAtajpwoDHJD1VLPDgncPMpfebGKZZZAHPK8
         S/Eg==
X-Gm-Message-State: AOAM530ZmpAazuXvvYkYXnbXO8z8NBRzfHHUULeItRaVcPzzZFb0Vh3U
	TRqBeGGeahcdQs56B6C+WW2H03cBpcCaRYUgdX11OA==
X-Google-Smtp-Source: ABdhPJyTIbblRWH1EHAIfBiIV4i0WLLoKtU2wlqfnifoTTPqL7FnGrV0iSQwQkh+ghKl/Cwk/3iYGhAPmKHgYR5/opY=
X-Received: by 2002:a05:6a00:8c5:b0:4fe:134d:30d3 with SMTP id
 s5-20020a056a0008c500b004fe134d30d3mr799676pfu.3.1649886239302; Wed, 13 Apr
 2022 14:43:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com> <20220413183720.2444089-4-ben.widawsky@intel.com>
In-Reply-To: <20220413183720.2444089-4-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Apr 2022 14:43:48 -0700
Message-ID: <CAPcyv4iwNaJTi6DCVrVDLuwY2Cc99u_2BWokfavh3TqVqEa6UA@mail.gmail.com>
Subject: Re: [RFC PATCH 03/15] Revert "cxl/core: Convert decoder range to resource"
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	patches@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> This reverts commit 608135db1b790170d22848815c4671407af74e37. All

Did checkpatch not complain about this being in "commit
<12-character-commit-id> <commit summary format>"? However, I'd rather
just drop the revert language and say:

Change root decoders to reuse the existing ->range field to track the
decoder's programmed HPA range. The infrastructure to track the
allocations out of the root decoder range is still a work-in-progress,
but in the meantime it simplifies the code to always represent the
current decoder range setting in the ->range field regardless of
decoder type.

> decoders do have a host physical address space and the revert allows us
> to keep that uniformity. Decoder disambiguation will allow for decoder
> type-specific members which is needed, but will be handled separately.
>
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
>
> ---
> The explanation for why it is impossible to make CFMWS ranges be
> iomem_resources is explain in a later patch.

This change stands alone / is independent of any iomem_resource concerns, right?

> ---
>  drivers/cxl/acpi.c      | 17 ++++++++++-------
>  drivers/cxl/core/hdm.c  |  2 +-
>  drivers/cxl/core/port.c | 28 ++++++----------------------
>  drivers/cxl/cxl.h       |  8 ++------
>  4 files changed, 19 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index d15a6aec0331..9b69955b90cb 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -108,8 +108,10 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
>
>         cxld->flags = cfmws_to_decoder_flags(cfmws->restrictions);
>         cxld->target_type = CXL_DECODER_EXPANDER;
> -       cxld->platform_res = (struct resource)DEFINE_RES_MEM(cfmws->base_hpa,
> -                                                            cfmws->window_size);
> +       cxld->range = (struct range){
> +               .start = cfmws->base_hpa,
> +               .end = cfmws->base_hpa + cfmws->window_size - 1,
> +       };
>         cxld->interleave_ways = CFMWS_INTERLEAVE_WAYS(cfmws);
>         cxld->interleave_granularity = CFMWS_INTERLEAVE_GRANULARITY(cfmws);
>
> @@ -119,13 +121,14 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
>         else
>                 rc = cxl_decoder_autoremove(dev, cxld);
>         if (rc) {
> -               dev_err(dev, "Failed to add decoder for %pr\n",
> -                       &cxld->platform_res);
> +               dev_err(dev, "Failed to add decoder for %#llx-%#llx\n",
> +                       cfmws->base_hpa,
> +                       cfmws->base_hpa + cfmws->window_size - 1);
>                 return 0;
>         }
> -       dev_dbg(dev, "add: %s node: %d range %pr\n", dev_name(&cxld->dev),
> -               phys_to_target_node(cxld->platform_res.start),
> -               &cxld->platform_res);
> +       dev_dbg(dev, "add: %s node: %d range %#llx-%#llx\n",
> +               dev_name(&cxld->dev), phys_to_target_node(cxld->range.start),
> +               cfmws->base_hpa, cfmws->base_hpa + cfmws->window_size - 1);
>
>         return 0;
>  }
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index c3c021b54079..3055e246aab9 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -172,7 +172,7 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
>                 return -ENXIO;
>         }
>
> -       cxld->decoder_range = (struct range) {
> +       cxld->range = (struct range) {
>                 .start = base,
>                 .end = base + size - 1,
>         };
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 74c8e47bf915..86f451ecb7ed 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -73,14 +73,8 @@ static ssize_t start_show(struct device *dev, struct device_attribute *attr,
>                           char *buf)
>  {
>         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> -       u64 start;
>
> -       if (is_root_decoder(dev))
> -               start = cxld->platform_res.start;
> -       else
> -               start = cxld->decoder_range.start;
> -
> -       return sysfs_emit(buf, "%#llx\n", start);
> +       return sysfs_emit(buf, "%#llx\n", cxld->range.start);
>  }
>  static DEVICE_ATTR_ADMIN_RO(start);
>
> @@ -88,14 +82,8 @@ static ssize_t size_show(struct device *dev, struct device_attribute *attr,
>                         char *buf)
>  {
>         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> -       u64 size;
>
> -       if (is_root_decoder(dev))
> -               size = resource_size(&cxld->platform_res);
> -       else
> -               size = range_len(&cxld->decoder_range);
> -
> -       return sysfs_emit(buf, "%#llx\n", size);
> +       return sysfs_emit(buf, "%#llx\n", range_len(&cxld->range));
>  }
>  static DEVICE_ATTR_RO(size);
>
> @@ -1228,7 +1216,10 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
>         cxld->interleave_ways = 1;
>         cxld->interleave_granularity = PAGE_SIZE;
>         cxld->target_type = CXL_DECODER_EXPANDER;
> -       cxld->platform_res = (struct resource)DEFINE_RES_MEM(0, 0);
> +       cxld->range = (struct range) {
> +               .start = 0,
> +               .end = -1,
> +       };
>
>         return cxld;
>  err:
> @@ -1342,13 +1333,6 @@ int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map)
>         if (rc)
>                 return rc;
>
> -       /*
> -        * Platform decoder resources should show up with a reasonable name. All
> -        * other resources are just sub ranges within the main decoder resource.
> -        */
> -       if (is_root_decoder(dev))
> -               cxld->platform_res.name = dev_name(dev);
> -
>         return device_add(dev);
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_decoder_add_locked, CXL);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 5102491e8d13..6517d5cdf5ee 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -197,8 +197,7 @@ enum cxl_decoder_type {
>   * struct cxl_decoder - CXL address range decode configuration
>   * @dev: this decoder's device
>   * @id: kernel device name id
> - * @platform_res: address space resources considered by root decoder
> - * @decoder_range: address space resources considered by midlevel decoder
> + * @range: address range considered by this decoder
>   * @interleave_ways: number of cxl_dports in this decode
>   * @interleave_granularity: data stride per dport
>   * @target_type: accelerator vs expander (type2 vs type3) selector
> @@ -210,10 +209,7 @@ enum cxl_decoder_type {
>  struct cxl_decoder {
>         struct device dev;
>         int id;
> -       union {
> -               struct resource platform_res;
> -               struct range decoder_range;
> -       };
> +       struct range range;
>         int interleave_ways;
>         int interleave_granularity;
>         enum cxl_decoder_type target_type;
> --
> 2.35.1
>
