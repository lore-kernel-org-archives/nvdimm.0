Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E542701CC
	for <nvdimm@lists.linux.dev>; Wed, 25 Jun 2025 09:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750842273; cv=none; b=oZDeLVS/duL6VFxZS3KXIsOysO5TNG1Eknui67poPFGIvl/IRv16bKWoQs6ZL7n9DkymBUkkTBNhmmsAx2cr75Qf66w1qdjwFYk05fj+6awp59ITrM/YXkJ2wThrX7ADO5RjzxVyOQWePs72MI7z7b3GrQN81yVyKgT6lvmUF1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750842273; c=relaxed/simple;
	bh=uMgJZlm8kmOo1C0YzL8T4qtqGzwhvMcbLYuniNt1GrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A/51v71Jqq4Df0ljEO61XPSy3mLKIVG/+cNh/smXDCgSd5jLNFWsqsMnwOFC6N+pIWMO1JLCoIF64l08/vWIxfb1rmVf+jwn5nw0i1KSRMC0k+O6oICddGgCQCtMXSGRThWotwaKSRUVrXILxkY37nrERoDzQNTSPJJckppdi8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FPjuGwNi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FPjuGwNi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750842271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mBhDzhwDu+oV0GKocax8RgDI9cO2NUV/K2JvMLKTnbI=;
	b=FPjuGwNiJSX9bVDdlHZij2Q1Fm6SWC6hNbHI41FUTJBDyvjUMRV9d4M09CYRiV0Md25HG4
	lh8zq3ajejec9kR2jZPQDEpEiQUQARyWwyU6L9twubFqGeqIlgDHe1yNKMtiXIFCQObc7g
	U6fXgq9W3m2yPywIr6sdw5Llqbk9wkk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-FIBTiToKOom6FgacrPrlOg-1; Wed, 25 Jun 2025 05:04:27 -0400
X-MC-Unique: FIBTiToKOom6FgacrPrlOg-1
X-Mimecast-MFC-AGG-ID: FIBTiToKOom6FgacrPrlOg_1750842267
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4eb6fcd88so3258670f8f.1
        for <nvdimm@lists.linux.dev>; Wed, 25 Jun 2025 02:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750842266; x=1751447066;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mBhDzhwDu+oV0GKocax8RgDI9cO2NUV/K2JvMLKTnbI=;
        b=mAGe4ItPSKy3NwC4Ed8sIAbKSZCAathsn5c2leZuHSR9zwkzgIDXFaO5pMnsc+ixAM
         txR55lfme3kSd6kyFX09zsfCKyubNb2Hw4AnX9BqfGMZfnATboNpWBh94DABnzmvvs2X
         MEbbZDuILUzTvwsiLCgMPOlRfl6hhwXQ8NRoLMEwoi/QN+s30pADBv+00HjxrgfzbfpL
         Ri+EUsK0obWKciiF25D+6OhOJEeNiQH23kOAWodRmtnotuv+9KXeaXJinL2EABUn5ldc
         Xy12S4N4kSfdZqk8ca02z4rLoLQYGQaj7/XHPUEi1N1FK7LqoyUE1LIeEZyw91kEkusx
         YPQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUh40uEPA51QA+o+Tty1B6hxANtZL7eMoT72b59MOYZe9alp8dSnwpNsmvx1oeglB07eW8/l/0=@lists.linux.dev
X-Gm-Message-State: AOJu0YysBZQFTLyvzc84eXKcKJVGm1bLucMjg7ylDK1JYE4mSKiqOYpS
	yiEkD9zUbdhz5lEpC1hZj3FsTXgQihLtpJeoEE37+fzGdCRVW6le+Hno9rpabcZvxvDZwZCi9Tb
	Df9z6GeHYyDS6zf/XS2fuu7RINFMwcEAKSEVdgLiyQOy/dapHiCY08N/vDA==
X-Gm-Gg: ASbGncti2arOIzjdy2b0y4IG9Sax3xuHPjBOY5TuN0RSx7dtLDegGgKHe4CcaxQZ6rp
	hid7mvKl3ybAjZ8wFPyo04pXavYLG1bPEPBDdYpfcrjJmcBufktEQYd7Y7YZFu3BqagHF1pJCJT
	M6TEOqN9qgx9KY4WnTzy5lSKPBUJuPnbCK/T6NbVQpPg0wIYRH+hMJkL0s9wg64rtev9l6aGlyq
	EImRzeIomu2Z2Z/9Rs36YPOtWmuU2JbZI4mVwGI7nvPzDCmEh14RgvmTZZzdbZ+lptr8BiD9/HG
	UzZ3m3DgUFXGTkEUYQ+f3gBiP5rAJMkF3Z+TVZhLs0UYnjpPvpomEej884VeZ2M/v/qzvVFkgtu
	liNYLVPchExP/a4du8XWZQPdYD3K7oBdlYFjL1RxmHZx8
X-Received: by 2002:a05:6000:26d2:b0:3a4:fc07:f453 with SMTP id ffacd0b85a97d-3a6ed5c910dmr1292234f8f.8.1750842266578;
        Wed, 25 Jun 2025 02:04:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVvoEG6BvgTkmXif0tj5T4xYuw1wZ555IQoWHI57kLqBKG4XZS1gaqfMOU/SLXEqw1QLIrvg==
X-Received: by 2002:a05:6000:26d2:b0:3a4:fc07:f453 with SMTP id ffacd0b85a97d-3a6ed5c910dmr1292196f8f.8.1750842266139;
        Wed, 25 Jun 2025 02:04:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f12:1b00:5d6b:db26:e2b7:12? (p200300d82f121b005d6bdb26e2b70012.dip0.t-ipconnect.de. [2003:d8:2f12:1b00:5d6b:db26:e2b7:12])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f2670sm3983504f8f.49.2025.06.25.02.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 02:04:23 -0700 (PDT)
Message-ID: <4753c20a-1bbe-4c16-86b8-1b430860a91e@redhat.com>
Date: Wed, 25 Jun 2025 11:04:21 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 11/14] mm: remove "horrible special case to handle
 copy-on-write behaviour"
To: Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, nvdimm@lists.linux.dev,
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
 Pedro Falcato <pfalcato@suse.de>
References: <20250617154345.2494405-1-david@redhat.com>
 <20250617154345.2494405-12-david@redhat.com>
 <5f4c0a45-f219-4d95-b5d7-b4ca1bc9540b@redhat.com>
 <aFu7C0S_SjSOqO8G@localhost.localdomain>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aFu7C0S_SjSOqO8G@localhost.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: t8f-lliiBu9QNQK1YqhDDYDr9ANDMrbVHe_2uo4VXss_1750842267
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25.06.25 11:02, Oscar Salvador wrote:
> On Wed, Jun 25, 2025 at 10:47:49AM +0200, David Hildenbrand wrote:
>> I'm still thinking about this patch here, and will likely send out the other
>> patches first as a v1, and come back to this one later.
> 
> Patch#12 depends on this one, but Patch#13 should be ok to review
> If I ignore the 'addr' parameter being dropped, right?

Yes, only #12 and #13 will be gone. #14 and #15 will simply have the 
"addr" parameter in the _pud() variant as well.

-- 
Cheers,

David / dhildenb

