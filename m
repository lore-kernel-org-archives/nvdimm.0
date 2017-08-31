Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4E0D21EB5271
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 20:23:45 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id t75so66204829oie.3
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 20:25:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170831102503.DA33.E1E9C6FF@jp.fujitsu.com>
References: <20170831102101.DA2C.E1E9C6FF@jp.fujitsu.com>
 <20170831102503.DA33.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 30 Aug 2017 20:25:33 -0700
Message-ID: <CAPcyv4iW=xaF5oT07fMo24J-kZ0zcA4L7N-NJ7p6n7WDz8yzgQ@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/5] make interface to check device/nfit/dsm_mask
 flags
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

On Wed, Aug 30, 2017 at 6:25 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> To check what feature can be called via ND_CMD_CALL, ndctl need to read
> device/nfit/dsm_mask. This patch make an interface to check it in libndctl.c
>
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>
> ---
>  ndctl/lib/libndctl.c   | 13 +++++++++++++
>  ndctl/lib/libndctl.sym |  1 +
>  ndctl/libndctl.h.in    |  1 +
>  3 files changed, 15 insertions(+)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index c2e0efb..803056d 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -102,6 +102,7 @@ struct ndctl_bus {
>         size_t buf_len;
>         char *wait_probe_path;
>         unsigned long dsm_mask;
> +       unsigned long passthru_dsm_mask;
>  };
>
>  /**
> @@ -846,6 +847,12 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>                 bus->revision = strtoul(buf, NULL, 0);
>         }
>
> +       sprintf(path, "%s/device/nfit/dsm_mask", ctl_base);
> +       if (sysfs_read_attr(ctx, path, buf) < 0)
> +               bus->passthru_dsm_mask = 0;
> +       else
> +               bus->passthru_dsm_mask = strtoul(buf, NULL, 16);

Let's keep the base 0 and 16 like the other calls to strtoul in this file.

> +
>         sprintf(path, "%s/device/provider", ctl_base);
>         if (sysfs_read_attr(ctx, path, buf) < 0)
>                 goto err_read;
> @@ -1101,6 +1108,12 @@ NDCTL_EXPORT int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus,
>         return !!(bus->dsm_mask & (1ULL << cmd));
>  }
>
> +NDCTL_EXPORT int ndctl_bus_is_passthru_cmd_supported(struct ndctl_bus *bus,
> +               int cmd)

I realize that I said to call this "passthru" before, but thinking
about it further these commands are truly nfit specific. The command
numbers that ndctl_bus_is_cmd_supported() reports could theoretically
be emulated by the kernel for other bus types, but these are truly
nfit specific. For example, another bus type could theoretically reuse
the same command numbers for other operations and
ndctl_bus_is_passthru_cmd_supported() would not be able to tell the
difference.

Let's add a new source file called ndctl/lib/nfit.c for these nfit
specifc commands and add a:

    ndctl_bus_is_nfit_cmd_supported()

...that can operate on nfit command numbers directly. We can later
decide to wrap that in a generic front-end if some future nvdimm bus
arrives with similar functionality.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
