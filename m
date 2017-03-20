Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH v4 08/13] x86, kasan: clarify kasan's dependency on
 vmemmap_populate_hugepages()
References: <148964440651.19438.2288075389153762985.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148964445079.19438.904042108424174547.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <ab8e8aa0-1645-2bc3-52ab-8b071a2a135a@virtuozzo.com>
Date: Mon, 20 Mar 2017 18:43:03 +0300
MIME-Version: 1.0
In-Reply-To: <148964445079.19438.904042108424174547.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Nicolai Stange <nicstange@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <linux-nvdimm@lists.01.org>

On 03/16/2017 09:07 AM, Dan Williams wrote:
> Historically kasan has not been careful about whether vmemmap_populate()
> internally allocates a section worth of memmap even if the parameters
> call for less.  For example, a request to shadow map a single page
> results in a full section (128MB) that contains that page being mapped.
> Also, kasan has not been careful to handle cases where this section
> promotion causes overlaps / overrides of previous calls to
> vmemmap_populate().
> 
> Before we teach vmemmap_populate() to support sub-section hotplug,
> arrange for kasan to explicitly avoid vmemmap_populate_basepages().
> This should be functionally equivalent to the current state since
> CONFIG_KASAN requires x86_64 (implies PSE) and it does not collide with
> sub-section hotplug support since CONFIG_KASAN disables
> CONFIG_MEMORY_HOTPLUG.
> 
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Reported-by: Nicolai Stange <nicstange@gmail.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
