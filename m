Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BAAD0211CD9A2
 for <linux-nvdimm@lists.01.org>; Fri, 22 Feb 2019 16:24:55 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id e7so3137460oia.8
 for <linux-nvdimm@lists.01.org>; Fri, 22 Feb 2019 16:24:55 -0800 (PST)
MIME-Version: 1.0
References: <20190222235854.18927-1-vishal.l.verma@intel.com>
In-Reply-To: <20190222235854.18927-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Feb 2019 16:24:44 -0800
Message-ID: <CAPcyv4ghTOwomME0GBuFi-ogfB7=D6kQMGR+Gb6b7cvMqLE4EA@mail.gmail.com>
Subject: Re: [PATCH] dax: add a 'modalias' attribute to DAX 'bus' devices
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Looks ok, but I think the changelog could be more accurate.

On Fri, Feb 22, 2019 at 3:59 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add a 'modalias' attribute to devices under the DAX bus so that userspace
> is able to dynamically load modules as needed.

The modalias is already published in the uevent which is how udev
identifies the module. This patch would allow "modalias to module
lookups" *outside* of the typical uevent used for dynamically loading
modules.

Care to fix up the changelog with that detail and why userspace needs
to do these lookups in addition to the typical uevent lookups?

> The modalias already
> exists, it was only the sysfs attribute that was missing.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/dax/bus.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 28c3324271ac..2109cfe80219 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -295,6 +295,17 @@ static ssize_t target_node_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(target_node);
>
> +static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
> +               char *buf)
> +{
> +       /*
> +        * We only ever expect to handle device-dax instances, i.e. the
> +        * @type argument to MODULE_ALIAS_DAX_DEVICE() is always zero
> +        */
> +       return sprintf(buf, DAX_DEVICE_MODALIAS_FMT "\n", 0);
> +}
> +static DEVICE_ATTR_RO(modalias);
> +
>  static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
>  {
>         struct device *dev = container_of(kobj, struct device, kobj);
> @@ -306,6 +317,7 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
>  }
>
>  static struct attribute *dev_dax_attributes[] = {
> +       &dev_attr_modalias.attr,
>         &dev_attr_size.attr,
>         &dev_attr_target_node.attr,
>         NULL,
> --
> 2.20.1
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
