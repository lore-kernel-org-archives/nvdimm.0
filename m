Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7C40922283500
 for <linux-nvdimm@lists.01.org>; Tue,  6 Mar 2018 12:49:38 -0800 (PST)
Received: by mail-ot0-x242.google.com with SMTP id 95so10218ote.5
 for <linux-nvdimm@lists.01.org>; Tue, 06 Mar 2018 12:55:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <152036074146.9605.16255604270824668249.stgit@djiang5-desk3.ch.intel.com>
References: <152036051666.9605.11333285528137008907.stgit@djiang5-desk3.ch.intel.com>
 <152036074146.9605.16255604270824668249.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Mar 2018 12:55:51 -0800
Message-ID: <CAPcyv4ioOKcoDthYZVMvHSpWEnXrv1H8RF7yMyoqOdr7xBLpYw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ndctl: add check for update firmware supported
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 6, 2018 at 10:25 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding generic and intel support function to allow check if update firmware
> is supported by the kernel.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[..]
> diff --git a/ndctl/update.c b/ndctl/update.c
> index 0f0f0d81..b4ae1ddb 100644
> --- a/ndctl/update.c
> +++ b/ndctl/update.c
> @@ -449,11 +449,24 @@ static int get_ndctl_dimm(struct update_context *uctx, void *ctx)
>  {
>         struct ndctl_dimm *dimm;
>         struct ndctl_bus *bus;
> +       int rc;
>
>         ndctl_bus_foreach(ctx, bus)
>                 ndctl_dimm_foreach(bus, dimm) {
>                         if (!util_dimm_filter(dimm, uctx->dimm_id))
>                                 continue;
> +                       rc = ndctl_dimm_fw_update_supported(dimm);
> +                       switch (rc) {
> +                       case -ENOTTY:
> +                               error("DIMM firmware update not supported by ndctl.");
> +                               return rc;
> +                       case -EOPNOTSUPP:
> +                               error("DIMM firmware update not supported by the kernel");
> +                               return rc;
> +                       case -EIO:
> +                               error("DIMM firmware update not supported by platform firmware.");

I like that you separated the no ND_CMD_CALL case from the
test_dimm_dsm(ND_INTEL_FW_GET_INFO) case, however this error message
should be:

     "DIMM firmware update not supported by either platform firmware
or the kernel"

...because it could be the case that the kernel has ND_CMD_CALL
support but has not been updated for the given DSM mask.

Other than that you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
