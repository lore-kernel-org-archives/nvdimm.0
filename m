Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D6B4C9C
	for <nvdimm@lists.linux.dev>; Fri, 18 Feb 2022 23:43:01 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id y5so3557186pfe.4
        for <nvdimm@lists.linux.dev>; Fri, 18 Feb 2022 15:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=whNrfqumba6KC2p9V6Pih5sz382GhTFok83j4GryLwE=;
        b=CUnXvna/nzoToDBNZHEzzpgX9e9lvq6R5InCaM/8HF+c7M9qkefrBPgyeiu5SgKjwk
         jEZEUbXNb6amnFGNQzFKtKgy4IJ10aeKpa8wfzSW2C6y+Vd/+2SiGAjXMB3g2sFwqHSo
         Za+If67L34iRq0VJSFjud16DUVXwrH4EtEpl8mWvfxEbPF3dHM64vQ+DAqaPBwVjZJ8R
         Keeq+HV319aTYJohVMKRB7mh+p5elAQIdI1oNh2ZqwV8wtajiKftYdDj/AttAHquQqDu
         N5vpefmxuZHO6pcjQRG5aDIGXR/EqqNOUTLUKQCTC3vCo6VPyV7pW49Omlz2eqRGqdGO
         iyhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=whNrfqumba6KC2p9V6Pih5sz382GhTFok83j4GryLwE=;
        b=3+UUzJ/R2lvn6r6izAkI30hyJ0mlYAldriflMLFdpS86hYQDNqPd/MehTI3SfQ49ej
         Hn/psOXEdQpCEHttr8pRTp29jwjuhNQenVGxnpB1jdA7oWNhp1nHq88VG9afTtjid3G1
         Qw5K/kexkXdi/4alF1LjQMfqlF7+i1FO2g7P6JM6urobPmO137nIERees6Oqkoc/duHs
         npuYP5UlI2cOg8nMDiRuH4U6rOEggswIxW2ooQx20wnN3JmjNYPPkkdVfSaf1iAcOhoS
         HmiFj9TJaPnu3j+wrDL+1Jx+it+pg4ux1n/MQN7ilVKOSyYPxUECphV2RwgQo7OPEqRR
         wfUA==
X-Gm-Message-State: AOAM531DGLTVM76kYJXnPIKy3SDz2OYn3AdgYVhgBN/Qtcm3tk+FxIUQ
	t2bylx/+DuUdQgTQNLM/s5gIrWzzxLG5U6WUjJ9bkg==
X-Google-Smtp-Source: ABdhPJzZmMN0+mLLFV6zFhJAgugkrkGZAZ9hJGF12JTGW372UotC0sF+5W85WXQp3DLcCjcKKLEsii9H7AGCDkc/R9o=
X-Received: by 2002:a62:ab09:0:b0:4e0:d967:318f with SMTP id
 p9-20020a62ab09000000b004e0d967318fmr10148714pff.86.1645227781372; Fri, 18
 Feb 2022 15:43:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220128002707.391076-1-ben.widawsky@intel.com> <20220128002707.391076-11-ben.widawsky@intel.com>
In-Reply-To: <20220128002707.391076-11-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 Feb 2022 15:42:50 -0800
Message-ID: <CAPcyv4hF=DWWszAhrOTiBLFxm5s8gcJ_TcdVz9UNfYEuXNiJTw@mail.gmail.com>
Subject: Re: [PATCH v3 10/14] cxl/region: Collect host bridge decoders
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 4:27 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> Part of host bridge verification in the CXL Type 3 Memory Device
> Software Guide calculates the host bridge interleave target list (6th
> step in the flow chart), ie. verification and state update are done in
> the same step. Host bridge verification is already in place, so go ahead
> and store the decoders with their target lists.
>
> Switches are implemented in a separate patch.
>
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
>  drivers/cxl/region.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/cxl/region.c b/drivers/cxl/region.c
> index 145d7bb02714..b8982be13bfe 100644
> --- a/drivers/cxl/region.c
> +++ b/drivers/cxl/region.c
> @@ -428,6 +428,7 @@ static bool region_hb_rp_config_valid(struct cxl_region *cxlr,
>                 return simple_config(cxlr, hbs[0]);
>
>         for (i = 0; i < hb_count; i++) {
> +               struct cxl_decoder *cxld;
>                 int idx, position_mask;
>                 struct cxl_dport *rp;
>                 struct cxl_port *hb;
> @@ -486,6 +487,18 @@ static bool region_hb_rp_config_valid(struct cxl_region *cxlr,
>                                                 "One or more devices are not connected to the correct Host Bridge Root Port\n");
>                                         goto err;
>                                 }
> +
> +                               if (!state_update)
> +                                       continue;
> +
> +                               if (dev_WARN_ONCE(&cxld->dev,
> +                                                 port_grouping >= cxld->nr_targets,
> +                                                 "Invalid port grouping %d/%d\n",
> +                                                 port_grouping, cxld->nr_targets))
> +                                       goto err;
> +
> +                               cxld->interleave_ways++;
> +                               cxld->target[port_grouping] = get_rp(ep);

There is not enough context in the changelog to understand what this
code is doing, but I do want to react to all this caching of objects
without references. I'd prefer helpers that walk the device that are
already synced with device_del() events than worry about these caches
and when to invalidate their references.

>                         }
>                 }
>         }
> @@ -538,7 +551,7 @@ static bool rootd_valid(const struct cxl_region *cxlr,
>
>  struct rootd_context {
>         const struct cxl_region *cxlr;
> -       struct cxl_port *hbs[CXL_DECODER_MAX_INTERLEAVE];
> +       const struct cxl_port *hbs[CXL_DECODER_MAX_INTERLEAVE];
>         int count;
>  };
>
> @@ -564,7 +577,7 @@ static struct cxl_decoder *find_rootd(const struct cxl_region *cxlr,
>         struct rootd_context ctx;
>         struct device *ret;
>
> -       ctx.cxlr = cxlr;
> +       ctx.cxlr = (struct cxl_region *)cxlr;

If const requires casting then don't use const.

>
>         ret = device_find_child((struct device *)&root->dev, &ctx, rootd_match);
>         if (ret)
> --
> 2.35.0
>
