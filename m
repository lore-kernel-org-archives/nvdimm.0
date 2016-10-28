Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam03on071e.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe48::71e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EEC021A1E28
 for <linux-nvdimm@lists.01.org>; Thu, 27 Oct 2016 18:58:30 -0700 (PDT)
From: "Boylston, Brian" <brian.boylston@hpe.com>
Subject: RE: [PATCH v2 3/3] x86: remove unneeded flush in
 arch_copy_from_iter_pmem()
Date: Fri, 28 Oct 2016 01:58:29 +0000
Message-ID: <CS1PR84MB0119143471FF0B524DA10EC08EAD0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
References: <20161026155021.20892-1-brian.boylston@hpe.com>
 <20161026155021.20892-4-brian.boylston@hpe.com>
 <58110A90.9070900@plexistor.com>
In-Reply-To: <58110A90.9070900@plexistor.com>
Content-Language: en-US
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
To: Boaz Harrosh <boaz@plexistor.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "Moreno, Oliver" <oliver.moreno@hpe.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "boylston@burromesa.net" <boylston@burromesa.net>
List-ID: <linux-nvdimm@lists.01.org>

Boaz Harrosh wrote on 2016-10-26:
> On 10/26/2016 06:50 PM, Brian Boylston wrote:
>> copy_from_iter_nocache() now uses nocache copies for all types of iovecs
>> on x86, so the flush in arch_copy_from_iter_pmem() is no longer needed.
>> 
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: <x86@kernel.org>
>> Cc: Al Viro <viro@ZenIV.linux.org.uk>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
>> Reviewed-by: Toshi Kani <toshi.kani@hpe.com>
>> Reported-by: Oliver Moreno <oliver.moreno@hpe.com>
>> ---
>>  arch/x86/include/asm/pmem.h | 19 +------------------
>>  1 file changed, 1 insertion(+), 18 deletions(-)
>> diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
>> index 643eba4..2fbf4ae 100644
>> --- a/arch/x86/include/asm/pmem.h
>> +++ b/arch/x86/include/asm/pmem.h
>> @@ -72,15 +72,6 @@ static inline void arch_wb_cache_pmem(void *addr, size_t size)
>>  		clwb(p);
>>  }
>> -/*
>> - * copy_from_iter_nocache() on x86 only uses non-temporal stores for iovec
>> - * iterators, so for other types (bvec & kvec) we must do a cache write-back.
>> - */
>> -static inline bool __iter_needs_pmem_wb(struct iov_iter *i)
>> -{
>> -	return iter_is_iovec(i) == false;
>> -}
>> -
>>  /**
>>   * arch_copy_from_iter_pmem - copy data from an iterator to PMEM
>>   * @addr:	PMEM destination address
>> @@ -92,15 +83,7 @@ static inline bool __iter_needs_pmem_wb(struct iov_iter *i)
>>  static inline size_t arch_copy_from_iter_pmem(void *addr, size_t bytes,
>>  		struct iov_iter *i)
>>  {
>> -	size_t len;
>> -
>> -	/* TODO: skip the write-back by always using non-temporal stores */
>> -	len = copy_from_iter_nocache(addr, bytes, i);
>> -
>> -	if (__iter_needs_pmem_wb(i))
>> -		arch_wb_cache_pmem(addr, bytes);
>> -
>> -	return len;
>> +	return copy_from_iter_nocache(addr, bytes, i);
> 
> I wish you would remove all this completely. Don't see the point for it anymore
> 

At first, I was just targeting bvecs for the splice() case, so I had left the
check and the flush in there for kvecs.  When doing this v2 of the patch set,
I made kvecs nocache as well, so removed the check and flush, but didn't follow
through completely as you suggest.  Will revisit.

Thanks!
Brian

> Thanks a lot for doing this. I have this patch for ages in my trees and was too
> lasy to fight them through. Yes it is a big boost for many workloads.
> 
> Lots of gratitude
> Boaz
> 
>>  }
>>  /**
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
