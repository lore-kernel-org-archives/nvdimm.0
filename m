Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A161E5B7E
	for <nvdimm@lists.linux.dev>; Tue,  1 Apr 2025 09:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743500859; cv=none; b=a8FmgXnT3crOcD6R1FYDORAM1MeQHrorY4l4rV5cENbeeoYYz1ittR7ECeKj85CGuYROgx1ooWHFZ6dFCTfd0aDX6vyXkm+ps5J0k4oW1CnEGHJfTGb1lCngjMrVJ/yGO6+ExY0I0A2NTeYH8wgwhTCDKOIzE2uiu3QkkrvX5CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743500859; c=relaxed/simple;
	bh=/kEDlxs4pWmB9oX/fku3N5QHYUv8wV66SG9+ndFhA8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L+fHS26Kj0ifFrSAR+tYQQUKSFVteF3Ss/kiuz8EMVQLcpiBUbzebcnsdNEhAaN6HfFhDgHl9OA6rkA1f3sx9F1XhRoVz0rQsMy7XGXPac2rHWzDW1N1R2NocsmiaNxRer9IYJq8Rf6ehS5Vd8uIcl9Q7cXf6tII9Ud+KRYDjIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HAqJDUG0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HAqJDUG0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743500856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ADDlubXMad228XKT7ftPgPCt5gtgtinY6YissM6OgU4=;
	b=HAqJDUG0BFxX6CRj0VNTUCWR5Fj9G4t2ARuqtdKa98TbHnGmAu6qZ+tAH77SlXNb8862Og
	EGHUWMXSNgXE05D9zJRX+yCx3LVRRloYwNvhqv3S7hqAHX5Qfu7E4zjl/rdBYaxy4k5nce
	qGopIGwAggLUxI0LqW0TkWpn+lFtm6w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-BYjHYzUEPTuWMd74tFOLvA-1; Tue, 01 Apr 2025 05:47:35 -0400
X-MC-Unique: BYjHYzUEPTuWMd74tFOLvA-1
X-Mimecast-MFC-AGG-ID: BYjHYzUEPTuWMd74tFOLvA_1743500855
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d0830c3f7so44169835e9.2
        for <nvdimm@lists.linux.dev>; Tue, 01 Apr 2025 02:47:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743500854; x=1744105654;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ADDlubXMad228XKT7ftPgPCt5gtgtinY6YissM6OgU4=;
        b=gNYALURDBPQfyO8taRqVsEDLN6cl+3PlUq6KqALDv2Oi0gHBpNAYsi4PTDVhRB3lm/
         ioHFWuP25Sr7x6yYFaIvRhmFyo4MRKsQiTB/SIrVz6gtWxdWvUQUlJdO4FkTBX3sZtnl
         Q53ifGnn55V4Z/L4MEdabeGZ5EjSzKP6NGPrQpjBQ85UYVXZ915hzJ80CxsAsXugToCu
         /qXOBWvraM0UKVTQr7cb1h22vXCszxhFBaKpw1a5p79UEYc3PrV4qliyH+46EXBGehS3
         SDyd/dAUkXtWyxX2oPDAjkbnn9cUrEnAVokG+cmIHMElYaus6RKDizzkW3sX1DStiWxr
         bXqA==
X-Gm-Message-State: AOJu0YyP3SczKVwh8hve/f7yjw8strYf9Aou4hY0cCnIiNsF93dzvSZp
	vivsLjJJkSQ3oq/h3sdD4Xw8m47n1FPWZZ0bV3SJ6jtqanfW8ez0GF5UiWkth4mDyyqS8SvjnoP
	X/cv1jxs+7VrraczIpfdVMqACGufhdo6GKQfM8+S8IPevv62UWapQIg==
X-Gm-Gg: ASbGncv1EXZmK+07o+6hLSwtjQiQ6Mtiu2cNgJmzNHF1DozzhqN9wN0EOT8pAstT1sg
	4lgztFm6cJGRrOK6tkIV9bBGzFoZA/ueXtU1zTVUntxOzZXtyK5lDEwvCKHNlJ9hp31qjJkbopH
	kH1dafdHzsyKFozC4kyrZ4CCs4nWpVfWM01LXyXa1kkjEraX/S4rxECDuFAwTeDwHp6LFuyNhqY
	SRILATDXeoR7DAc16Y9REI3iCQnlvvqoqse3jy9PrN3aqpTToF8wgHzf8R4Jbxt7Muq0gTWMPzl
	faP2wvl6G/EvblH6smx7BmBKduPnRDozw7+EwBzCa8+0tOjhGA9VNkRGomHfVW6zC8tuqNrmok/
	iTjkmyM2WbpZljYZwpWv3OHhnnv+RJYr/2MbiJ11P
X-Received: by 2002:a05:600c:4715:b0:43c:ee3f:2c3 with SMTP id 5b1f17b1804b1-43db62274f4mr92304885e9.7.1743500854592;
        Tue, 01 Apr 2025 02:47:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHi3pJoCFP8+t9OEcAzrHTZEALh9nlhSaUL6YfefKUj+wsSgRQG8T/V7vs1PIYA4jslo+Pxqw==
X-Received: by 2002:a05:600c:4715:b0:43c:ee3f:2c3 with SMTP id 5b1f17b1804b1-43db62274f4mr92304635e9.7.1743500854131;
        Tue, 01 Apr 2025 02:47:34 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:4d00:6ac5:30d:1611:918f? (p200300cbc7074d006ac5030d1611918f.dip0.t-ipconnect.de. [2003:cb:c707:4d00:6ac5:30d:1611:918f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d8ff02e84sm150121975e9.32.2025.04.01.02.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 02:47:33 -0700 (PDT)
Message-ID: <88bce46e-a703-4935-b10e-638e33ea91b3@redhat.com>
Date: Tue, 1 Apr 2025 11:47:32 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] DAX: warn when kmem regions are truncated for memory
 block alignment.
To: Gregory Price <gourry@gourry.net>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com
References: <20250321180731.568460-1-gourry@gourry.net>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250321180731.568460-1-gourry@gourry.net>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zZ0jcRhGFS-8Rj8xX2PyU4W4BoF7e3uB0BSqWk3dxSs_1743500855
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.03.25 19:07, Gregory Price wrote:
> Device capacity intended for use as system ram should be aligned to the
> architecture-defined memory block size or that capacity will be silently
> truncated and capacity stranded.
> 
> As hotplug dax memory becomes more prevelant, the memory block size
> alignment becomes more important for platform and device vendors to
> pay attention to - so this truncation should not be silent.
> 
> This issue is particularly relevant for CXL Dynamic Capacity devices,
> whose capacity may arrive in spec-aligned but block-misaligned chunks.
> 
> Example:
>   [...] kmem dax0.0: dax region truncated 2684354560 bytes - alignment
>   [...] kmem dax1.0: dax region truncated 1610612736 bytes - alignment
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   drivers/dax/kmem.c | 18 ++++++++++++++----
>   1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index e97d47f42ee2..15b6807b703d 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -28,7 +28,8 @@ static const char *kmem_name;
>   /* Set if any memory will remain added when the driver will be unloaded. */
>   static bool any_hotremove_failed;
>   
> -static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
> +static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r,
> +			  unsigned long *truncated)
>   {
>   	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
>   	struct range *range = &dax_range->range;
> @@ -41,6 +42,9 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
>   		r->end = range->end;
>   		return -ENOSPC;
>   	}
> +
> +	if (truncated && (r->start != range->start || r->end != range->end))
> +		*truncated = (r->start - range->start) + (range->end - r->end);
>   	return 0;
>   }
>   
> @@ -75,6 +79,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>   	mhp_t mhp_flags;
>   	int numa_node;
>   	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
> +	unsigned long ttl_trunc = 0;
>   
>   	/*
>   	 * Ensure good NUMA information for the persistent memory.
> @@ -97,7 +102,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>   	for (i = 0; i < dev_dax->nr_range; i++) {
>   		struct range range;
>   
> -		rc = dax_kmem_range(dev_dax, i, &range);
> +		rc = dax_kmem_range(dev_dax, i, &range, NULL);
>   		if (rc) {
>   			dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
>   					i, range.start, range.end);
> @@ -130,8 +135,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>   	for (i = 0; i < dev_dax->nr_range; i++) {
>   		struct resource *res;
>   		struct range range;
> +		unsigned long truncated = 0;
>   
> -		rc = dax_kmem_range(dev_dax, i, &range);
> +		rc = dax_kmem_range(dev_dax, i, &range, &truncated);
>   		if (rc)
>   			continue;
>   
> @@ -180,8 +186,12 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>   				continue;
>   			goto err_request_mem;
>   		}
> +
> +		ttl_trunc += truncated;
>   		mapped++;
>   	}
> +	if (ttl_trunc)
> +		dev_warn(dev, "dax region truncated %ld bytes - alignment\n", ttl_trunc);
>   
>   	dev_set_drvdata(dev, data);
>   
> @@ -216,7 +226,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>   		struct range range;
>   		int rc;
>   
> -		rc = dax_kmem_range(dev_dax, i, &range);
> +		rc = dax_kmem_range(dev_dax, i, &range, NULL);
>   		if (rc)
>   			continue;
>   

Can't that be done a bit simpler?

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index e97d47f42ee2e..23a68ff809cdf 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -67,8 +67,8 @@ static void kmem_put_memory_types(void)
  
  static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
  {
+       unsigned long total_len = 0, orig_len = 0;
         struct device *dev = &dev_dax->dev;
-       unsigned long total_len = 0;
         struct dax_kmem_data *data;
         struct memory_dev_type *mtype;
         int i, rc, mapped = 0;
@@ -97,6 +97,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
         for (i = 0; i < dev_dax->nr_range; i++) {
                 struct range range;
  
+               orig_len += range_len(&dev_dax->ranges[i].range);
                 rc = dax_kmem_range(dev_dax, i, &range);
                 if (rc) {
                         dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
@@ -109,6 +110,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
         if (!total_len) {
                 dev_warn(dev, "rejecting DAX region without any memory after alignment\n");
                 return -EINVAL;
+       } else if (total_len != orig_len) {
+               dev_warn(dev, "DAX region truncated by %lu bytes due to alignment\n",
+                        orig_len - total_len);
         }
  
         init_node_memory_type(numa_node, mtype);


-- 
Cheers,

David / dhildenb

