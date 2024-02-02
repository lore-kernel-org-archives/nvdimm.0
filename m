Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE621474B6
	for <nvdimm@lists.linux.dev>; Fri,  2 Feb 2024 16:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706890678; cv=none; b=ZOsbC5NOUkN//ljFJ3/RFFbhDmRBKNLrPX/Iozp2uBATWVt0xdlHq07B9KPyAwKb1bgATzxVb9ryY4zsSmqcNKLSu2mWRdQZem5sMZ+cjnUQK04FTL42CRUbUW/cKgKxeJHIXFVZV+ATByUf6jGDxHdUh8XbQMC+M3fzTnjGKTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706890678; c=relaxed/simple;
	bh=iB3Mxsh1cFMlMBaXkdfyTemkCkfav5rV8fciVYUwryY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jQng73ITEl8lZRj8/D71C7QTMxm1NifnGL6qPeLE6I2fVv+9XIPBFGnHrOFScivRyenGPlbn4NzoWKw2gi5uQtCNe6o8594FO4ZmfBzId9xTyBsW2c2aGVACuXFglpCbl6V2gk/qy7niv1t5SsCgzUh7x1SIKebjge6jwO3Vngc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JMS+ex5s; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JMS+ex5s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706890674; x=1738426674;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iB3Mxsh1cFMlMBaXkdfyTemkCkfav5rV8fciVYUwryY=;
  b=JMS+ex5sAYRjbLbIdk1O9+YSl0v2WCbWFgFEIqH1iIbw2QRK+vmoa31g
   9S5MzFanU6ryTVQ7ptHx6/ls4Lq6VZ1hrkkhrigKb2cYn0oY6G7r8A4h+
   khoxpM0sInGLHhftM8JPnKt08dS8jZ7Gyxh/pXqgYirnzczLnHmocTruX
   Qs4tORSO9Xi5xlLqEuFS2m10g3DaRJVURG7o2Afd3W+Xdr//2kk5GDpUZ
   u3oQjBMuBNI7kI8yYpQl3Wj1k1a4SPstCUw/L+sXY6zcXrgx1NL1+8oYs
   4dM67z/5y9g7YJnQYX0zm4nluF1hwNMhP951unM6qAlp1WT1g+ZXSv29A
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="11285370"
X-IronPort-AV: E=Sophos;i="6.05,238,1701158400"; 
   d="scan'208";a="11285370"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 08:17:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="932503964"
X-IronPort-AV: E=Sophos;i="6.05,238,1701158400"; 
   d="scan'208";a="932503964"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.251.15.209])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 08:17:52 -0800
Date: Fri, 2 Feb 2024 08:17:50 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	vishal.l.verma@intel.com
Subject: Re: [NDCTL PATCH v5 4/4] ndctl: add test for qos_class in CXL test
 suite
Message-ID: <Zb0VrjTUimEMFkT2@aschofie-mobl2>
References: <20240201230646.1328211-1-dave.jiang@intel.com>
 <20240201230646.1328211-5-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240201230646.1328211-5-dave.jiang@intel.com>

On Thu, Feb 01, 2024 at 04:05:07PM -0700, Dave Jiang wrote:
> Add tests in cxl-qos-class.sh to verify qos_class are set with the fake
> qos_class create by the kernel.  Root decoders should have qos_class
> attribute set. Memory devices should have ram_qos_class or pmem_qos_class
> set depending on which partitions are valid.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> v5:
> - Split out from cxl-topology.sh (Vishal)
> ---
>  test/common           |  4 +++
>  test/cxl-qos-class.sh | 65 +++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build      |  2 ++
>  3 files changed, 71 insertions(+)
>  create mode 100755 test/cxl-qos-class.sh
> 
> diff --git a/test/common b/test/common
> index f1023ef20f7e..5694820c7adc 100644
> --- a/test/common
> +++ b/test/common
> @@ -150,3 +150,7 @@ check_dmesg()
>  	grep -q "Call Trace" <<< $log && err $1
>  	true
>  }
> +
> +
> +# CXL COMMON
> +TEST_QOS_CLASS=42
> diff --git a/test/cxl-qos-class.sh b/test/cxl-qos-class.sh
> new file mode 100755
> index 000000000000..365a7df9c1e4
> --- /dev/null
> +++ b/test/cxl-qos-class.sh
> @@ -0,0 +1,65 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2024 Intel Corporation. All rights reserved.
> +
> +check_qos_decoders () {
> +	# check root decoders have expected fake qos_class
> +	# also make sure the number of root decoders equal to the number
> +	# with qos_class found
> +	json=$($CXL list -b cxl_test -D -d root)
> +	decoders=$(echo "$json" | jq length)
> +	count=0
> +	while read -r qos_class
> +	do
> +		((qos_class == TEST_QOS_CLASS)) || err "$LINENO"
> +		count=$((count+1))
> +	done <<< "$(echo "$json" | jq -r '.[] | .qos_class')"
> +
> +	((count == decoders)) || err "$LINENO";
> +}
> +
> +check_qos_memdevs () {
> +	# Check that memdevs that expose ram_qos_class or pmem_qos_class have
> +	# expected fake value programmed.
> +	json=$(cxl list -b cxl_test -M)
> +	readarray -t lines < <(jq ".[] | .ram_size, .pmem_size, .ram_qos_class, .pmem_qos_class" <<<"$json")
> +	for (( i = 0; i < ${#lines[@]}; i += 4 ))
> +	do
> +		ram_size=${lines[i]}
> +		pmem_size=${lines[i+1]}
> +		ram_qos_class=${lines[i+2]}
> +		pmem_qos_class=${lines[i+3]}
> +
> +		if [[ "$ram_size" != null ]]
> +		then
> +			((ram_qos_class == TEST_QOS_CLASS)) || err "$LINENO"
> +		fi
> +		if [[ "$pmem_size" != null ]]
> +		then
> +			((pmem_qos_class == TEST_QOS_CLASS)) || err "$LINENO"
> +		fi
> +	done
> +}
> +
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
> +modprobe -r cxl_test
> +modprobe cxl_test
> +rc=1

This different style, boiler plate not first in file, caught my eye.
Functionally no difference but stopped me for a second.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> +
> +check_qos_decoders
> +
> +check_qos_memdevs
> +
> +check_dmesg "$LINEO"
> +
> +modprobe -r cxl_test
> diff --git a/test/meson.build b/test/meson.build
> index 5eb35749a95b..4892df11119f 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -160,6 +160,7 @@ cxl_events = find_program('cxl-events.sh')
>  cxl_poison = find_program('cxl-poison.sh')
>  cxl_sanitize = find_program('cxl-sanitize.sh')
>  cxl_destroy_region = find_program('cxl-destroy-region.sh')
> +cxl_qos_class = find_program('cxl-qos-class.sh')
>  
>  tests = [
>    [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -192,6 +193,7 @@ tests = [
>    [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
>    [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
>    [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
> +  [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
>  ]
>  
>  if get_option('destructive').enabled()
> -- 
> 2.43.0
> 
> 
