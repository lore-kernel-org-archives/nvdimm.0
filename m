Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A763F37C0FC
	for <nvdimm@lists.linux.dev>; Fri,  3 Apr 2026 22:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775257017; cv=none; b=WUfkFW8yHowCOlhFfkTtGY0uzygkncJRZq6yjmRjDJ2gr/onZiPoklpQgvgizS/q7AX1PDWjmnRQFZ9JiWZi9eFoP8eGCUh1y6PTneB94/q9PihnOdnpSH2mEnCYkprjydH5P6n7s63QrTNL8xUk9laN5q9tY58TvDg8qlMVW3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775257017; c=relaxed/simple;
	bh=821qJUwjF6o6Ev3F1IGyIIE03ftfAgp4aF2dcVT1OI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rpbX0vgG4NwuKNeEMWuJQf4ulh+cD0I3LVESFFih7HzFVM6OqXyc+9puKNfowlvaFCkQoLnRQjRT8rzG0+5/cAJ6z/7A46r+jMfE04oWUPrHYswtO6Dkn4GeLshfpSXgZ7MaEAriyoBuMqNs4z3diIl/fsNvOir2SJOE8DqKV7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PtWHlCxA; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PtWHlCxA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775257015; x=1806793015;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=821qJUwjF6o6Ev3F1IGyIIE03ftfAgp4aF2dcVT1OI8=;
  b=PtWHlCxAmZjAzczb6L7gsrDuCdtCzog8stmBvT0BquuXbRi8cwUSFsZk
   +Jn8L0z25CNxiL8mvwNHNsakVtvthbTrvl8pjg6OXViOJ8m3VYvTF2dZd
   AX+P7bLkl4E9WHLvUHCc5ENxLI9wmvgKYZEXYrV9B5dmzj731ii8Cd5dV
   k0ikQD/NuV6HMq5+BWlzMqvngKlirZBvlfbIr17dc1Z7+9HmDiiE+mWKP
   Ek9w7QimNT5oGjVSKuoVC3bxgNZyb7OFbmyFTkZFlAfneWEgLP6TpA0FG
   EIRdX231pfsFSQ9K65cg8EYUifmyjQ8I/YR51d9at//WA4pHwXqllgdJO
   g==;
X-CSE-ConnectionGUID: bwvqQluUSsCnnqn+dzabkQ==
X-CSE-MsgGUID: fRDDNPoRQraZ+2njr8WS/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="86619222"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="86619222"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 15:56:55 -0700
X-CSE-ConnectionGUID: hx3fvgEDT9mZO6RnDJs0xw==
X-CSE-MsgGUID: mthYTd3OR0mKibWnwdCHqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="231400763"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.111.241]) ([10.125.111.241])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 15:56:55 -0700
Message-ID: <af63eb65-66d6-42e2-b8f3-dd8d3938a280@intel.com>
Date: Fri, 3 Apr 2026 15:56:54 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Update address for Dan Williams
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <20260403214846.1062341-1-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260403214846.1062341-1-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/3/26 2:48 PM, Dan Williams wrote:
> Update MAINTAINERS and .mailmap to point to my kernel.org address:
> djbw@kernel.org.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Applied to cxl/next
9b6e1ed28a7f


> ---
>  .mailmap    |  1 +
>  MAINTAINERS | 18 +++++++++---------
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/.mailmap b/.mailmap
> index 2d04aeba68b4..a4ad593b5ed8 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -204,6 +204,7 @@ Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
>  Corey Minyard <minyard@acm.org>
>  Damian Hobson-Garcia <dhobsong@igel.co.jp>
>  Dan Carpenter <error27@gmail.com> <dan.carpenter@oracle.com>
> +Dan Williams <djbw@kernel.org> <dan.j.williams@intel.com>
>  Daniel Borkmann <daniel@iogearbox.net> <danborkmann@googlemail.com>
>  Daniel Borkmann <daniel@iogearbox.net> <danborkmann@iogearbox.net>
>  Daniel Borkmann <daniel@iogearbox.net> <daniel.borkmann@tik.ee.ethz.ch>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c3fe46d7c4bc..150784b8febc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4058,7 +4058,7 @@ S:	Maintained
>  F:	crypto/rsa*
>  
>  ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
> -R:	Dan Williams <dan.j.williams@intel.com>
> +R:	Dan Williams <djbw@kernel.org>
>  S:	Odd fixes
>  W:	http://sourceforge.net/projects/xscaleiop
>  F:	Documentation/crypto/async-tx-api.rst
> @@ -6429,7 +6429,7 @@ M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Ira Weiny <ira.weiny@intel.com>
> -M:	Dan Williams <dan.j.williams@intel.com>
> +M:	Dan Williams <djbw@kernel.org>
>  L:	linux-cxl@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/driver-api/cxl
> @@ -7290,7 +7290,7 @@ S:	Maintained
>  F:	scripts/dev-needs.sh
>  
>  DEVICE DIRECT ACCESS (DAX)
> -M:	Dan Williams <dan.j.williams@intel.com>
> +M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  L:	nvdimm@lists.linux.dev
> @@ -9816,7 +9816,7 @@ F:	include/linux/fcntl.h
>  F:	include/uapi/linux/fcntl.h
>  
>  FILESYSTEM DIRECT ACCESS (DAX)
> -M:	Dan Williams <dan.j.williams@intel.com>
> +M:	Dan Williams <djbw@kernel.org>
>  R:	Matthew Wilcox <willy@infradead.org>
>  R:	Jan Kara <jack@suse.cz>
>  L:	linux-fsdevel@vger.kernel.org
> @@ -12872,7 +12872,7 @@ F:	drivers/platform/x86/intel/hid.c
>  
>  INTEL I/OAT DMA DRIVER
>  M:	Dave Jiang <dave.jiang@intel.com>
> -R:	Dan Williams <dan.j.williams@intel.com>
> +R:	Dan Williams <djbw@kernel.org>
>  L:	dmaengine@vger.kernel.org
>  S:	Supported
>  Q:	https://patchwork.kernel.org/project/linux-dmaengine/list/
> @@ -14575,7 +14575,7 @@ K:	libie
>  
>  LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
>  M:	Vishal Verma <vishal.l.verma@intel.com>
> -M:	Dan Williams <dan.j.williams@intel.com>
> +M:	Dan Williams <djbw@kernel.org>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  L:	nvdimm@lists.linux.dev
>  S:	Supported
> @@ -14584,7 +14584,7 @@ P:	Documentation/nvdimm/maintainer-entry-profile.rst
>  F:	drivers/nvdimm/btt*
>  
>  LIBNVDIMM PMEM: PERSISTENT MEMORY DRIVER
> -M:	Dan Williams <dan.j.williams@intel.com>
> +M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  L:	nvdimm@lists.linux.dev
> @@ -14602,7 +14602,7 @@ F:	Documentation/devicetree/bindings/pmem/pmem-region.yaml
>  F:	drivers/nvdimm/of_pmem.c
>  
>  LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
> -M:	Dan Williams <dan.j.williams@intel.com>
> +M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Ira Weiny <ira.weiny@intel.com>
> @@ -26869,7 +26869,7 @@ S:	Maintained
>  F:	Documentation/devicetree/bindings/trigger-source/*
>  
>  TRUSTED EXECUTION ENVIRONMENT SECURITY MANAGER (TSM)
> -M:	Dan Williams <dan.j.williams@intel.com>
> +M:	Dan Williams <djbw@kernel.org>
>  L:	linux-coco@lists.linux.dev
>  S:	Maintained
>  F:	Documentation/ABI/testing/configfs-tsm-report
> 
> base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d

