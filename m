Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D22413E02B
	for <nvdimm@lists.linux.dev>; Wed, 11 Sep 2024 07:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726040884; cv=none; b=dsDpNkn7N3rbInIxaByYAfjCqGJYKOUW7st38n279tYLbNKWs+QA4i4+KAZx2/p0jSods7K/p2V3h4uRRlh8lYoalESkPD+tJtDfsEsEP8NGEo5GrWbPl27fCbIukJoRjZ/SEwqMVArT157ZDY8GK5iwgMIxXwnfZ1dyLorjF/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726040884; c=relaxed/simple;
	bh=dWI3Pd8hUNwX1F9lfw5/Q7Gvrg7f+xf+2lh6v/Vvvfc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=juiUvRUB4yWr7Pq5Z8ADFJW64RPhWJ2mxfBxtgeoOOzxBITwkZPWGtQw3HDIHNY95GnC/fjYF/naQLmuUVMrE6HSX7MUCYsslAAnodh7pw1k3d6ivgtcruFZJIcuzPD5ty2Hq7WsJPkPMzKc300HDr957PjEfsJhKGylp/trA1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TJ+T+WVK; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJ+T+WVK"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c0aa376e15so3127857a12.1
        for <nvdimm@lists.linux.dev>; Wed, 11 Sep 2024 00:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726040880; x=1726645680; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DAqoY6jIAjc3xzIZO9ujMSqjm0EX+JGfOEbTRNWh9ek=;
        b=TJ+T+WVKEL3h7hyEGSAm2eIF6vs1aCIBR3mM0BEI5jatvgAhr/Yg/pwqYdPxBooNzl
         guO6V4FxvOxTAcb8mdffyhYt22xV8r1VDNhi9rPYw01d0POquZYQaJl7bN47+XdyH5s2
         iA6esxCEpADMxZ/fWiaByl8Fehh1Ph9faKC/Y3w7iJgLvlgmSsS7yfcmjm/shLxH1uSl
         l/WdQid4PqclZDM3gvfR8xhqSTeNAZC/WaY+nsiJ0FgTPb9jUxib4bgjLAncgmB9gMW1
         Rx1qMx2X/Y5D9kAHqTGFpeEOnbVeLjeAHCNZB7w7mt/P3FMlM4bpRP9jz2IeEYrJ92ax
         ltcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726040880; x=1726645680;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DAqoY6jIAjc3xzIZO9ujMSqjm0EX+JGfOEbTRNWh9ek=;
        b=JDbkYXQ/J+0BHXdhSPYSh0YDAWKtJq+dqkORZSqJk/2fKj52ZkzwL+RrH9kzCeP6U9
         sanYGGUlMghdlYk5CiGVj9QXg30kwgfKNryOJdKtF8DLxDMwEC82Hkqt7PxypdXKPog1
         go5XkAwUvhX0Whjjvo4tDMMTSNG9XmaDL0QKW3owx6vFzRWGyvZWzIBXFtMyevypIrVU
         gTQmS8CsQ7nYWCatm1htT3oUvMi1X3i/6KNRenBnXkdLlUjY6MEOKhgX9UFcx6RB2ZYD
         lf/HEW7RC4EQE/rJkVsENr3BI7eD/Ahq+SPjTeZAQhzICef5h+k5sG5x4L2z36m0w8/m
         eldQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqVZnW1q0zdqTqBPDMhX0SeaprGppU0qDoWhuBS0BoRaB41Kz5TlzRr0MXKeXhnyHfMKF2vn8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxq9ONgycOimkTIvVymZgVw8DTqBKlMOi7xU1ZyrwQVg3tND4Yz
	KT7m85Yk5dPgUQYJOJAOFDBlFfR/fSf8qu98ooUunz9PL7HfZZpsWgZcOjCFPhilGP6u09dbfF6
	ADY0aCk/lEP9NtnCGW0J2yLIXNvY=
X-Google-Smtp-Source: AGHT+IFIM8V4DC0Z/5BWC5YRsJ9oRKTopRmw4RDrk2NBxBFwPDaaIWbAeLPw628HCYH5EvgpHLChk4iqxgrwnmbG4z4=
X-Received: by 2002:a05:6402:40d4:b0:5c3:d0e1:9f81 with SMTP id
 4fb4d7f45d1cf-5c3dc77ab97mr18285042a12.7.1726040879000; Wed, 11 Sep 2024
 00:47:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.9f0e45d52f5cff58807831b6b867084d0b14b61c.1725941415.git-series.apopple@nvidia.com>
 <39b1a78aa16ebe5db1c4b723e44fbdd217d302ac.1725941415.git-series.apopple@nvidia.com>
In-Reply-To: <39b1a78aa16ebe5db1c4b723e44fbdd217d302ac.1725941415.git-series.apopple@nvidia.com>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Wed, 11 Sep 2024 15:47:22 +0800
Message-ID: <CAOsKWHCEFSw6d7nC3A1Z4DKMNuUjirt-oULSr7hCWqT2GfnUDQ@mail.gmail.com>
Subject: Re: [PATCH 12/12] mm: Remove devmap related functions and page table bits
To: Alistair Popple <apopple@nvidia.com>
Cc: dan.j.williams@intel.com, linux-mm@kvack.org, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, logang@deltatee.com, bhelgaas@google.com, jack@suse.cz, 
	jgg@ziepe.ca, catalin.marinas@arm.com, will@kernel.org, mpe@ellerman.id.au, 
	npiggin@gmail.com, dave.hansen@linux.intel.com, ira.weiny@intel.com, 
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu, linmiaohe@huawei.com, 
	david@redhat.com, peterx@redhat.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jhubbard@nvidia.com, 
	hch@lst.de, david@fromorbit.com
Content-Type: text/plain; charset="UTF-8"

Hi Alistair,

On Tue, 10 Sept 2024 at 12:21, Alistair Popple <apopple@nvidia.com> wrote:
>
> Now that DAX and all other reference counts to ZONE_DEVICE pages are
> managed normally there is no need for the special devmap PTE/PMD/PUD
> page table bits. So drop all references to these, freeing up a
> software defined page table bit on architectures supporting it.
>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Acked-by: Will Deacon <will@kernel.org> # arm64
> ---
>  Documentation/mm/arch_pgtable_helpers.rst     |  6 +--
>  arch/arm64/Kconfig                            |  1 +-
>  arch/arm64/include/asm/pgtable-prot.h         |  1 +-
>  arch/arm64/include/asm/pgtable.h              | 24 +--------
>  arch/powerpc/Kconfig                          |  1 +-
>  arch/powerpc/include/asm/book3s/64/hash-4k.h  |  6 +--
>  arch/powerpc/include/asm/book3s/64/hash-64k.h |  7 +--
>  arch/powerpc/include/asm/book3s/64/pgtable.h  | 52 +------------------
>  arch/powerpc/include/asm/book3s/64/radix.h    | 14 +-----
>  arch/x86/Kconfig                              |  1 +-
>  arch/x86/include/asm/pgtable.h                | 50 +-----------------
>  arch/x86/include/asm/pgtable_types.h          |  5 +--

RISC-V's references also need to be cleanup, it simply can be done by
reverting the commit

216e04bf1e4d (riscv: mm: Add support for ZONE_DEVICE)

Thanks,
Chunyan

>  include/linux/mm.h                            |  7 +--
>  include/linux/pfn_t.h                         | 20 +-------
>  include/linux/pgtable.h                       | 19 +------
>  mm/Kconfig                                    |  4 +-
>  mm/debug_vm_pgtable.c                         | 59 +--------------------
>  mm/hmm.c                                      |  3 +-
>  18 files changed, 11 insertions(+), 269 deletions(-)
>
