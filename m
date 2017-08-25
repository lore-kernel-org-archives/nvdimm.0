Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CF5E2095AE65
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 16:43:09 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id r203so7080272oih.0
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 16:45:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170818133348.8EAE.E1E9C6FF@jp.fujitsu.com>
References: <20170818133124.8EAB.E1E9C6FF@jp.fujitsu.com>
 <20170818133348.8EAE.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Aug 2017 16:45:44 -0700
Message-ID: <CAPcyv4ha=aqoJmMH89uqVzaCcXhFXkWfCC1GxKk8zY35s0XA_A@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/4] make interface to check device/nfit/dsm_mask
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

On Thu, Aug 17, 2017 at 9:33 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> To check what feature can be called via ND_CMD_CALL, ndctl need to read
> device/nfit/dsm_mask. This patch make an interface to check it in libndctl.c
>
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> ---
>  ndctl/lib/libndctl.c | 13 +++++++++++++
>  ndctl/libndctl.h.in  |  1 +
>  2 files changed, 14 insertions(+)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index c2e0efb..93692e5 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -102,6 +102,7 @@ struct ndctl_bus {
>         size_t buf_len;
>         char *wait_probe_path;
>         unsigned long dsm_mask;
> +       unsigned long bus_dsm_mask;
>  };
>
>  /**
> @@ -846,6 +847,12 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>                 bus->revision = strtoul(buf, NULL, 0);
>         }
>
> +       sprintf(path, "%s/device/nfit/dsm_mask", ctl_base);
> +       if (sysfs_read_attr(ctx, path, buf) < 0)
> +               bus->bus_dsm_mask = 0;
> +       else
> +               bus->bus_dsm_mask = strtoul(buf, NULL, 16);
> +
>         sprintf(path, "%s/device/provider", ctl_base);
>         if (sysfs_read_attr(ctx, path, buf) < 0)
>                 goto err_read;
> @@ -1101,6 +1108,12 @@ NDCTL_EXPORT int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus,
>         return !!(bus->dsm_mask & (1ULL << cmd));
>  }
>
> +NDCTL_EXPORT int ndctl_bus_is_sub_cmd_supported(struct ndctl_bus *bus,

Looks good, let's call this ndctl_bus_is_passthru_cmd_supported()
since ndctl_bus_is_cmd_supported() is telling you about native bus
commands that Linux supports generically and "passthru" is for command
payloads that Linux is just blindly passing through to the firmware
implementation. As far as the libndctl user is concerned they should
not be able to easily tell the difference between an ACPI defined
NVDIMM bus or Open Firmware / some other platform.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
