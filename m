Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE602417E6
	for <nvdimm@lists.linux.dev>; Thu, 24 Jul 2025 22:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753395348; cv=none; b=Rv/PHOvUH+GAJuXfzavtbXOG67LIU+LpiQNCG+TCG/xeISt7iPcA5GRuRHjGgjeOaSP9DbaE/5N0G/2gPVaQfaRZfU0uWtLb7V8gML0gUOD5v/T4dmfYaiqIM5s7npZsn3ZUYL+8qBtjuZlBHiKHNz7eJrQAsQZUohJZBMezBLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753395348; c=relaxed/simple;
	bh=YkBVBmx38vNS10reLKqnpILoFPdtHUTfpRskrA3Jw3Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=T2rnaED4lr1nF4qQjLjGmyTUv84sKwGMewDVD1XTnNA5jSED5ZU5+YUSkh1J1+6AqyJUBEGP0G+ELiTOoypjSSQgWADFRPpNUEUbYNbCU2FOWp67jfWUiZFruI+4hzMz2KwX4X+IyS5hL3PZbm87fXSYVPUBSnL91slDxZ0F/D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hGNTSypW; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hGNTSypW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753395346; x=1784931346;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YkBVBmx38vNS10reLKqnpILoFPdtHUTfpRskrA3Jw3Y=;
  b=hGNTSypWQmQq2lM9X15CgFrsJN3swUjvMm7PNQ1CLtlOAbK9b8Oe4uOk
   dVXaTVdYTpZJtNAMQ58MiLbEjK2tAQZm5MW2RY/dieWR2zsH6SR1O/Hrt
   xUh8Oaf8w74YRaB3DSQ8FM00UWioHcliMAx+lndKrrcVgvfRleLRLT1Te
   QtD4fIdosqzBObbspdEaMlqfiD/QqiYQp4kAojZI8xkO6PWIAIbLIpHqx
   AExmuaKKqYeTE9sH3HxJkniaTyweUoOEMmkfH6wQClnhsVmO8mmCwanXN
   UHBjWwBvxQs1CmeTqxnKSQixirP0uprJp+PEBJY+0bDxlJI9V47uP51iG
   w==;
X-CSE-ConnectionGUID: bErOA/61TfKsRPkjwOZ/eQ==
X-CSE-MsgGUID: wKkQjP7gTBeIkXkV4G1kMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="54941623"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="54941623"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 15:15:46 -0700
X-CSE-ConnectionGUID: iPcI8j1tT7mXsDQWrXeEKw==
X-CSE-MsgGUID: w4R/drTpQ4GNOF7r7yQJ+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="160503408"
Received: from unknown (HELO hyperion.jf.intel.com) ([10.243.61.29])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 15:15:46 -0700
From: marc.herbert@linux.intel.com
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	alison.schofield@intel.com,
	dan.j.williams@intel.com,
	dave.jiang@intel.com
Subject: test/common: stop relying on bash $SECONDS in check_dmesg()
Date: Thu, 24 Jul 2025 22:00:43 +0000
Message-ID: <20250724221323.365191-1-marc.herbert@linux.intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As requested, this is the broken-down, first part of
  https://lore.kernel.org/linux-cxl/20250611235256.3866724-1-marc.herbert@linux.intel.com/
  test: fail on unexpected kernel error & warning, not just "Call Trace"

I will resubmit the rest after the review of this first part is
completed. The different parts are logically separate (different
"features") but they are interleaved in the same function and I don't
really have the time to fix one git conflict per review comment. 

While it is a requirement to catch warnings and errors later, the
better accuracy provided by this first part is useful alone. If you
are interested in what's next, just look at the bigger patch above.
You don't have to!

