Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8A6469D
	for <nvdimm@lists.linux.dev>; Fri,  6 Jun 2025 07:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749194908; cv=none; b=AdDfwodAUsjIN1OY6ORspTNjb7Z7KnOAxsrQKJ4GWX1M1gDNebAfI5ZK/sfUy52uUrv+A3yMYuU3PfS7fyaCz66xXji0olimp+aIiXF+WxWaNed3K14THN8sFoM5oV3mneTu8SIxgQOLjSPxD2noPTWWttQw9+wuH/d43NwgAfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749194908; c=relaxed/simple;
	bh=iaYxD+iI4naXYVHj7zQRNz0DVMwoDBG2LlbzruSW9qw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H7p+3p4m0ABqVVRZkC2cP7pZayT0dz6wVWAU23Qk+80HZjWrzRREkSVS3ZB9kTBNuaBf+aW103r95xJE/qQJWO8NNK6zRvYwtAvldnu8SZqck3H3EOlH/ii64cy/ODrgoc1/z8860n7DYa3/KB4Pkz4NFtxkTM6aalyVrBkoYQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NPscNTN9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPscNTN9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749194905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MzU6QKfO94usyKULdWmvLb6fqSscWED5D9l6Eb/I+FQ=;
	b=NPscNTN9AJzG4PvHk7gc8obNHfPzcCHZ+6E8Edi499ToYbKBxYFLzjwvOOiTBGnOGaBcAM
	kjoU0UKotqE4doOWKuWiorQXBjqNJPIJ2oioirZbl9Au+PvXkdTdfEnVtxTkBEs9C3m42b
	EkniHV52bGYffE3Uge92evzg9+pmK4U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-7wfWUQifMiK0x3yHw126Ew-1; Fri, 06 Jun 2025 03:28:24 -0400
X-MC-Unique: 7wfWUQifMiK0x3yHw126Ew-1
X-Mimecast-MFC-AGG-ID: 7wfWUQifMiK0x3yHw126Ew_1749194903
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-450eaae2934so14904065e9.2
        for <nvdimm@lists.linux.dev>; Fri, 06 Jun 2025 00:28:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749194903; x=1749799703;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MzU6QKfO94usyKULdWmvLb6fqSscWED5D9l6Eb/I+FQ=;
        b=As4JSGNfhCILVXoZvH5hSkLpI7flcBMxTptjKu5a+SCTiZWDW/k793qokZ6S09j8Ih
         MIm9bmgn8ylLj6ysNUxaac/3slTciMhi3oZAhKsZaQ8mBYGpoChSwgdPxQLEscbjCOMA
         L55p2J2uN2X+9o8wqPriVu28qMEm0N2k7yyh38zV/URyC6tZJEJ5iBbJ8hhMGtal7jnL
         QCu0cDPht3rGkrmonXL7c2jlhPszGOPV+ctP1jE+KVIqxud1UFb9Yz4CH8MW1lCWbAJp
         ttufMV4oTwsd3hVav2FVBp372Fy4wqAH48CvR6zwUF7aCSaM+GpKL7SCk4+b++mFPWH1
         cTRQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8xoPX5Z5DYXIKui11oAcJ+aQiw1nFS0j/RfTTbMYB6PdHuORd+QdAj8bBMxxi4Ump8ZAFKIE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBKHXCwYcKEvQzsV74ImtK+1CDq1AerMXnjXtAZ/tUgdMmPQmf
	GaxKNfBm4xYwUKibK5PRVRnKhsjkF1PmyDymU+KpcJ5/y9/PB8E5z9vmS7zxLUPm798ZOxKMMCV
	HkvkOvr/zZmhSo9LTb8fXKgLmegyo4v9Y4EolMY2NrTgvZRBYH4NY41o6xQ==
X-Gm-Gg: ASbGncvOzgZuMEHmHyV8+4QQ7sd5AaHLEfeXAwLjLtqNdOK2gsPCSJWU59RpjA9P11T
	6kIv7OoJqhqeXIDZGKDq5NEmVH+NaMIEjxZQteRZFyfoMxY5MdU22ADHLfLxkf+TL5yCd6it90T
	RGHTgK9iDW8ksiHHl3GilrubGKQ04vtap+SBWHBasYTQ5boJ5gjDwowaFMlaiSWBmbhLm1EUEcC
	PKuLUN1uLubzihLtWNEEA4g3l3cVpIzEgz2ZH9ir6Nu25QtQQUHEqSF6ZNtkapoaQc4xyYH93lk
	cG5b8wgZpCVfc+O0zsm5vplxVShCFdmPEFWUes2bCKs=
X-Received: by 2002:a05:6000:250d:b0:3a4:f912:862b with SMTP id ffacd0b85a97d-3a5318a0627mr2178096f8f.33.1749194902689;
        Fri, 06 Jun 2025 00:28:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaLWomZETgDCELZygyLcC/ojJCXhsOZyZJnL/gBwDuRpfKNSX2ofIkG8V68GPZaYh+LOJmwQ==
X-Received: by 2002:a05:6000:250d:b0:3a4:f912:862b with SMTP id ffacd0b85a97d-3a5318a0627mr2178057f8f.33.1749194902217;
        Fri, 06 Jun 2025 00:28:22 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a6a5.dip0.t-ipconnect.de. [87.161.166.165])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a53244d15asm1098905f8f.66.2025.06.06.00.28.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 00:28:21 -0700 (PDT)
Message-ID: <371ac1ce-8f14-4914-94f5-6e6b46a486fb@redhat.com>
Date: Fri, 6 Jun 2025 09:28:20 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] mm/huge_memory: don't mark refcounted pages
 special in vmf_insert_folio_*()
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>
References: <20250603211634.2925015-1-david@redhat.com>
 <68422c7a3a2c2_2491100fe@dwillia2-xfh.jf.intel.com.notmuch>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <68422c7a3a2c2_2491100fe@dwillia2-xfh.jf.intel.com.notmuch>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: n6bjU02945_5wE0ExGMx7E5ok7RLTxnspBYf3DuaP-E_1749194903
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dan,

On 06.06.25 01:47, Dan Williams wrote:
> David Hildenbrand wrote:
>> Based on Linus' master.
>>
>> While working on improving vm_normal_page() and friends, I stumbled
>> over this issues: refcounted "normal" pages must not be marked
>> using pmd_special() / pud_special().
>>
>> Fortunately, so far there doesn't seem to be serious damage.
>>
>> This is only compile-tested so far. Still looking for an easy way to test
>> PMD/PUD mappings with DAX. Any tests I can easily run?
> 
> The way I test this I would not classify as "easy", it is a bit of a pain
> to setup, but it is passing here:

I guess most of the instructions are in

https://github.com/pmem/ndctl

?

I would assume that we need to set aside some special dax area using 
early boot params (memmap=).

Might come in handy in the future.

> 
> [root@host ndctl]# meson test -C build --suite ndctl:dax
> ninja: Entering directory `/root/git/ndctl/build'
> [168/168] Linking target cxl/cxl
>   1/13 ndctl:dax / daxdev-errors.sh          OK              14.30s
>   2/13 ndctl:dax / multi-dax.sh              OK               2.89s
>   3/13 ndctl:dax / sub-section.sh            OK               8.40s
>   4/13 ndctl:dax / dax-dev                   OK               0.06s
>   5/13 ndctl:dax / dax-ext4.sh               OK              20.53s
>   6/13 ndctl:dax / dax-xfs.sh                OK              20.34s
>   7/13 ndctl:dax / device-dax                OK              11.67s
>   8/13 ndctl:dax / revoke-devmem             OK               0.25s
>   9/13 ndctl:dax / device-dax-fio.sh         OK              34.02s
> 10/13 ndctl:dax / daxctl-devices.sh         OK               3.44s
> 11/13 ndctl:dax / daxctl-create.sh          SKIP             0.32s   exit status 77
> 12/13 ndctl:dax / dm.sh                     OK               1.33s
> 13/13 ndctl:dax / mmap.sh                   OK              85.12s
> 
> ...ignore the SKIP, that seems to be caused by an acpi-einj regression.

Thanks for running these tests!

> 
> However, how about not duplicating the internals of insert_pfn_p[mu]d()
> with something like the below. Either way you can add:

I considered that, but I prefer the current end result where we cleanup 
the pmd_none() handling and not mess with folios and pfns at the same time.

... just like we do for insert_pfn() vs. insert_page(), I don't think 
these code paths should be unified.

(we should do more sanity checks like validate_page_before_insert() 
etc., but that's something for another day :) )


> 
> Tested-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Thanks!


Let me resend with the fixup squashed.

-- 
Cheers,

David / dhildenb

