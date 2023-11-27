Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41FF1A27A
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 11:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="O8kHKP+c"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-50a6ff9881fso6246533e87.1
        for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 03:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701085937; x=1701690737; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UDO7ncvXAATevhwT++kqK1bgvPT8hD/xVk4r8C8v3oU=;
        b=O8kHKP+c5te8179UggzD/dlN8J+y5FV+opLGowcv4bTcsJ+ivE4kiFzEz/zJemGt8x
         YXOz5ZDZ+n0nS5tt/cTePF89QdGaK94+AJWN2dPuSvb9yuszRyls+U8jH5Dlb4z6cvTu
         1TyI5nMesO9oUjQTyf2SrUvzBmkSs8IO/0Cud+Vi6S2YKoOXMzZfC5ubs//XCRYQvEMX
         /zAy7h3F1l8RooycVLuW9tAYRZfPPVrV3RDATL9verhFY3OEI7bf63DoEMsbK96ppQnu
         iXizacccDTeTwpyl1vtjnWZKWaXhzJnUHVRU8A8fhR2mxNogkWnXlogtFtgq9qcxBzhY
         GIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701085937; x=1701690737;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UDO7ncvXAATevhwT++kqK1bgvPT8hD/xVk4r8C8v3oU=;
        b=C7MNzcClIqra79hX3Sy3+n6zFf9wr8rakQQacps91cENWgBazN3/uTlKhD2mvRtKdB
         +RWBsVo6ce71frTPwPraERbyGMxMVdXRgKeGuznNdukia6l3+Q0k8O47EMnC3/NIpca5
         +lpkovM7NkWm6PVTAE1XYD4N8C2ntk/gJxUM5P2yPkFl7bQxX01dWT74Afhr+E76Pu5d
         swt70RJBqTrQ7TdFx0LSNic/ULQzA86MTKJdfaEzzanAoQO6ZA8juE+SGrd5BzZEJA0s
         /A/3Ey2ALOm2fpTg0V/idTgYR06oKQRaScinw0ofzRNd6xs7EfBuKWhA7RBqDZGReMyz
         yXqA==
X-Gm-Message-State: AOJu0YxByZYFycGXYZtQ7VXPtw0XMxMscBU5yqU9lbu0hnmfzg2z5o9l
	c2dQVobMhhyREjw2RM5rsVQu1g==
X-Google-Smtp-Source: AGHT+IH4TrdNMPzblGZNP+ycO68tEu2jCSB6jgINc1mAPjd3KiDZt90uG7xK9DQ2U8O9Q0zTqoOViQ==
X-Received: by 2002:a05:6512:2244:b0:50b:a68e:9541 with SMTP id i4-20020a056512224400b0050ba68e9541mr8023149lfu.23.1701085936674;
        Mon, 27 Nov 2023 03:52:16 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b5c7:0:e8f2:79b9:236a:4d41? ([2a02:6b6a:b5c7:0:e8f2:79b9:236a:4d41])
        by smtp.gmail.com with ESMTPSA id r7-20020a05600c35c700b0040b30be6244sm13673021wmq.24.2023.11.27.03.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Nov 2023 03:52:16 -0800 (PST)
Message-ID: <9867cf7b-29a1-4fc7-61b0-7212268f9d50@bytedance.com>
Date: Mon, 27 Nov 2023 11:52:15 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: Conditions for FOLL_LONGTERM mapping in fsdax
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
 nvdimm@lists.linux.dev, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 Fam Zheng <fam.zheng@bytedance.com>,
 "liangma@liangbit.com" <liangma@liangbit.com>
References: <172ab047-0dc7-1704-5f30-ec7cd3632e09@bytedance.com>
 <454dbfa1-2120-1e40-2582-d661203decca@bytedance.com>
 <a0d67f2d-f66b-8873-7c11-31d90aae8e8c@bytedance.com>
 <ZVw2CYKcZgjmHPXk@infradead.org>
From: Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <ZVw2CYKcZgjmHPXk@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 21/11/2023 04:46, Christoph Hellwig wrote:
> We don't have any way to recall the LONGTERM mappings, so we can't
> support them on DAX for now.
> 

By recall do you mean put the LONGTERM pages back? If I removed the 
check in check_vma and allowed the mappings to happen in fsdax, I can 
see that the mappings unmap/unpin in vfio_iommu_type1_unmap_dma later on 
which eventually ends up calling put_pfn.

Thanks
