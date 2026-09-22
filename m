Received: from mta0.migadu.com (out-9.mta0.migadu.com [91.218.175.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCA33EDAA2
	for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 04:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790052279; cv=none; b=M+xcbfylrqlQmE9hZVknjzGrJ5++fVtpmYv989/bvbjg7gRfVqSPIRRYOmC36Vq38/PmiC3CMLoqJJ3D8X+CxKedl7vJMjYo5OfBUp5mN+uGAB1HRWdWNWfMZfgesDalNzq/2Y9PnpvRh5CuqGi4kiGPJ5Oydq4vP1F6npVMdN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790052279; c=relaxed/simple;
	bh=O9TtdOhD8pGjJ5szyUuOrZgrl+8A101U3MBnFYDvhY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CoT9jDFRNVVkJt9Ren3IDmIvYOCpFT2HmNLbkvYbEYHbuVnAsfchKn7orTbdj+oG7u5SPdjc9EBtE+SW4Y93dm14xN8oi08Wt9WCiUfTHi16yVWpV3cImHY/FjxTqWogy3m1+hEki+5UlJjraZoIcoJJPCqq4zQBUpO/dpfDV5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PSPTnB4z; arc=none smtp.client-ip=91.218.175.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PSPTnB4z"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=O9TtdOhD8pGjJ5szyUuOrZgrl+8A101U3MBnFYDvhY8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790052271; v=1; x=1790657071;
 b=PSPTnB4zSxw4Mu49Z0TQhV1FNPlOwzFXABfcbLftXqQKLWeNRNr6oL60cCkVQlc0FULpn0Yb
 +gYjqTpa1UfXszW/jk0eE40uHRK2besbBxrZ0EpN9YBsDdDiS7APJNSdXyp2cZlNpyokx+Do3Dr
 xWmwF19PBWWFEU81MNODolls=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 1c91c1c822023d95;
	Tue, 22 Sep 2026 04:44:31 +0000
X-Mizu-Trace-ID: 1c91c1c822023d95
X-Migadu-Flow: FLOW_OUT
Message-ID: <10159c57-091e-474a-a154-4f675a39dcc2@linux.dev>
Date: Tue, 22 Sep 2026 12:44:19 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] nvdimm/pmem: Remove test_and_clear_pmem_poison()
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>,
 David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
 <20260903053535.17611-3-kaitao.cheng@linux.dev>
 <arIBvO3cFQ53ivG3@localhost.localdomain>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <arIBvO3cFQ53ivG3@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

在 2026/9/22 12:19, Oscar Salvador (SUSE) 写道:
> On Thu, Sep 03, 2026 at 01:35:35PM +0800, Kaitao Cheng wrote:
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> TestClearPageHWPoison() is now defined regardless of whether
>> CONFIG_MEMORY_FAILURE is enabled, returning false when memory failure
>> handling is unavailable.
>>
>> The test_and_clear_pmem_poison() wrapper duplicates this configuration
>> handling and has no other pmem-specific behavior.
>>
>> Call TestClearPageHWPoison() directly and remove the redundant wrapper.
>> This also removes the need to include page-flags.h from pmem.h.
>>
>> No functional change is intended.
>>
>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> Nice cleanup, but as David noted, please squash patch#1 into this one.

Although NVDIMM is currently the only external user of TestClearPageHWPoison,
I still consider it a generic declaration. Combining the two patches might
give the impression that TestClearPageHWPoison exists solely to serve a
specific driver.

That said, I’m not opposed to merging the two patches, as doing so would
make the submission more concise.

I think both approaches have their own advantages and disadvantages,
which is why I haven’t sent a v2 yet.

> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> 
>  


-- 
Thanks
Kaitao Cheng

