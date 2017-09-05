Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E55822095BB67
 for <linux-nvdimm@lists.01.org>; Tue,  5 Sep 2017 11:16:50 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id h70so29579708oic.1
 for <linux-nvdimm@lists.01.org>; Tue, 05 Sep 2017 11:19:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170901221719.C285.E1E9C6FF@jp.fujitsu.com>
References: <20170901221335.C27F.E1E9C6FF@jp.fujitsu.com>
 <20170901221719.C285.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 5 Sep 2017 11:19:39 -0700
Message-ID: <CAPcyv4io_xoOuewStu921_E65N=TGFvvDr6butXP6e224TZu1Q@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/5] ndctl: make interface to read
 device/nfit/dsm_mask
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 1, 2017 at 6:17 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> To check what feature can be called via ND_CMD_CALL, ndctl need to read
> device/nfit/dsm_mask.
> Since direct pointer access is not permitted,
> ndctl_bus_get_nfit_dsm_mask() is created to access nfit_dsm_mask.
> It is used later patch.
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> ---
>  ndctl/lib/libndctl.c   | 16 ++++++++++++++++
>  ndctl/lib/libndctl.sym |  1 +
>  ndctl/libndctl.h.in    |  1 +
>  3 files changed, 18 insertions(+)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index f52ecfe..ea37ca4 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -104,6 +104,7 @@ struct ndctl_bus {
>         size_t buf_len;
>         char *wait_probe_path;
>         unsigned long dsm_mask;
> +       unsigned long nfit_dsm_mask;
>  };
>
>  /**
> @@ -793,6 +794,12 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>                 bus->revision = strtoul(buf, NULL, 0);
>         }
>
> +       sprintf(path, "%s/device/nfit/dsm_mask", ctl_base);
> +       if (sysfs_read_attr(ctx, path, buf) < 0)
> +               bus->nfit_dsm_mask = 0;
> +       else
> +               bus->nfit_dsm_mask = strtoul(buf, NULL, 0);
> +
>         sprintf(path, "%s/device/provider", ctl_base);
>         if (sysfs_read_attr(ctx, path, buf) < 0)
>                 goto err_read;
> @@ -1048,6 +1055,15 @@ NDCTL_EXPORT int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus,
>         return !!(bus->dsm_mask & (1ULL << cmd));
>  }
>
> +/*
> + * This function is exported for only nfit.c.
> + * Please use ndctl_bus_is_nfit_cmd_supported() in nfit.c instead.
> + */
> +NDCTL_EXPORT unsigned long ndctl_bus_get_nfit_dsm_mask(struct ndctl_bus *bus)
> +{
> +       return bus->nfit_dsm_mask;
> +}

I don't want to export the mask directly from library since we'll also
have ndctl_bus_is_nfit_cmd_supported(). Let's just move struct
ndctl_bus into private.h.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
