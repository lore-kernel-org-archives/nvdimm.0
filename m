Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2041A1F461A
	for <nvdimm@lists.linux.dev>; Thu, 15 May 2025 23:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747350186; cv=none; b=K8bNQi/vyoFs+AMafzua1sICMA/9vn6WK7JZDE7kLj+JPeAU8cx/rxVyOz6UphZTYkGtHslIS3HQl1iJxlIIpa5OJYbdtytXK/HksBWuIb45iorChd3gfWneHBvac87aLn8b3EklWm7wBaB5HE1k01pGs+2P1/UESezOkE0AZ2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747350186; c=relaxed/simple;
	bh=2KrWgSdKGERWIa4me5l6ZvO0XYhQaJYeR6AwExPY5RM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=NJorzz41GOpnk2jkNACabCCRdjvj9QgNPCBCYVurqWKXOS3dLrXhESAXWQvIjBiHmO6tn0ABxwwJgmQ5K6lDYtCe9psAvBEmvBJsU/9acu+ncKGJiBEcaxkZDC6ohhOYIWhdkjF8oS0D+//MoTB8aLd249R7JUn473L8BVYEU/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQoxHo5k; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQoxHo5k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747350185; x=1778886185;
  h=message-id:date:mime-version:from:subject:to:cc:
   content-transfer-encoding;
  bh=2KrWgSdKGERWIa4me5l6ZvO0XYhQaJYeR6AwExPY5RM=;
  b=cQoxHo5kAh4PBZ6KHBxvXcdbU8FoXBjSxNZcE6itdbVyNAcQUezKYURD
   LRvqrKE9CdCoVOmvQ2lfSgfN/Dd/jfnGfg4ZHKzgeeFEaw2EShY/AtOgE
   M/DfE8XuLMRW4qnSG4zMSgaQQMGI57d9nzMKMyhaQg6te3W7tjEDdXFTI
   eoHLVnAGLuivGons4afomZik0aCqDELx6f0QXvXlaHELa3HHOnj2d6VB4
   KKfWumVJmirllQgjoA/8bU/ADsTG/rBkIp8Ph3NuPQXt7LQs1yn7iEMa/
   CIWRwjWP+AY5FqMZSys91lk/PJQmgIROFMZNCdRTJv5pp3lwHU1JTRy7U
   Q==;
X-CSE-ConnectionGUID: F/Jf7dPkQgqC+pmdhyf+AQ==
X-CSE-MsgGUID: fWnO2U0xTk6QbwuBba5vUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="60331347"
X-IronPort-AV: E=Sophos;i="6.15,292,1739865600"; 
   d="scan'208";a="60331347"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 16:03:04 -0700
X-CSE-ConnectionGUID: 5KEq+8GsRBmKfawggSz2zg==
X-CSE-MsgGUID: M7/1sCSCR/CrSOAy+XLiRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,292,1739865600"; 
   d="scan'208";a="139512626"
Received: from c02x38vbjhd2mac.jf.intel.com (HELO [10.54.75.26]) ([10.54.75.26])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 16:03:03 -0700
Message-ID: <aed71134-1029-4b88-ab20-8dfa527a7438@linux.intel.com>
Date: Thu, 15 May 2025 16:02:56 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Marc Herbert <Marc.Herbert@linux.intel.com>
Subject: List of CONFIG_s currently missing in ndctl.git/README.md
X-Mozilla-News-Host: news://news://nntp.lore.kernel.org:119
Content-Language: en-US
To: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Itaru Kitayama <itaru.kitayama@linux.dev>,
 "Verma, Vishal L" <vishal.l.verma@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


Thanks to the patience and help from the Intel people on these lists, I
think I finally found all the CONFIG_* missing in ndctl.git/README.md

I tested, fixed and published two CONFIG_ fragments here:

https://github.com/pmem/run_qemu/tree/main/.github/workflows/

- cxl-test.cfg:  CONFIG_ fragment enough for: meson test --suite=cxl
- nfit-test.cfg: CONFIG_ fragment enough for:
    meson test --suite=ndctl:ndctl and --suite=ndctl:dax

In my ideal world, these fragments would live in ndctl.git/ directly
(instead of run_qemu.git/) and ndctl.git/README.md would point at
them. This would make them _testable_ by any automation. Like this
automation: https://github.com/pmem/run_qemu/actions

As a second best and much quicker fix, "someone" could simply add to
ndctl.git/README.md the missing CONFIG_ found in these new .cfg files
of mine.

Unfortunately, that "someone" cannot be me because I don't know or don't
understand precisely what many of these CONFIG_s mean: the files in
https://github.com/pmem/run_qemu/tree/5723a592/.github/workflows/ come
from "educated" guesses and a lot of trial and error. But these fragments
pass the tests, so they're already much better than what is in the
current README.md!

I can already tell that some of these are tricky. For instance,
CONFIG_MEMORY_FAILURE=y is required for dax-ext4.sh and dax-xfs.sh to
trigger the error message "Sending SIGBUS due to hardware memory
corruption" (more context in
https://lore.kernel.org/nvdimm/20250515021730.1201996-3-marc.herbert@linux.intel.com/T/#u)

BUT, these tests can also pass without CONFIG_MEMORY_FAILURE=y and
without triggering that error message! So... CONFIG_MEMORY_FAILURE=y is
not required? Or, it is required but there a bug in that test? Or,
either choice is fine but CONFIG_MEMORY_FAILURE=y is better because
it provides more coverage? I don't have that sort of validation expertise
and it would take me a long time to learn it for every missing CONFIG_

Marc


PS: according to Dan, the test code in the kernel should also have more
build-time checks like the ones in nvdimm/config_check.c but that's not
mutually exclusive at all and IMHO a separate topic.
