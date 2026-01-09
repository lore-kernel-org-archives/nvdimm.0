Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A007331B131
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 22:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767997511; cv=none; b=TDgkDH16H4d8nOPKDKBfL23otaO/WG6SaHDMafWHhyoMm6bmMfNlKtWWcurOnkGjK11OJalhfPnk8MA4ZGDKSP6mo/luvLJNj/qtmfNNMbDjwEr3BvjDcQXLsORe7UMeHNudZJo0dFcChwerCswTETaa9C2EoAGrKq+OrK3s+3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767997511; c=relaxed/simple;
	bh=R4VAJ4IpEZzBcYToQnMWMEpwx4O6SED6+TU61CqI/Cw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LgoUxIcp79hyIvRUInkqnBMtXRe4emmO6uUTkF9rWfVnU3+yb1FSNTba+uKH4nLzZQz+bKd41tXS4pwFDfkA2IQ8w9sF3pXxChd6ttJuGTsd0dbbUjKb3BcC80QpOkknQXjmRFEBgaPjCiIMQkQgw7JxRmsMTmtvVngN3i1s3N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AYhttv2b; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AYhttv2b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767997509; x=1799533509;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=R4VAJ4IpEZzBcYToQnMWMEpwx4O6SED6+TU61CqI/Cw=;
  b=AYhttv2byv78RH2zIRfm+/cgD6kaSg2CTPe8jb7+xEZnE9pT9eTQceyQ
   5c2/nSVUGPQXs7jDgE3jTVVdZauZeY/3thNK8+gIsSSi6dKpmdad3PFhP
   TrTLrwzQwhZxCEJjV5Wo4alWr/QfxzkuYBCcwZPOQYBPBn5J4Az5feqaE
   ktFXP1sc/AeFostbKOwhGOCMOjvd3/GKZirZ+6Rr3sWDqSyArQg/2vr1s
   60kk0Z0YgiqbbfR5LHagbYk0r6XEaDOaJkf+hBx6EfEcAhPXppASAOb1c
   yojRmVi3+Cw26UCEhAFUmJKb2LZZKC/BWpD5m+LrR1AzcV8uPRUdOhkmW
   w==;
X-CSE-ConnectionGUID: 0dOgXryDTJSBq/gmDgGA3Q==
X-CSE-MsgGUID: k9qnUUdrRGex7KnS1X2vBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="69294036"
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="69294036"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 14:25:09 -0800
X-CSE-ConnectionGUID: IodM1rCdQwixJTVf1/T5Zg==
X-CSE-MsgGUID: K6SDBmE8QHONRn7sEBfYHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="208057508"
Received: from agladkov-desk.ger.corp.intel.com (HELO [10.125.110.37]) ([10.125.110.37])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 14:25:08 -0800
Message-ID: <6a618827-7763-44ba-a4df-b38afacccfab@intel.com>
Date: Fri, 9 Jan 2026 15:25:07 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] Documentation: Add docs for inject/clear-error
 commands
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev,
 alison.schofield@intel.com
Cc: linux-cxl@vger.kernel.org
References: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
 <20260109160720.1823-8-Benjamin.Cheatham@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260109160720.1823-8-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/9/26 9:07 AM, Ben Cheatham wrote:
> Add man pages for the 'cxl-inject-error' and 'cxl-clear-error' commands.
> These man pages show usage and examples for each of their use cases.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  Documentation/cxl/cxl-clear-error.txt  |  69 +++++++++++
>  Documentation/cxl/cxl-inject-error.txt | 161 +++++++++++++++++++++++++
>  Documentation/cxl/meson.build          |   2 +
>  3 files changed, 232 insertions(+)
>  create mode 100644 Documentation/cxl/cxl-clear-error.txt
>  create mode 100644 Documentation/cxl/cxl-inject-error.txt
> 
> diff --git a/Documentation/cxl/cxl-clear-error.txt b/Documentation/cxl/cxl-clear-error.txt
> new file mode 100644
> index 0000000..9d77855
> --- /dev/null
> +++ b/Documentation/cxl/cxl-clear-error.txt
> @@ -0,0 +1,69 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-clear-error(1)
> +==================
> +
> +NAME
> +----
> +cxl-clear-error - Clear CXL errors from CXL devices
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl clear-error' <device name> [<options>]
> +
> +Clear an error from a CXL device. The types of devices supported are:
> +
> +"memdevs":: A CXL memory device. Memory devices are specified by device
> +name ("mem0"), device id ("0") and/or host device name ("0000:35:00.0").
> +
> +Only device poison (viewable using the '-L'/'--media-errors' option of
> +'cxl-list') can be cleared from a device using this command. For example:
> +
> +----
> +
> +# cxl list -m mem0 -L -u
> +{
> +  "memdev":"mem0",
> +  "ram_size":"1024.00 MiB (1073.74 MB)",
> +  "ram_qos_class":42,
> +  "serial":"0x0",
> +  "numa_node:1,
> +  "host":"0000:35:00.0",
> +  "media_errors":[
> +    {
> +	  "offset":"0x1000",
> +	  "length":64,
> +	  "source":"Injected"
> +	}
> +  ]
> +}
> +
> +# cxl clear-error mem0 -a 0x1000
> +poison cleared at mem0:0x1000
> +
> +# cxl list -m mem0 -L -u
> +{
> +  "memdev":"mem0",
> +  "ram_size":"1024.00 MiB (1073.74 MB)",
> +  "ram_qos_class":42,
> +  "serial":"0x0",
> +  "numa_node:1,
> +  "host":"0000:35:00.0",
> +  "media_errors":[
> +  ]
> +}
> +
> +----
> +
> +This command depends on the kernel debug filesystem (debugfs) to clear device poison.
> +
> +OPTIONS
> +-------
> +-a::
> +--address::
> +	Device physical address (DPA) to clear poison from. Address can be specified
> +	in hex or decimal. Required for clearing poison.
> +
> +--debug::
> +	Enable debug output
> diff --git a/Documentation/cxl/cxl-inject-error.txt b/Documentation/cxl/cxl-inject-error.txt
> new file mode 100644
> index 0000000..80d03be
> --- /dev/null
> +++ b/Documentation/cxl/cxl-inject-error.txt
> @@ -0,0 +1,161 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-inject-error(1)
> +===================
> +
> +NAME
> +----
> +cxl-inject-error - Inject CXL errors into CXL devices
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl inject-error' <device name> [<options>]
> +
> +WARNING: Error injection can cause system instability and should only be used
> +for debugging hardware and software error recovery flows. Use at your own risk!
> +
> +Inject an error into a CXL device. The type of errors supported depend on the
> +device specified. The types of devices supported are:
> +
> +"Downstream Ports":: A CXL RCH downstream port (dport) or a CXL VH root port.
> +Eligible ports will have their 'protocol_injectable' attribute in 'cxl-list'
> +set to true. Dports are specified by host name ("0000:0e:01.1").
> +"memdevs":: A CXL memory device. Memory devices are specified by device name
> +("mem0"), device id ("0"), and/or host device name ("0000:35:00.0").
> +
> +There are two types of errors which can be injected: CXL protocol errors
> +and device poison.
> +
> +CXL protocol errors can only be used with downstream ports (as defined above).
> +Protocol errors follow the format of "<protocol>-<severity>". For example,
> +a "mem-fatal" error is a CXL.mem fatal protocol error. Protocol errors can be
> +found in the "injectable_protocol_errors" list under a CXL bus object. This
> +list is only available when the CXL debugfs is accessible (normally mounted
> +at "/sys/kernel/debug/cxl"). For example:
> +
> +----
> +
> +# cxl list -B
> +[
> +  {
> +	"bus":"root0",
> +	"provider":"ACPI.CXL",
> +	"injectable_protocol_errors":[
> +	  "mem-correctable",
> +	  "mem-fatal",
> +	]
> +  }
> +]
> +
> +----
> +
> +CXL protocol (CXL.cache/mem) error injection requires the platform to support
> +ACPI v6.5+ error injection (EINJ). In addition to platform support, the
> +CONFIG_ACPI_APEI_EINJ and CONFIG_ACPI_APEI_EINJ_CXL kernel configuration options
> +will need to be enabled. For more information, view the Linux kernel documentation
> +on EINJ. Example using the bus output above:
> +
> +----
> +
> +# cxl list -TP
> + [
> +  {
> +    "port":"port1",
> +    "host":"pci0000:e0",
> +    "depth":1,
> +    "decoders_committed":1,
> +    "nr_dports":1,
> +    "dports":[
> +      {
> +        "dport":"0000:e0:01.1",
> +        "alias":"device:02",
> +        "id":0,
> +        "protocol_injectable":true
> +      }
> +    ]
> +  }
> +]
> +
> +# cxl inject-error "0000:e0:01.1" -t mem-correctable
> +cxl inject-error: inject_proto_err: injected mem-correctable protocol error.
> +
> +----
> +
> +Device poison can only by used with CXL memory devices. A device physical address
> +(DPA) is required to do poison injection. DPAs range from 0 to the size of
> +device's memory, which can be found using 'cxl-list'. An example injection:
> +
> +----
> +
> +# cxl inject-error mem0 -t poison -a 0x1000
> +poison injected at mem0:0x1000
> +# cxl list -m mem0 -u --media-errors
> +{
> +  "memdev":"mem0",
> +  "ram_size":"256.00 MiB (268.44 MB)",
> +  "serial":"0",
> +  "host":"0000:0d:00.0",
> +  "firmware_version":"BWFW VERSION 00",
> +  "media_errors":[
> +    {
> +      "offset":"0x1000",
> +      "length":64,
> +      "source":"Injected"
> +    }
> +  ]
> +}
> +
> +----
> +
> +Not all memory devices support poison injection. To see if a device supports
> +poison injection through debugfs, use 'cxl-list' look for the "poison-injectable"
> +attribute under the device. This attribute is only available when the CXL debugfs
> +is accessible. Example:
> +
> +----
> +
> +# cxl list -u -m mem0
> +{
> +  "memdev":"mem0",
> +  "ram_size":"256.00 MiB (268.44 MB)",
> +  "serial":"0",
> +  "host":"0000:0d:00.0",
> +  "firmware_version":"BWFW VERSION 00",
> +  "poison_injectable":true
> +}
> +
> +----
> +
> +This command depends on the kernel debug filesystem (debugfs) to do CXL protocol
> +error and device poison injection.
> +
> +OPTIONS
> +-------
> +-a::
> +--address::
> +	Device physical address (DPA) to use for poison injection. Address can
> +	be specified in hex or decimal. Required for poison injection.
> +
> +-t::
> +--type::
> +	Type of error to inject into <device name>. The type of error is restricted
> +	by device type. The following shows the possible types under their associated
> +	device type(s):
> +----
> +
> +Downstream Ports: ::
> +	cache-correctable, cache-uncorrectable, cache-fatal, mem-correctable,
> +	mem-uncorrectable, mem-fatal
> +
> +Memdevs: ::
> +	poison
> +
> +----
> +
> +--debug::
> +	Enable debug output
> +
> +SEE ALSO
> +--------
> +linkcxl:cxl-list[1]
> diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
> index 8085c1c..0b75eed 100644
> --- a/Documentation/cxl/meson.build
> +++ b/Documentation/cxl/meson.build
> @@ -50,6 +50,8 @@ cxl_manpages = [
>    'cxl-update-firmware.txt',
>    'cxl-set-alert-config.txt',
>    'cxl-wait-sanitize.txt',
> +  'cxl-inject-error.txt',
> +  'cxl-clear-error.txt',
>  ]
>  
>  foreach man : cxl_manpages

