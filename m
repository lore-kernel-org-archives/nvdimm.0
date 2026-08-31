Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E6B351C27
	for <nvdimm@lists.linux.dev>; Mon, 31 Aug 2026 05:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788152571; cv=none; b=nSIV5PII/QJ8hXDrjg11V4VXJEF2hkAsVOC1GU/ZPHjjhO1HhvbgAdLYjkDZPjTAffMrrlD3cF6UEAe4k8MuOuB1n+NgvASy2yEqSwhM/aY8k07+ILSlzWZHn0O52sym2qsLCCMiXcWpmCkFr9Q0PjwgZlxIGaF+6YqFeh64rZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788152571; c=relaxed/simple;
	bh=+IoUalunk6EBcTh9xGk4fB9x0NW21q/3n3sKS5ELLS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luzfjVUWCzDcS2ZxFu6WI+a5Q9si79mVFFgEbbDK2sbT+rhRZrqvo9B66Kfd2pvf78LL53nWXL3fXTShQ1xIj8RUomGR7L5ddPk/+PlQfEwrD1/LJIIiyViCom3ueeVidq94sBS38U0OYrEQl72ekJAvpPFCBg+WA+tjyCWWrlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ItbaUzW7; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ItbaUzW7"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d6efd73032so33707065ad.0
        for <nvdimm@lists.linux.dev>; Sun, 30 Aug 2026 22:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788152570; x=1788757370; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l4KeYjahQ7mXCY2qiFTNky7ut0uCfsaiu5clA8xyfKA=;
        b=ItbaUzW74bwL7oA8wxsPR8u+liUiwIf+pleO9VtiGlnqE31/mrxDeUH2p6qx+udFTJ
         NILab/q9NsOwj73ChrO8c+kEtXj4pDWcWh1pHoDOJCR+NLGbykSQX0+pLa+2EqdgKGn1
         Q/lFsLTNDCKIV7qLoiJpxV57K+t7auX34VSV3nrY8ca1N8ZUnMczrIv6rDpiVFGhWeGO
         f3k9RHdsQLbq0MxHIb6pTSMqQQULQIOe0XL55rN8DV8dKPwcUCeKNAxjKL8GSD/N9F6N
         ZoASyFlO+7MdHsGD6ixffb+E1xKhQQGW+tVf0uawuxH20MCb0xJY4yMk86ykYzGmBlSC
         kaJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788152570; x=1788757370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l4KeYjahQ7mXCY2qiFTNky7ut0uCfsaiu5clA8xyfKA=;
        b=M86M0fLIGBg+z4C5tuP6mxJUsEeSOpj3C2c9eBw8WkIUV2wuwe3duBOUp4wCfs2Ksv
         s15LIrPqcfuxIGzoglBdjtbG/lk45t/kA5tuoZE3ZCz0BKtHMBRxdJrI0YM8r2/kZiA/
         zxelqMn6kVCxFJVj3ntVVUDOTBYWvBEeNlpRjSUW7HDlrNBGeJpCu2h3KGU7E7kvWFMc
         2vX7UKDZ4DU1gXWaLg4a6SVmcQ2h6hofHOx79D9AptSGC1g/GfDNAisTR/j9qNRjoYIt
         UidXzZ7t0sD75JMMiP3KaUDUoZ95xz1v2XZIfo+PIR7kRgPI0yqNuLcvy09bMrUtWyn8
         dpjQ==
X-Forwarded-Encrypted: i=1; AKwUvBzKfnlIcSoY41Nu6EaxiajhjCVHrk+tlGPEtssfPoizOOeSc+EwLtzpQ5sw7EbTHFpLV1/vhgE=@lists.linux.dev
X-Gm-Message-State: AFuF++kund/Ewa2YZjMd58hHmDKTMTiPEhlzwN7mGwfoxijQX6/nMlY1
	Z/JI9s40TEFezctq8wgB0cGF4N3wUsHccA6k2lOtxYsfgE8/f8j8OaVW
X-Gm-Gg: AYBFou2pW+mL7IZdDuMxFvuCpICbfaPAm+EP9XbkARpEQGru9aFNgi0Lrn6LMNNHFEA
	OVliryvWyJXkJnL9wut/v7alXiEUHqpbcrfPbXNo/DfZu5hNiyIlgukIUz9cwtWc6o7DP204nUO
	oddweeLjmXiVKQ/u6rZOquHXMF08w3JIsfy5Gx3cnB/nvfwmrlj/G14I/OKcTWsiyrA/zfoe6Ql
	2/ydpu3V/CCV7z9mpO2jJ077uGnZQxA6IRxYxGaJq5GlvFh+bNGrMQZ8O+0M9480NO2Zj9i7IbW
	9uHlrh/agHMcyuZ/nyM1LczMxM0xd/wy1dvVFCocJ98SOnNoC34K2u56DKad8MpsvBF9odJpuO0
	LvGxWC/cBrfTzLouX6YgvpnLHbCes2vbKfQosaxfRqjEZMK1h5WcI5/4AohNmo8zIaZHeqQqvab
	VmoB9P/HCbXWy/o/Ws46JzjPY/TC68FgaejBuKfsJyVhoLDMAVAny6sxYta4gWgXK2w1pvgK1MH
	12cCfpXvlE=
X-Received: by 2002:a17:90a:dfce:b0:369:7491:7b24 with SMTP id 98e67ed59e1d1-398da5e8899mr4849560a91.6.1788152569656;
        Sun, 30 Aug 2026 22:02:49 -0700 (PDT)
Received: from volcano9f8e-host.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0dc854dsm24897806c88.10.2026.08.30.22.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 22:02:49 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	iweiny@kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] nvdimm/pmem: Release gendisk on probe failure
Date: Mon, 31 Aug 2026 10:32:41 +0530
Message-ID: <20260831050241.1303288-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260831044508.520351F000E9@smtp.kernel.org>
References: <20260831043459.1298059-1-hemanth.selam@gmail.com> <20260831044508.520351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Aug 31, 2026 at 04:45:08AM +0000, sashiko-bot@kernel.org wrote:
> This isn't a bug introduced by this patch, but I wanted to ask about the error
> handling for alloc_dax() just below this code.
>
> In pmem_attach_disk(), if alloc_dax() fails with -EOPNOTSUPP, the code
> gracefully falls back and leaves pmem->dax_dev as NULL:
[...]
> However, the write_cache sysfs attribute remains unconditionally visible as long
> as CONFIG_ARCH_HAS_PMEM_API is enabled.

I do not think the two can meet.  alloc_dax() only returns -EOPNOTSUPP for

	if (ops && cpu_dcache_is_aliasing())
		return ERR_PTR(-EOPNOTSUPP);

so pmem->dax_dev is left NULL only on architectures whose data caches are
virtually aliased: csky, m68k, parisc and sh unconditionally, arm and mips
depending on the CPU.

write_cache is visible only when CONFIG_ARCH_HAS_PMEM_API is selected, and
that is arm64, powerpc, riscv and x86_64 (X86_64 only), none of which have
aliasing data caches.  So on every architecture where alloc_dax() can hand
back -EOPNOTSUPP, dax_visible() returns 0 for write_cache and there is
nothing to read.

Happy to be shown otherwise if there is a configuration I am missing, in
which case the fix belongs in dax_visible() rather than in this patch.

Hemanth
