Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x244.google.com (mail-ot0-x244.google.com
 [IPv6:2607:f8b0:4003:c0f::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2BE6B22085869
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 17:44:11 -0800 (PST)
Received: by mail-ot0-x244.google.com with SMTP id p31so19872246ota.4
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 17:49:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171215140947.26075-5-hch@lst.de>
References: <20171215140947.26075-1-hch@lst.de>
 <20171215140947.26075-5-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Dec 2017 17:49:01 -0800
Message-ID: <CAPcyv4jyjNM1nRskA5Q9Q6w69OeL1=mssyTYDqFXqW2X40Oc0g@mail.gmail.com>
Subject: Re: [PATCH 04/17] mm: pass the vmem_altmap to arch_add_memory and
 __add_pages
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nvdimm@lists.01.org, X86 ML <x86@kernel.org>, linux-kernel@vger.kernel.org, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 15, 2017 at 6:09 AM, Christoph Hellwig <hch@lst.de> wrote:
> We can just pass this on instead of having to do a radix tree lookup
> without proper locking 2 levels into the callchain.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
[..]
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index 403ab9cdb949..16456117a1b1 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -427,7 +427,7 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
>                 goto err_pfn_remap;
>
>         mem_hotplug_begin();
> -       error = arch_add_memory(nid, align_start, align_size, false);
> +       error = arch_add_memory(nid, align_start, align_size, altmap, false);
>         if (!error)
>                 move_pfn_range_to_zone(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
>                                         align_start >> PAGE_SHIFT,

Subtle bug here. This altmap is the one that was passed in that we
copy into its permanent location in the pgmap, so it looks like this
patch needs to fold the following fix:

diff --git a/kernel/memremap.c b/kernel/memremap.c
index f277bf5b8c57..157a3756e1d5 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -382,6 +382,7 @@ void *devm_memremap_pages(struct device *dev,
struct resource *res,
        if (altmap) {
                memcpy(&page_map->altmap, altmap, sizeof(*altmap));
                pgmap->altmap = &page_map->altmap;
+               altmap = pgmap->altmap;
        }
        pgmap->ref = ref;
        pgmap->res = &page_map->res;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
