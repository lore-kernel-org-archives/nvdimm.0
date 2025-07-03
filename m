Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1CB2DE6E5
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 14:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553899; cv=none; b=CXT5H5O6skHRSHZwKp9mB8ROFIp8UoskOfOarPaf9UVjhH9W6eWybq0r6b8fBXf7JF4iAGjVE0fhVir379g14alFi3XrMvkFhUERol89RgOunYMPK2q2LBgKbuWXMLuY6jEQoPTme8ZT8PvPLPBULwzIvoWuasQnGZ//qT5Qg/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553899; c=relaxed/simple;
	bh=Ae1tTKSZCMTkOVIlkV7/uZhkeFMV1n32rMfpwg6PKm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lSyrRseUJgtrh8SVI1uq1TpZSTAQp4a8fPzBaiMZIqqga5bDQMIQ5V/5YohsTz4sp8g1/Tfa86YlttMi5AvkjK2CdPvQcOT0T7aNMC8UxmomoNphDa3lnBUTUNcuAY2OUP0kSrBiMTf8VkEK3NQ0YfoDab1EmiClqIqd29KCAXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xw0Nq/aB; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xw0Nq/aB"
Message-ID: <aa977869-f93f-4c2b-a189-f90e2d3bc7da@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751553894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JOIrRfIeyTH2apsnsGitpg+mindX/IyZqQlNCkKTr4I=;
	b=xw0Nq/aBHVz2IZHt44g+yDNXMx0Jed8Ecs/I7Q8XpWowwI0KhrCtu7tM8hiuQMEO4xFxZq
	Pucfwly1yrq2L5+Uh3Y/1m/oyNxJlaLfYA+rF+qU27u4jKqGLYBBXKLdsVmYvbjzI4qgdE
	5jQ8Y1ofO5WJu7Xdc9pFpUFAAWtApgY=
Date: Thu, 3 Jul 2025 22:44:44 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH RFC 01/14] mm/memory: drop highest_memmap_pfn sanity check
 in vm_normal_page()
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Dan Williams <dan.j.williams@intel.com>, Alistair Popple
 <apopple@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Lance Yang <ioworker0@gmail.com>
References: <20250617154345.2494405-1-david@redhat.com>
 <20250617154345.2494405-2-david@redhat.com>
 <aFVZCvOpIpBGAf9w@localhost.localdomain>
 <c88c29d2-d887-4c5a-8b4e-0cf30e71d596@redhat.com>
 <CABzRoyZtxBgJUZK4p0V1sPAqbNr=6S-aE1S68u8tKo=cZ2ELSw@mail.gmail.com>
 <5e5e8d79-61b1-465d-ab5a-4fa82d401215@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <5e5e8d79-61b1-465d-ab5a-4fa82d401215@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 2025/7/3 20:39, David Hildenbrand wrote:
> On 03.07.25 14:34, Lance Yang wrote:
>> On Mon, Jun 23, 2025 at 10:04 PM David Hildenbrand <david@redhat.com> 
>> wrote:
>>>
>>> On 20.06.25 14:50, Oscar Salvador wrote:
>>>> On Tue, Jun 17, 2025 at 05:43:32PM +0200, David Hildenbrand wrote:
>>>>> In 2009, we converted a VM_BUG_ON(!pfn_valid(pfn)) to the current
>>>>> highest_memmap_pfn sanity check in commit 22b31eec63e5 ("badpage:
>>>>> vm_normal_page use print_bad_pte"), because highest_memmap_pfn was
>>>>> readily available.
>>>>>
>>>>> Nowadays, this is the last remaining highest_memmap_pfn user, and this
>>>>> sanity check is not really triggering ... frequently.
>>>>>
>>>>> Let's convert it to VM_WARN_ON_ONCE(!pfn_valid(pfn)), so we can
>>>>> simplify and get rid of highest_memmap_pfn. Checking for
>>>>> pfn_to_online_page() might be even better, but it would not handle
>>>>> ZONE_DEVICE properly.
>>>>>
>>>>> Do the same in vm_normal_page_pmd(), where we don't even report a
>>>>> problem at all ...
>>>>>
>>>>> What might be better in the future is having a runtime option like
>>>>> page-table-check to enable such checks dynamically on-demand. 
>>>>> Something
>>>>> for the future.
>>>>>
>>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>>
>>>
>>> Hi Oscar,
>>>
>>>> I'm confused, I'm missing something here.
>>>> Before this change we would return NULL if e.g: pfn > 
>>>> highest_memmap_pfn, but
>>>> now we just print the warning and call pfn_to_page() anyway.
>>>> AFAIK, pfn_to_page() doesn't return NULL?
>>>
>>> You're missing that vm_normal_page_pmd() was created as a copy from
>>> vm_normal_page() [history of the sanity check above], but as we don't
>>> have (and shouldn't have ...) print_bad_pmd(), we made the code look
>>> like this would be something that can just happen.
>>>
>>> "
>>> Do the same in vm_normal_page_pmd(), where we don't even report a
>>> problem at all ...
>>> "
>>>
>>> So we made something that should never happen a runtime sanity check
>>> without ever reporting a problem ...
>>
>> IIUC, the reasoning is that because this case should never happen, we can
>> change the behavior from returning NULL to a "warn and continue" model?
> 
> Well, yes. Point is, that check should have never been copy-pasted that 
> way, while dropping the actual warning :)

Ah, I see your point now. Thanks for clarifying!

> 
> It's a sanity check for something that should never happen, turned into 
> something that looks like it must be handled and would be valid to 
> encounter.

Yeah. Makes sense to me ;)


