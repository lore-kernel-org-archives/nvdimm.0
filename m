Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAD492097F55E
 for <linux-nvdimm@lists.01.org>; Mon, 16 Jul 2018 13:30:51 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id k81-v6so77289513oib.4
 for <linux-nvdimm@lists.01.org>; Mon, 16 Jul 2018 13:30:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGM2rea9AwQGaf1JiV_SDDKTKyP_n+dG9Z20gtTZEkuZPFnXFQ@mail.gmail.com>
References: <153176041838.12695.3365448145295112857.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAGM2rea9AwQGaf1JiV_SDDKTKyP_n+dG9Z20gtTZEkuZPFnXFQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Jul 2018 13:30:50 -0700
Message-ID: <CAPcyv4jo91jKjwn-M7cOhG=6vJ3c-QCyp0W+T+CtmiKGyZP1ng@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] mm: Asynchronous + multithreaded memmap init for
 ZONE_DEVICE
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
To: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Linux Memory Management List <linux-mm@kvack.org>, Rich Felker <dalias@libc.org>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Yoshinori Sato <ysato@users.sourceforge.jp>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Matthew Wilcox <willy@infradead.org>, Daniel Jordan <daniel.m.jordan@oracle.com>, Ingo Molnar <mingo@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 16, 2018 at 12:12 PM, Pavel Tatashin
<pasha.tatashin@oracle.com> wrote:
> On Mon, Jul 16, 2018 at 1:10 PM Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> Changes since v1 [1]:
>> * Teach memmap_sync() to take over a sub-set of memmap initialization in
>>   the foreground. This foreground work still needs to await the
>>   completion of vmemmap_populate_hugepages(), but it will otherwise
>>   steal 1/1024th of the 'struct page' init work for the given range.
>>   (Jan)
>> * Add kernel-doc for all the new 'async' structures.
>> * Split foreach_order_pgoff() to its own patch.
>> * Add Pavel and Daniel to the cc as they have been active in the memory
>>   hotplug code.
>> * Fix a typo that prevented CONFIG_DAX_DRIVER_DEBUG=y from performing
>>   early pfn retrieval at dax-filesystem mount time.
>> * Improve some of the changelogs
>>
>> [1]: https://lwn.net/Articles/759117/
>>
>> ---
>>
>> In order to keep pfn_to_page() a simple offset calculation the 'struct
>> page' memmap needs to be mapped and initialized in advance of any usage
>> of a page. This poses a problem for large memory systems as it delays
>> full availability of memory resources for 10s to 100s of seconds.
>>
>> For typical 'System RAM' the problem is mitigated by the fact that large
>> memory allocations tend to happen after the kernel has fully initialized
>> and userspace services / applications are launched. A small amount, 2GB
>> of memory, is initialized up front. The remainder is initialized in the
>> background and freed to the page allocator over time.
>>
>> Unfortunately, that scheme is not directly reusable for persistent
>> memory and dax because userspace has visibility to the entire resource
>> pool and can choose to access any offset directly at its choosing. In
>> other words there is no allocator indirection where the kernel can
>> satisfy requests with arbitrary pages as they become initialized.
>>
>> That said, we can approximate the optimization by performing the
>> initialization in the background, allow the kernel to fully boot the
>> platform, start up pmem block devices, mount filesystems in dax mode,
>> and only incur delay at the first userspace dax fault. When that initial
>> fault occurs that process is delegated a portion of the memmap to
>> initialize in the foreground so that it need not wait for initialization
>> of resources that it does not immediately need.
>>
>> With this change an 8 socket system was observed to initialize pmem
>> namespaces in ~4 seconds whereas it was previously taking ~4 minutes.
>
> Hi Dan,
>
> I am worried that this work adds another way to multi-thread struct
> page initialization without re-use of already existing method. The
> code is already a mess, and leads to bugs [1] because of the number of
> different memory layouts, architecture specific quirks, and different
> struct page initialization methods.

Yes, the lamentations about the complexity of the memory hotplug code
are known. I didn't think this set made it irretrievably worse, but
I'm biased and otherwise certainly want to build consensus with other
mem-hotplug folks.

>
> So, when DEFERRED_STRUCT_PAGE_INIT is used we initialize struct pages
> on demand until page_alloc_init_late() is called, and at that time we
> initialize all the rest of struct pages by calling:
>
> page_alloc_init_late()
>   deferred_init_memmap() (a thread per node)
>     deferred_init_pages()
>        __init_single_page()
>
> This is because memmap_init_zone() is not multi-threaded. However,
> this work makes memmap_init_zone() multi-threaded. So, I think we
> should really be either be using deferred_init_memmap() here, or teach
> DEFERRED_STRUCT_PAGE_INIT to use new multi-threaded memmap_init_zone()
> but not both.

I agree it would be good to look at unifying the 2 async
initialization approaches, however they have distinct constraints. All
of the ZONE_DEVICE memmap initialization work happens as a hotplug
event where the deferred_init_memmap() threads have already been torn
down. For the memory capacities where it takes minutes to initialize
the memmap it is painful to incur a global flush of all initialization
work. So, I think that a move to rework deferred_init_memmap() in
terms of memmap_init_async() is warranted because memmap_init_async()
avoids a global sync and supports the hotplug case.

Unfortunately, the work to unite these 2 mechanisms is going to be
4.20 material, at least for me, since I'm taking an extended leave,
and there is little time for me to get this in shape for 4.19. I
wouldn't be opposed to someone judiciously stealing from this set and
taking a shot at the integration, I likely will not get back to this
until September.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
