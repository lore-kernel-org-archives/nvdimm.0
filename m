Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE26624
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 07:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686901624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5bYwqNSLrXJiQtrIMo72MYJh3QZB8KMtEIiq6QD74Q=;
	b=dJ3Jd/lRu5hWlJXXjkww20RhmabPGDliDcFGSYo75y9F9s2qQU68wFcPwmXCv1OyRsQ9vZ
	d+NpaWuQHGazyFjZlyfeDofHKMIId9CryAKZDZnRiUeOIn+gZrzxY4QqLSAe2EOF/N0liD
	Eebd8G1ZXMdvD6WoKuPt2eNgzDEx+Uw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-5DfWbyYjPP-R8bOA4fFbDQ-1; Fri, 16 Jun 2023 03:47:02 -0400
X-MC-Unique: 5DfWbyYjPP-R8bOA4fFbDQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f81f4a7596so1839885e9.1
        for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 00:47:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686901621; x=1689493621;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U5bYwqNSLrXJiQtrIMo72MYJh3QZB8KMtEIiq6QD74Q=;
        b=kuAur9IwsHTdTt5uIxp7da1g8Zrsm5KikIo+FXhgv0B0wumSM9snXqYylSVV57sSaa
         AIfWNoo9fWSKBSinWAZYF8x7dtUn8vEQ5zSjchb/veDBIQsd0jUVz8puNZ5KvPG2Z6vN
         M7iUrXhfHb2WJZmq9eWnpruD8JW/IJZ1Ad2sKIJfuq/40WgZSggznwFH/nypphgojgx3
         tx3W1Wa1z78vNaubPnH5Sj+LtI6B+nUAhQQHtiiANheu+PAcDscJHdwa9jDnkB0Ztjdg
         P/LqMs4fUjG1ZDhg6SzwtafDWUEn4tAya2x8u555wVpjkRfDIfKJbBDvkKVLknp4YEpa
         XksA==
X-Gm-Message-State: AC+VfDxjo0yCCS0FjkCPaAfH7pZujwKZPkWRgm2JCRYGUZwlRXS2FF2L
	zseEjNE+BiXl1GN6hP8Y9GSws0pXcDIzmVzc8eMFalqnCvStdJr4V1p3Z6m28wrNlMLRS9HcX9J
	E4Ppenfyov0HSCRDt
X-Received: by 2002:a7b:cd98:0:b0:3f6:766:f76f with SMTP id y24-20020a7bcd98000000b003f60766f76fmr925939wmj.36.1686901621068;
        Fri, 16 Jun 2023 00:47:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6FjFAGg0EAY/fN2yFOMKdsON/pGAcgKV47j+V2XrsGwOYGSddhs9zmuejwHx2MuQTEuN5LJg==
X-Received: by 2002:a7b:cd98:0:b0:3f6:766:f76f with SMTP id y24-20020a7bcd98000000b003f60766f76fmr925931wmj.36.1686901620728;
        Fri, 16 Jun 2023 00:47:00 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:9800:59ba:1006:9052:fb40? (p200300cbc707980059ba10069052fb40.dip0.t-ipconnect.de. [2003:cb:c707:9800:59ba:1006:9052:fb40])
        by smtp.gmail.com with ESMTPSA id d22-20020a1c7316000000b003f80946116dsm1356132wmb.45.2023.06.16.00.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 00:47:00 -0700 (PDT)
Message-ID: <0ea4728a-8601-bf75-1921-bcde0818aac3@redhat.com>
Date: Fri, 16 Jun 2023 09:46:59 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/3] mm/memory_hotplug: Allow an override for the
 memmap_on_memory param
To: Vishal Verma <vishal.l.verma@intel.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Dan Williams <dan.j.williams@intel.com>,
 Dave Jiang <dave.jiang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 Huang Ying <ying.huang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
References: <20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com>
 <20230613-vv-kmem_memmap-v1-1-f6de9c6af2c6@intel.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230613-vv-kmem_memmap-v1-1-f6de9c6af2c6@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.06.23 00:00, Vishal Verma wrote:
> For memory hotplug to consider MHP_MEMMAP_ON_MEMORY behavior, the
> 'memmap_on_memory' module parameter was a hard requirement.
> 
> In preparation for the dax/kmem driver to use memmap_on_memory
> semantics, arrange for the module parameter check to be bypassed via the
> appropriate mhp_flag.
> 
> Recall that the kmem driver could contribute huge amounts of hotplugged
> memory originating from special purposes devices such as CXL memory
> expanders. In some cases memmap_on_memory may be the /only/ way this new
> memory can be hotplugged. Hence it makes sense for kmem to have a way to
> force memmap_on_memory without depending on a module param, if all the
> other conditions for it are met.

Just let the admin configure it. After all, an admin is involved in 
configuring the dax/kmem device to begin with. If add_memory() fails you 
could give a useful hint to the admin.

-- 
Cheers,

David / dhildenb

