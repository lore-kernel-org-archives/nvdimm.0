Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF63E21954084
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 16:18:48 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id w12so41564728oiw.3
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 16:18:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170424230738.GA11734@x1>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <20170419133630.GA2311@x1>
 <CAJcbSZEbrOfnMQhr2dA0HBqogo0dYsEGCGsEbPMh1kM9tX4tEA@mail.gmail.com>
 <20170420132632.GD2311@x1>
 <CAJcbSZEOOZZnuD3nftkzpcthGdT-6f6DDZ=VtdBKuHbC+0LdFw@mail.gmail.com>
 <CAPcyv4gzdwDmtxoz7O5=1zGow+6zx2YqQqjRu1=kBX087MLx2Q@mail.gmail.com>
 <20170424230738.GA11734@x1>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 24 Apr 2017 16:18:47 -0700
Message-ID: <CAPcyv4iPS1Gz_rkG1-d59ve+kaVyWs_jHZ9wdSaC0R17MaxWsg@mail.gmail.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
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
To: Baoquan He <bhe@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Thomas Garnier <thgarnie@google.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 24, 2017 at 4:07 PM, Baoquan He <bhe@redhat.com> wrote:
> On 04/24/17 at 01:52pm, Dan Williams wrote:
[..]
>> When using the memmap= parameter we're using this call by default:
>>
>>         } else if (pmem_should_map_pages(dev)) {
>>                 addr = devm_memremap_pages(dev, &nsio->res,
>>                                 &q->q_usage_counter, NULL);
>>                 pmem->pfn_flags |= PFN_MAP;
>>         } else
>>
>> ...where we are assuming that the memmap= parameter does not specify a
>> range-size that will exhaust all of system-memory just to hold the
>> struct page array.
>
> Yeah, according to my debugging tracking, it goes as Dan said. And the
> is_ram is REGION_DISJOINT. And till arch_add_memory, the parameters
> passed to arch_add_memory are "arch_add_memory, align_start:0x10000000000, align_size:0x3000000000",
> seems it's going well.
>
> Hi Dan,
>
> I am always confused that in devm_memremap_pages, the passed in
> parameter altmap is NULL, while it used devres_alloc_node to allocate a
> page_map and that page_map contained a altmap instance, not pointer.
> Then the addr range were inserted into pgmap_radix with value of
> page_map. Why later in __add_pages, to_vmem_altmap() return NULL
> according to my debugging code?

We expect altmap to always be NULL in this case. The only time it is
not NULL is when the namespace is configured to allocate the struct
page array from capacity on the namespace itself. I.e. instead of
allocating struct page from page allocator pages the driver creates an
altmap and vmemmap_populate_hugepages() uses that to allocate the
array from "alternate" capacity.

You can force this by running:

    ndctl create-namespace -f -e namespace0.0 -m memory -M dev

...which says "put the struct page map on the device".
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
