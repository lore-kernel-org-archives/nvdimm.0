Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <5643B043.3010103@plexistor.com>
References: <5643B043.3010103@plexistor.com>
Date: Wed, 11 Nov 2015 13:46:05 -0800
Message-ID: <CAPcyv4jCg58-Je4hW=O4TT9ESeJTV-GFEUidLD9n60-z9w9V2Q@mail.gmail.com>
Subject: Re: [RFC 1/1] memremap: devm_memremap_pages has wrong nid
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 11, 2015 at 1:16 PM, Boaz Harrosh <boaz@plexistor.com> wrote:
>
> The pmem dev as received in devm_memremap_pages() does not have
> its dev->numa_node properly initialized yet.
>
> What I see is that all pmem devices will call arch_add_memory
> with nid==0 regardless of the real nid the memory is actually
> on. Needless to say that after that all the NUMA page and zone
> members (at page->flags) come out wrong.
>
> If I do the below code it will all work properly.
>
> RFC because probably we want to fix dev->numa_node before the
> call to devm_memremap_pages.

Let's just do that instead.  I.e. in the case of NFIT numa node should
already be set, and in the case of the memmap=ss!nn or e820-type-12 we
can set the numa node like this:

diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
index 8282db2ef99e..e40df8fedf73 100644
--- a/drivers/nvdimm/e820.c
+++ b/drivers/nvdimm/e820.c
@@ -48,7 +48,7 @@ static int e820_pmem_probe(struct platform_device *pdev)
               memset(&ndr_desc, 0, sizeof(ndr_desc));
               ndr_desc.res = p;
               ndr_desc.attr_groups = e820_pmem_region_attribute_groups;
-               ndr_desc.numa_node = NUMA_NO_NODE;
+               ndr_desc.numa_node = memory_add_physaddr_to_nid(p->start);
               set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
               if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
                       goto err;

Thanks for pointing out memory_add_physaddr_to_nid(). I did not know
that existed.
