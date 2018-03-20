Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2A07C21E25690
 for <linux-nvdimm@lists.01.org>; Tue, 20 Mar 2018 13:38:00 -0700 (PDT)
Received: by mail-ot0-x243.google.com with SMTP id x6-v6so1829933otg.11
 for <linux-nvdimm@lists.01.org>; Tue, 20 Mar 2018 13:44:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152150305678.47105.9095916907704193253.stgit@djiang5-desk3.ch.intel.com>
References: <152150305678.47105.9095916907704193253.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 20 Mar 2018 13:44:29 -0700
Message-ID: <CAPcyv4gNHdFFxqL=iGg-Mp+QYirYf6gqrHaz5Qo32GYYbT1cWg@mail.gmail.com>
Subject: Re: [PATCH v2] ndctl: Add support for get bus and region persistent
 domain
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

On Mon, Mar 19, 2018 at 4:45 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding helper functions to iterate through sysfs region persistence domain
> attribute. The region will display the domain with the most persistence for the
> region.  The bus will display the domain attribute with the least persistence
> amongst all the regions. ndctl_bus_get_persistence_domain() and
> ndctl_region_get_persistence_domain are exported. ndctl list will also display
> the region persistence domain as well.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> v2:
> - Simplied scanning of persistence domain from Ross's comments.
>
>  ndctl/lib/libndctl.c   |   87 ++++++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym |    2 +
>  ndctl/lib/private.h    |    1 +
>  ndctl/libndctl.h       |   10 ++++++
>  ndctl/list.c           |   16 +++++++++
>  5 files changed, 116 insertions(+)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index a165e697..8f4e1745 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -180,6 +180,7 @@ struct ndctl_region {
>         } iset;
>         FILE *badblocks;
>         struct badblock bb;
> +       enum ndctl_persistence persistence_domain;
>  };
>
>  /**
> @@ -755,6 +756,7 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>         list_head_init(&bus->regions);
>         bus->ctx = ctx;
>         bus->id = id;
> +       bus->persistence_domain = PERSISTENCE_UNKNOWN;
>
>         sprintf(path, "%s/dev", ctl_base);
>         if (sysfs_read_attr(ctx, path, buf) < 0
> @@ -916,6 +918,17 @@ NDCTL_EXPORT struct ndctl_bus *ndctl_bus_get_by_provider(struct ndctl_ctx *ctx,
>         return NULL;
>  }
>
> +NDCTL_EXPORT unsigned int
> +ndctl_bus_get_persistence_domain(struct ndctl_bus *bus)
> +{
> +       struct ndctl_region *region;
> +
> +       /* iterate through region to get the region persistence domain */
> +       ndctl_region_foreach(bus, region) {}
> +
> +       return bus->persistence_domain;

There's no need to add this property to the 'struct ndctl_bus' object.
Just do the aggregation live in the ndctl_region_foreach() loop that
you already have.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
