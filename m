Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C98B1411C8
	for <nvdimm@lists.linux.dev>; Tue, 14 Jan 2025 14:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736866074; cv=none; b=ojPSJcbrJzhQMVTXuyghPTEH+kMOmG9arTziA+CFyAeIwjw1v605/5Yub+j/bugLaM8oEizxlyGPUAJHxkbFlXlVz2c/1Fl3Guv4u/POha73/jXpMQDARQGNuA2Qx0VO3gZY7Ql4KfNf3ojwH4g/UfVBnLXJyQLFrD/tEQAcg8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736866074; c=relaxed/simple;
	bh=n0gFWavEdTvtzvVwm6qJrQDd/tgnPw11Y8Zbx+7YwaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MfFmQpg0fMA59vXp4Sc+8CSBCJuj50JQvs5Fhc+6MsMZyBePXQ3X8QSwaCAxitQe9FeRpf0utmsDyOg7NWndW45quZltm+svksJEfSZKKjItc7U5oexcSyV3DpT/qROi2NrhJ+VR2pVrIMxVdhGMMfgvIhcocHBEKKmQ2lApZ2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F4WTnxxr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F4WTnxxr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736866071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=W1UWAgLlJaquYVVEeAD7AobVV/dxlnCJ6eG/I3yuA44=;
	b=F4WTnxxrRVt9a4mgGswp1GoxID99wDhJPdsRd/IVAUEyQB+2AtPs1gWh5R6xz7NSQ6oZJy
	OMcJ8OA6MtwUpNqog1/qupPCe+ZL5Q4x2jFLkyC5iq1Q6Ae5osKSo+qZi/H5Aw6uJj6M17
	eGOl7I5oHzVEWTCsnszbPlmH/PlRP3Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-Ec6geQYmOeClRtO6QrrkyA-1; Tue, 14 Jan 2025 09:47:50 -0500
X-MC-Unique: Ec6geQYmOeClRtO6QrrkyA-1
X-Mimecast-MFC-AGG-ID: Ec6geQYmOeClRtO6QrrkyA
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4362f893bfaso30509715e9.1
        for <nvdimm@lists.linux.dev>; Tue, 14 Jan 2025 06:47:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736866069; x=1737470869;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W1UWAgLlJaquYVVEeAD7AobVV/dxlnCJ6eG/I3yuA44=;
        b=pU5gs0TmRMCjuirOAGv6e0kHk7Fl0cWAi7tWlKr/scefotcAJUcPJham0ukYGzaS6I
         CimY7MaJmmORLU+301ecQj6r5XeFsF0bkZ1dIGkYHaqjV9rGqKHV+TDtk7CKL8fXcYFI
         VNGhp2LRFdHRMAJbeXkK7E7EZwnw6G7ckP/dh5RUqfNIeVOws6C+21bD3WBfISGTsB4e
         QeJy7vdcTkC6rQqqE/5bnjWfdjabQ5OwXA3PknO4XRjyn/5pRtK2G/UG1D2dvh5tOwfd
         M54g0G1WXJoFQiDoS9TmahmPQACewcbe5dAGRS+ZKA0EgqiSe/lNqepxT7fC1Kf9ofJQ
         RzAw==
X-Forwarded-Encrypted: i=1; AJvYcCWDJbVPxkY5F4bq9UDQ2kb4nXW77MHx2tDSVQ8cyLb+P7lPkDeviUr4H3g4TmxDAcldDvkUr7Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yww48lVWigBFWyF+rEjjVCkJ9nU261u7pweUykiS0007HHJdtmD
	RrwGAl9dJ39rIvgDGkWgfGEt7otqLWQ+P19FsmTZ6LfYUy/EzW7C862nugX4cHJ83pBrfhMrp82
	L/5jR3wO+2M3rYKrNgEnPQF84no9SrITF/ETqtonjveYqzyWk83gEbA==
X-Gm-Gg: ASbGnctU/ihYR0n1+uG9aS1urt5L5bhvYURrZor9L1IDJNU/PBieqrs0oeyqXUGS5Ab
	Pla4a+ijU7HrfN9L6v8qwyRdnMu5JZxJPg21oggur0fi11R8fjvqqWZWllmUB1UkzCROguoZv7R
	5hbcziPusu+wingolzT5LKc9EBzRedGtr6aES1gloPhyAisNzCZjAuZm7InGhrj81EPT4tjIw8Q
	VpU7zK5L5BeN02g1Hy5R9pMMcWi7+71rGm5kj66VUjsxpPrkVY7FlveslvQPi25Dx+rpmQU0ctz
	QIM3ErDX8p1Si2jSr6d1Qy7z+8LPKpYR6jlu3EzAzUcvZJeuk5v8SJM8w6w4DVU3rOWAaErMtsT
	ofrzGUhrZ
X-Received: by 2002:a05:600c:4fc2:b0:434:f3d8:62d0 with SMTP id 5b1f17b1804b1-436e26803f4mr219460725e9.3.1736866068923;
        Tue, 14 Jan 2025 06:47:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEENnT/QV/z/XX4uFBevKHkPxg7NffS9Usi3CNGFfMDEfqLcKcxnlPQgZ2KD/ykp7GZk9Grug==
X-Received: by 2002:a05:600c:4fc2:b0:434:f3d8:62d0 with SMTP id 5b1f17b1804b1-436e26803f4mr219459495e9.3.1736866067102;
        Tue, 14 Jan 2025 06:47:47 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4c1967sm14681312f8f.86.2025.01.14.06.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 06:47:45 -0800 (PST)
Message-ID: <f696d28c-c3a8-4500-98da-4ddcaa0db41f@redhat.com>
Date: Tue, 14 Jan 2025 15:47:44 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/26] fs/dax: Remove PAGE_MAPPING_DAX_SHARED mapping
 flag
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
 <b8b39849e171c120442963d3fd81c49a8f005bf0.1736488799.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <b8b39849e171c120442963d3fd81c49a8f005bf0.1736488799.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6Ibt2ohtMzVMQIo9Ulj1BEnDtdwysllfpbZdsHUiGD0_1736866069
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.01.25 07:00, Alistair Popple wrote:
> PAGE_MAPPING_DAX_SHARED is the same as PAGE_MAPPING_ANON. This isn't
> currently a problem because FS DAX pages are treated
> specially. However a future change will make FS DAX pages more like
> normal pages, so folio_test_anon() must not return true for a FS DAX
> page.

Yes, very nice to see PAGE_MAPPING_DAX_SHARED go!

-- 
Cheers,

David / dhildenb

