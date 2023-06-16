Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5AC624
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 07:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686901495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wHh80tHevfpfGpsYLMJr0xWQFhLc1pRS6PbFj4Uk1xM=;
	b=drFc/Zch9l9sUv5vXMu0WMzWJSZczsSP3P1R3fPg3u+ijB4VHi5pKJFrbUcZjxbJyepX4N
	oiJsLU3ZlNwyP7HWYh3HkL3/tGZ5h2WMZ89D+CqQM+JBcGSTE1ohHRyvJWariNWEAGLuMV
	mWON2sxe8/0IgV7SBoPIxCA8RXHwy/w=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-CXAhE1w2OsyaSqvZN8s6qA-1; Fri, 16 Jun 2023 03:44:54 -0400
X-MC-Unique: CXAhE1w2OsyaSqvZN8s6qA-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4edc7406cbaso297356e87.2
        for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 00:44:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686901493; x=1689493493;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :content-language:references:cc:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wHh80tHevfpfGpsYLMJr0xWQFhLc1pRS6PbFj4Uk1xM=;
        b=VdNoWfYkPj0mJBki4twSf3YhHrlTN9mRKBn+zfRCdlc67jpkT8rjfUPw9jnRrZkeWp
         Vq9fID9KXiAm3/NCfCiyaoPvauBU+p0IWPUrpR8ABwG69WIbDY7lQ8idw75YdcS+rHvX
         6xbE3RiTt9pdyRE8sFs2LlvFCLw0M9KENcfpq3O+kuwVGvtwBApLtYdE8IwrynqIQALy
         G7cSyndgdKq7HchbTXOOFL4wUxp9AMGi1JKZEX4H/2O41jaMSxJeJCmQIN49Wya80D0n
         mpDK0OTWhe4HF/8eb9RTQkSzlWmd0jGjIAcCV3vd2CJe4qQDLvnIlnI6NfEOQqBE9zmc
         zqkA==
X-Gm-Message-State: AC+VfDxuvNzUIzK+qYwO3esOdbfTp3+rYndY0BRTDMxhxeDOMzqC+hgs
	BmuSWBxdgEBxgPnEk0kAU65sTWfR2BnQUQ/djELU5hdIrQW84ZSzcSipp3l24Tmv1ve+TsAiyOU
	xdFnL5IP0hOD0vbCp
X-Received: by 2002:ac2:4d93:0:b0:4f8:4961:7610 with SMTP id g19-20020ac24d93000000b004f849617610mr755640lfe.43.1686901492815;
        Fri, 16 Jun 2023 00:44:52 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4V2KwN13A0iu+AAg7e0iRwh6yMnxJrHrSMfwNZ/+rksVbEc+zvz9ZHK23cYpe/zyiH2IoeHg==
X-Received: by 2002:ac2:4d93:0:b0:4f8:4961:7610 with SMTP id g19-20020ac24d93000000b004f849617610mr755629lfe.43.1686901492450;
        Fri, 16 Jun 2023 00:44:52 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:9800:59ba:1006:9052:fb40? (p200300cbc707980059ba10069052fb40.dip0.t-ipconnect.de. [2003:cb:c707:9800:59ba:1006:9052:fb40])
        by smtp.gmail.com with ESMTPSA id q3-20020adff503000000b002ca864b807csm22936582wro.0.2023.06.16.00.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 00:44:52 -0700 (PDT)
Message-ID: <29c9b998-f453-59f2-5084-9b4482b489cf@redhat.com>
Date: Fri, 16 Jun 2023 09:44:50 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To: Vishal Verma <vishal.l.verma@intel.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Dan Williams <dan.j.williams@intel.com>,
 Dave Jiang <dave.jiang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 Huang Ying <ying.huang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
References: <20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH 0/3] mm: use memmap_on_memory semantics for dax/kmem
In-Reply-To: <20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.06.23 00:00, Vishal Verma wrote:
> The dax/kmem driver can potentially hot-add large amounts of memory
> originating from CXL memory expanders, or NVDIMMs, or other 'device
> memories'. There is a chance there isn't enough regular system memory
> available to fit ythe memmap for this new memory. It's therefore
> desirable, if all other conditions are met, for the kmem managed memory
> to place its memmap on the newly added memory itself.
> 
> Arrange for this by first allowing for a module parameter override for
> the mhp_supports_memmap_on_memory() test using a flag, adjusting the
> only other caller of this interface in dirvers/acpi/acpi_memoryhotplug.c,
> exporting the symbol so it can be called by kmem.c, and finally changing
> the kmem driver to add_memory() in chunks of memory_block_size_bytes().

1) Why is the override a requirement here? Just let the admin configure 
it then then add conditional support for kmem.

2) I recall that there are cases where we don't want the memmap to land 
on slow memory (which online_movable would achieve). Just imagine the 
slow PMEM case. So this might need another configuration knob on the 
kmem side.


I recall some discussions on doing that chunk handling internally (so 
kmem can just perform one add_memory() and we'd split that up internally).

-- 
Cheers,

David / dhildenb

