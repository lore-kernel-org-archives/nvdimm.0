Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1385158B8
	for <nvdimm@lists.linux.dev>; Tue, 13 Oct 2026 16:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791908285; cv=none; b=U5jIQq51J4KyICNWLGMQ+BZ/TiL6Ti8fruOA/9xQ2KcIw3y++7aP5e2oklQQjSvdah5RZDuFU9y70yY37+SsHA07Eol6rwMePbr9ifAjhajjE7NxB7t9OrkpmsyqLL5N729Lj6Bkxb3JY9YGS0cZwm0IR+pRFfmb4MUqq1qzrOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791908285; c=relaxed/simple;
	bh=kwmzLEgEOyg6PcRq33bprrnPinvbL4+6gfEHwfl9+i0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OzRZc8Mo1JPxjbbXx1OW4f/yOcS1EDDRxrot+EnngIbqlYUXY9FGV1cIMbmdmNv9kh5NhRSm60do/0AV52A3eQk9myvoVHC+ZjdB9xdBocjIvQQOxb0LP3zR1byRgF1qmEpW1dqXs3KBqRUOPfQulZ3BNMr92EKSskkgoKMfPuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zhpo/Yfi; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zhpo/Yfi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791908283; x=1823444283;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kwmzLEgEOyg6PcRq33bprrnPinvbL4+6gfEHwfl9+i0=;
  b=Zhpo/YfiM+irR5I0Q86opA3sHns/aRY5+tegTmtm18NVNOQvmIcZ3M0i
   TG0DqvSvkukDswjMwmpdQht/oHK+vvTJo4UA1QFvxbVOYVFvmfr4fo2+b
   d47+U2quQ+I/4/puYcVHZIoxtEbrOIeMJk0seoNTqaL+PH2E6707bCR52
   RFcDpfqiv5HQxBYIujD+J4CrsY6dXj6f/5AZVt/lVqReICNVW53melSMg
   2sbMSH9IWbzR17HmK8bjjMm+qckhPb2lnlP1YEbljKRapIpOt9ORF30Bn
   72fj4vbMss7ydn+rwjVHJ85OtjkEnM+YMnzgj0XhcunUG+DNEv1Alk5+6
   w==;
X-CSE-ConnectionGUID: KAaQBN4ZR5iXjM6dBCxuPQ==
X-CSE-MsgGUID: zgY69olfSie/fdgjjP90Bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="643877"
X-IronPort-AV: E=Sophos;i="6.27,156,1787036400"; 
   d="scan'208";a="643877"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 09:18:03 -0700
X-CSE-ConnectionGUID: 3m4woNyYQL+NYMiOpLIn3Q==
X-CSE-MsgGUID: JBOJ20rJQ9e+KOPFoCnAVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,156,1787036400"; 
   d="scan'208";a="1270460"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.109.235]) ([10.125.109.235])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 09:18:01 -0700
Message-ID: <38cd2c79-00a9-477d-8595-18e1805a49fe@intel.com>
Date: Tue, 13 Oct 2026 09:18:00 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 0/8] DCD Prep Series
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Alison Schofield <alison.schofield@intel.com>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Ira Weiny <iweiny@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Fan Ni <nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Gregory Price <gourry@gourry.net>, Richard Cheng <icheng@nvidia.com>,
 Anisa Su <anisa.su@samsung.com>
References: <20261010225852.10727-1-anisa.su@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261010225852.10727-1-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/10/26 3:54 PM, Anisa Su wrote:
> These are the first eight patches of the Dynamic Capacity Device (DCD)
> series. They set up: DCD enumeration, CDAT handling for DC partitions,
> the event interrupt plumbing, a preparatory refactor, and
> documentation of the DPA partition layout. They stand alone and keep DCD
> disabled. They are not dependent on the rest of the series.
> Patch 1 detects the 48h command set and then leaves mds->dcd_supported
> false. The flag is only turned on by the series that adds DCD event
> handling, so every DCD specific path added here is shut off at runtime:
> cxl_configure_dcd() never runs, no DC partition is created, no DCD
> interrupt is armed, and the CXL_PARTMODE_DYNAMIC_RAM paths are
> unreachable. The intent is to land the enumeration and plumbing while
> the extent to DAX pipeline is still under review.
> 
> Based on v7.3-rc6
> v15: https://lore.kernel.org/linux-cxl/20261007201828.952-1-anisa.su@samsung.com/
> 
> v15 -> v16 Changes:
> ===================
> A quick respin:
> 
>  - Patch 2: cxl_configure_dcd() took Identify Total Capacity as the end
>    of static capacity, but Total Capacity is only required to be >=
>    ram + pmem. The static end now comes from the last static partition's end dpa
>    +1 instead of info->size. Check that DC starts from there. (Richard).
> 
>  - Patch 3: dsmas_entry.qos_class initialized as CXL_QOS_CLASS_INVALID, so a
>    DSMAS entry that is skipped for lack of DSLBIS, or whose QTG lookup
>    fails, no longer reaches update_perf_entry() with qos_class 0, which
>    is a valid class. (Sashiko).
>    
>    The DSMAD handle check now checks handle > U8_MAX instead of
>    handle & ~0xFF (Dave).
> 
>  - Patch 6: when the DCD vector cannot be requested, tell the device
>    not to use the vector: dcd_settings is cleared with
>    Set Event Interrupt Policy, so a device does not keep signalling a
>    vector with no handler while the
>    host considers DCD off.  The Set command is re-factored into a new helper
>    cxl_event_set_int_policy() (Richard).
>    
> All other patches are unchanged.
> I kept the review tags on patch 3, since the changes are minimal and
> dropped tags from 2 and 6.
> 
> Patch organization
> ==================
>  1-3: enumerate DCD command support, read the DC configuration, and pick
>       up DSMAS data for DC partitions.
>  4-6: split event msgnum configuration from irq setup, factor out the
>       interrupt policy check, then configure the DCD event interrupt.
>    7: preparatory refactor -- enforce partition order while collapsing
>       the ram/pmem specific partition helpers into one.
>    8: document the DPA partition layout the previous patches enforce,
>       and where Linux is stricter than the specification.
> 
> Testing
> =======
> This series leaves mds->dcd_supported false on purpose, so
> cxl_configure_dcd(), cxl_dev_dc_identify() and cxl_dc_check() are
> unreachable at runtime as posted. The tests below are done with the rest
> of the series on top, otherwise testing would not yield any meaningful
> results.
> 
> HW:
> Tested add and release of one 2G tagged extent on a DCD with a sharable
> partition, driven from the system's BMC with FM-API Initiate Dynamic
> Capacity Add / Release over MCTP, to confirm the DCD interrupt
> configuration and the DSMAS attributes are read properly. The device
> is sharable, so an add without a tag and sequence number is refused.
> 
> 
> cxl_test:
> ndctl cxl test suite
> 16 of 17 pass, cxl-features.sh skips for lack of FWCTL
> 
> Anisa Su (1):
>   Documentation/cxl: Document DPA partition layout and ordering rules
> 
> Ira Weiny (7):
>   cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
>   cxl/mem: Read dynamic capacity configuration from the device
>   cxl/cdat: Gather DSMAS data for DCD partitions
>   cxl/events: Split event msgnum configuration from irq setup
>   cxl/pci: Factor out interrupt policy check
>   cxl/mem: Configure dynamic capacity interrupts
>   cxl/core: Enforce partition order/simplify partition calls
> 
>  .../driver-api/cxl/linux/cxl-driver.rst       |  35 +++
>  Documentation/driver-api/cxl/maturity-map.rst |   4 +
>  drivers/cxl/core/cdat.c                       |  99 +++++-
>  drivers/cxl/core/hdm.c                        |  24 +-
>  drivers/cxl/core/mbox.c                       | 285 ++++++++++++++++++
>  drivers/cxl/core/memdev.c                     | 100 ++++--
>  drivers/cxl/cxl.h                             |  14 +-
>  drivers/cxl/cxlmem.h                          |  88 +++++-
>  drivers/cxl/mem.c                             |   2 +-
>  drivers/cxl/pci.c                             | 207 ++++++++++---
>  include/cxl/cxl.h                             |  29 +-
>  tools/testing/cxl/test/mem.c                  |   2 +-
>  12 files changed, 792 insertions(+), 97 deletions(-)
> 
> 
> base-commit: a90ee4305c4a5df72c11b31dacfdc76e00fcf78a

Applied to cxl/next
e4478834aa09
c801107605f3
9c45dd3684a5
726ac97330a4
f9c672229ca8
a7d2b5e9c4f5
b5d93fa1b7ac
13797539ae78

