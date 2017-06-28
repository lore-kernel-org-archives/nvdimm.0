Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22b.google.com (mail-yw0-x22b.google.com
 [IPv6:2607:f8b0:4002:c05::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B5F421A00AD1
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 19:00:33 -0700 (PDT)
Received: by mail-yw0-x22b.google.com with SMTP id l21so10544110ywb.1
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 19:02:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170628012441.20886-1-vishal.l.verma@intel.com>
References: <20170628012441.20886-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 27 Jun 2017 19:02:03 -0700
Message-ID: <CAPcyv4grO4oZPJ6MUm3sXUP6nCB=kF+tzKrUe2HM6AwqV_gimQ@mail.gmail.com>
Subject: Re: [PATCH v3] libnvdimm, btt: BTT updates for UEFI 2.7 format
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

On Tue, Jun 27, 2017 at 6:24 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
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
> v3:
>  - Add athe actual BTT2 guid from the UEFI spec, and plumb a new
>    claim class for it (Dan)

Looks correct, but some code organization comments below:

[..]
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index f05d9b0..a11c189 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1427,14 +1427,43 @@ static DEVICE_ATTR_RO(holder);
>
>  static ssize_t __holder_class_store(struct device *dev, const char *buf)
>  {
> +       struct nd_region *nd_region = to_nd_region(dev->parent);
> +       struct nd_mapping *nd_mapping = &nd_region->mapping[0];
>         struct nd_namespace_common *ndns = to_ndns(dev);
> +       int use_btt_legacy = 0;
> +
> +       /* for legacy/label-less namespaces, just use BTT1 */
> +       if (nd_mapping != NULL && nd_mapping->nvdimm != NULL) {

By definition if we have an nd_mapping then nd_mapping->nvdimm is
non-null, so you can go straight to calling to_ndd(). However, I think
you want to loop through all nd_mappings in the region to make sure
they all agree about the version and if they disagree we should fail
the write. That loop will use nd_region->ndr_mappings to catch the no
mappings case.

> +               struct nd_namespace_index *nsindex;
> +               struct nvdimm_drvdata *ndd;
> +
> +               ndd = to_ndd(nd_mapping);
> +               nsindex = to_namespace_index(ndd, ndd->ns_current);
> +               if (nsindex == NULL) {
> +                       ;
> +                       /*
> +                        * Labels haven't been initialized yet, and when they
> +                        * will, they will be of the 1.2 format, so we can
> +                        * assume BTT2.0
> +                        */
> +               } else {
> +                       /* check if existing labels are v1.1 */
> +                       if (__le16_to_cpu(nsindex->major) == 1
> +                                       && __le16_to_cpu(nsindex->minor) == 1)
> +                               use_btt_legacy = 1;
> +               }
> +       } else
> +               use_btt_legacy = 1;

This whole hunk above really wants to be its own helper function...

>
>         if (dev->driver || ndns->claim)
>                 return -EBUSY;
>
> -       if (strcmp(buf, "btt") == 0 || strcmp(buf, "btt\n") == 0)
> -               ndns->claim_class = NVDIMM_CCLASS_BTT;
> -       else if (strcmp(buf, "pfn") == 0 || strcmp(buf, "pfn\n") == 0)
> +       if (strcmp(buf, "btt") == 0 || strcmp(buf, "btt\n") == 0) {
> +               if (use_btt_legacy)
> +                       ndns->claim_class = NVDIMM_CCLASS_BTT;
> +               else
> +                       ndns->claim_class = NVDIMM_CCLASS_BTT2;

...and then here we can do:

    ndns->claim_class = btt_claim_class(ndns);

That way any reader who doesn't care about the gory details of the
default btt_claim_class() can just skip over it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
