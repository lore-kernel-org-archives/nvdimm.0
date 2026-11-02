Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652352;
	b=lHwH8cb/kaPBjgH9awxuPkwstKKIv8/233XHDgM/9J9/bL8D1ESeyDdRHFXFfwBbaBNM
	 3LGKPstCkeSDOaxBPeKEYn6fn2rKy57T681NPuF6XbKi3BWo+mQz5diicwK18XHNRxS+3
	 sbJVwIvjEtA+vItGh+Jww4zOglqVfWGSI80cVZQGlHjMSdQDNE+USFvqCDtVtGKNaZZ8z
	 zQkQWZfdyeGpmSXOVg9SkvX9qjJ5t42tI3fUKJuQ9HtFr8elej4E944SEW225lEMgfi8H
	 zq7zLEYG/QfYOEqod1vJA3Y+O+CYvsu6QwgrgTjXi0bdY2fBxwpbXcJ+GUymDL0hoxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652352;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:From:Content-Language:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=XJuTsAOOyGqLeew1ewCAm38gD3HQ/6Ch1odVZSvncAI=;
	b=gRFqUbusFHjXp9TOGauMM4b9AUd3HU0dkZeQ8MikGU3FnZJgp8wlKdD2gYH1pfNCh6Fd
	 Z8swwBWppS9KyVQ+t69arvnPb8CxKbJ+b4BxR1R+1/QDOY9D78dNg7NtH/qoHmLQDMSWm
	 /iu0QRupP51hswQdDnHBmh2ppZLn+l4PsFcPVcbwb8ML72w0oJRVoOGzk3bv6Uxm+eRYT
	 8VCJ+KHgO2VXOOOTXaYNULc74AflUvMLVtZeJE9z8FZSevzCA3x1ciaO9uAyFpNWKCi7o
	 uHfgzjTKYQ2OWTH4f3wOGb9dCSacrGUJjCJejoXxVc6QPagZtHvGgTA9w8N1PJ2Ygng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NZzxeJn7;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A78606A329
	for <nvdimm@lists.linux.dev>; Mon,  2 Nov 2026 20:45:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2A78606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NZzxeJn7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793652351; x=1825188351;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=q0iRDElRMw9tOFJJQAcT1P1BnWaj6rP+fn6HuzJIHm0=;
  b=NZzxeJn7f8fZ22ga0dy+Yy0rnFSVMGFfI0VIiZHwTk4DQUtxk+c6s1qN
   gb9vFtElHIWwxOaTT0KCuwtL/KY7pIMHjIHPMua+ZUHBhXoDCySslWUSp
   K+tllesmsdQJSZJPrS/QTHWjPoALXJO7Dc2Mg5vUhnM52mNI3W+8Tvtdx
   /gldpc0rmJ1vD25rf+atPs2+3kN8j4EBKeDUHgC11XX51bAXr1fZEHE4e
   tx/yPfcM7bieFOTkpxn4VAmPb5kH/gufkPscFtsabXJh1gGj2ple7zgBc
   VZQ0u/vhu2PlD3U2naQQr8VAUgFngZ1Pid1rcz7AxfvKgJBd/ZDsZ6Oh0
   Q==;
X-CSE-ConnectionGUID: mbbBMeWpTU2Gr4wi53Fesw==
X-CSE-MsgGUID: bhXli916QYaMFKRhAQj46Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2391433"
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="2391433"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 12:45:50 -0800
X-CSE-ConnectionGUID: L+PTmtGyTBivZbsHUBs+fQ==
X-CSE-MsgGUID: Vz+/NBKCQVG9AeGI1F+nWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="6558253"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.109.163]) ([10.125.109.163])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 12:45:50 -0800
Message-ID: <fffb0387-559a-4557-a219-feb01da5661c@intel.com>
Date: Mon, 2 Nov 2026 13:45:49 -0700
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
Subject: Re: [ndctl PATCH] test/cxl-kunit.sh: enable running the CXL KUnit
 tests
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <20261014043823.295243-1-alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261014043823.295243-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/13/26 9:38 PM, Alison Schofield wrote:
> CXL KUnit suites run when their modules are loaded, but the ndctl CXL
> test suite does not load them. As a result, they are not exercised by
> the existing ndctl tests.
> 
> Add cxl-kunit.sh to discover and load installed CXL KUnit modules, check
> their KTAP results in debugfs, and unload the modules on exit. Test
> failures are reported individually without preventing the remaining suites
> from running.
> 
> Discover modules by the cxl_*_kunit naming convention so newly added suites
> are included automatically.
> 
> Add CONFIG_KUNIT, CONFIG_KUNIT_DEBUGFS, and CONFIG_CXL_KUNIT_TEST=m to the
> README kernel configuration.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  README.md         |  3 ++
>  test/cxl-kunit.sh | 86 +++++++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build  |  2 ++
>  3 files changed, 91 insertions(+)
>  create mode 100755 test/cxl-kunit.sh
> 
> diff --git a/README.md b/README.md
> index a71db28f62fb..83e809a2b325 100644
> --- a/README.md
> +++ b/README.md
> @@ -130,6 +130,9 @@ loaded.  To build and install nfit_test.ko:
>     CONFIG_NVDIMM_SECURITY_TEST=y
>     CONFIG_ENCRYPTED_KEYS=y
>     CONFIG_NVDIMM_KEYS=y
> +   CONFIG_KUNIT=y
> +   CONFIG_KUNIT_DEBUGFS=y
> +   CONFIG_CXL_KUNIT_TEST=m
>     ```
>  1. Install cxl_test and related mock modules.
>     ```
> diff --git a/test/cxl-kunit.sh b/test/cxl-kunit.sh
> new file mode 100755
> index 000000000000..12e94e417cac
> --- /dev/null
> +++ b/test/cxl-kunit.sh
> @@ -0,0 +1,86 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2026 Intel Corporation. All rights reserved.
> +
> +# Run CXL KUnit suites through the ndctl test harness.
> +# Discover test modules by name and check their KTAP results in debugfs.
> +# See Documentation/driver-api/cxl/testing.rst in the kernel.
> +
> +# shellcheck disable=SC1091 # common is sourced from the test directory
> +. "$(dirname "$0")"/common
> +
> +kunit_debugfs=/sys/kernel/debug/kunit
> +
> +mapfile -t modules < <(find /lib/modules/"$(uname -r)" \
> +	-name 'cxl_*_kunit.ko*' -printf '%f\n' | sed 's/\.ko.*$//' | sort)
> +
> +[ ${#modules[@]} -gt 0 ] ||
> +	do_skip "test requires CONFIG_CXL_KUNIT_TEST=m"
> +
> +unload_modules() {
> +	local mod
> +
> +	for mod in "${modules[@]}"; do
> +		modprobe -r "$mod" 2>/dev/null || true
> +	done
> +}
> +
> +trap unload_modules EXIT
> +trap 'err $LINENO' ERR
> +set -ex
> +# shellcheck disable=SC2034 # rc is the exit status used by err()
> +rc=1
> +
> +# Force test suites to rerun on module load
> +unload_modules
> +
> +loaded=()
> +summary=()
> +nr_failed=0
> +
> +for mod in "${modules[@]}"; do
> +	if modprobe "$mod"; then
> +		loaded+=("$mod")
> +	else
> +		summary+=("$mod: FAIL, module did not load")
> +		nr_failed=$((nr_failed + 1))
> +	fi
> +done
> +
> +[ -d "$kunit_debugfs" ] ||
> +	do_skip "test requires CONFIG_KUNIT_DEBUGFS=y"
> +
> +for mod in "${loaded[@]}"; do
> +	nr_suites=0
> +
> +	for results in "$kunit_debugfs"/cxl_*/results; do
> +		[ -f "$results" ] || continue
> +		grep -qE "^[[:space:]]*# module: $mod\$" "$results" || continue
> +
> +		suite=$(basename "$(dirname "$results")")
> +		nr_suites=$((nr_suites + 1))
> +		cat "$results"
> +
> +		# Match the suite result, not individual test cases
> +		if grep -qE "^ok [0-9]+ $suite\$" "$results"; then
> +			summary+=("$mod: suite $suite PASS")
> +		else
> +			summary+=("$mod: suite $suite FAIL")
> +			nr_failed=$((nr_failed + 1))
> +		fi
> +	done
> +
> +	if [ "$nr_suites" -eq 0 ]; then
> +		summary+=("$mod: FAIL, no suite results in $kunit_debugfs")
> +		nr_failed=$((nr_failed + 1))
> +	fi
> +done
> +
> +set +x
> +echo "CXL KUnit summary:"
> +printf '  %s\n' "${summary[@]}"
> +set -x
> +
> +[ "$nr_failed" -eq 0 ] || err "$LINENO"
> +
> +echo "CXL KUnit: all suites from ${#modules[@]} modules passed"
> diff --git a/test/meson.build b/test/meson.build
> index 07c8618cbc6e..3b3a634ef25d 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -173,6 +173,7 @@ cxl_elc = find_program('cxl-elc.sh')
>  cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
>  cxl_region_replay = find_program('cxl-region-replay.sh')
>  cxl_type2 = find_program('cxl-type2.sh')
> +cxl_kunit = find_program('cxl-kunit.sh')
>  
>  tests = [
>    [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -211,6 +212,7 @@ tests = [
>    [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
>    [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
>    [ 'cxl-type2.sh',           cxl_type2,          'cxl'   ],
> +  [ 'cxl-kunit.sh',           cxl_kunit,          'cxl'   ],
>  ]
>  
>  if get_option('destructive').enabled()

