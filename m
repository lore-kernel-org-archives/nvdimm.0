Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3E9275869
	for <nvdimm@lists.linux.dev>; Tue,  1 Jul 2025 15:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751383119; cv=none; b=KRvNCZzFvUqdcRYIAzxiLmhAMILR5u4Moi25T8WoPsGoTn4kSaweGbr4Q4Mza2rxooEdVzOWYyQy6v7WCHhrMDwcCC+w8VongOBJxKgdg8rWa/joQh+M2fkqrUtbPilA29IAxmO548ltcc8ZUjPHyK8YLktSQihhCXekFiVxVd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751383119; c=relaxed/simple;
	bh=gD2I3EOIZ31Z1+7hkLiZ9Y2sWNygt55hZvIbAypzH1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TXksev3hxRGBRmn0FIUob2qfyPnYQss0LlFqgjH/qhWkT3PWUNPdFJRrGV+Che2OzIu0dFw7ms6vGiezeUDPQd+N7hRjjPBoACVXjdEL78r9juLwu65ehwk6diVxQKgGadSuK7sGnzsh9+JFus709D5C0i19rDJ6O5zs5pzNUow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gba3wHLU; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gba3wHLU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751383117; x=1782919117;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gD2I3EOIZ31Z1+7hkLiZ9Y2sWNygt55hZvIbAypzH1Q=;
  b=Gba3wHLUnWym4yksifzAm+KDng5fcFYKaSlM75o3rTXNOoJorgKw+TzN
   7PbUv1eUnerdS8szZJHb4JJThNfkJiVooJIb9UGVm+KY5rpYuikh+3lSP
   YGBR35++J8M0P0rdl8sgIIxcLqy9vPTs+GxTynbIh723PTAN51LQ2Gs4q
   Hf602rOP1b9gnT0o30vx9V5gLQcnIA0cVD8p3KoDrYOCkiRdx4mM+Z6YJ
   hxyBiKy3k39qCb/DV0+eBjIZJankXSnYTD03uR/sDARYvTiAot9ERBZDl
   WcCD2lK9h/C+ClajcZ+Ed+OxCweOcmTH/Ci+L3xEd6GbRERAxTYNzk6ZM
   A==;
X-CSE-ConnectionGUID: 4mm+yaf/Q22pqMnQB+hDtA==
X-CSE-MsgGUID: SB/Zpx2KRTqWDRdfgyq/hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="56281167"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="56281167"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 08:18:33 -0700
X-CSE-ConnectionGUID: kOuYdBhpTeSXkeP2NiLb3w==
X-CSE-MsgGUID: Q4MEeP1XQNGdtfR5Q6rfHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="158073001"
Received: from puneetse-mobl.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 08:18:32 -0700
Message-ID: <81ad9457-ffa8-4d83-9fcd-3d9d79d8b085@intel.com>
Date: Tue, 1 Jul 2025 08:18:31 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] ndctl: spelling fixes
To: Yi Zhang <yi.zhang@redhat.com>, nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com, linux-cxl@vger.kernel.org
References: <20250701141545.2631700-1-yi.zhang@redhat.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250701141545.2631700-1-yi.zhang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/1/25 7:15 AM, Yi Zhang wrote:
> Fix various spelling errors in ndctl.
> 
> Signed-off-by: Yi Zhang <yi.zhang@redhat.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/cxl/cxl-reserve-dpa.txt          | 2 +-
>  Documentation/cxl/lib/libcxl.txt               | 2 +-
>  Documentation/daxctl/daxctl-create-device.txt  | 2 +-
>  Documentation/ndctl/ndctl-create-namespace.txt | 4 ++--
>  ccan/list/list.h                               | 2 +-
>  cxl/bus.c                                      | 2 +-
>  cxl/lib/libcxl.c                               | 2 +-
>  cxl/memdev.c                                   | 2 +-
>  meson.build                                    | 2 +-
>  ndctl/dimm.c                                   | 2 +-
>  ndctl/lib/ars.c                                | 4 ++--
>  ndctl/lib/libndctl.c                           | 8 ++++----
>  ndctl/lib/papr_pdsm.h                          | 8 ++++----
>  ndctl/libndctl.h                               | 4 ++--
>  test/cxl-sanitize.sh                           | 2 +-
>  test/daxctl-create.sh                          | 4 ++--
>  test/daxctl-devices.sh                         | 4 ++--
>  test/libndctl.c                                | 2 +-
>  test/security.sh                               | 2 +-
>  util/parse-options.h                           | 6 +++---
>  util/strbuf.h                                  | 2 +-
>  21 files changed, 34 insertions(+), 34 deletions(-)
> 
> diff --git a/Documentation/cxl/cxl-reserve-dpa.txt b/Documentation/cxl/cxl-reserve-dpa.txt
> index 58cc93e..d51ccd6 100644
> --- a/Documentation/cxl/cxl-reserve-dpa.txt
> +++ b/Documentation/cxl/cxl-reserve-dpa.txt
> @@ -38,7 +38,7 @@ include::bus-option.txt[]
>  -t::
>  --type::
>  	Select the partition for the allocation. CXL devices implement a
> -	partition that divdes 'ram' and 'pmem' capacity, where 'pmem' capacity
> +	partition that divides 'ram' and 'pmem' capacity, where 'pmem' capacity
>  	consumes the higher DPA capacity above the partition boundary. The type
>  	defaults to 'pmem'. Note that given CXL DPA allocation constraints, once
>  	any 'pmem' allocation is established then all remaining 'ram' capacity
> diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> index 2a512fd..ce311b1 100644
> --- a/Documentation/cxl/lib/libcxl.txt
> +++ b/Documentation/cxl/lib/libcxl.txt
> @@ -296,7 +296,7 @@ use generic port APIs on root objects.
>  Ports are hierarchical. All but the a root object have another CXL port
>  as a parent object retrievable via cxl_port_get_parent().
>  
> -The root port of a hiearchy can be retrieved via any port instance in
> +The root port of a hierarchy can be retrieved via any port instance in
>  that hierarchy via cxl_port_get_bus().
>  
>  The host of a port is the corresponding device name of the PCIe Root
> diff --git a/Documentation/daxctl/daxctl-create-device.txt b/Documentation/daxctl/daxctl-create-device.txt
> index 05f4dbd..b774b86 100644
> --- a/Documentation/daxctl/daxctl-create-device.txt
> +++ b/Documentation/daxctl/daxctl-create-device.txt
> @@ -62,7 +62,7 @@ DESCRIPTION
>  -----------
>  
>  Creates dax device in 'devdax' mode in dynamic regions. The resultant can also
> -be convereted to the 'system-ram' mode which arranges for the dax range to be
> +be converted to the 'system-ram' mode which arranges for the dax range to be
>  hot-plugged into the system as regular memory.
>  
>  'daxctl create-device' expects that the BIOS or kernel defines a range in the
> diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
> index afb085e..3d0a2dd 100644
> --- a/Documentation/ndctl/ndctl-create-namespace.txt
> +++ b/Documentation/ndctl/ndctl-create-namespace.txt
> @@ -31,7 +31,7 @@ OPTIONS
>  -m::
>  --mode=::
>  	- "raw": expose the namespace capacity directly with
> -	  limitations. A raw pmem namepace namespace does not support
> +	  limitations. A raw pmem namespace does not support
>  	  sector atomicity (see "sector" mode below). A raw pmem
>  	  namespace may have limited to no dax support depending the
>  	  kernel. In other words operations like direct-I/O targeting a
> @@ -95,7 +95,7 @@ OPTIONS
>  	suffixes "k" or "K" for KiB, "m" or "M" for MiB, "g" or "G" for
>  	GiB and "t" or "T" for TiB.
>  
> -	For pmem namepsaces the size must be a multiple of the
> +	For pmem namespaces the size must be a multiple of the
>  	interleave-width and the namespace alignment (see
>  	below).
>  
> diff --git a/ccan/list/list.h b/ccan/list/list.h
> index 15f5fb7..eeaed16 100644
> --- a/ccan/list/list.h
> +++ b/ccan/list/list.h
> @@ -712,7 +712,7 @@ static inline void list_prepend_list_(struct list_head *to,
>   * @off: offset(relative to @i) at which list node data resides.
>   *
>   * This is a low-level wrapper to iterate @i over the entire list, used to
> - * implement all oher, more high-level, for-each constructs. It's a for loop,
> + * implement all other, more high-level, for-each constructs. It's a for loop,
>   * so you can break and continue as normal.
>   *
>   * WARNING! Being the low-level macro that it is, this wrapper doesn't know
> diff --git a/cxl/bus.c b/cxl/bus.c
> index 3321295..9ef04bc 100644
> --- a/cxl/bus.c
> +++ b/cxl/bus.c
> @@ -100,7 +100,7 @@ static int bus_action(int argc, const char **argv, struct cxl_ctx *ctx,
>  		if (sscanf(argv[i], "%lu", &id) == 1)
>  			continue;
>  
> -		log_err(&bl, "'%s' is not a valid bus identifer\n", argv[i]);
> +		log_err(&bl, "'%s' is not a valid bus identifier\n", argv[i]);
>  		err++;
>  	}
>  
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 5d97023..1da0c1e 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1785,7 +1785,7 @@ static void bus_invalidate(struct cxl_bus *bus)
>  	struct cxl_memdev *memdev;
>  
>  	/*
> -	 * Something happend to cause the state of all ports to be
> +	 * Something happened to cause the state of all ports to be
>  	 * indeterminate, delete them all and start over.
>  	 */
>  	cxl_memdev_foreach(ctx, memdev)
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index 6e44d15..58087de 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -650,7 +650,7 @@ param_size_to_volatile_size(const char *devname, enum cxl_setpart_type type,
>  }
>  
>  /*
> - * Return the volatile_size to use in the CXL set paritition
> + * Return the volatile_size to use in the CXL set partition
>   * command, or ULLONG_MAX if unable to validate the partition
>   * request.
>   */
> diff --git a/meson.build b/meson.build
> index 300eddb..56b7d48 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -173,7 +173,7 @@ keyutils = cc.find_library('keyutils', required : get_option('keyutils'))
>  
>  # iniparser lacks pkgconfig and its header files are either at '/usr/include' or '/usr/include/iniparser'
>  # Use the path provided by user via meson configure -Diniparserdir=<somepath>
> -# if thats not provided then try searching for 'iniparser.h' in default system include path
> +# if that's not provided then try searching for 'iniparser.h' in default system include path
>  # and if that not found then as a last resort try looking at '/usr/include/iniparser'
>  iniparser_headers = ['iniparser.h', 'dictionary.h']
>  
> diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> index aaa0abf..533ab04 100644
> --- a/ndctl/dimm.c
> +++ b/ndctl/dimm.c
> @@ -1074,7 +1074,7 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
>  	if (!param.crypto_erase && !param.overwrite) {
>  		param.crypto_erase = true;
>  		if (param.verbose)
> -			fprintf(stderr, "No santize method passed in, default to crypto-erase\n");
> +			fprintf(stderr, "No sanitize method passed in, default to crypto-erase\n");
>  	}
>  
>  	if (param.crypto_erase) {
> diff --git a/ndctl/lib/ars.c b/ndctl/lib/ars.c
> index d50c283..b705cf0 100644
> --- a/ndctl/lib/ars.c
> +++ b/ndctl/lib/ars.c
> @@ -70,7 +70,7 @@ static bool __validate_ars_cap(struct ndctl_cmd *ars_cap)
>  ({ \
>  	bool __valid = __validate_ars_cap(ars_cap); \
>  	if (!__valid) \
> -		dbg(ctx, "expected sucessfully completed ars_cap command\n"); \
> +		dbg(ctx, "expected successfully completed ars_cap command\n"); \
>  	__valid; \
>  })
>  
> @@ -224,7 +224,7 @@ static bool __validate_ars_stat(struct ndctl_cmd *ars_stat)
>  ({ \
>  	bool __valid = __validate_ars_stat(ars_stat); \
>  	if (!__valid) \
> -		dbg(ctx, "expected sucessfully completed ars_stat command\n"); \
> +		dbg(ctx, "expected successfully completed ars_stat command\n"); \
>  	__valid; \
>  })
>  
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index f75dbd4..dd3e802 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -50,7 +50,7 @@ NDCTL_EXPORT size_t ndctl_sizeof_namespace_index(void)
>  }
>  
>  /**
> - * ndctl_min_namespace_size - minimum namespace size that btt suports
> + * ndctl_min_namespace_size - minimum namespace size that btt supports
>   */
>  NDCTL_EXPORT size_t ndctl_min_namespace_size(void)
>  {
> @@ -3184,7 +3184,7 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_read(struct ndctl_cmd *cfg
>  
>  	if (cfg_size->type != ND_CMD_GET_CONFIG_SIZE
>  			|| cfg_size->status != 0) {
> -		dbg(ctx, "expected sucessfully completed cfg_size command\n");
> +		dbg(ctx, "expected successfully completed cfg_size command\n");
>  		return NULL;
>  	}
>  
> @@ -3275,7 +3275,7 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_write(struct ndctl_cmd *cf
>  	/* enforce rmw */
>  	if (cfg_read->type != ND_CMD_GET_CONFIG_DATA
>  		       || cfg_read->status != 0) {
> -		dbg(ctx, "expected sucessfully completed cfg_read command\n");
> +		dbg(ctx, "expected successfully completed cfg_read command\n");
>  		return NULL;
>  	}
>  
> @@ -4694,7 +4694,7 @@ NDCTL_EXPORT int ndctl_namespace_disable_safe(struct ndctl_namespace *ndns)
>  			 * Yes, TOCTOU hole, but if you're racing namespace
>  			 * creation you have other problems, and there's nothing
>  			 * stopping the !bdev case from racing to mount an fs or
> -			 * re-enabling the namepace.
> +			 * re-enabling the namespace.
>  			 */
>  			dbg(ctx, "%s: %s failed exclusive open: %s\n",
>  					devname, bdev, strerror(errno));
> diff --git a/ndctl/lib/papr_pdsm.h b/ndctl/lib/papr_pdsm.h
> index 20ac20f..6d808da 100644
> --- a/ndctl/lib/papr_pdsm.h
> +++ b/ndctl/lib/papr_pdsm.h
> @@ -44,7 +44,7 @@
>   *
>   * PDSM Header:
>   * This is papr-scm specific header that precedes the payload. This is defined
> - * as nd_cmd_pdsm_pkg.  Following fields aare available in this header:
> + * as nd_cmd_pdsm_pkg.  Following fields are available in this header:
>   *
>   * 'cmd_status'		: (Out) Errors if any encountered while servicing PDSM.
>   * 'reserved'		: Not used, reserved for future and should be set to 0.
> @@ -83,11 +83,11 @@
>   * Various flags indicate the health status of the dimm.
>   *
>   * extension_flags	: Any extension fields present in the struct.
> - * dimm_unarmed		: Dimm not armed. So contents wont persist.
> + * dimm_unarmed		: Dimm not armed. So contents won't persist.
>   * dimm_bad_shutdown	: Previous shutdown did not persist contents.
> - * dimm_bad_restore	: Contents from previous shutdown werent restored.
> + * dimm_bad_restore	: Contents from previous shutdown weren't restored.
>   * dimm_scrubbed	: Contents of the dimm have been scrubbed.
> - * dimm_locked		: Contents of the dimm cant be modified until CEC reboot
> + * dimm_locked		: Contents of the dimm can't be modified until CEC reboot
>   * dimm_encrypted	: Contents of dimm are encrypted.
>   * dimm_health		: Dimm health indicator. One of PAPR_PDSM_DIMM_XXXX
>   * dimm_fuel_gauge	: Life remaining of DIMM as a percentage from 0-100
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index 91ef0f4..5730edf 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -53,7 +53,7 @@ typedef unsigned char uuid_t[16];
>   *
>   * Notes:
>   * 1/ The object ids are not guaranteed to be stable from boot to boot
> - * 2/ While regions and busses are numbered in sequential/bus-discovery
> + * 2/ While regions and buses are numbered in sequential/bus-discovery
>   *    order, the resulting block devices may appear to have random ids.
>   *    Use static attributes of the devices/device-path to generate a
>   *    persistent name.
> @@ -258,7 +258,7 @@ int ndctl_cmd_ars_stat_get_flag_overflow(struct ndctl_cmd *ars_stat);
>  
>  /*
>   * the ndctl.h definition of these are deprecated, libndctl.h is the
> - * authoritative defintion.
> + * authoritative definition.
>   */
>  #define ND_SMART_HEALTH_VALID	(1 << 0)
>  #define ND_SMART_SPARES_VALID	(1 << 1)
> diff --git a/test/cxl-sanitize.sh b/test/cxl-sanitize.sh
> index 9c16101..10f07f0 100644
> --- a/test/cxl-sanitize.sh
> +++ b/test/cxl-sanitize.sh
> @@ -64,7 +64,7 @@ done
>  [ -z $inactive ] && err $LINENO
>  
>  # kickoff a background sanitize and make sure the wait takes a couple
> -# secounds
> +# seconds
>  set_timeout $inactive 3000
>  start=$SECONDS
>  echo 1 > /sys/bus/cxl/devices/${inactive}/security/sanitize &
> diff --git a/test/daxctl-create.sh b/test/daxctl-create.sh
> index 954a112..ee3756b 100755
> --- a/test/daxctl-create.sh
> +++ b/test/daxctl-create.sh
> @@ -279,7 +279,7 @@ daxctl_test_adjust()
>  }
>  
>  # Test 0:
> -# Sucessfully zero out the region device and allocate the whole space again.
> +# Successfully zero out the region device and allocate the whole space again.
>  daxctl_test0()
>  {
>  	clear_dev
> @@ -287,7 +287,7 @@ daxctl_test0()
>  }
>  
>  # Test 1:
> -# Sucessfully creates and destroys a device with the whole available space
> +# Successfully creates and destroys a device with the whole available space
>  daxctl_test1()
>  {
>  	local daxdev
> diff --git a/test/daxctl-devices.sh b/test/daxctl-devices.sh
> index dfce74b..659428d 100755
> --- a/test/daxctl-devices.sh
> +++ b/test/daxctl-devices.sh
> @@ -117,7 +117,7 @@ daxctl_test()
>  	if ! "$NDCTL" disable-namespace "$testdev"; then
>  		echo "disable-namespace failed as expected"
>  	else
> -		echo "disable-namespace succeded, expected failure"
> +		echo "disable-namespace succeeded, expected failure"
>  		echo "reboot required to recover from this state"
>  		return 1
>  	fi
> @@ -130,7 +130,7 @@ daxctl_test()
>  	if ! "$DAXCTL" reconfigure-device -N -m system-ram "$daxdev"; then
>  		echo "reconfigure failed as expected"
>  	else
> -		echo "reconfigure succeded, expected failure"
> +		echo "reconfigure succeeded, expected failure"
>  		restore_online_policy
>  		return 1
>  	fi
> diff --git a/test/libndctl.c b/test/libndctl.c
> index 858110c..0c7115b 100644
> --- a/test/libndctl.c
> +++ b/test/libndctl.c
> @@ -1617,7 +1617,7 @@ static int check_namespaces(struct ndctl_region *region,
>  			 * On the second time through this loop we skip
>  			 * establishing btt|pfn since
>  			 * check_{btt|pfn}_autodetect() destroyed the
> -			 * inital instance.
> +			 * initial instance.
>  			 */
>  			if (mode == BTT) {
>  				btt_s = namespace->do_configure > 0
> diff --git a/test/security.sh b/test/security.sh
> index d3a840c..4112d88 100755
> --- a/test/security.sh
> +++ b/test/security.sh
> @@ -250,7 +250,7 @@ echo "Test 5, freeze security"
>  test_5_security_freeze
>  
>  # Load-keys is independent of actual nvdimm security and is part of key
> -# mangement testing.
> +# management testing.
>  echo "Test 6, test load-keys"
>  test_6_load_keys
>  
> diff --git a/util/parse-options.h b/util/parse-options.h
> index 9318fe7..14e87a9 100644
> --- a/util/parse-options.h
> +++ b/util/parse-options.h
> @@ -75,7 +75,7 @@ typedef int parse_opt_cb(const struct option *, const char *arg, int unset);
>   *
>   * `flags`::
>   *   mask of parse_opt_option_flags.
> - *   PARSE_OPT_OPTARG: says that the argument is optionnal (not for BOOLEANs)
> + *   PARSE_OPT_OPTARG: says that the argument is optional (not for BOOLEANs)
>   *   PARSE_OPT_NOARG: says that this option takes no argument, for CALLBACKs
>   *   PARSE_OPT_NONEG: says that this option cannot be negated
>   *   PARSE_OPT_HIDDEN this option is skipped in the default usage, showed in
> @@ -141,7 +141,7 @@ struct option {
>  	.flags = PARSE_OPT_LASTARG_DEFAULT | PARSE_OPT_NOARG}
>  
>  /* parse_options() will filter out the processed options and leave the
> - * non-option argments in argv[].
> + * non-option arguments in argv[].
>   * Returns the number of arguments left in argv[].
>   */
>  extern int parse_options(int argc, const char **argv,
> @@ -160,7 +160,7 @@ extern int parse_options_subcommand(int argc, const char **argv,
>  extern NORETURN void usage_with_options(const char * const *usagestr,
>                                          const struct option *options);
>  
> -/*----- incremantal advanced APIs -----*/
> +/*----- incremental advanced APIs -----*/
>  
>  enum {
>  	PARSE_OPT_HELP = -1,
> diff --git a/util/strbuf.h b/util/strbuf.h
> index 3f810a5..614e58b 100644
> --- a/util/strbuf.h
> +++ b/util/strbuf.h
> @@ -19,7 +19,7 @@
>   *    build complex strings/buffers whose final size isn't easily known.
>   *
>   *    It is NOT legal to copy the ->buf pointer away.
> - *    `strbuf_detach' is the operation that detachs a buffer from its shell
> + *    `strbuf_detach' is the operation that detaches a buffer from its shell
>   *    while keeping the shell valid wrt its invariants.
>   *
>   * 2. the ->buf member is a byte array that has at least ->len + 1 bytes

