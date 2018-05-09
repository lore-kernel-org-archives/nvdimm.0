Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta8.messagelabs.com (mail1.bemta8.messagelabs.com
 [216.82.243.201])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C52AA203B8598
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 21:22:37 -0700 (PDT)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: RE: [External] [RFC PATCH v1 3/6] mm, zone_type: create ZONE_NVM and
 fill into GFP_ZONE_TABLE
Date: Wed, 9 May 2018 04:22:10 +0000
Message-ID: <HK2PR03MB16847B78265A033C7310DDCB92990@HK2PR03MB1684.apcprd03.prod.outlook.com>
References: <1525746628-114136-1-git-send-email-yehs1@lenovo.com>
 <1525746628-114136-4-git-send-email-yehs1@lenovo.com>
 <HK2PR03MB1684653383FFEDAE9B41A548929A0@HK2PR03MB1684.apcprd03.prod.outlook.com>
 <ce3a6f37-3b13-0c35-6895-35156c7a290c@infradead.org>
In-Reply-To: <ce3a6f37-3b13-0c35-6895-35156c7a290c@infradead.org>
Content-Language: zh-CN
MIME-Version: 1.0
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
To: Randy Dunlap <rdunlap@infradead.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "mhocko@suse.com" <mhocko@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ocean HY1 He <hehy1@lenovo.com>, "penguin-kernel@I-love.SAKURA.ne.jp" <penguin-kernel@I-love.SAKURA.ne.jp>, NingTing Cheng <chengnt@lenovo.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "pasha.tatashin@oracle.com" <pasha.tatashin@oracle.com>, "willy@infradead.org" <willy@infradead.org>, "alexander.levin@verizon.com" <alexander.levin@verizon.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "colyli@suse.de" <colyli@suse.de>, "mgorman@techsingularity.net" <mgorman@techsingularity.net>, "vbabka@suse.cz" <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>


> On 05/07/2018 07:33 PM, Huaisheng HS1 Ye wrote:
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index c782e8f..5fe1f63 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -687,6 +687,22 @@ config ZONE_DEVICE
> >
> > +config ZONE_NVM
> > +	bool "Manage NVDIMM (pmem) by memory management (EXPERIMENTAL)"
> > +	depends on NUMA && X86_64
> 
> Hi,
> I'm curious why this depends on NUMA. Couldn't it be useful in non-NUMA
> (i.e., UMA) configs?
> 
I wrote these patches with two sockets testing platform, and there are two DDRs and two NVDIMMs have been installed to it.
So, for every socket it has one DDR and one NVDIMM with it. Here is memory region from memblock, you can get its distribution.

 435 [    0.000000] Zone ranges:
 436 [    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
 437 [    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
 438 [    0.000000]   Normal   [mem 0x0000000100000000-0x00000046bfffffff]
 439 [    0.000000]   NVM      [mem 0x0000000440000000-0x00000046bfffffff]
 440 [    0.000000]   Device   empty
 441 [    0.000000] Movable zone start for each node
 442 [    0.000000] Early memory node ranges
 443 [    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
 444 [    0.000000]   node   0: [mem 0x0000000000100000-0x00000000a69c2fff]
 445 [    0.000000]   node   0: [mem 0x00000000a7654000-0x00000000a85eefff]
 446 [    0.000000]   node   0: [mem 0x00000000ab399000-0x00000000af3f6fff]
 447 [    0.000000]   node   0: [mem 0x00000000af429000-0x00000000af7fffff]
 448 [    0.000000]   node   0: [mem 0x0000000100000000-0x000000043fffffff]	Normal 0
 449 [    0.000000]   node   0: [mem 0x0000000440000000-0x000000237fffffff]	NVDIMM 0
 450 [    0.000000]   node   1: [mem 0x0000002380000000-0x000000277fffffff]	Normal 1
 451 [    0.000000]   node   1: [mem 0x0000002780000000-0x00000046bfffffff]	NVDIMM 1

If we disable NUMA, there is a result as Normal an NVDIMM zones will be overlapping with each other.
Current mm treats all memory regions equally, it divides zones just by size, like 16M for DMA, 4G for DMA32, and others above for Normal.
The spanned range of all zones couldn't be overlapped.

If we enable NUMA, for every socket its DDR and NVDIMM are separated, you can find that NVDIMM region always behind Normal zone.

Sincerely,
Huaisheng Ye 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
