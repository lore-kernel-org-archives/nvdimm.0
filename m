Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCE11D3576
	for <nvdimm@lists.linux.dev>; Tue, 14 Jan 2025 16:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736872848; cv=none; b=amVzAKP197ryPdxwOqkybUf8X9cbkbccWlXox6oJwDfzUJ+4uJjZhnUR/CmjZviD1EdxkYycuHhVo/hd1U9OjHk3tG4q34dU/W3Pfc30FTyC920LL5rFWb5tgqp2uPlBogkak3OhZcxY7OsRX0gYB2ztsSvZq7zoil6nyeioDy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736872848; c=relaxed/simple;
	bh=SWpTIMK8lzFBKRNAU3gX+w9k3JLPq/iF6huli7uPfm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MA5cTdMt/LyYxH62vk+sZBLvRRSnRf/rzQ8uSoMjMEMb9i1ROBPW4MSdvYpoWdJQM3VXx/j4G31T45eHeLuMkBYvjeiKmbLdyaOw8RNGxLktiZ1ylRy+z714z7Qnw0C/ZBeXGzisjyDLGF8StdzK78E8pDjIQNvTU8ih06LmOzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fW7HUAGA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fW7HUAGA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736872846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mczZUoWGAV5QF6Dgux9UR9VFuQW2+GvnXwEwpL5KPSQ=;
	b=fW7HUAGA+CCHF8eTsxcVD0M5XhPgqIcHN6RvpM0DQvqaSMv26anjUZdT6INVidVN3MzSa6
	KEqtmDVUfPlUgPFUfgZTEhNiDOnnTmrpN/liiDB2sGYR2U5APsClMbaRzdjzonYGf3XZRK
	3j83UAg3LG5p0enZzuLeraq2aolHDWM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-XHKO_vWxPKKgtrK805QG4g-1; Tue, 14 Jan 2025 11:40:42 -0500
X-MC-Unique: XHKO_vWxPKKgtrK805QG4g-1
X-Mimecast-MFC-AGG-ID: XHKO_vWxPKKgtrK805QG4g
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3862f3ccf4fso2099499f8f.0
        for <nvdimm@lists.linux.dev>; Tue, 14 Jan 2025 08:40:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736872841; x=1737477641;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mczZUoWGAV5QF6Dgux9UR9VFuQW2+GvnXwEwpL5KPSQ=;
        b=oiq18dWqOR4FTKRO2N6HReW5P8hZM7maK+ATSz3UsAV2elRYp2I900pKRQdsdz8/SN
         jmC7dgWMWzY2TFDU0tfKLv4vArubwFjZBlvE3AFzHz+z1BEIAtFgQsdb+Nrh84QyyhX2
         mC3xyKA75OTgf3TGGcKnnN0eZltuprFGkAXsIDkezi6dE3v79EqtjMyDXrPu3tnMhL2e
         5KUn25S/L3FxJdqXVDH2/x3EOG9w/TkZLh0LJNOW+Wb375nfcsohVUggdqUtaYwswxVl
         s76gIzrwQEgMMMbNatIqKHQysxY0V4gFUaSxBJV+CbvBpMsnFXeyk/0oIDvKlOTK0zDK
         W8Pg==
X-Forwarded-Encrypted: i=1; AJvYcCXQ7ufCVUpkIFUkqP0W903Zvn0X0Vz9e0G/Lo0zeo2HH+s3LFD1FwrAes+CxJpsZwpkn4XGUME=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhTp+Z8Xg7KEom/IkbWaIfheeMj6B+wkUPP2Ls+t7Q2KAAzVoo
	3LEWDw6y1tO28KiAOk8MbKM8aOWv3TMDpWQahb/ce3OBpwUXEk1ePPTcx45mPfSmk83XQcaCbjU
	8+D5tUw6ciA62go+7yQOq2XQoRSGBMNKJ3PS9zPakGuUYD/U4hBMFLQ==
X-Gm-Gg: ASbGnctlmNuGvZEZTb7rGC1PgiYQ/LA+SNk1JdzQM1D6xPKM0ecZgZ7xXQGGPCbhyaX
	IeHqYmp3j7yVlmS5qqpNh4ikaPUWhUo8sgLF7CPRDsth1pl4Ts7DPG+Nl/AOdhVAXmIyeeh0hs5
	kA0nJE6QUyeJMBqLO442L/fNgCn/FdY6iOScKyLp3yK4qyQLu8Rm5J42sYK3eMcVqhdYOHkcR57
	/C6Gk56WRsdE1B0CIEDWZ5ocYZx4ybhSsGKv9k6y539udAAWF9qv86mMpqOOc9P3uLosh7IoqNo
	FzE344v7/nabctmiUfZavnLBDI55/EWBrnoH3umt5IIp8uI/KNTrfUF59EYDvlKY1nVDuhGqZGi
	iFbkgyYx6
X-Received: by 2002:a5d:64a7:0:b0:385:f631:612 with SMTP id ffacd0b85a97d-38a9d0a169fmr10472147f8f.17.1736872841235;
        Tue, 14 Jan 2025 08:40:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEc1fBtauoetrfyVmlAeLA4qBkDXyQ6HQ3d2cKZ9xBYn1krtsjfIkJAnB30ZUXL+ZF7yLk2tQ==
X-Received: by 2002:a5d:64a7:0:b0:385:f631:612 with SMTP id ffacd0b85a97d-38a9d0a169fmr10472068f8f.17.1736872839906;
        Tue, 14 Jan 2025 08:40:39 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38c006sm15191889f8f.46.2025.01.14.08.40.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 08:40:38 -0800 (PST)
Message-ID: <31919e6c-0cec-4e3a-a0c6-a80be53d6ccc@redhat.com>
Date: Tue, 14 Jan 2025 17:40:35 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 16/26] huge_memory: Add vmf_insert_folio_pmd()
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
 dan.j.williams@intel.com, linux-mm@kvack.org
Cc: alison.schofield@intel.com, lina@asahilina.net, zhang.lyra@gmail.com,
 gerald.schaefer@linux.ibm.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, logang@deltatee.com, bhelgaas@google.com,
 jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com, will@kernel.org,
 mpe@ellerman.id.au, npiggin@gmail.com, dave.hansen@linux.intel.com,
 ira.weiny@intel.com, willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
 linmiaohe@huawei.com, peterx@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jhubbard@nvidia.com,
 hch@lst.de, david@fromorbit.com, chenhuacai@kernel.org, kernel@xen0n.name,
 loongarch@lists.linux.dev
References: <cover.11189864684e31260d1408779fac9db80122047b.1736488799.git-series.apopple@nvidia.com>
 <02216c30a733ecc84951f9aeb1130cef7497125d.1736488799.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <02216c30a733ecc84951f9aeb1130cef7497125d.1736488799.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: glvpm2eqcr-bor28_SerQftd8Tkb0BDN5mQCXVmmkxI_1736872841
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> +vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio, bool write)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	unsigned long addr = vmf->address & PMD_MASK;
> +	struct mm_struct *mm = vma->vm_mm;
> +	spinlock_t *ptl;
> +	pgtable_t pgtable = NULL;
> +
> +	if (addr < vma->vm_start || addr >= vma->vm_end)
> +		return VM_FAULT_SIGBUS;
> +
> +	if (WARN_ON_ONCE(folio_order(folio) != PMD_ORDER))
> +		return VM_FAULT_SIGBUS;
> +
> +	if (arch_needs_pgtable_deposit()) {
> +		pgtable = pte_alloc_one(vma->vm_mm);
> +		if (!pgtable)
> +			return VM_FAULT_OOM;
> +	}

This is interesting and nasty at the same time (only to make ppc64 boo3s 
with has tables happy). But it seems to be the right thing to do.

> +
> +	ptl = pmd_lock(mm, vmf->pmd);
> +	if (pmd_none(*vmf->pmd)) {
> +		folio_get(folio);
> +		folio_add_file_rmap_pmd(folio, &folio->page, vma);
> +		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PMD_NR);
> +	}
> +	insert_pfn_pmd(vma, addr, vmf->pmd, pfn_to_pfn_t(folio_pfn(folio)),
> +		       vma->vm_page_prot, write, pgtable);
> +	spin_unlock(ptl);
> +	if (pgtable)
> +		pte_free(mm, pgtable);

Ehm, are you unconditionally freeing the pgtable, even if consumed by 
insert_pfn_pmd() ?

Note that setting pgtable to NULL in insert_pfn_pmd() when consumed will 
not be visible here.

You'd have to pass a pointer to the ... pointer (&pgtable).

... unless I am missing something, staring at the diff.

-- 
Cheers,

David / dhildenb

