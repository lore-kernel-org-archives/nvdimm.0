Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1B630CDAB
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 16:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779208893; cv=none; b=WujY3WJibkkZbnLcZkxWvX+kazck3VLTDSiwvNwL+mUidYGhxsUkwlbM5LPF8bJxB4Mgdr49yIGNh2Wja/h/tD/RRtAiHFdqkj47X3nXZ2hOCVlg6Yy9hDDxXdEN2GQY4ddkcyc89+9K3plqXLdVRu2Dc7vSo9NCqjlpOKShrAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779208893; c=relaxed/simple;
	bh=Gog6HfCP2VtJxY3nFz4EH1UM7tFheAVuzlhzDf7d88o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EeT8OrBNWR/qIIJlk2bG8cvTVIuworyk48LJIlrQWbJbEC8b+Ibf/hJr0DpEmi1hXCWz5y27CpE/Cl9WezIftHLFWgHjzaw7pWvKPzEGpl1bKDezXyBQ3xuQ/D9Zl19c+k3PqWZ72govQa23i5wbyuYmEutPZMFsvTZ42mNKZOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cm+GUaWI; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cm+GUaWI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779208892; x=1810744892;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gog6HfCP2VtJxY3nFz4EH1UM7tFheAVuzlhzDf7d88o=;
  b=Cm+GUaWITxuAUiG33REJ1dxAHnun5CTHqmhYWXS3dzooEK0keYZzJgSL
   OBn5vNw4RXGdjR9Nq5C6sf1/IxcVpMakHk55jivZhjNAdWH4dqEPPhIQm
   lJFxTT+fw9MEZP7mtDCh7YJEly/ncw59TEPFnTg6O7EEnNVFNwR02IMYa
   IjPUQ5zAPFLNzYAuZnNS3ofEDx9OxZE4zytgdrkm0SXpRaYFHe/2zVOhQ
   e1FAsSgEm7tFRqHqUFmWStNBEKl4/3clWvQgcX+Pk6jMkVXVotY5cUuSG
   X7+jNq0TlMzEuHeHWAnvpJikBYsvbip15dNcowzNOOceAWNaey48jHM5b
   w==;
X-CSE-ConnectionGUID: P9IEirr6QK+rw2iYO5SUQQ==
X-CSE-MsgGUID: sySJihgTSi6OuC7KM/N88A==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="105553502"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="105553502"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 09:41:31 -0700
X-CSE-ConnectionGUID: KPuaR1ygT6eOFRbtd8xN3A==
X-CSE-MsgGUID: 77ccOqjlSEKO+SO0AW9XFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="233457445"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO [10.125.109.153]) ([10.125.109.153])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 09:41:30 -0700
Message-ID: <e38e5fd0-db57-417b-a2d1-0521333ae7cb@intel.com>
Date: Tue, 19 May 2026 09:41:34 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: Juhyung Park <qkrwngud825@gmail.com>
Cc: linux-mm@kvack.org, stable@vger.kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 David Hildenbrand <david@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dan Williams <djbw@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 Matthew Wilcox <willy@infradead.org>
References: <20260519151008.1399226-1-qkrwngud825@gmail.com>
 <5d00b63c-1802-450f-8e54-8da6c0aeedc2@intel.com>
 <CAD14+f2p7D6eco+-O0X6zWwi-XaxGLs0nQKDAC8eVWhQmB1VhA@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 xsFNBE6HMP0BEADIMA3XYkQfF3dwHlj58Yjsc4E5y5G67cfbt8dvaUq2fx1lR0K9h1bOI6fC
 oAiUXvGAOxPDsB/P6UEOISPpLl5IuYsSwAeZGkdQ5g6m1xq7AlDJQZddhr/1DC/nMVa/2BoY
 2UnKuZuSBu7lgOE193+7Uks3416N2hTkyKUSNkduyoZ9F5twiBhxPJwPtn/wnch6n5RsoXsb
 ygOEDxLEsSk/7eyFycjE+btUtAWZtx+HseyaGfqkZK0Z9bT1lsaHecmB203xShwCPT49Blxz
 VOab8668QpaEOdLGhtvrVYVK7x4skyT3nGWcgDCl5/Vp3TWA4K+IofwvXzX2ON/Mj7aQwf5W
 iC+3nWC7q0uxKwwsddJ0Nu+dpA/UORQWa1NiAftEoSpk5+nUUi0WE+5DRm0H+TXKBWMGNCFn
 c6+EKg5zQaa8KqymHcOrSXNPmzJuXvDQ8uj2J8XuzCZfK4uy1+YdIr0yyEMI7mdh4KX50LO1
 pmowEqDh7dLShTOif/7UtQYrzYq9cPnjU2ZW4qd5Qz2joSGTG9eCXLz5PRe5SqHxv6ljk8mb
 ApNuY7bOXO/A7T2j5RwXIlcmssqIjBcxsRRoIbpCwWWGjkYjzYCjgsNFL6rt4OL11OUF37wL
 QcTl7fbCGv53KfKPdYD5hcbguLKi/aCccJK18ZwNjFhqr4MliQARAQABzUVEYXZpZCBDaHJp
 c3RvcGhlciBIYW5zZW4gKEludGVsIFdvcmsgQWRkcmVzcykgPGRhdmUuaGFuc2VuQGludGVs
 LmNvbT7CwXgEEwECACIFAlQ+9J0CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEGg1
 lTBwyZKwLZUP/0dnbhDc229u2u6WtK1s1cSd9WsflGXGagkR6liJ4um3XCfYWDHvIdkHYC1t
 MNcVHFBwmQkawxsYvgO8kXT3SaFZe4ISfB4K4CL2qp4JO+nJdlFUbZI7cz/Td9z8nHjMcWYF
 IQuTsWOLs/LBMTs+ANumibtw6UkiGVD3dfHJAOPNApjVr+M0P/lVmTeP8w0uVcd2syiaU5jB
 aht9CYATn+ytFGWZnBEEQFnqcibIaOrmoBLu2b3fKJEd8Jp7NHDSIdrvrMjYynmc6sZKUqH2
 I1qOevaa8jUg7wlLJAWGfIqnu85kkqrVOkbNbk4TPub7VOqA6qG5GCNEIv6ZY7HLYd/vAkVY
 E8Plzq/NwLAuOWxvGrOl7OPuwVeR4hBDfcrNb990MFPpjGgACzAZyjdmYoMu8j3/MAEW4P0z
 F5+EYJAOZ+z212y1pchNNauehORXgjrNKsZwxwKpPY9qb84E3O9KYpwfATsqOoQ6tTgr+1BR
 CCwP712H+E9U5HJ0iibN/CDZFVPL1bRerHziuwuQuvE0qWg0+0SChFe9oq0KAwEkVs6ZDMB2
 P16MieEEQ6StQRlvy2YBv80L1TMl3T90Bo1UUn6ARXEpcbFE0/aORH/jEXcRteb+vuik5UGY
 5TsyLYdPur3TXm7XDBdmmyQVJjnJKYK9AQxj95KlXLVO38lczsFNBFRjzmoBEACyAxbvUEhd
 GDGNg0JhDdezyTdN8C9BFsdxyTLnSH31NRiyp1QtuxvcqGZjb2trDVuCbIzRrgMZLVgo3upr
 MIOx1CXEgmn23Zhh0EpdVHM8IKx9Z7V0r+rrpRWFE8/wQZngKYVi49PGoZj50ZEifEJ5qn/H
 Nsp2+Y+bTUjDdgWMATg9DiFMyv8fvoqgNsNyrrZTnSgoLzdxr89FGHZCoSoAK8gfgFHuO54B
 lI8QOfPDG9WDPJ66HCodjTlBEr/Cwq6GruxS5i2Y33YVqxvFvDa1tUtl+iJ2SWKS9kCai2DR
 3BwVONJEYSDQaven/EHMlY1q8Vln3lGPsS11vSUK3QcNJjmrgYxH5KsVsf6PNRj9mp8Z1kIG
 qjRx08+nnyStWC0gZH6NrYyS9rpqH3j+hA2WcI7De51L4Rv9pFwzp161mvtc6eC/GxaiUGuH
 BNAVP0PY0fqvIC68p3rLIAW3f97uv4ce2RSQ7LbsPsimOeCo/5vgS6YQsj83E+AipPr09Caj
 0hloj+hFoqiticNpmsxdWKoOsV0PftcQvBCCYuhKbZV9s5hjt9qn8CE86A5g5KqDf83Fxqm/
 vXKgHNFHE5zgXGZnrmaf6resQzbvJHO0Fb0CcIohzrpPaL3YepcLDoCCgElGMGQjdCcSQ+Ci
 FCRl0Bvyj1YZUql+ZkptgGjikQARAQABwsFfBBgBAgAJBQJUY85qAhsMAAoJEGg1lTBwyZKw
 l4IQAIKHs/9po4spZDFyfDjunimEhVHqlUt7ggR1Hsl/tkvTSze8pI1P6dGp2XW6AnH1iayn
 yRcoyT0ZJ+Zmm4xAH1zqKjWplzqdb/dO28qk0bPso8+1oPO8oDhLm1+tY+cOvufXkBTm+whm
 +AyNTjaCRt6aSMnA/QHVGSJ8grrTJCoACVNhnXg/R0g90g8iV8Q+IBZyDkG0tBThaDdw1B2l
 asInUTeb9EiVfL/Zjdg5VWiF9LL7iS+9hTeVdR09vThQ/DhVbCNxVk+DtyBHsjOKifrVsYep
 WpRGBIAu3bK8eXtyvrw1igWTNs2wazJ71+0z2jMzbclKAyRHKU9JdN6Hkkgr2nPb561yjcB8
 sIq1pFXKyO+nKy6SZYxOvHxCcjk2fkw6UmPU6/j/nQlj2lfOAgNVKuDLothIxzi8pndB8Jju
 KktE5HJqUUMXePkAYIxEQ0mMc8Po7tuXdejgPMwgP7x65xtfEqI0RuzbUioFltsp1jUaRwQZ
 MTsCeQDdjpgHsj+P2ZDeEKCbma4m6Ez/YWs4+zDm1X8uZDkZcfQlD9NldbKDJEXLIjYWo1PH
 hYepSffIWPyvBMBTW2W5FRjJ4vLRrJSUoEfJuPQ3vW9Y73foyo/qFoURHO48AinGPZ7PC7TF
 vUaNOTjKedrqHkaOcqB185ahG2had0xnFsDPlx5y
In-Reply-To: <CAD14+f2p7D6eco+-O0X6zWwi-XaxGLs0nQKDAC8eVWhQmB1VhA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/19/26 09:27, Juhyung Park wrote:
> Hi Dave,
> 
> On Wed, May 20, 2026 at 1:02 AM Dave Hansen <dave.hansen@intel.com> wrote:
>>
>> On 5/19/26 08:10, Juhyung Park wrote:
>>>  #endif
>>>       } else {
>>> -             pagetable_free(page_ptdesc(page));
>>> +             /*
>>> +              * Use __free_pages() to honor @order: vmemmap PMD leaves
>>> +              * freed here are not compound pages, so pagetable_free()
>>> +              * would lose leak 511 of 512 pages per 2 MB chunk.
>>> +              */
>>> +             __free_pages(page, order);
>>>       }
>>>  }
>>
>> I find myself really wondering how much of this came from a human and
>> how much from the LLM. Could you share that with us?
> 
> Not my first kernel contribution, just so you know. (first in mm tho)
> 
> I asked Claude to write both the commit body and comment and it was
> too verbose. I manually trimmed it down.
> Sorry if it still sounds too LLM-ish.

Yeah, it still sounded really LLM-ish to me. Still rather chatty.

> This was tested on a VM with virtualized CXL device and toggling it
> back and forth was visibly causing leaks. kmemleak was unable to catch
> this (rightfully so), so I skeptically asked Claude to see if it can
> figure it out while pwd was the kernel source the VM was running.
> "Access the VM at "ssh -p2223 root@192.168.0.185". There's a memory
> leak whenever CXL memory switches modes via: daxctl reconfigure-device
> --mode=system-ram dax0.0 --force, daxctl reconfigure-device
> --mode=devdax dax0.0 --force. Figure out why. If you need to reboot
> the VM, do not do it yourself and ask me."
> 
> It did in 6 minutes and it basically told me to revert bf9e4e30f353. I
> was very skeptical and reviewed manually (with my short knowledge of
> mm) why this would be a correct fix.

Neato.

>> We're trying to get _away_ from using the 'struct page' APIs on page
>> tables. This goes backwards. Worst case, do:
>>
>>         /* vmemmap PMD leaves are not compound pages */
>>         for (i = 0; i < 1<<order; i++)
>>                 pagetable_free(page_ptdesc(&page[i]));
>>
>> Right?
> 
> Shouldn't I worry about the loop overhead? With order == 9, that's 512
> iterations. That's compounded to O(N) when the entire memory size is
> in consideration.

Is it optimal? No.

Will anybody ever notice? Also no.

Will anybody ever care? No sir.

Can you measure the difference? I'd wager a beer: No again.

Even if someone manages to notice, then you have a clear path to fix it
*right*: fix the ptdesc data structure to represent high-order allocations.
