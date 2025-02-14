Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F95BB644
	for <nvdimm@lists.linux.dev>; Fri, 14 Feb 2025 00:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739491827; cv=none; b=GC3nWzbsVaHt+D50g0OjR49noKX2OXcKE35qdTsAYMzkcUgkEefcHS3tz7O43bZCt060SXMKD1ec9tQSx0ptRBH8Y7THy/Fkl5eSQOeyz7LbEbckN/uqteWnIihowIAhbOA0ZzaSgD5ZM9Y7Hn7FcX+8nOuA4c4k7PeTs0HU4YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739491827; c=relaxed/simple;
	bh=K5SA8GU6wsqJ9hUJTM31mUXcKajb3uBP7JxgJa8JMpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GdtVbgdYW8nyKgi+xe6etxjwyLxIK291GIaz8qfpxNctoIG92w5c3u4mPrfHRLPXXt7haGHO3C/My1yPMHx91Xj3P3idgyBDIu9ad6JnI34KV56Iyrh69wfSSSRvlZIGNXABKSksjCOHmX6MXOLMGIFcn95TQaR6nh5ORlmBg0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EQSIOVj6; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EQSIOVj6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739491825; x=1771027825;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K5SA8GU6wsqJ9hUJTM31mUXcKajb3uBP7JxgJa8JMpE=;
  b=EQSIOVj6WXB5EbWEtXKD1xNUqB6YCMRNqge65JhuJHNNEQhl7bQrHXEh
   7EGDQD68E6anan0A4FZuejZXayfTB2k82GgUdH8O7SasGjKOiagIYY5j/
   5yamMidvCxhhYVrJcomasb4e0VyrWgZTHk9VLQZmpXf9BmQGswF/m5WQA
   ahCXBadcX754zCHvhAUDn09r/bjsB1efAexKhlbwEdh1P3d5K5YPBlEPq
   nWvexuaUbSvMwxG8ById9YoqPCxRfehhA+1fT2SDO8fLwEn0Mgo/mm41X
   eDlQFGL19CfKii84GW6I3zSGt72d00b2XqsiJsyCqNyj54ZTDUlrvVi/V
   w==;
X-CSE-ConnectionGUID: e7D2eX21TWmO+YMO8Pu9AA==
X-CSE-MsgGUID: uQ0zb5RcTtCkdhyewZn9Ow==
X-IronPort-AV: E=McAfee;i="6700,10204,11344"; a="27824491"
X-IronPort-AV: E=Sophos;i="6.13,284,1732608000"; 
   d="scan'208";a="27824491"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 16:10:24 -0800
X-CSE-ConnectionGUID: ahDRM9+STzG31aYy5j/2LQ==
X-CSE-MsgGUID: XN/CWaqBR/+ZIjockXrBxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="114191203"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.108.202])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 16:10:24 -0800
Date: Thu, 13 Feb 2025 16:10:21 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [RFC ndctl PATCH] cxl: Add inject-error command
Message-ID: <Z66J7fW4SXuqFgN_@aschofie-mobl2.lan>
References: <20250108215749.181852-1-Benjamin.Cheatham@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108215749.181852-1-Benjamin.Cheatham@amd.com>

On Wed, Jan 08, 2025 at 03:57:49PM -0600, Ben Cheatham wrote:
> Add inject-error command for injecting CXL errors into CXL devices.
> The command currently only has support for injecting CXL protocol
> errors into CXL downstream ports via EINJ.

Hi Ben,
I went through enough to give you some feedback for your v1.
Just ran out of time and didn't want to keep you waiting any longer.

wrt 'currently only has' - what is the grander scope of this that we
might see in the future. Will there only every be one system wide
response to --list-errors or will there be error types per type of
port.

Spec reference?

> 
> The command takes an error type and injects an error of that type into the
> specified downstream port. Downstream ports can be specified using the
> port's device name with the -d option. Available error types can be obtained
> by running "cxl inject-error --list-errors".
> 
> This command requires the kernel to be built with CONFIG_DEBUGFS and
> CONFIG_ACPI_APEI_EINJ_CXL enabled. It also requires root privileges to
> run due to reading from <debugfs>/cxl/einj_types and writing to
> <debugfs>/cxl/<dport>/einj_inject.
> 
> Example usage:
>     # cxl inject-error --list-errors
>     cxl.mem_correctable
>     cxl.mem_fatal
>     ...
>     # cxl inject-error -d 0000:00:01.1 cxl.mem_correctable
>     injected cxl.mem_correctable protocol error
>

I'll probably ask this again later on, but how does user see
list of downstream ports. Does user really think -d dport,
or do they think -d device-name, or ?
Man page will help here.

We don't have cxl-cli support for poison inject, but to future
proof this, let's think about the naming.

Please split the patch up at least into 2 -
libcxl: Add APIs supporting CXL protocol error injection
        include updates to Documentation/cxl/lib/libcxl.txt

cxl: add {list,inject}-protocol-error' commands
     include man page updates, additiona

The 'list-errors' is the the system level error support, right?
Could that fit in the existing 'cxl list' hierachy?
Would they be a property of the bus?

I don't know that 'protocol' is best name, but seems it needs
another descriptor.


> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
> ---
>  cxl/builtin.h      |   1 +
>  cxl/cxl.c          |   1 +
>  cxl/inject-error.c | 188 +++++++++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.c   |  53 +++++++++++++
>  cxl/lib/libcxl.sym |   2 +
>  cxl/libcxl.h       |  13 ++++
>  cxl/meson.build    |   1 +
>  7 files changed, 259 insertions(+)
>  create mode 100644 cxl/inject-error.c
> 
> diff --git a/cxl/builtin.h b/cxl/builtin.h
> index c483f30..e82fcb5 100644
> --- a/cxl/builtin.h
> +++ b/cxl/builtin.h
> @@ -25,6 +25,7 @@ int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx);
>  #ifdef ENABLE_LIBTRACEFS
>  int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx);
>  #else
> diff --git a/cxl/cxl.c b/cxl/cxl.c
> index 1643667..f808926 100644
> --- a/cxl/cxl.c
> +++ b/cxl/cxl.c
> @@ -79,6 +79,7 @@ static struct cmd_struct commands[] = {
>  	{ "enable-region", .c_fn = cmd_enable_region },
>  	{ "disable-region", .c_fn = cmd_disable_region },
>  	{ "destroy-region", .c_fn = cmd_destroy_region },
> +	{ "inject-error", .c_fn = cmd_inject_error },
>  	{ "monitor", .c_fn = cmd_monitor },
>  };
>  
> diff --git a/cxl/inject-error.c b/cxl/inject-error.c
> new file mode 100644

Can this fit in an existing file?  port.c ?

I didn't review this file yet, so snipping.


> index 0000000..3645934
> --- /dev/null
> +++ b/cxl/inject-error.c

snip

> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 91eedd1..8174c11 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -3179,6 +3179,59 @@ CXL_EXPORT int cxl_dport_get_id(struct cxl_dport *dport)
>  	return dport->id;
>  }
>  
> +CXL_EXPORT int cxl_dport_inject_proto_err(struct cxl_dport *dport,
> +					  enum cxl_proto_error_types perr,
> +					  const char *debugfs)
> +{
> +	struct cxl_port *port = cxl_dport_get_port(dport);
> +	size_t path_len = strlen(debugfs) + 24;

What's the path_len math, +24 here and +16 in next fcn.
I notice other path calloc's in this file padding more, ie +100 or +50.


> +	struct cxl_ctx *ctx = port->ctx;
> +	char buf[32];
> +	char *path;
> +	int rc;
> +
> +	if (!dport->dev_path) {
> +		err(ctx, "no dev_path for dport\n");
> +		return -EINVAL;
> +	}
> +
> +	path_len += strlen(dport->dev_path);
> +	path = calloc(1, path_len);
> +	if (!path)
> +		return -ENOMEM;
> +
> +	snprintf(path, path_len, "%s/cxl/%s/einj_inject", debugfs,
> +		 cxl_dport_get_devname(dport));
> +
> +	snprintf(buf, sizeof(buf), "0x%lx\n", (u64) perr);

Here, and in cxl_get_proto_errors(), can we check for the path and
fail with 'unsupported' if it doesn't exist. That'll tell folks
if feature is not configured, or not enabled ?
Are kernel configured and port enabled 2 different levels?

There's an example in this file w "if (access(path, F_OK) != 0)"


> +	rc = sysfs_write_attr(ctx, path, buf);
> +	if (rc)
> +		err(ctx, "could not write to %s: %d\n", path, rc);

for 'sameness' with most err's in this library, do:
        err(ctx, "failed write to %s: %s\n", path, strerr(-rc));

> +
> +	free(path);
> +	return rc;
> +}
> +
> +CXL_EXPORT int cxl_get_proto_errors(struct cxl_ctx *ctx, char *buf,
> +				    const char *debugfs)
> +{
> +	size_t path_len = strlen(debugfs) + 16;
> +	char *path;
> +	int rc = 0;
> +
> +	path = calloc(1, path_len);
> +	if (!path)
> +		return -ENOMEM;
> +
> +	snprintf(path, path_len, "%s/cxl/einj_types", debugfs);
> +	rc = sysfs_read_attr(ctx, path, buf);
> +	if (rc)
> +		err(ctx, "could not read from %s: %d\n", path, rc);
> +

same comments as previous, check path and make err msg similar


> +	free(path);
> +	return rc;
> +}
> +
>  CXL_EXPORT struct cxl_port *cxl_dport_get_port(struct cxl_dport *dport)
>  {
>  	return dport->port;
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 304d7fa..d39a12d 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -281,4 +281,6 @@ global:
>  	cxl_memdev_get_ram_qos_class;
>  	cxl_region_qos_class_mismatch;
>  	cxl_port_decoders_committed;
> +	cxl_dport_inject_proto_err;
> +	cxl_get_proto_errors;
>  } LIBCXL_6;

Start a new section above for these new symbols.
Each ndctl release gets a new section - if symbols added.



> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index fc6dd00..867daa4 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -160,6 +160,15 @@ struct cxl_port *cxl_port_get_next_all(struct cxl_port *port,
>  	for (port = cxl_port_get_first(top); port != NULL;                     \
>  	     port = cxl_port_get_next_all(port, top))
>  
> +enum cxl_proto_error_types {
> +	CXL_CACHE_CORRECTABLE = 1 << 12,
> +	CXL_CACHE_UNCORRECTABLE = 1 << 13,
> +	CXL_CACHE_FATAL = 1 << 14,
> +	CXL_MEM_CORRECTABLE = 1 << 15,
> +	CXL_MEM_UNCORRECTABLE = 1 << 16,
> +	CXL_MEM_FATAL = 1 << 17,
> +};

Please align like enum util_json_flags
Is there a spec reference to add?

That's all.
-- Alison



> +
>  struct cxl_dport;
>  struct cxl_dport *cxl_dport_get_first(struct cxl_port *port);
>  struct cxl_dport *cxl_dport_get_next(struct cxl_dport *dport);
> @@ -168,6 +177,10 @@ const char *cxl_dport_get_physical_node(struct cxl_dport *dport);
>  const char *cxl_dport_get_firmware_node(struct cxl_dport *dport);
>  struct cxl_port *cxl_dport_get_port(struct cxl_dport *dport);
>  int cxl_dport_get_id(struct cxl_dport *dport);
> +int cxl_dport_inject_proto_err(struct cxl_dport *dport,
> +			       enum cxl_proto_error_types err,
> +			       const char *debugfs);
> +int cxl_get_proto_errors(struct cxl_ctx *ctx, char *buf, const char *debugfs);
>  bool cxl_dport_maps_memdev(struct cxl_dport *dport, struct cxl_memdev *memdev);
>  struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
>  					       struct cxl_memdev *memdev);
> diff --git a/cxl/meson.build b/cxl/meson.build
> index 61b4d87..79da4e6 100644
> --- a/cxl/meson.build
> +++ b/cxl/meson.build
> @@ -7,6 +7,7 @@ cxl_src = [
>    'memdev.c',
>    'json.c',
>    'filter.c',
> +  'inject-error.c',
>    '../daxctl/json.c',
>    '../daxctl/filter.c',
>  ]
> -- 
> 2.34.1
> 
> 
