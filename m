Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793316686;
	b=WWXof5svZMcs1ara+4ykUnwNsJGmAnt00dqbsm8vfXuYtirQEJKQXY2wOezJo4bDGOiG
	 Tgyi0okeg7XBsyJ+jItPO/2GKeM9P+shVQxBzsdRPmrIYiCuGCAL9KGg0dc5u5L/iJ3q8
	 JC+bRAFZ9qSwbBm4o8dGw+3FTikvuPNFagCg+v4RJ6H+TyMUFocTxA8R92McyLG9cfqTn
	 bnRfGJO+iFn6om3SMkNrpLhYuClxGm95+fWpSFW3Hrwc/24BsKv5NLpKRSQr2fDK5xpp8
	 mf9R+xbNs63NGzGLlM7/awtz2EH8hBfd9vBzddrnlP39m/w6WkAYMBtVLwYCEOENHRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793316686;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=wBd/3pbAHYefPoYyncbIaWQ+88je0Ek2D7C15nu9xiA=;
	b=5OmSYYTgopB04ErmPfEt+KhuaRXeY6Lc8R6LjoM50mFSNDp+85DQV/+PGTVBLptq82aX
	 DLw2iiMFOUOBfYmxtizJthqJ7aUftbEUZaAqT7qYz/GYptnGTg3UokQQ6o3BIM0KUOFsE
	 nGvq1S/NA2S9Su+7xJqHogo5dLDCtdebkJz3uQYMh1Uu4CXh8TdgIVU1jVBcngzqA6R1F
	 wPW/ratwW75x5r+dBsAXgqYfSobwjxDIXZmWPJqo1OjK0SHauoq6XiqzkEUW49ei/3cZz
	 uyNdBIJ7ouhTQBEwvA9CGvkGtqJxgaBbEW0jw0wkp1T04Gls/71Wy/5KNMwxKKaMkrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PlqOgWTK;
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE5E60A2625
	for <nvdimm@lists.linux.dev>; Thu, 29 Oct 2026 23:31:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADE5E60A2625
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PlqOgWTK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793316684; x=1824852684;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=on7nyL7Y00Q0SvSDG6CqYZsgSE9E2hx7Jct/0lDtBoA=;
  b=PlqOgWTKM8xP9I9wlNMRQ7yI/1WU+udTH18FiyvDgxvyT7EP+2Ug5bpc
   lCwEPQmXvrNMT7mQ/NkqDMTgVAlH7FGJRgtwe7U+AdQT08stK9F9mh2YF
   PBAON8qBc6XFNFZVNNNrnWur9xreM4DUBarpV22C2rhQ6oyC3DlGbdXq8
   2ujIJePqyb++R7Gz9WqbhK5U2W1z1raGaYcPhnGwFHcmoZ9feqn4hQYXj
   s9jtygDOlw11Zs4I7/u8Eo33+O/5knfa2mfDK7oANKAKrmCOA2X0Yf2C5
   k8GfiKk7RWmBFu2e6bmU+4XTOBmqgIWw2o44o2snfxUXSp01I1haobEmq
   w==;
X-CSE-ConnectionGUID: yxY5ttWMQDyV2zSBbgXppw==
X-CSE-MsgGUID: 43ZMdxGxRkqZuzvgLQIBYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2090221"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="2090221"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 16:31:24 -0700
X-CSE-ConnectionGUID: 1JX0BFWsRDacQyPmiKkSNw==
X-CSE-MsgGUID: 7jPVi1a0Sce9VwRiQ/9J5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="5162262"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.109.28]) ([10.125.109.28])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 16:31:23 -0700
Message-ID: <23981bf0-75a0-43c5-a996-32cbab8bc1bb@intel.com>
Date: Thu, 29 Oct 2026 16:31:22 -0700
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
Subject: Re: [ndctl PATCH 4/4] test/daxctl-create.sh: count memory blocks
 across dax mappings
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 Gregory Price <gourry@gourry.net>
Cc: linux-cxl@vger.kernel.org
References: <cover.1792695259.git.alison.schofield@intel.com>
 <55162d83dfab6101fca10df09b6baacac1834b17.1792695259.git.alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <55162d83dfab6101fca10df09b6baacac1834b17.1792695259.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/22/26 12:56 PM, Alison Schofield wrote:
> Existing tests use single-range devices and cannot detect incorrect memory
> block accounting across discontiguous mappings. A two-range device exposed
> this bug by reporting only one of its two blocks.
> 
> Create a device with two separated mappings and verify its memory block
> count against the expected count from both mappings.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  test/daxctl-create.sh | 58 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
> 
> diff --git a/test/daxctl-create.sh b/test/daxctl-create.sh
> index 954a112d0f18..c4fe369eac3a 100755
> --- a/test/daxctl-create.sh
> +++ b/test/daxctl-create.sh
> @@ -7,6 +7,9 @@ rc=77
>  
>  trap 'cleanup $LINENO' ERR
>  
> +policy=/sys/devices/system/memory/auto_online_blocks
> +saved_policy=
> +
>  modprobe -r cxl_test
>  modprobe cxl_test
>  $CXL list
> @@ -14,6 +17,7 @@ $CXL list
>  cleanup()
>  {
>  	printf "Error at line %d\n" "$1"
> +	[[ $saved_policy ]] && echo "$saved_policy" > "$policy"
>  	[[ $testdev ]] && reset_dax
>  	exit $rc
>  }
> @@ -396,6 +400,59 @@ daxctl_test7()
>  	test_pass
>  }
>  
> +# Test 8: multi-range system-ram
> +# Successfully counts every memory block of a device whose two ranges
> +# have a gap between them. The memory is never onlined: cxl_test memory
> +# is not backed by RAM.
> +daxctl_test8()
> +{
> +	local daxdev_1 daxdev_2 daxdev path m start end n nmaps=0 total=0
> +	local bs size
> +
> +	bs=$((0x$(cat /sys/devices/system/memory/block_size_bytes)))
> +	size=$((available / 4))
> +	if (( size < bs || size % bs )); then
> +		echo "test8: skipped, region too small for $bs byte memory blocks"
> +		return 0
> +	fi
> +
> +	# a devdax device in the gap between the two ranges, it has no
> +	# memory blocks to be miscounted
> +	daxdev_1=$("$DAXCTL" create-device -r "$region_id" -s $size | jq -er '.[].chardev')
> +	daxdev_2=$("$DAXCTL" create-device -r "$region_id" -s $size | jq -er '.[].chardev')
> +	test -n "$daxdev_2"
> +	"$DAXCTL" disable-device "$daxdev_1" && "$DAXCTL" destroy-device "$daxdev_1"
> +
> +	daxdev=$("$DAXCTL" create-device -r "$region_id" -s $((size * 2)) | jq -er '.[].chardev')
> +	test "$(daxctl_get_nr_mappings "$daxdev")" -eq 2
> +
> +	# memory blocks wholly inside each mapping
> +	path=$(readlink -f /sys/bus/dax/devices/"$daxdev")
> +	for m in "$path"/mapping[0-9]*; do
> +		start=$(cat "$m"/start)
> +		end=$(cat "$m"/end)
> +		n=$(((end + 1) / bs - (start + bs - 1) / bs))
> +		(( n > 0 ))
> +		total=$((total + n))
> +		nmaps=$((nmaps + 1))
> +	done
> +	test "$nmaps" -eq 2
> +
> +	saved_policy=$(cat "$policy")
> +	echo offline > "$policy"
> +	"$DAXCTL" reconfigure-device -N -m system-ram "$daxdev"
> +	test "$("$DAXCTL" list -d "$daxdev" | jq -er '.[].total_memblocks')" -eq "$total"
> +	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
> +	echo "$saved_policy" > "$policy"
> +	saved_policy=
> +
> +	"$DAXCTL" disable-device -r "$region_id" all
> +	"$DAXCTL" destroy-device -r "$region_id" all
> +
> +	clear_dev
> +	test_pass
> +}
> +
>  find_testdev
>  rc=1
>  setup_dev
> @@ -407,6 +464,7 @@ daxctl_test4
>  daxctl_test5
>  daxctl_test6
>  daxctl_test7
> +daxctl_test8
>  reset_dev
>  modprobe -r cxl_test
>  exit 0

