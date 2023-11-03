Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4AA1C6A8
	for <nvdimm@lists.linux.dev>; Fri,  3 Nov 2023 16:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K3Na7nYL"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1cc316ccc38so23775365ad.1
        for <nvdimm@lists.linux.dev>; Fri, 03 Nov 2023 09:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699028788; x=1699633588; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6RxeQm4cmA2JrbAVa8HTs83GsMijucDFIF/Igdee3yE=;
        b=K3Na7nYLOPjDHHnJPSxlRb0bm4EPQSf1Vwb//HbVTSoBNt1E3RcKE+EAaoINfoeBcm
         dxKRTEignsPwVeYZHSdUK2mxjNQTWqYOto7PY2pfQ5FNLdjd+dMBCCOXGZ1obsJmZk0T
         Dgw5FGWmjsjdLChbY32RkoR7wfb2CS2KgBJyUNx4FM3xh5aZb0JWVKf5TIS8AkGWJg3P
         QJy9NJB9J1tpqr/8507OUUDZvtJa6bxfgLhcNSnYlgTnZTo9r03DOY8JqGK4sAt8nz2d
         QaDXu1dCaxn6UHfxxj9oMXxDAQe2/IGpJn8U7updd6vBlqU0TbBR8NP5jqXbGxL3oSp5
         NchQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699028788; x=1699633588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6RxeQm4cmA2JrbAVa8HTs83GsMijucDFIF/Igdee3yE=;
        b=fQmfgyk6OixOm1O9Rhg4CCqMWrmlV9qSbwpi+2Lfugw3Rujvp4+I+W/uiRWJX0R99F
         Ta8DDXVVUOODKo3ekKvocGj/sJZq2F8+J5C4mHWmtFX8Dqz59NY/v7SCP9nPTG+JAZGo
         o1T1a/VntLfb+8ETqm8kEftcw4aVHXN3zmq5W73mF7Cu3FUP4dvIFP9+BQDxcPJCgZcu
         0jlWXEPAu6+cELoo7WXrL85ZdED/EOOvgAMVuIkhCmyS1Wu4VKfr/JB7LWKpjgk1Xzks
         P0k7QXNTeZ43vSj1gl0uzhPujYsLeCPABmATti53WksrTSm28hllVbgw214l3Irs2RGi
         NBIw==
X-Gm-Message-State: AOJu0Yzq6no6BGt3XbcpzO99tVrrYuZCFIQBbjoNote2PUTZQCLafvN7
	6s7R+8MFfLhhllCM9m2eW9A=
X-Google-Smtp-Source: AGHT+IH+UfkDk1M09a11MgKdQ/HzVeEoAf8yilhUhOvIPnSu6kULsuDKgmMoS0l4cwRyk9qiS6Zxpw==
X-Received: by 2002:a17:902:f551:b0:1cc:5b2a:2f33 with SMTP id h17-20020a170902f55100b001cc5b2a2f33mr14887406plf.43.1699028787560;
        Fri, 03 Nov 2023 09:26:27 -0700 (PDT)
Received: from debian (c-71-202-158-162.hsd1.ca.comcast.net. [71.202.158.162])
        by smtp.gmail.com with ESMTPSA id p22-20020a170902b09600b001b8a3e2c241sm1609244plr.14.2023.11.03.09.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Nov 2023 09:26:27 -0700 (PDT)
From: fan <nifan.cxl@gmail.com>
X-Google-Original-From: fan <fan@debian>
Date: Fri, 3 Nov 2023 09:26:06 -0700
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v8 1/3] mm/memory_hotplug: replace an open-coded
 kmemdup() in add_memory_resource()
Message-ID: <ZUUfHqaGGxjYc0wH@debian>
References: <20231101-vv-kmem_memmap-v8-0-5e4a83331388@intel.com>
 <20231101-vv-kmem_memmap-v8-1-5e4a83331388@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231101-vv-kmem_memmap-v8-1-5e4a83331388@intel.com>

On Wed, Nov 01, 2023 at 04:51:51PM -0600, Vishal Verma wrote:
> A review of the memmap_on_memory modifications to add_memory_resource()
> revealed an instance of an open-coded kmemdup(). Replace it with
> kmemdup().
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---

Reviewed-by: Fan Ni <fan.ni@samsung.com>

>  mm/memory_hotplug.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index f8d3e7427e32..6be7de9efa55 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1439,11 +1439,11 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
>  		if (mhp_supports_memmap_on_memory(size)) {
>  			mhp_altmap.free = memory_block_memmap_on_memory_pages();
> -			params.altmap = kmalloc(sizeof(struct vmem_altmap), GFP_KERNEL);
> +			params.altmap = kmemdup(&mhp_altmap,
> +						sizeof(struct vmem_altmap),
> +						GFP_KERNEL);
>  			if (!params.altmap)
>  				goto error;
> -
> -			memcpy(params.altmap, &mhp_altmap, sizeof(mhp_altmap));
>  		}
>  		/* fallback to not using altmap  */
>  	}
> 
> -- 
> 2.41.0
> 
