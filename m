Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C248E18B46E
	for <nvdimm@lists.linux.dev>; Wed,  9 Apr 2025 08:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744188024; cv=none; b=lM3qGNiZWyEU5tlWvUcax2JVJPz96HhMoPFyaAzZSFOONHej+AZTythwcYKTltabyeyLUVWwtFvl5DuzrZNkKH7UyfA2bkGhTnFWGgKcDut7QOs7iJ730BNbiVUWz9c2DEcNtGtFp8Rp5sP/SQtDmDo+5ivDLro4Mv8Ekplv2P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744188024; c=relaxed/simple;
	bh=TRXLRwkKt5RdquNMvN3UlenIKDqR4tyFHQPrKssL0es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ms3KuKOmMwv7AId80DaXuC1tdPydu4eHE0SH4rPj865Dd/Cg8LpGAz4zP6FLu96MFDqIt4wfchvk5ZbNRdGO1hp044eCXfIkowxZJP6NH1GrzaZjHSgJ6Ea6iEzzkeO7vQryg2KlLyn5qOt3Jzq2cpA1QcdvvP3q1osbv+47Pps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GcT7Tl5Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GcT7Tl5Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744188021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=n1leLUo6hJG8Yt+vIJqFsONDJaIpr5lawRcoNhUcXTc=;
	b=GcT7Tl5QsENkW/y+QaEPX5d9Uvsyjky1mt74kijtGB9iV7JWXFKaKstn4h2ae9L43w/dH+
	FfoHYQaIAN3nYL0PnF+LQkb7wbz+IaxOwtTaW5xfPaOofOdc6Ba3r8VfTkGwArXOLrYopL
	d8e9CwtQwOqxLJMPb0qPGS0kK7FWBw4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-aU6RS4LDMq-8l8nGyVddlQ-1; Wed, 09 Apr 2025 04:40:20 -0400
X-MC-Unique: aU6RS4LDMq-8l8nGyVddlQ-1
X-Mimecast-MFC-AGG-ID: aU6RS4LDMq-8l8nGyVddlQ_1744188019
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-391492acb59so3673047f8f.3
        for <nvdimm@lists.linux.dev>; Wed, 09 Apr 2025 01:40:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744188019; x=1744792819;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n1leLUo6hJG8Yt+vIJqFsONDJaIpr5lawRcoNhUcXTc=;
        b=Sxj4ifnZpxEORgr/58P6VGxODqIOmQxx2xTfesTf10WDi457kXm8cDuP/hC/n+iO1w
         riejpsC+A5X/3a5kQVvfNFMBXncCDtEzBZnJXjCPyPGUUMFmiBMBwkr9aH4AdlOY58+r
         2qbaPnwtIAzx9qPVbblDib4Llat+8Vxd+Ud48XjlecVaLcqdKM0dHg0dTpbRB2qXGvXf
         csm6OfqRcwPK1BKUokU0s1vR3MHEHeTrWBqYk9fCeexpp75U6sCaQBZozLXGH+V0XLtP
         KBVqTV+BeTARnoK0k6JhJYPQ3YVfHO9PetFWaGIT5rpf8Ry3wFDf/32yh8dThCpsroYc
         HI5A==
X-Forwarded-Encrypted: i=1; AJvYcCWnIEhlE6PevM/o9KRs1fhICnxwytDhbA97o4vNUrBhfGCXUKASyFT5liuQkXe01Z/R/VFm5tk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCiLxUaAN984llFmAImoBr6BVHVL6b8KfgJIsEF/a87WjmQVGh
	6gE3OJ/ZGRf5/p99SZnlClW7RhFP9Jc45vSERWKwJh+Z4e861XIwIhgAUaYYrh6S3wd2CYAkN8l
	4c+itNFsLAEwjijScOx38CBtLr/SxDnz7916mv3r2+f3WrZKWXAyrRg==
X-Gm-Gg: ASbGncswBErbDzsrulq2d8mvB9deoLez/EZqaoWGnc25Awb7bEmyRhhcwa2x1W/7MvA
	LbB5OYq/Pd5djKhySEGHJdvIH9WxsHUd/IW1DpUcNta9L9zBEDTe0nN/eQRQej+8QKm7Ht8XVsV
	M+YGWf2u4R7nnzxWH+T8kT+deEnk/aRu+wCjCUprehP7YSP4BgnmRCOLc+bDx0ez+AALnunpSfr
	kyK2s99sZSCNWMlyreXkuuuBIc+orqqEw1AacKNSI0+ipPnj/6+RZhsX9srNdHIi8E12jy69WV9
	sCI0iASTLBYAb3JpPsTG6DxMhOQrIp/VUUM1PjLGiH5o4m3wrkJGQlZHHPrnaRSldrzm9/F14Lw
	YgQCmbA/cGs3j4TMswo0fES6KHDO791o9hA==
X-Received: by 2002:a05:6000:2508:b0:390:ebae:6c18 with SMTP id ffacd0b85a97d-39d87aa57eemr1747370f8f.12.1744188018885;
        Wed, 09 Apr 2025 01:40:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIMnM+hH4va1P5dcTwys+cw2AllKEGqUwkk9MPd82+62YkeU+Eg7RRRaD9rvfXbZ2yG9dqIQ==
X-Received: by 2002:a05:6000:2508:b0:390:ebae:6c18 with SMTP id ffacd0b85a97d-39d87aa57eemr1747346f8f.12.1744188018473;
        Wed, 09 Apr 2025 01:40:18 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:8400:ed9b:a3a:88e5:c6a? (p200300cbc70d8400ed9b0a3a88e50c6a.dip0.t-ipconnect.de. [2003:cb:c70d:8400:ed9b:a3a:88e5:c6a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f207cb692sm12979065e9.40.2025.04.09.01.40.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 01:40:17 -0700 (PDT)
Message-ID: <322e93d6-3fe2-48e9-84a9-c387cef41013@redhat.com>
Date: Wed, 9 Apr 2025 10:40:17 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG Report] 6.15-rc1 RIP:
 0010:__lruvec_stat_mod_folio+0x7e/0x250
To: Alison Schofield <alison.schofield@intel.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev
References: <Z_W9Oeg-D9FhImf3@aschofie-mobl2.lan>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z_W9Oeg-D9FhImf3@aschofie-mobl2.lan>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UbTRDTM5bnr8fGotzm9I6qK1EdFJ_Q8KktM3kDqS59o_1744188019
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.04.25 02:20, Alison Schofield wrote:
> Hi David, because this bisected to a patch you posted
> Hi Alistair,  because vmf_insert_page_mkwrite() is in the path

Hi!

> 
> A DAX unit test began failing on 6.15-rc1. I chased it as described below, but
> need XFS and/or your Folio/tail page accounting knowledge to take it further.
> 
> A DAX XFS mappings that is SHARED and R/W fails when the folio is
> unexpectedly NULL. Note that XFS PRIVATE always succeeds and XFS SHARED,
> READ_ONLY works fine. Also note that it works all the ways with EXT4.
> 

Huh, but why is the folio NULL?

insert_page_into_pte_locked() does "folio = page_folio(page)" and then 
even calls folio_get(folio) before calling folio_add_file_rmap_pte().

folio_add_file_rmap_ptes()->__folio_add_file_rmap() just passes the 
folio pointer along.

The RIP seems to be in __lruvec_stat_mod_folio(), so I assume we end up 
in __folio_mod_stat()->__lruvec_stat_mod_folio().

There, we call folio_memcg(folio). Likely we're not getting NULL back, 
which we could handle, but instead "0000000000000b00"

So maybe the memcg we get is "almost NULL", and not the folio ?

> [  417.796271] BUG: kernel NULL pointer dereference, address: 0000000000000b00
> [  417.796982] #PF: supervisor read access in kernel mode
> [  417.797540] #PF: error_code(0x0000) - not-present page
> [  417.798123] PGD 2a5c5067 P4D 2a5c5067 PUD 2a5c6067 PMD 0
> [  417.798690] Oops: Oops: 0000 [#1] SMP NOPTI
> [  417.799178] CPU: 5 UID: 0 PID: 1515 Comm: mmap Tainted: G           O        6.15.0-rc1-dirty #158 PREEMPT(voluntary)
> [  417.800150] Tainted: [O]=OOT_MODULE
> [  417.800583] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> [  417.801358] RIP: 0010:__lruvec_stat_mod_folio+0x7e/0x250
> [  417.801948] Code: 85 97 00 00 00 48 8b 43 38 48 89 c3 48 83 e3 f8 a8 02 0f 85 1a 01 00 00 48 85 db 0f 84 28 01 00 00 66 90 49 63 86 80 3e 00 00 <48> 8b 9c c3 00 09 00 00 48 83 c3 40 4c 3b b3 c0 00 00 00 0f 85 68
> [  417.803662] RSP: 0000:ffffc90002be3a08 EFLAGS: 00010206
> [  417.804234] RAX: 0000000000000000 RBX: 0000000000000200 RCX: 0000000000000002
> [  417.804984] RDX: ffffffff815652d7 RSI: 0000000000000000 RDI: ffffffff82a2beae
> [  417.805689] RBP: ffffc90002be3a28 R08: 0000000000000000 R09: 0000000000000000
> [  417.806384] R10: ffffea0007000040 R11: ffff888376ffe000 R12: 0000000000000001
> [  417.807099] R13: 0000000000000012 R14: ffff88807fe4ab40 R15: ffff888029210580
> [  417.807801] FS:  00007f339fa7a740(0000) GS:ffff8881fa9b9000(0000) knlGS:0000000000000000
> [  417.808570] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  417.809193] CR2: 0000000000000b00 CR3: 000000002a4f0004 CR4: 0000000000370ef0
> [  417.809925] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  417.810622] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  417.811353] Call Trace:
> [  417.811709]  <TASK>
> [  417.812038]  folio_add_file_rmap_ptes+0x143/0x230
> [  417.812566]  insert_page_into_pte_locked+0x1ee/0x3c0
> [  417.813132]  insert_page+0x78/0xf0
> [  417.813558]  vmf_insert_page_mkwrite+0x55/0xa0
> [  417.814088]  dax_fault_iter+0x484/0x7b0
> [  417.814542]  dax_iomap_pte_fault+0x1ca/0x620
> [  417.815055]  dax_iomap_fault+0x39/0x40
> [  417.815499]  __xfs_write_fault+0x139/0x380
> [  417.815995]  ? __handle_mm_fault+0x5e5/0x1a60
> [  417.816483]  xfs_write_fault+0x41/0x50
> [  417.816966]  xfs_filemap_fault+0x3b/0xe0
> [  417.817424]  __do_fault+0x31/0x180
> [  417.817859]  __handle_mm_fault+0xee1/0x1a60
> [  417.818325]  ? debug_smp_processor_id+0x17/0x20
> [  417.818844]  handle_mm_fault+0xe1/0x2b0
> [  417.819286]  do_user_addr_fault+0x217/0x630
> [  417.819747]  ? rcu_is_watching+0x11/0x50
> [  417.820185]  exc_page_fault+0x6c/0x210
> [  417.820599]  asm_exc_page_fault+0x27/0x30
> [  417.821080] RIP: 0033:0x40130c
> [  417.821461] Code: 89 7d d8 48 89 75 d0 e8 94 ff ff ff 48 c7 45 f8 00 00 00 00 48 8b 45 d8 48 89 45 f0 eb 18 48 8b 45 f0 48 8d 50 08 48 89 55 f0 <48> c7 00 01 00 00 00 48 83 45 f8 01 48 8b 45 d0 48 c1 e8 03 48 39
> [  417.823156] RSP: 002b:00007ffcc82a8cb0 EFLAGS: 00010287
> [  417.823703] RAX: 00007f336f5f5000 RBX: 00007ffcc82a8f08 RCX: 0000000067f5a1da
> [  417.824382] RDX: 00007f336f5f5008 RSI: 0000000000000000 RDI: 0000000000036a98
> [  417.825096] RBP: 00007ffcc82a8ce0 R08: 00007f339fa84000 R09: 00000000004040b0
> [  417.825769] R10: 00007f339fa8a200 R11: 00007f339fa8a7b0 R12: 0000000000000000
> [  417.826438] R13: 00007ffcc82a8f28 R14: 0000000000403e18 R15: 00007f339fac3000
> [  417.827148]  </TASK>
> [  417.827461] Modules linked in: nd_pmem(O) dax_pmem(O) nd_btt(O) nfit(O) nd_e820(O) libnvdimm(O) nfit_test_iomap(O)
> [  417.828404] CR2: 0000000000000b00
> [  417.828807] ---[ end trace 0000000000000000 ]---
> [  417.829293] RIP: 0010:__lruvec_stat_mod_folio+0x7e/0x250
> 
> 
> And then, looking at the page passed to vmf_insert_page_mkwrite():
> 
> [   55.468109] flags: 0x300000000002009(locked|uptodate|reserved|node=0|zone=3)

reserved might indicate ZONE_DEVICE. But zone=3 might or might not be 
ZONE_DEVICE (depending on the kernel config).

> [   55.468674] raw: 0300000000002009 ffff888028c27b20 00000000ffffffff ffff888033b69b88
> [   55.469270] raw: 000000000000fff5 0000000000000000 00000001ffffffff 0000000000000200
> [   55.469835] page dumped because: ALISON dump locked & uptodate pages

Do you have the other (earlier) output from __dump_page(), especially if 
this page is part of a large folio etc?

Trying to decipher:

0300000000002009 -> "unsigned long flags"
ffff888028c27b20 -> big union

As the big union overlays "unsigned long compound_head", and the last 
bit is not set, this should be a *small folio*.

That would mean that "0000000000000200" would be "unsigned long memcg_data".

0x200 might have been the folio_nr_pages before the large folio was 
split. Likely, we are not clearing that when splitting the large folio, 
resulting in a false-positive "memcg_data" after the split.

> 
> ^ That's different:  locked|uptodate. Other page flags arriving here are
> not locked | uptodate.
> 
> Git bisect says this is first bad patch (6.14 --> 6.15-rc1)
> 4996fc547f5b ("mm: let _folio_nr_pages overlay memcg_data in first tail page")
> 
> Experimenting a bit with the patch, UN-defining NR_PAGES_IN_LARGE_FOLIO,
> avoids the problem.
> 
> The way that patch is reusing memory in tail pages and the fact that it
> only fails in XFS (not ext4) suggests the XFS is depending on tail pages
> in a way that ext4 does not.

IIRC, XFS supports large folios but ext4 does not. But I don't really 
know how that interacts with DAX (if the same thing applies). Ordinary 
XFS large folio tests seem to work just fine, so the question is what 
DAX-specific is happening here.

When we free large folios back to the buddy, we set "folio->_nr_pages = 
0", to make the "page->memcg_data" check in page_bad_reason() happy. 
Also, just before the large folio split for ordinary large folios, we 
set "folio->_nr_pages = 0".

Maybe there is something missing in ZONE_DEVICE freeing/splitting code 
of large folios, where we should do the same, to make sure that all 
page->memcg_data is actually 0?

I assume so. Let me dig.

-- 
Cheers,

David / dhildenb

