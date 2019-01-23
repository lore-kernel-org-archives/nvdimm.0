Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 79F4D211B63F7
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 22:40:47 -0800 (PST)
Date: Wed, 23 Jan 2019 14:40:14 +0800
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: Re: [PATCH 2/2] libnvdimm, pfn: use PAGE_SIZE to calculate npfns
Message-ID: <20190123064014.GA14452@richard>
References: <20190122024810.4448-1-richardw.yang@linux.intel.com>
 <20190122024810.4448-2-richardw.yang@linux.intel.com>
 <CAPcyv4htjAH8QEHbCzGR7X828Y4WWmw-30dchUNEfv7jK6w-fg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4htjAH8QEHbCzGR7X828Y4WWmw-30dchUNEfv7jK6w-fg@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 22, 2019 at 05:27:29PM -0800, Dan Williams wrote:
>On Mon, Jan 21, 2019 at 6:49 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>>
>> There are two places to calculate npfns in nd_pfn_init(), while they use
>> difference size to calculate.
>>
>> Use PAGE_SIZE would be more proper for calculation.
>
>No, this would make the kernel have different output based on
>PAGE_SIZE. It should be possible for a PAGE_SIZE==64K system to create
>a valid info-block for PAGE_SIZE==4K system. This would need to encode
>the PAGE_SIZE in the info-block if it were to ever support non-4K
>PAGE_SIZE systems.
>

I am confused.

Generally, npfns is used in two functions: nd_pfn_init() and
__nvdimm_setup_pfn().

The code flow looks like this:

  nvdimm_setup_pfn()

    nd_pfn_init()
      npfns = SECTION_ALIGN(trim_size / PAGE_SIZE)
      offset = start + npfns * page_struct
      npfns = (trim_size - offset) / SZ_4K
      pfn_sb->npfns

    __nvdimm_setup_pfn()
      nd_pfn->npfns = pfn_sb->npfns
      or
      nd_pfn->npfns = (trim_size - offset) / PAGE_SIZE

My questions are:

1. offset = start + npfns * page_struct
   This means the number of page struct we reserve in meta-data area is
   calculated with PAGE_SIZE page.

   But we set pfn_sb->npfns = (trim_size - offset) / SZ_4K, which
   means we tell hardware the number of pages is calculated with 4K size.
   
   Would this be a conflict?  Or at least we need to reserve more meta-data
   area to hold page struct?

2. When mode == PFN_MODE_PMEM and PAGE_SIZE == 64K,
   nd_pfn->pfn_sb->npfns is sure to be bigger than nd_pfn->npfns. Because 
   nd_pfn->pfn_sb->npfns = (trim_size - offset) / 4K
   nd_pfn->npfns         = (trim_size - offset) / 64K

   If we are sure for the final result, why we would like to have this
   calculation again?

>Another consideration is that a PAGE_SIZE==4K infoblock is compatible
>with a PAGE_SIZE==64K system. All that happens is that the memmap
>reserve area is oversized and portions go unused. The reverse is not
>true.

The oversized memap reserve area is SECTION size aligned? If so, it looks we
took that into consideration when we calculate offset.


-- 
Wei Yang
Help you, Help me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
