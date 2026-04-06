Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D6A1DED40
	for <nvdimm@lists.linux.dev>; Mon,  6 Apr 2026 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775488937; cv=none; b=YXCMbUw5sJ3tcR10cO6wMhwPpF7hcf5QyG0lbhJopA/Qn1WJtn8Uk7rL0ZKS86mWrqjqW64mBuZ5hH31CZHSpSKFY7iWn2vB6HWEMlAACrmCLPt2OgrsuXqEFKiVRWH9toSEAIed1bkMYuFjO2T/5TQDCbZ5mY9qLjpDGKxFjOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775488937; c=relaxed/simple;
	bh=NMI742bMYxFB0aLiRJfaAm0g02uvHH/QYllcJi+70CQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jC3JiZcfzVgZGZb4qRsr6u/mZaHyFts2nQG+pxBFVMtgfKGNbquqRuNSnzoCaUPiT2OPFa2RyQiy3DERVRjveH27pO0bl6HiWCAJoD7I8VJIg1ci+Js00mh9KKJeS/kuRkffXOTIg9eFAIvOLCjZTHmziKln9HxGC+emcP1X7oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LKlOb/wH; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LKlOb/wH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775488936; x=1807024936;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NMI742bMYxFB0aLiRJfaAm0g02uvHH/QYllcJi+70CQ=;
  b=LKlOb/wHy6KJVQ60JX0w8AC4nhx9BvR5XzvDNUOkBBjQhtrMcJzu6jeU
   WSfpROscHltNnCUZ44Nhzlw/ayKz89NvzmpitZ1ommAbshhbkOW9BX9Er
   d/Ajb3oQ1xNovOeIe4/Os+IFtZJOuwk5R74uAjrFglHlwdfAF9c4uN27U
   s544LXL8jYgqe7Q1laiESwk/CsyeWxrFd0iiD2BfE4uKRjaJsG8r/EuFh
   8M/pitV6JIrRUavt1IHnuR5MuxDxbfd4KSUhiz2SE/Bx4EjLdLeCIr/p0
   QYk3mL6Y6OOK+T3SNBdBOwk0OY87y6ZBkho/hLP6SIEFHNHdHzveTctpP
   Q==;
X-CSE-ConnectionGUID: YVHO8wnNTOCytOXbYTzakw==
X-CSE-MsgGUID: tXAIgb4ARV+1ksVBHK/Qgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11750"; a="99060095"
X-IronPort-AV: E=Sophos;i="6.23,163,1770624000"; 
   d="scan'208";a="99060095"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 08:22:15 -0700
X-CSE-ConnectionGUID: HlVD919gRsOXGgWpLjvXkg==
X-CSE-MsgGUID: QMf7ULW+TLu747ifPGehTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,163,1770624000"; 
   d="scan'208";a="251180731"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.108.81]) ([10.125.108.81])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 08:22:14 -0700
Message-ID: <afd0f7b1-77d9-424e-99d7-d2e4bd75ee79@intel.com>
Date: Mon, 6 Apr 2026 08:22:13 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v2] test/cxl-dax-hmem.sh: validate dax_hmem vs CXL
 collisions
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
References: <20260404025123.2967169-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260404025123.2967169-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/3/26 7:51 PM, Alison Schofield wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Use the new "cxl_test.hmem_test" and "cxl_test.fail_autoassemble"
> module options to implement a new cxl-dax-hmem.sh test. The test
> checks dax_hmem takeover of Soft Reserve ranges that collide with
> autoassembled CXL regions. It depends on the cxl_mock_mem driver
> to launch multiple async probes before the dax_hmem driver attaches.
> 
> [as: do_skip on missing params, explicit param usage, robust unload,
> check_dmesg, misc style]
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Tested-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> 
> Changes in v2:
> - Add delay (cxl-list) between modprobe and dax lookup
>   In testing sometimes a daxctl right after modprobe fails to find
>   the devices.
> 
>  test/cxl-dax-hmem.sh | 68 ++++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build     |  2 ++
>  2 files changed, 70 insertions(+)
>  create mode 100755 test/cxl-dax-hmem.sh
> 
> diff --git a/test/cxl-dax-hmem.sh b/test/cxl-dax-hmem.sh
> new file mode 100755
> index 000000000000..6f4ed5076870
> --- /dev/null
> +++ b/test/cxl-dax-hmem.sh
> @@ -0,0 +1,68 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2026 Intel Corporation
> +
> +. $(dirname $0)/common
> +
> +rc=77
> +
> +set -ex
> +
> +trap 'err $LINENO' ERR
> +
> +check_prereq "jq"
> +
> +modinfo cxl_test | grep -q '^parm:.*hmem_test' || \
> +	do_skip "cxl_test hmem_test module param not available"
> +
> +modinfo cxl_test | grep -q '^parm:.*fail_autoassemble' || \
> +	do_skip "cxl_test fail_autoassemble module param not available"
> +
> +rc=1
> +
> +unload()
> +{
> +	modprobe -r dax_cxl 2>/dev/null || true
> +	modprobe -r dax_hmem 2>/dev/null || true
> +	modprobe -r cxl_mock_mem 2>/dev/null || true
> +	modprobe -r cxl_test 2>/dev/null || true
> +}
> +
> +find_dax_cxl()
> +{
> +	$DAXCTL list -R | jq -r \
> +		'.[] | select(.path | contains("cxl_acpi.0")) | .path'
> +}
> +
> +find_dax_hmem()
> +{
> +	$DAXCTL list -R | jq -r \
> +		'.[] | select(.path | contains("hmem_platform.1")) | .path'
> +}
> +
> +unload
> +
> +# Verify CXL autoassembly claims the Soft Reserve range before dax_hmem
> +modprobe cxl_mock_mem
> +modprobe cxl_test hmem_test=1
> +$CXL list
> +
> +dax=$(find_dax_cxl)
> +[[ -z "$dax" ]] && err $LINENO
> +dax=$(find_dax_hmem)
> +[[ -n "$dax" ]] && err $LINENO
> +
> +unload
> +
> +# Verify dax_hmem claims the Soft Reserve range when CXL autoassembly fails
> +modprobe cxl_mock_mem
> +modprobe cxl_test hmem_test=1 fail_autoassemble=1
> +$CXL list
> +
> +dax=$(find_dax_cxl)
> +[[ -n "$dax" ]] && err $LINENO
> +dax=$(find_dax_hmem)
> +[[ -z "$dax" ]] && err $LINENO
> +
> +unload
> +check_dmesg "$LINENO"
> diff --git a/test/meson.build b/test/meson.build
> index 593edf552b36..4260a3fa4448 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -169,6 +169,7 @@ cxl_destroy_region = find_program('cxl-destroy-region.sh')
>  cxl_qos_class = find_program('cxl-qos-class.sh')
>  cxl_translate = find_program('cxl-translate.sh')
>  cxl_elc = find_program('cxl-elc.sh')
> +cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
>  
>  tests = [
>    [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -203,6 +204,7 @@ tests = [
>    [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
>    [ 'cxl-translate.sh',       cxl_translate,      'cxl'   ],
>    [ 'cxl-elc.sh',             cxl_elc,            'cxl'   ],
> +  [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
>  ]
>  
>  if get_option('destructive').enabled()

