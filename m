Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794946768;
	b=yqw6I+9/7s3RFrR6gFt/PuqsLUuwxkN2BG8GfAU6nSHVcTN9HA276gNVl1KL0d7JSsHK
	 H6Fmrx8vn1dCE7NUk475p0zHy0+yYLBmF3eDcZdbphs2whjV1YOS9dlRcEqSVpSJuUKi5
	 uS3RcFiV5eXadpRl6tYvs0SQZbJ9IuCaC+0c+MjE3L7UsBjVUoof0wqWtCC+MDFbONGc1
	 pX0YoaqgmMU1T89KRIL+0p0GldUEjEbsSycxfWGWPoDR4Phbwhxh7MuuILrEZapfDbr/z
	 NacUESmZcXKe4OmvpdWX8JIkSf0zTfxiVpgHy99Yn6LzvoAK5VipVyqSZvPS6uTBXqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794946768;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=WY9IFVkkOBOpnAhykaCKS5Ee5S56skAlbBfr1XJGQ+0=;
	b=SaLH++lL8+l9ACHdM7QmY5v/kE6S0n+Naw3dL56EAJxt8VUXVKxjaNaTIn9eRZrGAXBU
	 sCrDTz3HICqBuxZ6bsjtFTsi5mXBL5vH5VKc66YmUeRohWHaZXc/SawQJgUMQ+kfGapZz
	 UhC79t+9qCaBw2VoylNSXFiwpYXUnX0cnjBm8ubGsRlXN32qrlygMZz2uvbTd8zXXJKDX
	 X8g2jeQdUwxX1vGpfnCgXxevebnPyFH30gu2fMs7cSWKa+4dIboiUFGNOpfhpvCusRGmL
	 UAH5M7xOa8V8lpWm3N/1yhXAtIoIe3N5N8Xi9vImxt9RdPyssXE17ePeS/ZtM70PGeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oMhz1tPc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8F2606A31C;
	Tue, 17 Nov 2026 20:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oMhz1tPc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1393B1F000C4;
	Tue, 17 Nov 2026 20:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794946768;
	bh=WY9IFVkkOBOpnAhykaCKS5Ee5S56skAlbBfr1XJGQ+0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oMhz1tPcr84xfecTqSKkB1bmkwTmKwgpCugDzxXkwA9o1T1Gu8mzOlRm8hJnMuMJ1
	 DGQz3cEqjiqzgMxMQC8+54HhRT0MaGuQtS/oel/+bMXiCCbSzc5PsehycXMmUFU6/d
	 luV3p2KMsk3OfYJb+X7zgRwrJHY4SVLxjhahbxFY4p5X+xiStsIXXsvZvrcR6jSaof
	 iX5xw7rw/Tpj2XlkQNR/eDjTiCe6YYhfzHq4zwA2hhgJODzvogLK5dUjjs3aPtptOZ
	 djnyLp/a82Xy7lbDcBGPQy5Q/4frdklGHnG3nWbr6oXuDGKWWH1b/wcvCdh0N6Gox/
	 hZi+jWXNFYjhg==
Message-ID: <71899695-4dcc-4875-80c0-bbcb224d43e2@kernel.org>
Date: Tue, 17 Nov 2026 21:19:20 +0100
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm/memory: fix handling of PTE markers in
 insert_page_into_pte_locked()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
 Jingyi Sun <1045704958@qq.com>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Michal Hocko <mhocko@suse.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nvdimm@lists.linux.dev
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
 <7ae17206-829d-4fdb-afd0-cc14c5411b74@kernel.org>
 <avyri3PoPUriTmxN@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avyri3PoPUriTmxN@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/17/26 20:31, Mike Rapoport wrote:
> On Tue, Nov 17, 2026 at 05:22:09PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/17/26 16:58, Mike Rapoport (Microsoft) wrote:
>>> Jingyi reported that a uffd-wp marker in a DAX mapping causes endless
>>> refaults on reads and SIGBUS on writes [1].
>>>
>>> The root cause is that insert_page_into_pte_locked() treats every PTE that
>>> is not none as a present mapping. Besides uffd-wp markers, this also
>>> affects guard markers that MADV_GUARD_INSTALL can put into a DAX mapping
>>> concurrently with a write fault.
>>>
>>> The first patch restructures insert_page_into_pte_locked() to make room
>>> for the fixes, the second patch fixes the reported issue and the third
>>> makes write faults back off on non-present PTEs.
>>>
>>> Both issues were reproduced on ext4 with dax=always on emulated pmem, and
>>> the fixes were verified with these reproducers.
>>> selftests.
>>>
>>> [1] https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com
>>>
>>> ---
>>> Mike Rapoport (Microsoft) (3):
>>>       mm/memory: install new PTEs first in insert_page_into_pte_locked()
>>>       mm/memory: replace uffd-wp markers in insert_page_into_pte_locked()
>>>       mm/memory: don't upgrade non-present PTEs in insert_page_into_pte_locked()
>>>
>>>  mm/memory.c | 68 +++++++++++++++++++++++++++++++------------------------------
>>>  1 file changed, 35 insertions(+), 33 deletions(-)
>>> ---
>>> base-commit: 93d7a816a2df3e907e2719bd12b0073f1285fc5c
>>> change-id: 20261117-uffd-dax-async-wp-fix-867acc8dc78f
>>>
>>> --
>>> Sincerely yours,
>>> Mike.
>>
>>
>> I have here a fix to disallow uffd on DAX entirely. It's completely broken.
>>
>> I was staging it to send with others, but I can send it out separately.
>  
> Nah, no need.
> 
> But patch 3/3 here is for MADV_GUARD_INSTALL on DAX unrelated to uffd.

Let me take a look at that tomorrow. But for 1 and 2 we should just reject uffd
registration.


-- 
Cheers,

David
