Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54E46228.9060308@plexistor.com>
Date: Wed, 18 Feb 2015 11:58:00 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] pmem: Allow request_mem to fail, (CONFIG_BLK_DEV_PMEM_IGNORE_REQUEST_MEM_RET)
References: <54E1CF5B.9020905@plexistor.com>	 <54E1D36B.4000905@plexistor.com> <1424206333.12687.8.camel@theros.lm.intel.com>
In-Reply-To: <1424206333.12687.8.camel@theros.lm.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <linux-nvdimm@lists.01.org>

On 02/17/2015 10:52 PM, Ross Zwisler wrote:
> On Mon, 2015-02-16 at 13:24 +0200, Boaz Harrosh wrote:
>> With old Kernels there was a bug in x86 where any unknown
>> memory chip type would come up BUSY when calling
>> request_mem_region_exclusive().
>>
>> So for pmem to work with old Kernels and real NvDIMM chips
>> we have a new Kconfig option CONFIG_BLK_DEV_PMEM_IGNORE_REQUEST_MEM_RET.
>>
>> People have been running with hacked up pmem that will ignore
>> the return code from request_mem_region_exclusive. So here it is
>> official
>>
>> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> 

Hi Ross, good morning

> I'm confused - I thought that this behavior was fixed by patch 1/3?
> With that patch this memory reservation should not fail, correct?
> 

Yes, I have tested it extensively and PATCH-1/3 fixes this problem
for sure.

> If so, why do we need this patch?
> 

I put in this patch for people that do-not-want/cannot compile their
own Kernel but have a need for pmem.c regardless. I will not include
this patch in the final submitted Kernel. Given that patch-1 gets
accepted before the merge of pmem.

Lets say that patch-1 and patch-3 are either or. A tree
that has 1/3 does not need 3/3, a tree that does not have 1/3 needs
3/3.

<>

Thanks
Boaz

