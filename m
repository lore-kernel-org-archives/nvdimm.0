Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22e.google.com (mail-yw0-x22e.google.com
 [IPv6:2607:f8b0:4002:c05::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F2EC21A00ACB
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 13:13:22 -0700 (PDT)
Received: by mail-yw0-x22e.google.com with SMTP id 63so29196506ywr.0
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 13:14:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170628200742.26795-1-vishal.l.verma@intel.com>
References: <20170628200742.26795-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jun 2017 13:14:52 -0700
Message-ID: <CAPcyv4hxNLNQ6d0P2tEOwU+LQ4gbc_WEYEOuZZ+zZYQJE3kw7Q@mail.gmail.com>
Subject: Re: [PATCH v4] libnvdimm, btt: BTT updates for UEFI 2.7 format
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

On Wed, Jun 28, 2017 at 1:07 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The UEFI 2.7 specification defines an updated BTT metadata format,
> bumping the revision to 2.0. Add support for the new format, while
> retaining compatibility for the old 1.1 format.
>
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Cc: Linda Knippers <linda.knippers@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
[..]
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index f05d9b0..09e7e76 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1411,6 +1411,58 @@ static ssize_t dpa_extents_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(dpa_extents);
>
> +static int btt_claim_class(struct device *dev)
> +{
> +       struct nd_region *nd_region = to_nd_region(dev->parent);
> +       int i, loop_bitmask = 0;
> +
> +       for (i = 0; i < nd_region->ndr_mappings; i++) {
> +               struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +               struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +               struct nd_namespace_index *nsindex;
> +
> +               nsindex = to_namespace_index(ndd, ndd->ns_current);
> +               if (nsindex == NULL)
> +                       loop_bitmask |= 1;
> +               else {
> +                       /* check whether existing labels are v1.1 or v1.2 */
> +                       if (__le16_to_cpu(nsindex->major) == 1
> +                                       && __le16_to_cpu(nsindex->minor) == 1)
> +                               loop_bitmask |= 2;
> +                       else
> +                               loop_bitmask |= 4;
> +               }
> +       }
> +       /*
> +        * If nsindex is null loop_bitmask's bit 0 will be set, and if an index
> +        * block is found, a v1.1 label for any mapping will set bit 1, and a
> +        * v1.2 label will set bit 2.
> +        *
> +        * At the end of the loop, only one of the three bits must be set.
> +        * If multiple bits were set, it means the different mappings disagree
> +        * about their labels, and this must be cleaned up first.
> +        *
> +        * If all the label index blocks are found to agree, nsindex of NULL
> +        * implies labels haven't been initialized yet, and when they will,
> +        * they will be of the 1.2 format, so we can assume BTT2.0
> +        *
> +        * If 1.1 labels are found, we enforce BTT1.1, and if 1.2 labels are
> +        * found, we enforce BTT2.0
> +        *
> +        * If the loop was never entered, default to BTT1.1 (legacy namespaces)
> +        */
> +       switch (loop_bitmask) {
> +       case 0:
> +       case 2:
> +               return NVDIMM_CCLASS_BTT;
> +       case 1:
> +       case 4:
> +               return NVDIMM_CCLASS_BTT2;
> +       default:
> +               return -ENXIO;
> +       }

Clever, looks good to me. I'll get this queued.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
