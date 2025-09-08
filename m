Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AB330F7F3
	for <nvdimm@lists.linux.dev>; Mon,  8 Sep 2025 15:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757345074; cv=none; b=F9mSJGWG+JloopIMPZtY9BYYAsFtn5OgiNHNkRUgH7R+aiXi5GRsJQmwNIQhnddYDoE/DwL/MPUiZAL5lzzGRXl9PxDiuaKPahUgtcZMpJNDV5ddvj6Ytl1d9UOTu413mZj8sJyr9tAFD1eCvww6jZoJGS2CPpjEmM1Mmm+3+Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757345074; c=relaxed/simple;
	bh=Tm8QCJMQMgokPs/JXQEG2GlrFn6yUTqcROvvkDy7NZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cTjq0t62UjgLDN3dqqMej+mUsLMWN4a5SxXXlgb5eW7rViRfPIewq+/eEJEpW5gv/8eqcKtgLxEkTYfHE2/UHAvmLQ+GY+yux7huT0akUP0lHP2uPMnjodEq9R0NgZQupuxo0OWEXmKvXeYrCbSd0so1UjJeYMXNZVh3qXvEQEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ORRirM0v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ORRirM0v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757345071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OFR4fsYCPzy26gT9T9kYZtLy/SzbzsJmYYmla+zsN4U=;
	b=ORRirM0vRRQVA9g1Af5TpS++4BGlaC/YDrvJV96449TIJjf2sKee9HabI7TPAKJsUtkzii
	0A7vUuca8vrK+v8kcRs4Hafs+7Yn12UbgnBYWPai/IlxqbvAyxTMUneAwZdK3ZvkyXnjcV
	lBKDsCYQjxNY0ec0vcJ6CKxUUIAhymc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-2--Jb05eOGuHvY-Zlx14CQ-1; Mon, 08 Sep 2025 11:24:29 -0400
X-MC-Unique: 2--Jb05eOGuHvY-Zlx14CQ-1
X-Mimecast-MFC-AGG-ID: 2--Jb05eOGuHvY-Zlx14CQ_1757345068
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3df07c967e9so2873300f8f.2
        for <nvdimm@lists.linux.dev>; Mon, 08 Sep 2025 08:24:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757345068; x=1757949868;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OFR4fsYCPzy26gT9T9kYZtLy/SzbzsJmYYmla+zsN4U=;
        b=jGzcGY8j00b8cbF/AuOts4vOfHUsx3bgs4+NVTpxXW55mmKITqv6O1j8r7LuCyGnDu
         O3ALBAtu6sGRu1jT/yQYY4EzxNPrTwgXgYNHtEnT2dt3TRliIucyTO+TnlyCmkNzrdb+
         zPLbj4wI13MR3xa72WVd+Vhz0ttJrGCSC62l2pcYGYOLPQuJep/VR3SdduATLMYr3a4m
         zkv9TihUVi80M6pZxbQyFHnWYdwzEZpaK85s/3pPJrrjUN0JBMuM62lD66eO8PHWBTs/
         ezuDWPW+2EYJozqYZCFF0nFk9vtmRhH+nggTfAPr5Bfbtax5lSv3yybpr+5u/Qdtx3vQ
         CA+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXSsCdaeaurzwg9AXi+QQvwkmID1SOvyJ+ySLqy0LQgGSFGsZRu0XWP/ALUfC6TUXHojX74GkA=@lists.linux.dev
X-Gm-Message-State: AOJu0YziS7rKSOIS2uDxip9WUB0Rtc1cLwJ2AuzDjbgIoa43xT3GacY3
	hJCTM2RRhoURHB/Lpu1SIAYSrtR5KFSeV0JQRKi5ULu+KuZDdgNgWTWU6UUACMHXm+OVZnfptMn
	gJUrVJVoXEU0ToUk5kyRtH4Ie/w+LUPry83htPrxxLBvskw8tBJlV9upFbw==
X-Gm-Gg: ASbGncsomqChWVj/aSLszmOL8bYSomomLcJxqGg5Nphmyemmjy+2pgmY7ZuZMPuB6u1
	IHQo5Y9vhoVY9M9ekjjDzBSHjVqHOYriouWueOtuD4yg0xRAooV380eJ7PxGyTRf8WT4IYEAIvR
	v1rPSOIMTisz692ythoII4G5G39DOALm9JmTIb1dVoCDhLAzMRAddPaHeLhYT9NE0mnY0LyNN0a
	YU9RQfJ1kgT9+xWoWF3D+TWvl39vw55RCdRWDHzOxHsmRDS1JDKEw4YrAYu8wk9pmB6GplyMMFp
	4HLcWjTNPa5wCOUioBQkj/idpbcIDfw7XOEqq5mqfffB9+J3O3z6Nh5cTmHoS5loGyoVKyxL230
	NG2CvYXa6qRnzY7vn2IP8Ax4zZhIl8ca6oyr1KULFiUOgIJvrJjhN1XDemmW+1Ee5
X-Received: by 2002:a05:6000:2087:b0:3de:c5b3:dda3 with SMTP id ffacd0b85a97d-3e645c9d0fbmr7224223f8f.44.1757345067774;
        Mon, 08 Sep 2025 08:24:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1+PXcaDlfYMG7l/tiEGAk9GKqnsTr1vgulen25L6LSRNlWKiBe/sZ6bAf6RuwddMzqclqxA==
X-Received: by 2002:a05:6000:2087:b0:3de:c5b3:dda3 with SMTP id ffacd0b85a97d-3e645c9d0fbmr7224167f8f.44.1757345067184;
        Mon, 08 Sep 2025 08:24:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33add504sm41539994f8f.30.2025.09.08.08.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:24:26 -0700 (PDT)
Message-ID: <8edb13fc-e58d-4480-8c94-c321da0f4d8e@redhat.com>
Date: Mon, 8 Sep 2025 17:24:23 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/16] mm: add vma_desc_size(), vma_desc_pages() helpers
To: Jason Gunthorpe <jgg@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
 Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
 Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 kexec@lists.infradead.org, kasan-dev@googlegroups.com
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <d8767cda1afd04133e841a819bcedf1e8dda4436.1757329751.git.lorenzo.stoakes@oracle.com>
 <20250908125101.GX616306@nvidia.com>
 <e71b7763-4a62-4709-9969-8579bdcff595@lucifer.local>
 <20250908133224.GE616306@nvidia.com>
 <090675bd-cb18-4148-967b-52cca452e07b@lucifer.local>
 <20250908142011.GK616306@nvidia.com>
 <764d413a-43a3-4be2-99c4-616cd8cd3998@lucifer.local>
 <20250908151637.GM616306@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20250908151637.GM616306@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MtCv9LD3uvM8vPLAzmt_HJvYUqJanFruJMbxjzCywCY_1757345068
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> 
>> I think we need to be cautious of scope here :) I don't want to
>> accidentally break things this way.
> 
> IMHO it is worth doing when you get into more driver places it is far
> more obvious why the VM_SHARED is being checked.
> 
>> OK I think a sensible way forward - How about I add desc_is_cowable() or
>> vma_desc_cowable() and only set this if I'm confident it's correct?
> 
> I'm thinking to call it vma_desc_never_cowable() as that is much much
> clear what the purpose is.

Secretmem wants no private mappings. So we should check exactly that, 
not whether we might have a cow mapping.

-- 
Cheers

David / dhildenb

