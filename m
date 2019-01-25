Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D703211BA456
 for <linux-nvdimm@lists.01.org>; Fri, 25 Jan 2019 13:09:58 -0800 (PST)
Subject: Re: [PATCH 1/5] mm/resource: return real error codes from walk
 failures
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231442.EFD29EE0@viggo.jf.intel.com>
 <CAErSpo7kMjfi-1r8ZyGbheWzo+JCFkDZ1zpVhyNV7VVy8NOV7g@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <4898e064-5298-6a82-83ea-23d16f3dfb3d@intel.com>
Date: Fri, 25 Jan 2019 13:09:57 -0800
MIME-Version: 1.0
In-Reply-To: <CAErSpo7kMjfi-1r8ZyGbheWzo+JCFkDZ1zpVhyNV7VVy8NOV7g@mail.gmail.com>
Content-Language: en-US
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
To: Bjorn Helgaas <bhelgaas@google.com>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, Takashi Iwai <tiwai@suse.de>, Michael Ellerman <mpe@ellerman.id.au>, Huang Ying <ying.huang@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Jerome Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Borislav Petkov <bp@suse.de>, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, Paul Mackerras <paulus@samba.org>, Wu Fengguang <fengguang.wu@intel.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 1/25/19 1:02 PM, Bjorn Helgaas wrote:
>> @@ -453,7 +453,7 @@ int walk_system_ram_range(unsigned long
>>         unsigned long flags;
>>         struct resource res;
>>         unsigned long pfn, end_pfn;
>> -       int ret = -1;
>> +       int ret = -EINVAL;
> Can you either make a similar change to the powerpc version of
> walk_system_ram_range() in arch/powerpc/mm/mem.c or explain why it's
> not needed?  It *seems* like we'd want both versions of
> walk_system_ram_range() to behave similarly in this respect.

Sure.  A quick grep shows powerpc being the only other implementation.
I'll just add this hunk:

> diff -puN arch/powerpc/mm/mem.c~memory-hotplug-walk_system_ram_range-returns-neg-1 arch/powerpc/mm/mem.c
> --- a/arch/powerpc/mm/mem.c~memory-hotplug-walk_system_ram_range-returns-neg-1  2019-01-25 12:57:00.000004446 -0800
> +++ b/arch/powerpc/mm/mem.c     2019-01-25 12:58:13.215004263 -0800 
> @@ -188,7 +188,7 @@ walk_system_ram_range(unsigned long star 
>         struct memblock_region *reg; 
>         unsigned long end_pfn = start_pfn + nr_pages; 
>         unsigned long tstart, tend; 
> -       int ret = -1; 
> +       int ret = -EINVAL; 

I'll also dust off the ol' cross-compiler and make sure I didn't
fat-finger anything.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
