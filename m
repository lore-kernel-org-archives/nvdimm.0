Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931161;
	b=rimiMIos/0lBnExIuifr52yb83pMuWY51sxz7EbFEoSpOFeD44FMefBPX5ouhQEZVmVI
	 SOGXkcEIiL1r1AmR6di01WofjZqDq9gpDHD3dFIApdq92VYQOMjH0KE9/2kaeKnIce53y
	 wu9aBqTZqHyUsCxmAEpBI4zvZC2/bDDY4wiDw018eUOGVywcw2Zzs9PlmXcSYvKheZtTh
	 B1iWQ5+2/Ib1pIiqP13VZMZ9WbhbkZNu51NlrRq6eQVc+GGtijRb4fgo3y9PlRr6eBr7+
	 bjpmTJEyInRO5/1I6g1YGQ2nweqlOOym+T/5tbIXL7JinrcWCOI29Ul/BmYzmNPzZJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931161;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=h/3rF4Eul2ZUedOC6ysniY/GPouHi/AlQBH3kKs+gsU=;
	b=UskHKV+VnsZmDmkt2surlkY+SQIz5gdImLpBwWx7TJ7Aj3ANovWkDG9BmslHFlVWbPIs
	 J7kDvVpcdCx7DSeXWMOsXqNt+r66qPIbqONfkv0bdQnNaP046aaZ1ZMrhrWlf1SyXA8qe
	 iBjpsKEoRuVKePfEkC3vT/4dUaCImf04vPwQhgXsuCmeuER5OerVwyrL3nE56xB0eiJhd
	 F2hmlLF3KSbcDXtaYQsU2G+9th2OHFJQ5HPkWa56e2W2I5zZzvGhx8jExmZ4zLFK9SOv6
	 qQUC8ibrUY7x8d0L6BUDhTJO/qprMJsVGJa9702Fi8MEO/qwzLRtem5HjbmsTc+CzIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gQhrWKfl;
	arc=none smtp.remote-ip=198.175.65.10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13089606A334
	for <nvdimm@lists.linux.dev>; Tue, 17 Nov 2026 15:59:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13089606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gQhrWKfl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794931161; x=1826467161;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=ogO0mTz2AgaJsonmWpeYAFiZBu7kzIrrb/QfEOJdD04=;
  b=gQhrWKflq+V/fS9kOmsJsBXjvnbkXbXTbVV8Edy7QaiNNjL+OUiPt2u2
   zwuOp0jv2CxGW8+AQDlrPSiknZQZUhdZpN4wN5UY7FFBahMPdfKp5M6qK
   smXMVr1Fx09ZHRXHO3Mc6Lu/8B33Hd0dbhIO1St/pYmDarz62g7+ot0az
   3plaMCD5yZZhKvqaoZ7WpJX+9zNedikxsxy8IdIZZdaNV1XZ4Ygy5XNZk
   n7O8hAU4tW6z8FDVBIBzXKSjZak10RkdC40KLftVKKrb7LGoUMhlaWsrf
   c1bP5C0mmiQ2TtoO5QKxFEwU0ELX7LV3roqcorLeMKBMTNcqaQpBf5jnM
   w==;
X-CSE-ConnectionGUID: R8/QBBMYRD2GCkJnZLx89A==
X-CSE-MsgGUID: gg8eLvz/QzW9/ZiGoe3rYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3625149"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3625149"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 07:58:04 -0800
X-CSE-ConnectionGUID: xExwgk48SUKFDOhmSkw7kQ==
X-CSE-MsgGUID: WZojkiUMQy2BW7p8NZgTBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="9930907"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.197]) ([10.125.108.197])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 07:58:01 -0800
Message-ID: <d6a3c6a9-71f7-406d-9ae9-33b3566768eb@intel.com>
Date: Tue, 17 Nov 2026 08:57:59 -0700
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for
 djbw
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron <jic23@kernel.org>,
 Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>,
 Alistair Popple <apopple@nvidia.com>,
 Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
References: <20261110210152.3494345-1-dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261110210152.3494345-1-dave.jiang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/10/26 2:01 PM, Dave Jiang wrote:
> Dan is no longer with us. Removing entries in MAINTAINERS to prevent
> people from keep emailing his address.
> 
> Frank will take over for async_tx until the feature is removed.
> 
> Alistair will take over on fsdax with Alison continue to wrangle patches
> for DAX overall patches.
> 
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Frank Li <Frank.Li@kernel.org>
> Cc: Alistair Popple <apopple@nvidia.com>
> Acked-by: Davidlohr Bueso <dave@stgolabs.net>
> Acked-by: Vishal Verma <vishal.l.verma@intel.com>
> Acked-by: Alison Schofield <alison.schofield@intel.com>
> Acked-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> 

Applied to cxl/next:
9b5da39088f4
> ---
> 
> v2:
> - Add Frank as reviewer for async_tx.
> - Alistair has been working on fsdax and agreed to be maintainer.
> ---
>  MAINTAINERS | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 93abbb315065..58bdd5eff5c2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4294,7 +4294,7 @@ S:	Maintained
>  F:	crypto/rsa*
>  
>  ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
> -R:	Dan Williams <djbw@kernel.org>
> +R:	Frank Li <Frank.li@oss.nxp.com>
>  S:	Odd fixes
>  W:	http://sourceforge.net/projects/xscaleiop
>  F:	Documentation/crypto/async-tx-api.rst
> @@ -6726,7 +6726,6 @@ M:	Jonathan Cameron <jic23@kernel.org>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
> -M:	Dan Williams <djbw@kernel.org>
>  R:	Ira Weiny <iweiny@kernel.org>
>  R:	Li Ming <ming.li@zohomail.com>
>  R:	Richard Cheng <icheng@nvidia.com>
> @@ -7621,7 +7620,6 @@ S:	Maintained
>  F:	scripts/dev-needs.sh
>  
>  DEVICE DIRECT ACCESS (DAX)
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
> @@ -10315,12 +10313,12 @@ F:	include/linux/fcntl.h
>  F:	include/uapi/linux/fcntl.h
>  
>  FILESYSTEM DIRECT ACCESS (DAX)
> -M:	Dan Williams <djbw@kernel.org>
> +M:	Alistair Popple <apopple@nvidia.com>
>  R:	Matthew Wilcox <willy@infradead.org>
>  R:	Jan Kara <jack@suse.cz>
>  L:	linux-fsdevel@vger.kernel.org
>  L:	nvdimm@lists.linux.dev
> -S:	Supported
> +S:	Maintained
>  F:	fs/dax.c
>  F:	include/linux/dax.h
>  F:	include/trace/events/fs_dax.h
> @@ -13455,7 +13453,6 @@ F:	drivers/platform/x86/intel/hid.c
>  
>  INTEL I/OAT DMA DRIVER
>  M:	Dave Jiang <dave.jiang@intel.com>
> -R:	Dan Williams <djbw@kernel.org>
>  L:	dmaengine@vger.kernel.org
>  S:	Supported
>  Q:	https://patchwork.kernel.org/project/linux-dmaengine/list/
> @@ -15278,7 +15275,6 @@ K:	libie
>  
>  LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
>  M:	Vishal Verma <vishal.l.verma@intel.com>
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
>  L:	nvdimm@lists.linux.dev
> @@ -15288,7 +15284,6 @@ P:	Documentation/nvdimm/maintainer-entry-profile.rst
>  F:	drivers/nvdimm/btt*
>  
>  LIBNVDIMM PMEM: PERSISTENT MEMORY DRIVER
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
> @@ -15307,7 +15302,6 @@ F:	Documentation/devicetree/bindings/pmem/pmem-region.yaml
>  F:	drivers/nvdimm/of_pmem.c
>  
>  LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4

