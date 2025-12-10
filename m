Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98213B8D7E
	for <nvdimm@lists.linux.dev>; Wed, 10 Dec 2025 20:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765397743; cv=none; b=GHGrsTdP3X0Ifxf7GY0E2Xl0hQzZQErCewHPWjdPyglbB+UkAnmAmj2rKKSZd1/TUOYB6CFr92fRirlZLPzPGpf9Of4ucjfR/GGUHCYvpxxLdO9zT3gha4IoQlx9BNb5SBl4+YRxTQtMrrUOzwDxTmBSn4nZx4mPVsRySwkSjpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765397743; c=relaxed/simple;
	bh=tV3oMlA0Z5DOtgs7fdLa6knDDM5IomrhZ40mq+zm9Sg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TnUAnYafyCYCxBDZ8vNDz+toi7vGVCN0SrHSj1QpqxbByGB7Lt8M294Dg3y2LDh8XDqOFrU24c4y3s4EN/3kgAXXXEsZZL9bPvdsk2dLl0xsBgHqyvSl3FtJ7aBkxylutbOvX6Y7fWsQGE7pPUlZfLrBnr5fh7AIwpqXmWvhg2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NhVdzJ6j; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NhVdzJ6j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765397742; x=1796933742;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tV3oMlA0Z5DOtgs7fdLa6knDDM5IomrhZ40mq+zm9Sg=;
  b=NhVdzJ6jQI6+yrlIGPBGkPd+fwxkZHwuhxasmbDsTMMQp4ZRRaTh1Mn9
   ef3uDAVvI+WQfWibGCix8ul7vzPP2Xi6tCahmkrxdfAUjAvLxk5n1I2Yg
   Ba6HYMbrwCaygpp8ivkDDFbjgJ9o36lI2b1bpH4UoKwCfU+2SPUA5tq6M
   bqCRC9MW17V8HAEaeC1BfIH6T6mcQAHP4gYjBzrPeN2X0PrAWXCoxFB5T
   jMPO4FGo5aPgRNZHtVFANe+4gUnHosgvkFARIsiqiO2wE+iooaDBvJiJE
   QUOcYxhYlhB5c877ofCftlU+4ChmI65ZLWBcAUfHuJb5edlGIN6QK8HFg
   Q==;
X-CSE-ConnectionGUID: 8PcFyMgJR1mJSm3P2XOL6w==
X-CSE-MsgGUID: r4MnU7keQhqT9OYlpGxy2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67264061"
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="67264061"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 12:15:41 -0800
X-CSE-ConnectionGUID: ndPiyr3XS/ilnJA3HhEV4Q==
X-CSE-MsgGUID: Bx2UcBr4QVqsSVHg62NOFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="200769365"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.138]) ([10.125.109.138])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 12:15:41 -0800
Message-ID: <7a74d3a7-9f04-4d94-a48f-5085d5c7e7f9@intel.com>
Date: Wed, 10 Dec 2025 13:15:40 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] Documentation: Add docs for inject/clear-error
 commands
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, alison.schofield@intel.com
References: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
 <20251209171404.64412-8-Benjamin.Cheatham@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20251209171404.64412-8-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/9/25 10:14 AM, Ben Cheatham wrote:
> Add man pages for the 'cxl-inject-error' and 'cxl-clear-error' commands.
> These man pages show usage and examples for each of their use cases.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  Documentation/cxl/cxl-clear-error.txt  |  67 +++++++++++++
>  Documentation/cxl/cxl-inject-error.txt | 129 +++++++++++++++++++++++++
>  Documentation/cxl/meson.build          |   2 +
>  3 files changed, 198 insertions(+)
>  create mode 100644 Documentation/cxl/cxl-clear-error.txt
>  create mode 100644 Documentation/cxl/cxl-inject-error.txt
> 
> diff --git a/Documentation/cxl/cxl-clear-error.txt b/Documentation/cxl/cxl-clear-error.txt
> new file mode 100644
> index 0000000..ccb0e63
> --- /dev/null
> +++ b/Documentation/cxl/cxl-clear-error.txt
> @@ -0,0 +1,67 @@
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
> index 0000000..e1bebd7
> --- /dev/null
> +++ b/Documentation/cxl/cxl-inject-error.txt
> @@ -0,0 +1,129 @@
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
> +Inject an error into a CXL device. The type of errors supported depend on the
> +device specified. The types of devices supported are:
> +
> +"Downstream Ports":: A CXL RCH downstream port (dport) or a CXL VH root port.
> +Eligible CXL 2.0+ ports are dports of ports at depth 1 in the output of cxl-list.
> +Dports are specified by host name ("0000:0e:01.1").
> +"memdevs":: A CXL memory device. Memory devices are specified by device name
> +("mem0"), device id ("0"), and/or host device name ("0000:35:00.0").
> +
> +There are two types of errors which can be injected: CXL protocol errors
> +and device poison.
> +
> +CXL protocol errors can only be used with downstream ports (as defined above).
> +Protocol errors follow the format of "<protocol>-<severity>". For example,
> +a "mem-fatal" error is a CXL.mem fatal protocol error. Protocol errors can be
> +found with the '-N' option of 'cxl-list' under a CXL bus object. For example:
> +
> +----
> +
> +# cxl list -NB
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
> +on EINJ.
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
> +Not all devices support poison injection. To see if a device supports poison injection
> +through debugfs, use 'cxl-list' with the '-N' option and look for the "poison-injectable"
> +attribute under the device. Example:
> +
> +----
> +
> +# cxl list -Nu -m mem0
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
> +	mem-fatal
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

