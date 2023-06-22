Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F9F168DC
	for <nvdimm@lists.linux.dev>; Thu, 22 Jun 2023 13:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687442145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p6G7WiAZOcQ9lIcGNb7i76CvK3NP16OpxiaWi+YzEms=;
	b=eykX3TcPt8nSqIq4RLEinznRc9OzrVsVCS6WJJigYRJO+LVBP8R1VzcNfPYheO5mb7jHon
	zd5O0Yv7o8kGfEo8zkyqLww6KJBhgjWnG3hikuJ4s75qKiERWw4MhmdzN+LzRQhcWo+Hs+
	dkJH5uMwuConuOqG2dR7DUB2LMlsV6Q=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-kGIuid5kO_ubC2N9k-gP1w-1; Thu, 22 Jun 2023 09:55:43 -0400
X-MC-Unique: kGIuid5kO_ubC2N9k-gP1w-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4f624a4ea72so5206258e87.2
        for <nvdimm@lists.linux.dev>; Thu, 22 Jun 2023 06:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687442141; x=1690034141;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p6G7WiAZOcQ9lIcGNb7i76CvK3NP16OpxiaWi+YzEms=;
        b=h3HAGBJibTVMyq5VocWVDDYQzHCZORKpSvqKKOhhQ2hZSoMn1ekC7l5Pas/v7RZ2rx
         Yze1iehQsrk1ttuM29uIJ0at1GoVBhcp3t960nmGUIUrC7vKW+ebYsCMxqTG7hkzafmV
         Rejz5TPv2GQ5ST6SFvRfUb3hTU9N6re4IPBWkjw2Kdc03ByS1UqVABo2F0fjA5HZ6FEQ
         ePMM8U4kZ1RsAfOi2ixeNYLZOTck8peT2Oy6I2Iw9PGStXgDu+tmlRzHjHM83wW04crs
         3r+EPHFxD7CwakxEL2Vts1r/jo/AWRWid5m7tKm0AdDYWqab/9/1cUXS75dcQMUxW+7L
         p72g==
X-Gm-Message-State: AC+VfDy75Uq6u10QB25aT1XkwtE1BxteX470oId5OzMjD34Huwr9C9LX
	9crLHWVY9m4AtnLepqxyhg1ZiRbZ5DLqFEmBAbcwMpi9bGZq6LyG9hBIEJQ39hSniHUrPQ7l6o/
	koJWeXMx11Gu8Q1WV
X-Received: by 2002:a05:6512:2e7:b0:4f8:71ca:bb15 with SMTP id m7-20020a05651202e700b004f871cabb15mr9177799lfq.48.1687442141565;
        Thu, 22 Jun 2023 06:55:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4B3PJA6vAcVuODvAd1+uWbP6euZQ43Yz3zVopBeuZdQAZiCsBeOr4t+6/ZZr44BUky2qiISA==
X-Received: by 2002:a05:6512:2e7:b0:4f8:71ca:bb15 with SMTP id m7-20020a05651202e700b004f871cabb15mr9177762lfq.48.1687442140970;
        Thu, 22 Jun 2023 06:55:40 -0700 (PDT)
Received: from [192.168.3.108] (p4ff23922.dip0.t-ipconnect.de. [79.242.57.34])
        by smtp.gmail.com with ESMTPSA id z5-20020a1c4c05000000b003fa78d1055esm399654wmf.21.2023.06.22.06.55.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jun 2023 06:55:40 -0700 (PDT)
Message-ID: <39fe2152-c4fc-6b8e-90e8-1060234a1943@redhat.com>
Date: Thu, 22 Jun 2023 15:55:38 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 0/3] mm: use memmap_on_memory semantics for dax/kmem
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "osalvador@suse.de" <osalvador@suse.de>, "Jiang, Dave"
 <dave.jiang@intel.com>, "rafael@kernel.org" <rafael@kernel.org>,
 "lenb@kernel.org" <lenb@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "Huang, Ying" <ying.huang@intel.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
References: <20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com>
 <29c9b998-f453-59f2-5084-9b4482b489cf@redhat.com>
 <b61a9efdff30fbff9477369ded05d133e0de7335.camel@intel.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <b61a9efdff30fbff9477369ded05d133e0de7335.camel@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.06.23 21:32, Verma, Vishal L wrote:
> On Fri, 2023-06-16 at 09:44 +0200, David Hildenbrand wrote:
>> On 16.06.23 00:00, Vishal Verma wrote:
>>> The dax/kmem driver can potentially hot-add large amounts of memory
>>> originating from CXL memory expanders, or NVDIMMs, or other 'device
>>> memories'. There is a chance there isn't enough regular system memory
>>> available to fit ythe memmap for this new memory. It's therefore
>>> desirable, if all other conditions are met, for the kmem managed memory
>>> to place its memmap on the newly added memory itself.
>>>
>>> Arrange for this by first allowing for a module parameter override for
>>> the mhp_supports_memmap_on_memory() test using a flag, adjusting the
>>> only other caller of this interface in dirvers/acpi/acpi_memoryhotplug.c,
>>> exporting the symbol so it can be called by kmem.c, and finally changing
>>> the kmem driver to add_memory() in chunks of memory_block_size_bytes().
>>
>> 1) Why is the override a requirement here? Just let the admin configure
>> it then then add conditional support for kmem.
> 
> Configure it in the current way using the module parameter to
> memory_hotplug? The whole module param check feels a bit awkward,
> especially since memory_hotplug is builtin, the only way to supply the
> param is on the kernel command line as opposed to a modprobe config.

Yes, and that's nothing special. Runtime toggling is not implemented.

> 
> The goal with extending mhp_supports_memmap_on_memory() to check for
> support with or without consideration for the module param is that it
> makes it a bit more flexible for callers like kmem.

Not convinced yet that the global parameter should be bypassed TBH. And 
if so, this should be a separate patch on top that is completely 
optional for the remainder of the series.


In any case, there has to be some admin control over that, because

1) You usually don't want vmemmap on potentially slow memory
2) Using memmap-on-memory prohibits gigantic pages from forming on that 
memory (when runtime-allocating them).

So "just doing that" without any config knob is problematic.

-- 
Cheers,

David / dhildenb

