Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5CF181304
	for <nvdimm@lists.linux.dev>; Wed, 17 Jul 2024 14:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721226910; cv=none; b=lQHzry8p7XcGG1SW5DDm1Gv9IwB6z/mAQSqXMfwbq+Wyufe2gfJnddrsEnm5gkVkfNQ9LsJO63FH+u9EEr97XhLxsodpBYHH32YIjFyY/ZHX+MNVDaaHXnVR9ejmuGMa5+xYO+rURv5wyYbCsBpRChBZtnjLtBIvjId4F32uT8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721226910; c=relaxed/simple;
	bh=fnm4iemd7xvqFvDqI1KPJ1+UlIwFqVX26iV0ULfsN98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BY5xlm5TKypmwS/nQupMWuYEJO1TXPmPhhr1SC5PhRZW6jySmO7HA3Rn04M/qgM+O3c9ZU4MFQ5hKHwLrMZxJqQy1oOsXG2KEBaYOcXgnqjkfL4JmLet28GIXmq37Kbq7riAsoGO+tXeS4WvsbQvUv0ce4zaWzsDw9P3HS37HUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EFrtZZ9u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EFrtZZ9u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721226908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bQ+fqkZTCVbwQr6DwGYo0tiSadNAEaaTmdSJdfMrkK4=;
	b=EFrtZZ9uRQ3bQz04zsVwxGyTtkk+gFnh7jx5pSQPZlpa4IxnrwHPZfG7FA4EZFrHsyyPVW
	6rZV3RYIhSZBUEew5vkKLtu8Ol4kmxuv3sf/wGxjML4caQRKOvQL8ZO65BcDG5P0NPXUgj
	48gInLdPL1BirknFwUfhw1adchoj5lk=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-2SBksAKaNjO1GcCLmJbt5g-1; Wed, 17 Jul 2024 10:35:06 -0400
X-MC-Unique: 2SBksAKaNjO1GcCLmJbt5g-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-52e969d0198so7058185e87.2
        for <nvdimm@lists.linux.dev>; Wed, 17 Jul 2024 07:35:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721226905; x=1721831705;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bQ+fqkZTCVbwQr6DwGYo0tiSadNAEaaTmdSJdfMrkK4=;
        b=CbzYe5yTKcai7GyQUKqzHA8vn8jSmUbRj3tfsk3CDsZcM91qjede4gs56+cEUduqxJ
         CzLp9s5InlqIoe2FaWwA35GTrm3fjnLvyTGfPynm1tuy/xDDcW3kydzUf8RZYAppDyT5
         Fw4Ouzu40dpNHvjSFX5/81mgKCSWerh3xSqYSUK0a2EQ9bzPrJ/f9VdYPwP1R3c4O8PT
         1r9vzn335XL00IxAR234SvkvGO2QYpMjfudBf+pT5ZTWV9vsadH/HIYowx5wFw/cXYBK
         WGPneX6429OjprUqNKOvHgjFXvKmTfw+PLpMc/RILP0ZMALrSxO4/SZQlqlmI9uMCKYL
         192g==
X-Forwarded-Encrypted: i=1; AJvYcCVPq8UaJQo9LdkNmJzSQ+kD4nbWw2GSDshEsyE+UcBSoV7ye8pc+M8Q4Z5iIdvk0c0LYkuK1EROVy3KaQ5B6y3F7DD3Glrn
X-Gm-Message-State: AOJu0YxEfmwARCmEP6HsS2uT2cuQoUPA9gnumInmk1Y2r8hF/bxC0h9P
	OTMgIaCCmNND+xNOMgfqOvxVEN27eJ1KSQPJzmhg5T0zAUAcK/6vSlDedlgesfLHIqo4FjJjX2P
	kHBSRI/6XW4cI5mFpZqqOm/Lt/N2ublTMhjPxeLCVBNtKGy4iI38oSQ==
X-Received: by 2002:a05:6512:1316:b0:52e:a60e:3a04 with SMTP id 2adb3069b0e04-52ee542a129mr1866195e87.59.1721226905233;
        Wed, 17 Jul 2024 07:35:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH04Gq57875HpWPakTIyYyIvXlTOyNbE9pUtdgazlRW5m2Y5upStMZ+SEMfPLUpoxgxOiDOHQ==
X-Received: by 2002:a05:6512:1316:b0:52e:a60e:3a04 with SMTP id 2adb3069b0e04-52ee542a129mr1866156e87.59.1721226904762;
        Wed, 17 Jul 2024 07:35:04 -0700 (PDT)
Received: from ?IPV6:2003:cb:c714:c00:b08b:a871:ce99:dfde? (p200300cbc7140c00b08ba871ce99dfde.dip0.t-ipconnect.de. [2003:cb:c714:c00:b08b:a871:ce99:dfde])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427c779847asm301165e9.8.2024.07.17.07.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 07:35:04 -0700 (PDT)
Message-ID: <11c4ffb9-ea48-44d0-8a58-2c705c7176de@redhat.com>
Date: Wed, 17 Jul 2024 16:35:02 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/17] arch, mm: move definition of node_data to generic
 code
To: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dan Williams <dan.j.williams@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Palmer Dabbelt <palmer@dabbelt.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Rob Herring <robh@kernel.org>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 x86@kernel.org
References: <20240716111346.3676969-1-rppt@kernel.org>
 <20240716111346.3676969-5-rppt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240716111346.3676969-5-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.07.24 13:13, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Every architecture that supports NUMA defines node_data in the same way:
> 
> 	struct pglist_data *node_data[MAX_NUMNODES];
> 
> No reason to keep multiple copies of this definition and its forward
> declarations, especially when such forward declaration is the only thing
> in include/asm/mmzone.h for many architectures.
> 
> Add definition and declaration of node_data to generic code and drop
> architecture-specific versions.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   arch/arm64/include/asm/Kbuild                  |  1 +
>   arch/arm64/include/asm/mmzone.h                | 13 -------------
>   arch/arm64/include/asm/topology.h              |  1 +
>   arch/loongarch/include/asm/Kbuild              |  1 +
>   arch/loongarch/include/asm/mmzone.h            | 16 ----------------
>   arch/loongarch/include/asm/topology.h          |  1 +
>   arch/loongarch/kernel/numa.c                   |  3 ---
>   arch/mips/include/asm/mach-ip27/mmzone.h       |  4 ----
>   arch/mips/include/asm/mach-loongson64/mmzone.h |  4 ----
>   arch/mips/loongson64/numa.c                    |  2 --
>   arch/mips/sgi-ip27/ip27-memory.c               |  3 ---
>   arch/powerpc/include/asm/mmzone.h              |  6 ------
>   arch/powerpc/mm/numa.c                         |  2 --
>   arch/riscv/include/asm/Kbuild                  |  1 +
>   arch/riscv/include/asm/mmzone.h                | 13 -------------
>   arch/riscv/include/asm/topology.h              |  4 ++++
>   arch/s390/include/asm/Kbuild                   |  1 +
>   arch/s390/include/asm/mmzone.h                 | 17 -----------------
>   arch/s390/kernel/numa.c                        |  3 ---
>   arch/sh/include/asm/mmzone.h                   |  3 ---
>   arch/sh/mm/numa.c                              |  3 ---
>   arch/sparc/include/asm/mmzone.h                |  4 ----
>   arch/sparc/mm/init_64.c                        |  2 --
>   arch/x86/include/asm/Kbuild                    |  1 +
>   arch/x86/include/asm/mmzone.h                  |  6 ------
>   arch/x86/include/asm/mmzone_32.h               | 17 -----------------
>   arch/x86/include/asm/mmzone_64.h               | 18 ------------------
>   arch/x86/mm/numa.c                             |  3 ---
>   drivers/base/arch_numa.c                       |  2 --
>   include/asm-generic/mmzone.h                   |  5 +++++
>   include/linux/numa.h                           |  3 +++
>   mm/numa.c                                      |  3 +++
>   32 files changed, 22 insertions(+), 144 deletions(-)
>   delete mode 100644 arch/arm64/include/asm/mmzone.h
>   delete mode 100644 arch/loongarch/include/asm/mmzone.h
>   delete mode 100644 arch/riscv/include/asm/mmzone.h
>   delete mode 100644 arch/s390/include/asm/mmzone.h
>   delete mode 100644 arch/x86/include/asm/mmzone.h
>   delete mode 100644 arch/x86/include/asm/mmzone_32.h
>   delete mode 100644 arch/x86/include/asm/mmzone_64.h
>   create mode 100644 include/asm-generic/mmzone.h

Nice!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

