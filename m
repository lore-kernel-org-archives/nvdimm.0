Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E196286417
	for <nvdimm@lists.linux.dev>; Thu, 23 Oct 2025 22:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761259906; cv=none; b=CageZgDARX73tcbyae9APDKDIdg1TVPUbNJ2Y+FGbUax1valYKeUm56BQwcG/GZ8MGQIiLDLZafverNH0f+/6gWwvFCc74qYlXE2FXN+2oH3a/nXYhcAA61lDWslx7TbT4jHrjR9+EemUQuTAbEm9yABB9d4e+rWQBmIhRKSNSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761259906; c=relaxed/simple;
	bh=5PThRZip1BNayZu2LLm1vDMhiRLP4wrSMxHd5fXVaW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jPCIpotJhG4/UWnm8JWS+gpnqjyKY242j9FPgDlkKM5C24O6qGs34P09SgaDxRlACJucZ6klwFhKa4yyOQ72dFyOEvMsYDoKOSQ8le56+aRES0OkBQECN6HOX75WVeujoWujhRd+oFXXA0T1nP6sL2apdm6/RVYsPw7QC2flQQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QuW4owhB; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QuW4owhB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761259905; x=1792795905;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5PThRZip1BNayZu2LLm1vDMhiRLP4wrSMxHd5fXVaW0=;
  b=QuW4owhBZbFEiCzvRcAozO9QnvmB4zZvlld/lA1MgavPmq/EWUa35yuv
   3BnjionjBcFWE1Q2V31WA9P6kMtuk3Tnoa8zK6bpfOUmiD+OU/nH+z2vX
   /Tfce7PhAfNV0k2U+lhp3ytEAelYVOMd5AxxTvznwFv8OMr5hBuTAQ88A
   etDqfT6AH6uWt8khpV0FMsXGi0RMl6tkwEa8hr9bYm+/byZ42UmOT4zT3
   Cp+q0F6wBZVdbyb9kW0RQV7r7lp2BHi+a7GIkKE1xg0ERlnjh1iLkzMdw
   nfRb7xcl911fhfY1TwaKnZ9YtV+8xCHtIcBYL5b2PM4Kvs7DaAv9TqcDw
   g==;
X-CSE-ConnectionGUID: JYOSTuI+RpyBWHWTZ1kzrg==
X-CSE-MsgGUID: pqH8jtM8Sy6uN7XIERJF1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74881988"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="74881988"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 15:51:45 -0700
X-CSE-ConnectionGUID: k8P7I+4NRMWjfPeOEZv0Kw==
X-CSE-MsgGUID: 2uwRqUFpQaODfYdVlRoW0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="183457553"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.109.4]) ([10.125.109.4])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 15:51:45 -0700
Message-ID: <698d06a4-f5fb-4995-819a-6664c67e0b1c@intel.com>
Date: Thu, 23 Oct 2025 15:51:42 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v3 4/7] cxl: Add inject-error command
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, alison.schofield@intel.com
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
 <20251021183124.2311-5-Benjamin.Cheatham@amd.com>
 <5d3337cd-94c4-4d5e-beb6-219058af11a5@intel.com>
 <33c55070-35f4-4aec-afd1-33197b368d80@amd.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <33c55070-35f4-4aec-afd1-33197b368d80@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/23/25 1:15 PM, Cheatham, Benjamin wrote:
> On 10/22/2025 12:06 PM, Dave Jiang wrote:
>>
>>
>> On 10/21/25 11:31 AM, Ben Cheatham wrote:
>>> Add the 'cxl-inject-error' command. This command will provide CXL
>>> protocol error injection for CXL VH root ports and CXL RCH downstream
>>> ports, as well as poison injection for CXL memory devices.
>>>
>>> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
>>> ---
>>>  cxl/builtin.h      |   1 +
>>>  cxl/cxl.c          |   1 +
>>>  cxl/inject-error.c | 195 +++++++++++++++++++++++++++++++++++++++++++++
>>>  cxl/meson.build    |   1 +
>>>  4 files changed, 198 insertions(+)
>>>  create mode 100644 cxl/inject-error.c
>>>
>>> diff --git a/cxl/builtin.h b/cxl/builtin.h
>>> index c483f30..e82fcb5 100644
>>> --- a/cxl/builtin.h
>>> +++ b/cxl/builtin.h
>>> @@ -25,6 +25,7 @@ int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
>>>  int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
>>>  int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
>>>  int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
>>> +int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx);
>>>  #ifdef ENABLE_LIBTRACEFS
>>>  int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx);
>>>  #else
>>> diff --git a/cxl/cxl.c b/cxl/cxl.c
>>> index 1643667..a98bd6b 100644
>>> --- a/cxl/cxl.c
>>> +++ b/cxl/cxl.c
>>> @@ -80,6 +80,7 @@ static struct cmd_struct commands[] = {
>>>  	{ "disable-region", .c_fn = cmd_disable_region },
>>>  	{ "destroy-region", .c_fn = cmd_destroy_region },
>>>  	{ "monitor", .c_fn = cmd_monitor },
>>> +	{ "inject-error", .c_fn = cmd_inject_error },
>>>  };
>>>  
>>>  int main(int argc, const char **argv)
>>> diff --git a/cxl/inject-error.c b/cxl/inject-error.c
>>> new file mode 100644
>>> index 0000000..c48ea69
>>> --- /dev/null
>>> +++ b/cxl/inject-error.c
>>> @@ -0,0 +1,195 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/* Copyright (C) 2025 AMD. All rights reserved. */
>>> +#include <util/parse-options.h>
>>> +#include <cxl/libcxl.h>
>>> +#include <cxl/filter.h>
>>> +#include <util/log.h>
>>> +#include <stdlib.h>
>>> +#include <unistd.h>
>>> +#include <stdio.h>
>>> +#include <errno.h>
>>> +#include <limits.h>
>>> +
>>> +#define EINJ_TYPES_BUF_SIZE 512
>>> +
>>> +static bool debug;
>>> +
>>> +static struct inject_params {
>>> +	const char *type;
>>> +	const char *address;
>>> +} inj_param;
>>> +
>>> +static const struct option inject_options[] = {
>>> +	OPT_STRING('t', "type", &inj_param.type, "Error type",
>>> +		   "Error type to inject into <device>"),
>>> +	OPT_STRING('a', "address", &inj_param.address, "Address for poison injection",
>>> +		   "Device physical address for poison injection in hex or decimal"),
>>> +#ifdef ENABLE_DEBUG
>>> +	OPT_BOOLEAN(0, "debug", &debug, "turn on debug output"),
>>> +#endif
>>> +	OPT_END(),
>>> +};
>>> +
>>> +static struct log_ctx iel;
>>> +
>>> +static struct cxl_protocol_error *find_cxl_proto_err(struct cxl_ctx *ctx,
>>> +						     const char *type)
>>> +{
>>> +	struct cxl_protocol_error *perror;
>>> +
>>> +	cxl_protocol_error_foreach(ctx, perror) {
>>> +		if (strcmp(type, cxl_protocol_error_get_str(perror)) == 0)
>>> +			return perror;
>>> +	}
>>> +
>>> +	log_err(&iel, "Invalid CXL protocol error type: %s\n", type);
>>> +	return NULL;
>>> +}
>>> +
>>> +static struct cxl_dport *find_cxl_dport(struct cxl_ctx *ctx, const char *devname)
>>> +{
>>> +	struct cxl_port *port, *top;
>>> +	struct cxl_dport *dport;
>>> +	struct cxl_bus *bus;
>>> +
>>> +	cxl_bus_foreach(ctx, bus) {
>>> +		top = cxl_bus_get_port(bus);
>>> +
>>> +		cxl_port_foreach_all(top, port)
>>> +			cxl_dport_foreach(port, dport)
>>> +				if (!strcmp(devname,
>>> +					    cxl_dport_get_devname(dport)))
>>> +					return dport;
>>
>> Would it be worthwhile to create a util_cxl_dport_filter()?
>>
> 
> Yeah probably. I'll make one for the next revision.
> 
>>> +	}
>>> +
>>> +	log_err(&iel, "Downstream port \"%s\" not found\n", devname);
>>> +	return NULL;
>>> +}
>>> +
>>> +static struct cxl_memdev *find_cxl_memdev(struct cxl_ctx *ctx,
>>> +					  const char *filter)
>>> +{
>>> +	struct cxl_memdev *memdev;
>>> +
>>> +	cxl_memdev_foreach(ctx, memdev) {
>>> +		if (util_cxl_memdev_filter(memdev, filter, NULL))
>>> +			return memdev;
>>> +	}
>>> +
>>> +	log_err(&iel, "Memdev \"%s\" not found\n", filter);
>>> +	return NULL;
>>> +}
>>> +
>>> +static int inject_proto_err(struct cxl_ctx *ctx, const char *devname,
>>> +			    struct cxl_protocol_error *perror)
>>> +{
>>> +	struct cxl_dport *dport;
>>> +	int rc;
>>> +
>>> +	if (!devname) {
>>> +		log_err(&iel, "No downstream port specified for injection\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	dport = find_cxl_dport(ctx, devname);
>>> +	if (!dport)
>>> +		return -ENODEV;
>>> +
>>> +	rc = cxl_dport_protocol_error_inject(dport,
>>> +					     cxl_protocol_error_get_num(perror));
>>> +	if (rc)
>>> +		return rc;
>>> +
>>> +	printf("injected %s protocol error.\n",
>>> +	       cxl_protocol_error_get_str(perror));
>>
>> log_info() maybe?
> 
> I think I had it as log_info() before, but I don't think it was making it's way to
> the console. I think I wanted the console output because I personally don't like running
> silent commands. Not a great reason, so I'm fine with changing it if that's the preferred
> way.
> 

Alison,
Do you have a preference?

DJ

>>
>>> +	return 0;
>>> +}
>>> +
>>> +static int poison_action(struct cxl_ctx *ctx, const char *filter,
>>> +			 const char *addr)
>>> +{
>>> +	struct cxl_memdev *memdev;
>>> +	size_t a;
>>
>> Maybe rename 'addr' to 'addr_str' and rename 'a' to 'addr'
>>
> 
> Sure.
> 
>>> +	int rc;
>>> +
>>> +	memdev = find_cxl_memdev(ctx, filter);
>>> +	if (!memdev)
>>> +		return -ENODEV;
>>> +
>>> +	if (!cxl_memdev_has_poison_injection(memdev)) {
>>> +		log_err(&iel, "%s does not support error injection\n",
>>> +			cxl_memdev_get_devname(memdev));
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if (!addr) {
>>> +		log_err(&iel, "no address provided\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	a = strtoull(addr, NULL, 0);
>>> +	if (a == ULLONG_MAX && errno == ERANGE) {
>>> +		log_err(&iel, "invalid address %s", addr);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	rc = cxl_memdev_inject_poison(memdev, a);
>>> +
>>
>> unnecessary blank line> +	if (rc)
> 
> Will remove!
> 
>>> +		log_err(&iel, "failed to inject poison at %s:%s: %s\n",
>>> +			cxl_memdev_get_devname(memdev), addr, strerror(-rc));
>>> +	else
>>> +		printf("poison injected at %s:%s\n",
>>> +		       cxl_memdev_get_devname(memdev), addr);
>>
>> log_info() maybe?
> 
> Same thing as above.
> 
> Thanks,
> Ben
> 
>>
>> DJ
>>

