Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x231.google.com (mail-ob0-x231.google.com
 [IPv6:2607:f8b0:4003:c01::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D045C1A1EF4
 for <linux-nvdimm@lists.01.org>; Tue, 15 Mar 2016 15:08:33 -0700 (PDT)
Received: by mail-ob0-x231.google.com with SMTP id fz5so32598728obc.0
 for <linux-nvdimm@lists.01.org>; Tue, 15 Mar 2016 15:08:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5731be3c82134d47a485ca7def099030c29decd1.1458076114.git.jerry.hoemann@hpe.com>
References: <cover.1458076114.git.jerry.hoemann@hpe.com>
 <5731be3c82134d47a485ca7def099030c29decd1.1458076114.git.jerry.hoemann@hpe.com>
Date: Tue, 15 Mar 2016 15:08:14 -0700
Message-ID: <CAPcyv4jD3upVC+sgWhaNrU9U4qZi=706ya84KiC59cqRGWQPog@mail.gmail.com>
Subject: Re: [PATCH v7 5/7] libnvdimm: advertise 'call_dsm' support
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 15, 2016 at 2:32 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> Indicate to userspace that the generic 'dsm_call' capability is
> available for the given control device.  Over time we want to deprecate
> the per-dsm function ioctl commands and direct everything through the
> generic envelope.
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---
>  drivers/nvdimm/core.c      | 3 +++
>  drivers/nvdimm/dimm_devs.c | 8 +++++++-
>  include/linux/libnvdimm.h  | 1 +
>  3 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
> index 79646d0..9b395e5 100644
> --- a/drivers/nvdimm/core.c
> +++ b/drivers/nvdimm/core.c
> @@ -253,6 +253,9 @@ static ssize_t commands_show(struct device *dev,
>
>         for_each_set_bit(cmd, &nd_desc->dsm_mask, BITS_PER_LONG)
>                 len += sprintf(buf + len, "%s ", nvdimm_bus_cmd_name(cmd));
> +       if (nd_desc->call_dsm)
> +               len += sprintf(buf + len, "%s ",
> +                               nvdimm_bus_cmd_name(ND_CMD_CALL));
>         len += sprintf(buf + len, "\n");
>         return len;
>  }
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index c56f882..89086d6 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -274,14 +274,20 @@ EXPORT_SYMBOL_GPL(nvdimm_provider_data);
>  static ssize_t commands_show(struct device *dev,
>                 struct device_attribute *attr, char *buf)
>  {
> +       struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
>         struct nvdimm *nvdimm = to_nvdimm(dev);
> +       struct nvdimm_bus_descriptor *nd_desc;
>         int cmd, len = 0;
>
> -       if (!nvdimm->dsm_mask)
> +       if (!nvdimm->dsm_mask || !nvdimm_bus)
>                 return sprintf(buf, "\n");
>
>         for_each_set_bit(cmd, nvdimm->dsm_mask, BITS_PER_LONG)
>                 len += sprintf(buf + len, "%s ", nvdimm_cmd_name(cmd));
> +       nd_desc = nvdimm_bus->nd_desc;
> +       if (nd_desc->call_dsm)
> +               len += sprintf(buf + len, "%s ",
> +                               nvdimm_cmd_name(ND_CMD_CALL));
>         len += sprintf(buf + len, "\n");
>         return len;
>  }
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index af31d1c..458db57 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -68,6 +68,7 @@ struct nd_mapping {
>
>  struct nvdimm_bus_descriptor {
>         const struct attribute_group **attr_groups;
> +       unsigned int call_dsm:1;

We don't need this at the bus level, only at the dimm level.  I.e
replace dsm_mask with cmd_mask as all it refers to is the ioctls that
the dimm interface supports where command 10 is the generic
nd_cmd_call interface.

If you want to tell userspace which functions a dimm supports that can
be a true "dsm_mask" exported in sysfs under the nfit/ sub-directory.

For example:

    /sys/bus/nd/devices/nmem0/commands

...shows the base/generic nd commands supported in text format, while new

    /sys/bus/nd/devices/nmem0/nfit/dsm_mask
    /sys/bus/nd/devices/nmem0/nfit/family

...shares the raw bit mask of ACPI _DSM command codes.  I'd like to
pretend that a dimm will not support multiple families even though the
spec technically allows that.  If we're forced to cross that bridge
down the road we can add a series of alt_familyX/ sub-directories to
detail the other supported families per-dimm.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
