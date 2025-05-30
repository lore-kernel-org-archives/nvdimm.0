Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64A622ACFA
	for <nvdimm@lists.linux.dev>; Fri, 30 May 2025 09:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748597633; cv=none; b=VRt0J3OuPanccQcyEkOuBFxlfdhUHPoxMSwM0uhBLi++3i7CGImyMtYghpAGEqwLhBW8e6pHGD+C5JF16Ta6gm3gXxZIbINcNOqnLD3+RcGkVeBBFmmHZ5bwjd91duhwxPkrdxyVoRhzqw38GYVb/MGEgyMaoNOW9HY+vlh5dAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748597633; c=relaxed/simple;
	bh=DB+1yl7APIInm8MCrBxZ4Qwh/WXcXEhVDIyFl5OmcI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GBHildpeHhqifRE/d0FL9cYfqw4StXjihqQL8dmAxq5XBVpOqBvvHwDzw6dxsZGHHG4WmZA+vYhJZYHiQHnlzQKIbSUvzJAw7z1O7sh3JjyN0CR1AWEjJQsT+ItiLDz+nzWXOYKZxVuGXJBK4k9z+nqGgRkbTwknWaS0Ix3oY08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OsOA5HEF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OsOA5HEF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748597631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3HsXX6R0HPP/biqLepMPHpr/VTNhNhquA8c3ePXroJI=;
	b=OsOA5HEF2k818s0fAygUVueKPJTmp+zsbpd/ZoHS6GfaAqroUa1jcLQlQJKk82VfAvv/Jz
	oTCx1D2XsmATDBAQMqENQvdvZoVUIlP+MwRlroKwmRsbWTu44OUZcBSy9TxRFv5YDqxOUT
	UhN0Hyu1m1LJWBcsOeeRKjny2u6RYwQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-vuT0Mh-pNIWF-JTkdB4hKQ-1; Fri, 30 May 2025 05:33:49 -0400
X-MC-Unique: vuT0Mh-pNIWF-JTkdB4hKQ-1
X-Mimecast-MFC-AGG-ID: vuT0Mh-pNIWF-JTkdB4hKQ_1748597628
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4fabcafecso65924f8f.0
        for <nvdimm@lists.linux.dev>; Fri, 30 May 2025 02:33:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748597628; x=1749202428;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3HsXX6R0HPP/biqLepMPHpr/VTNhNhquA8c3ePXroJI=;
        b=u/4l1xNiyKW1k8uzKITPMmwGOXuIFoAfuOHb9qkrDb3pujATEOWV8h97JOTCv8a8PO
         /eNEMNY3kFvqOHtykW952ojwJiUtL4bL4ejmWwp6uioAigJ7ule3DiNO6wqE5PYZcZUK
         uYP77Gnbh3hm8eRRvbWWOVHL0dX29qKRMi8BkQeQiOgoV0g7gxZGq+sKiS+AXUozj+Og
         s2amt6bC/Y1aPiKjaexrCEloWg8qgt2EKhxoO2+1TMCIQXBW8/WbKZBdY3T7sqidoB6S
         Y/8nvgKCyI+h2OI6myKRusuoN70p/Z0If+JbeQkOOyBJbIJHAkeRfTylryFCaQBfwjxP
         zxxg==
X-Forwarded-Encrypted: i=1; AJvYcCWeypbdKAgpiGtD5U5L1SPVxjHWL2Ol428mwwX7hReeiUFAYf9v4pQCY+Ym0aGwxP2+Thq1yYA=@lists.linux.dev
X-Gm-Message-State: AOJu0YztRFB1tFZJg9GIWBYuwjOuv0xaVqDtuJc6V2l7Qt0jdZ0mDlqf
	7j6lDADUS1NIJd6BTqBX66t8PIT1KgnV/1PLLU/8atC+CQ3X1N0jpgjajPJ06YWQUhSpgQilRKR
	XX0G1IMdg5uyYgucJRWO9G4pW1ggbJ2D+W7646JsDTFGRclRbmHZsDyjYxA==
X-Gm-Gg: ASbGncsZPT4AlaxRmyPJHA7el26wID0YeErfvyXlO3o9sk10rXo+7Gg9RcY/eSfvFaV
	mku73I9KXWGChvs4PJwccJArxbMhUeGQZ9sxltYXJ4lVnmw1S+3iBpbgy8j99hSCAxpeihikc5S
	VJSiqS98XvOwvCOrlfyHHxiDBPmBCGV3dkhUflrZsX4UP2O30PDBFLt7GYoKBfM1CxqPMqjN3oa
	MHDsVO4T80QxV1/AZULlENyoRZzUqcb5jcrBRMdcyHKF+cV1z6IkI4S5qjL3fKTX/ngDYlo4pBl
	ofkQtY8PPncr/mBBs5w3fAigXFlx1ren7a7IYUOl3nbATp+zqyMApUGfCG9bNe88QVLVYYPtyrA
	HN8HoYuGe0VsKS+bUDRObmWJlqF0EIcvefXMHWRU=
X-Received: by 2002:a05:6000:188b:b0:3a4:e393:11e2 with SMTP id ffacd0b85a97d-3a4f7a366bbmr2070877f8f.34.1748597628391;
        Fri, 30 May 2025 02:33:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPLwoEcfpG65ruS1QubjzGQLrQH9J6REe/EFj1LtU5rHML/KjwauHHFCNN+LVLagp2fysdSQ==
X-Received: by 2002:a05:6000:188b:b0:3a4:e393:11e2 with SMTP id ffacd0b85a97d-3a4f7a366bbmr2070847f8f.34.1748597627996;
        Fri, 30 May 2025 02:33:47 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f03:5b00:f549:a879:b2d3:73ee? (p200300d82f035b00f549a879b2d373ee.dip0.t-ipconnect.de. [2003:d8:2f03:5b00:f549:a879:b2d3:73ee])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4f00972d9sm4415633f8f.64.2025.05.30.02.33.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 02:33:47 -0700 (PDT)
Message-ID: <bbb19f59-54bc-4399-a387-1df9713fc621@redhat.com>
Date: Fri, 30 May 2025 11:33:45 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/12] mm: Remove PFN_MAP, PFN_SG_CHAIN and PFN_SG_LAST
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Cc: gerald.schaefer@linux.ibm.com, dan.j.williams@intel.com, jgg@ziepe.ca,
 willy@infradead.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org,
 balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org, John@Groves.net
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <cb45fa705b2eefa1228e262778e784e9b3646827.1748500293.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <cb45fa705b2eefa1228e262778e784e9b3646827.1748500293.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GFyIUhkIRZcT5IOrq6Pc6v1E3cw1GmMm6zKQjxf103I_1748597628
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29.05.25 08:32, Alistair Popple wrote:
> The PFN_MAP flag is no longer used for anything, so remove it. The
> PFN_SG_CHAIN and PFN_SG_LAST flags never appear to have been used so
> also remove them.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

With SPECIAL mentioned as well

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

