Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAB591A1E14
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 14:20:55 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id l203so75552643oib.1
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 14:20:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1471283545-16561-1-git-send-email-toshi.kani@hpe.com>
References: <1471283545-16561-1-git-send-email-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Aug 2016 14:20:54 -0700
Message-ID: <CAPcyv4gPQcqHQHSKpF1cqK22cppyHxNf7swE3QcssY5tdE3evQ@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: Fix nvdimm_probe error on NVDIMM-N
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 15, 2016 at 10:52 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> 'ndctl list --buses --dimms' does not list any NVDIMM-Ns since
> they are considered as idle.  ndctl checks if any driver is
> attached to nmem device.  nvdimm_probe() always fails in
> nvdimm_init_nsarea() since NVDIMM-Ns do not implement optinal
> ND_CMD_GET_CONFIG_DATA command.
>
> Change nvdimm_probe() to accept the case that the CONFIG_DATA
> command is not implemented for NVDIMM-Ns.  The driver attaches
> without ndd, which keeps it no-op to the device.
>
> Reported-by: Brian Boylston <brian.boylston@hpe.com>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/nvdimm/dimm.c      |   10 ++++++++++
>  drivers/nvdimm/dimm_devs.c |   27 ++++++++++++++++-----------
>  drivers/nvdimm/nd.h        |    1 +
>  3 files changed, 27 insertions(+), 11 deletions(-)

This fails the ndctl unit test suite, see below plus some other cleanups...

>
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 71d12bb..07e09c2 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -26,6 +26,13 @@ static int nvdimm_probe(struct device *dev)
>         struct nvdimm_drvdata *ndd;
>         int rc;
>
> +       rc = nvdimm_check_config_data(dev);
> +       if (rc == -ENOENT)
> +               /* not required for non-aliased nvdimm, ex. NVDIMM-N */
> +               return 0;
> +       else
> +               return rc;
> +

Change usage of ENOENT to ENOTTY throughout...

>         ndd = kzalloc(sizeof(*ndd), GFP_KERNEL);
>         if (!ndd)
>                 return -ENOMEM;
> @@ -72,6 +79,9 @@ static int nvdimm_remove(struct device *dev)
>  {
>         struct nvdimm_drvdata *ndd = dev_get_drvdata(dev);
>
> +       if (!ndd)
> +               return 0;
> +
>         nvdimm_bus_lock(dev);
>         dev_set_drvdata(dev, NULL);
>         nvdimm_bus_unlock(dev);
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index d9bba5e..fee82d3 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -28,28 +28,33 @@ static DEFINE_IDA(dimm_ida);
>   * Retrieve bus and dimm handle and return if this bus supports
>   * get_config_data commands
>   */
> -static int __validate_dimm(struct nvdimm_drvdata *ndd)
> +int nvdimm_check_config_data(struct device *dev)
>  {
> -       struct nvdimm *nvdimm;
> -
> -       if (!ndd)
> -               return -EINVAL;
> -
> -       nvdimm = to_nvdimm(ndd->dev);
> +       struct nvdimm *nvdimm = to_nvdimm(dev);
>
>         if (!nvdimm->cmd_mask)
> -               return -ENXIO;
> +               goto err;
>         if (!test_bit(ND_CMD_GET_CONFIG_DATA, &nvdimm->cmd_mask))
> -               return -ENXIO;
> +               goto err;
>
>         return 0;
> +
> + err:
> +       if (nvdimm->flags & NDD_ALIASING)
> +               return -ENXIO;
> +       else
> +               return -ENOENT;


Let's not use "goto" since there is nothing to unwind.


>  }
>
>  static int validate_dimm(struct nvdimm_drvdata *ndd)
>  {
> -       int rc = __validate_dimm(ndd);
> +       int rc;
>
> -       if (rc && ndd)
> +       if (!ndd)
> +               return -EINVAL;

Since we've called nvdimm_check_config_data() before allocating ndd it
will always be NULL causing DIMMs with label areas to fail init.


> +
> +       rc = nvdimm_check_config_data(ndd->dev);
> +       if (rc)
>                 dev_dbg(ndd->dev, "%pf: %s error: %d\n",
>                                 __builtin_return_address(0), __func__, rc);
>         return rc;
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 8024a0e..38d6f03 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -191,6 +191,7 @@ void nvdimm_exit(void);
>  void nd_region_exit(void);
>  struct nvdimm;
>  struct nvdimm_drvdata *to_ndd(struct nd_mapping *nd_mapping);
> +int nvdimm_check_config_data(struct device *dev);
>  int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd);
>  int nvdimm_init_config_data(struct nvdimm_drvdata *ndd);
>  int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
