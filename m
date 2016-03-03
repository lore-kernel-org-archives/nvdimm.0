Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x233.google.com (mail-ob0-x233.google.com
 [IPv6:2607:f8b0:4003:c01::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E7F781A1E46
 for <linux-nvdimm@lists.01.org>; Thu,  3 Mar 2016 14:45:21 -0800 (PST)
Received: by mail-ob0-x233.google.com with SMTP id rt7so34336064obb.3
 for <linux-nvdimm@lists.01.org>; Thu, 03 Mar 2016 14:45:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456959056-12316-4-git-send-email-toshi.kani@hpe.com>
References: <1456959056-12316-1-git-send-email-toshi.kani@hpe.com>
 <1456959056-12316-4-git-send-email-toshi.kani@hpe.com>
Date: Thu, 3 Mar 2016 14:45:10 -0800
Message-ID: <CAPcyv4iBg0fsaAM-fnHaDir6mosLM-gwr+VU_doTsYU6st-yyQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] resource: Add device-managed
 insert/remove_resource()
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 2, 2016 at 2:50 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> insert_resource() and remove_resouce() are called by producers
> of resources, such as FW modules and bus drivers.  These modules
> may be implemented as loadable modules.
>
> Add device-managed implementaions of insert_resource() and
> remove_resouce() functions.
>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> ---
>  include/linux/ioport.h |    5 +++
>  kernel/resource.c      |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 74 insertions(+)
>
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 8017b8b..3580038 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -259,6 +259,11 @@ extern struct resource * __devm_request_region(struct device *dev,
>
>  extern void __devm_release_region(struct device *dev, struct resource *parent,
>                                   resource_size_t start, resource_size_t n);
> +
> +extern int devm_insert_resource(struct device *dev, struct resource *root,
> +                                struct resource *new);
> +extern void devm_remove_resource(struct device *dev, struct resource *old);
> +
>  extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
>  extern int iomem_is_exclusive(u64 addr);
>
> diff --git a/kernel/resource.c b/kernel/resource.c
> index effb6ee..b1a3394 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1449,6 +1449,75 @@ void __devm_release_region(struct device *dev, struct resource *parent,
>  EXPORT_SYMBOL(__devm_release_region);
>
>  /*
> + * Remove function for devm_insert_resource() and devm_remove_resource().
> + */
> +static void devm_resource_remove(struct device *dev, void *ptr)
> +{
> +       struct resource **r = ptr;
> +
> +       remove_resource(*r);
> +}
> +

Maybe call this __devm_remove_resource?  I think this makes it clearer
that it is a private helper function.  I was initially confused about
the difference between devm_resource_remove and devm_remove_resource.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
