Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB447279787
	for <nvdimm@lists.linux.dev>; Mon, 18 Aug 2025 06:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755500348; cv=none; b=UXljm0tA/Eroq9dJiqragjcHg4EqUmploFhnC18r0aDJiS8+dLWNfB75BYSqn6EszGC7zIQ2bCrV6Uuhe4nEIuCupBlZzDaXccyXF1haK2pLs24bAa1VyCUrj66nTmHYyZASLDwrZ0cyBqUBgBPPeCCDHNAb+aihD0cS9Q+BYUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755500348; c=relaxed/simple;
	bh=8ANVqQON5vFuvip7qPcrFXbCGuxWRaCvDHn+6/k6d80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ax2esS+JJPpCqy5uIONff0W4tn5egZ2u/e7kG8u0dd4NDPWXMQsj9SMkgeym8wWCHCylSU8AIHiOAQy6YyRhQ388GB4aZ0yU271Oa5zv+4ssYs9NDc2G7QX5DfoYMy51ybvBVx5eU8vwXwp9f52NylJurbV8/DgVcQGQkHZ/MSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LRCUF7pX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LRCUF7pX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755500345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tPhHppo9Id9H3Mf+xNXwTczb/fY9tmDFofhTHWpEmEI=;
	b=LRCUF7pX9oBGT+Cbdyw6S2hNEICrsJlS8hwR5s5YYZ74GAxy4RFnQKydbSdiY3H9yw6/b0
	a2uwfFlJMYtCwAYmzbiETxJj8DJqwlJGcNnrpLuA88N4rqLaZ0vh/H1yPWBJhtbgH4978U
	1XJGmP90jSJ2jejobUQLd64276p8md8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-hzsMaZU_MnSgexS0RmCVKQ-1; Mon, 18 Aug 2025 02:59:03 -0400
X-MC-Unique: hzsMaZU_MnSgexS0RmCVKQ-1
X-Mimecast-MFC-AGG-ID: hzsMaZU_MnSgexS0RmCVKQ_1755500343
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05a59cso18934315e9.1
        for <nvdimm@lists.linux.dev>; Sun, 17 Aug 2025 23:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755500342; x=1756105142;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tPhHppo9Id9H3Mf+xNXwTczb/fY9tmDFofhTHWpEmEI=;
        b=cqoh1rCC4r3oGcnNV26A/Pp28hvrE7w+ERq9IJtWzVlM7tCmWA4mZLp4nb8f/uEugZ
         ceOIjoPKCBE+XRMVnyW73qfZjzOAUG2Q0JIVZOIDgoxM3Bckd1tDu2BwRW60C5oicyfp
         Gl++MAoWs+4CXHz3EsuwZSuMN9gar8MNSQ/Hy8nwkZa6ad35z27zUtTLQzDnz6+ETKEN
         u7i7fIk2PWuI9JRAZWG8BWkKUNDGCrWJTyEW5VG3dOEV7HKhn/HWgtvpOY7BBOnUlUDh
         mRTWPFOagXGfQIM7L7FTK2imgYYq6lEm3XWZYRTINWAJ2Eh8EqYa0pb1s7kXCOYWfq8F
         dzlg==
X-Forwarded-Encrypted: i=1; AJvYcCUOoBRaeAjPbQSACJSVXRprivSUoC+2KMHvQTvdVmD0fh2btt1GY8cGBMs8/dNMLpIsxdwA8WM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWkG8D6PXMZk4id7IJcGWBzc/iMCszQzhs/q3Heb5A2hOHrwVS
	1ty3KlyiSq/0Sr/RXl2wzPLt5pMY/p0UYUG0HxlCadCU1o025TlZUvTxbWVzqUFfIUl5iRoFHZu
	BgPqqGkbQbSK0VYYiTK4bc143DbjDJoJt0sX/6QNe+q9E6X6B2P3MJ8TIlw==
X-Gm-Gg: ASbGnct4sWGAJmltViUK8klt8LeZkbD8XaCkTmMmu+HRSpNFm1GLMM1t5M7sWxVekhD
	4DN1H8JXQeqwRKUXXWL7V6DRCZmRoN4Ghs/wuKNjzFpNvkLNNmB63hcmDtobG8lzMjZxoMlgJVQ
	IJwqCMZjTkbCwFwdIvayLFBSBN6+woI9d+UJK9/CtoYOvMu8jzPiVn2CSLKi/14JF4UKaEZew7T
	92XitkrqektpV7Mati7rEkGv3KGnIvuCPvMnpjAE8Ssq2YWVqg2RgyKwwxJ+8zDUDAIjJ27BCrZ
	KrRhT7X7p4z+CslBl5vVpdw6xyzlHsImTSiO0i9Coat9q1/e8cO/kBz4DZ5xUD6WMwHWrrRSWmc
	iXV39BJVTa166V0HUnKb9+6XGrVTxlXPz02Hh7r/PQT/i3RVkPeV9BNu5tfMVFt2R
X-Received: by 2002:a05:600c:3b0e:b0:458:aed1:f82c with SMTP id 5b1f17b1804b1-45a21844ae1mr69168825e9.22.1755500342387;
        Sun, 17 Aug 2025 23:59:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRjJq0XIQ1oLnzV4tapEXxp+CDryL3RteLWPsUBJ810j9eh5EZSzNq0LPGyZErkVrGEekgEg==
X-Received: by 2002:a05:600c:3b0e:b0:458:aed1:f82c with SMTP id 5b1f17b1804b1-45a21844ae1mr69168235e9.22.1755500341938;
        Sun, 17 Aug 2025 23:59:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a72sm11554512f8f.34.2025.08.17.23.58.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Aug 2025 23:59:01 -0700 (PDT)
Message-ID: <d7cdb65d-c241-478c-aa01-bc1a5f188e4f@redhat.com>
Date: Mon, 18 Aug 2025 08:58:59 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/numa: Rename memory_add_physaddr_to_nid to
 memory_get_phys_to_nid
To: pratyush.brahma@oss.qualcomm.com,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Danilo Krummrich <dakr@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Alison Schofield <alison.schofield@intel.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Pankaj Gupta
 <pankaj.gupta.linux@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-acpi@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 xen-devel@lists.xenproject.org
References: <20250818-numa_memblks-v1-1-9eb29ade560a@oss.qualcomm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250818-numa_memblks-v1-1-9eb29ade560a@oss.qualcomm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PKOM6ORpo76G3xc1QT4llLPmLTRjqvB9qh-h7n4TXEM_1755500343
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.08.25 08:41, pratyush.brahma@oss.qualcomm.com wrote:
> From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> 
> The function `memory_add_physaddr_to_nid` seems a misnomer.
> It does not to "add" a physical address to a NID mapping,
> but rather it gets the NID associated with a given physical address.

You probably misunderstood what the function is used for: memory hotplug 
aka "memory_add".

This patch is making matters worse by stripping that detail, unfortunately.


-- 
Cheers

David / dhildenb

