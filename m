Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FFC1D63C7
	for <nvdimm@lists.linux.dev>; Wed, 22 Oct 2025 17:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153747; cv=none; b=McDa8SUZ9iWLW8AyW3Q8BHHZGbSDI5IVC8ADe19IG2/xIs9Divq3tUhJT6ozqSTN6Ba7oXTKXKJqvkOhoc9l0UOaAfoZDgQykQOWq8XRtn4L9YOCIFndcXkKS1GQ2qcrXWqYi9xhE7YDs1baRHHIFCG6pdZ+fxlv1jqu6ogRFtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153747; c=relaxed/simple;
	bh=gXytS0kIbg67VrR4iTAET5yHSHxTYUQsHwV0EMO9Oes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WsywKQLMzxZflcEZ3SvzMIO5rEOK68vqgwY9adwQlxo/czecunenbm4zh+x/nJmFFysxFH31oqOFYUsmhK+9IfWdaNIpK2DyQ2nOxgajuNY+4G1KNQ7A+PFVFDE6BkYPaerZVYWUAL2ZyhjXFqTBlqH27cirBkOAGG2md/Vyuws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AG9TuD1u; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AG9TuD1u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761153746; x=1792689746;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gXytS0kIbg67VrR4iTAET5yHSHxTYUQsHwV0EMO9Oes=;
  b=AG9TuD1ufbvo9RMADBkuxVkZA/MOZZ12G0ggpOPFhGOkoihyHUu78CGL
   meDboqN1QA6d63TXZuBkMAOWebCIOk4f6YBVbSKLTMjAVh1Q2s2RQMUzG
   R6NweFlD5cDcnWj9sHly4lscFq0OEzc5cOVYmqmfYXxPuJWWULlazmouq
   TFMLiCTfYWSZmThlVYKnvzivq/vL7ZclMDFgftXvIOAsFaugaZ0SYwR6u
   mPF8nWh+68bLiHAg6WAMqIrCc/9OC1aMLjsfoh0DLvCbyTeIbfWj2epVB
   F2m5rkKN7O0k9u444QkTYL1kSEwERMzUtvdTU3eFoXa40ycL5khcnYlTT
   A==;
X-CSE-ConnectionGUID: Qte1BWuCSDKXXkEN6JMp/w==
X-CSE-MsgGUID: lS6BMZqFRa+LVwvHRGyzhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63233721"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63233721"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 10:22:26 -0700
X-CSE-ConnectionGUID: kOKjPqD3Tf2mjZrl+hEXhg==
X-CSE-MsgGUID: vzywaNKcS9iQesKnyHOOlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="183518755"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.108.213]) ([10.125.108.213])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 10:22:25 -0700
Message-ID: <47cbf704-78dc-437e-a3de-e446c89b914d@intel.com>
Date: Wed, 22 Oct 2025 10:22:24 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v3 7/7] Documentation: Add docs for
 inject/clear-error commands
To: Ben Cheatham <Benjamin.Cheatham@amd.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, alison.schofield@intel.com
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
 <20251021183124.2311-8-Benjamin.Cheatham@amd.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251021183124.2311-8-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/21/25 11:31 AM, Ben Cheatham wrote:
> Add man pages for the 'cxl-inject-error' and 'cxl-clear-error' commands.
> These man pages show usage and examples for each of their use cases.
> 
> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>> ---
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

