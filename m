Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 937272118C50E
 for <linux-nvdimm@lists.01.org>; Mon, 12 Nov 2018 07:12:17 -0800 (PST)
Subject: Re: [mm PATCH v5 7/7] mm: Use common iterator for deferred_init_pages
 and deferred_free_pages
References: <154145268025.30046.11742652345962594283.stgit@ahduyck-desk1.jf.intel.com>
 <154145280115.30046.13334106887516645119.stgit@ahduyck-desk1.jf.intel.com>
 <20181110041338.7ttram7po7a2ssz7@xakep.localdomain>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <ce8504f0-5963-7415-8e8d-7454b0e68fe5@linux.intel.com>
Date: Mon, 12 Nov 2018 07:12:13 -0800
MIME-Version: 1.0
In-Reply-To: <20181110041338.7ttram7po7a2ssz7@xakep.localdomain>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: pavel.tatashin@microsoft.com, mhocko@suse.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, willy@infradead.org, mingo@kernel.org, linux-mm@kvack.org, khalid.aziz@oracle.com, rppt@linux.vnet.ibm.com, vbabka@suse.cz, sparclinux@vger.kernel.org, akpm@linux-foundation.org, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, davem@davemloft.net, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On 11/9/2018 8:13 PM, Pavel Tatashin wrote:
> On 18-11-05 13:20:01, Alexander Duyck wrote:
>> +static unsigned long __next_pfn_valid_range(unsigned long *i,
>> +					    unsigned long end_pfn)
>>   {
>> -	if (!pfn_valid_within(pfn))
>> -		return false;
>> -	if (!(pfn & (pageblock_nr_pages - 1)) && !pfn_valid(pfn))
>> -		return false;
>> -	return true;
>> +	unsigned long pfn = *i;
>> +	unsigned long count;
>> +
>> +	while (pfn < end_pfn) {
>> +		unsigned long t = ALIGN(pfn + 1, pageblock_nr_pages);
>> +		unsigned long pageblock_pfn = min(t, end_pfn);
>> +
>> +#ifndef CONFIG_HOLES_IN_ZONE
>> +		count = pageblock_pfn - pfn;
>> +		pfn = pageblock_pfn;
>> +		if (!pfn_valid(pfn))
>> +			continue;
>> +#else
>> +		for (count = 0; pfn < pageblock_pfn; pfn++) {
>> +			if (pfn_valid_within(pfn)) {
>> +				count++;
>> +				continue;
>> +			}
>> +
>> +			if (count)
>> +				break;
>> +		}
>> +
>> +		if (!count)
>> +			continue;
>> +#endif
>> +		*i = pfn;
>> +		return count;
>> +	}
>> +
>> +	return 0;
>>   }
>>   
>> +#define for_each_deferred_pfn_valid_range(i, start_pfn, end_pfn, pfn, count) \
>> +	for (i = (start_pfn),						     \
>> +	     count = __next_pfn_valid_range(&i, (end_pfn));		     \
>> +	     count && ({ pfn = i - count; 1; });			     \
>> +	     count = __next_pfn_valid_range(&i, (end_pfn)))
> 
> Can this be improved somehow? It took me a while to understand this
> piece of code. i is actually end of block, and not an index by PFN, ({pfn = i - count; 1;}) is
> simply hard to parse. Why can't we make __next_pfn_valid_range() to
> return both end and a start of a block?

One thing I could do is flip the direction and work from the end to the 
start. If I did that then 'i' and 'pfn' would be the same value and I 
wouldn't have to do the subtraction. If that works for you I could 
probably do that and it may actually be more efficient.

Otherwise I could probably pass pfn as a reference, and compute it in 
the case where count is non-zero.

> The rest is good:
> 
> Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
> 
> Thank you,
> Pasha
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
