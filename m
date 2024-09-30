Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61141194096
	for <nvdimm@lists.linux.dev>; Mon, 30 Sep 2024 17:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727717824; cv=none; b=BYhE30brr23QXaiCgEiCW+fpj4oj18v26nvuaHwNdJwYyOWl9jsKIpNWsAq8mHoOHcLMPXtz5uaJCNF9CXMyb4CmUTQ7j3iin+GB/igQp1NUa8Sq+okhF0hd+CBqJFQFMAiNuTYc6o1rpX5inyIZrYN00wSx0fnUvwq26G/CChE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727717824; c=relaxed/simple;
	bh=uHtnF2edxbV6ndK0H1WzWrdm5RfHcwtNrVAXfgojpU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeNmZ4im29XS0F9h/N+esNsh+FbQtwc44PW3Lrx6Kgn2PHD7e8UU5a5K8/F9jYfQ5Im4MI5E4smWvuvIH5PObSwytFnZdj+dBAg1usRRAI0vPGva617NynPuv9AJU+jsfMM/CCTYsbXC2Dff6kMKWS8ZnaddpiObfyrX5sPmwWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ljfNB5RY; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ljfNB5RY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727717821; x=1759253821;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=uHtnF2edxbV6ndK0H1WzWrdm5RfHcwtNrVAXfgojpU8=;
  b=ljfNB5RYPhVqyyiSl8Ko0LmnmrHwbmFIPo+y/sMX1E/hpzO47HTZHGio
   YXlZGT5wQDOkqMTO4p7IvWRxZ2j+8lTPafEdCuDVGi5AA4tdNC0bwt8ep
   WFcq1zr5N2zazYEj9379Grup7amsP9akkh8W5WgWm/sMLBrmmc7Xu7Ph5
   jRw7TZhCrjRCXCdid84T61b5/NjqNvuxJTvsT5GW7OpGqkloAvdwD27JR
   ZyapX4kGrtvGsVeOmtun53zWa0aFU1EFfwMx4qrq13pJLZeE+LJc8ZlQt
   ASV2mgZ8GUVW0LIAJkMKfnWDSP5fjHsi056FnK4ElRpaTDBwuBkV8ocvu
   g==;
X-CSE-ConnectionGUID: k4Lg9+YUSpeHTl3KMK8hDQ==
X-CSE-MsgGUID: YA5HgbawSnSihLz2WAWA7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11211"; a="26284954"
X-IronPort-AV: E=Sophos;i="6.11,166,1725346800"; 
   d="scan'208";a="26284954"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2024 10:37:00 -0700
X-CSE-ConnectionGUID: LRrZ/yXlSguRUhct/mqEug==
X-CSE-MsgGUID: QqjXa/LgTNKRiw4+RNAqfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,166,1725346800"; 
   d="scan'208";a="73780434"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.108.158])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2024 10:37:00 -0700
Date: Mon, 30 Sep 2024 10:36:58 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: vishal.l.verma@intel.com, y-goto@fujitsu.com, dave.jiang@intel.com,
	dan.j.williams@intel.com, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Message-ID: <ZvrhusA7So_u51W_@aschofie-mobl2.lan>
References: <20240928211643.140264-1-dave@stgolabs.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240928211643.140264-1-dave@stgolabs.net>

+ nvdimm@lists.linux.dev

On Sat, Sep 28, 2024 at 02:16:42PM -0700, Davidlohr Bueso wrote:
> Add a new cxl_memdev_sanitize() to libcxl to support triggering memory
> device sanitation, in either Sanitize and/or Secure Erase, per the
> CXL 3.0 spec.
> 
> This is analogous to 'ndctl sanitize-dimm'.
> 
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>

Hi David,

I'm wrangling patches for ndctl now and need your help with this one.

Looking at the lore history, you posted a patchset for wait-sanitize &
sanitize-memdev in Apr'03.[1] and update with rev2.[2] Later in Oct'23
Dan posted a patchset with wait-sanitize and a unit test that was merged
in ndctl v80.[3,4]  A quick look at the code tells me Dan did not just
grab your implementation. It differs.

Can you confirm that the two features as a set are what you want today?
Are the last comments from Vishal and I addressed? [2]
Can the existing unit test be expanded with a sanitize-memdev test case?

Thanks!

-- Alison


[1] https://lore.kernel.org/linux-cxl/20230423015920.11384-1-dave@stgolabs.net/
[2] https://lore.kernel.org/linux-cxl/20230713195455.19769-1-dave@stgolabs.net/
[3] https://lore.kernel.org/all/169657749402.1491881.12666757616880845510.stgit@dwillia2-xfh.jf.intel.com/
[4] https://lore.kernel.org/nvdimm/72bdf880b2cafd42163638d9e7e1d848c1d2d3a9.camel@intel.com/






> ---
>  Documentation/cxl/cxl-sanitize-memdev.txt | 59 +++++++++++++++++++++++
>  Documentation/cxl/meson.build             |  1 +
>  cxl/builtin.h                             |  1 +
>  cxl/cxl.c                                 |  1 +
>  cxl/lib/libcxl.c                          | 15 ++++++
>  cxl/lib/libcxl.sym                        |  1 +
>  cxl/libcxl.h                              |  1 +
>  cxl/memdev.c                              | 48 ++++++++++++++++++
>  8 files changed, 127 insertions(+)
>  create mode 100644 Documentation/cxl/cxl-sanitize-memdev.txt
> 
> diff --git a/Documentation/cxl/cxl-sanitize-memdev.txt b/Documentation/cxl/cxl-sanitize-memdev.txt
> new file mode 100644
> index 000000000000..22212898542a
> --- /dev/null
> +++ b/Documentation/cxl/cxl-sanitize-memdev.txt
> @@ -0,0 +1,59 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-sanitize-memdev(1)
> +======================
> +
> +NAME
> +----
> +cxl-sanitize-memdev - Perform a cryptographic destruction or sanitization
> +of the contents of the given memdev(s).
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl sanitize-memdev <mem0> [<mem1>..<memN>] [<options>]'
> +
> +DESCRIPTION
> +-----------
> +The 'sanitize-memdev' command performs two different methods of
> +sanitization, per the CXL 3.0+ specification. It is required that
> +the memdev be disabled before sanitizing, such that the device
> +cannot be actively decoding any HPA ranges at the time.
> +
> +The default is 'sanitize', but additionally, a 'secure-erase'
> +option is available. If both types of operations are supplied,
> +then the 'secure-erase' is performed before 'sanitize'.
> +
> +OPTIONS
> +-------
> +
> +include::bus-option.txt[]
> +
> +-e::
> +--secure-erase::
> +	Erase user data by changing the media encryption keys for all user
> +	data areas of the device.
> +
> +-s::
> +--sanitize::
> +	Sanitize the device to securely re-purpose or decommission it. This is
> +	done by ensuring that all user data and meta data, whether it resides
> +	in persistent capacity, volatile capacity, or the label storage area,
> +	is made permanently unavailable by whatever means is appropriate for
> +	the media type.
> +
> +	With this option, the sanitization request is merely submitted to the
> +	kernel, and the completion is asynchronous. Depending on the medium and
> +	capacity, sanitize may take tens of minutes to many hours. Subsequently,
> +	'cxl wait-sanitize’ can be used to wait for the memdevs that are under
> +	the sanitization.
> +
> +include::verbose-option.txt[]
> +
> +include::../copyright.txt[]
> +
> +SEE ALSO
> +--------
> +linkcxl:cxl-wait-sanitize[1],
> +linkcxl:cxl-disable-memdev[1],
> +linkcxl:cxl-list[1],
> diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
> index 8085c1c2c87e..99e6ee782a1c 100644
> --- a/Documentation/cxl/meson.build
> +++ b/Documentation/cxl/meson.build
> @@ -49,6 +49,7 @@ cxl_manpages = [
>    'cxl-monitor.txt',
>    'cxl-update-firmware.txt',
>    'cxl-set-alert-config.txt',
> +  'cxl-sanitize-memdev.txt',
>    'cxl-wait-sanitize.txt',
>  ]
>  
> diff --git a/cxl/builtin.h b/cxl/builtin.h
> index c483f301e5e0..29c8ad2a0ad9 100644
> --- a/cxl/builtin.h
> +++ b/cxl/builtin.h
> @@ -16,6 +16,7 @@ int cmd_reserve_dpa(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_free_dpa(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_update_fw(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_set_alert_config(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_sanitize_memdev(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_wait_sanitize(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_disable_port(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_enable_port(int argc, const char **argv, struct cxl_ctx *ctx);
> diff --git a/cxl/cxl.c b/cxl/cxl.c
> index 16436671dc53..9c9f217c5a93 100644
> --- a/cxl/cxl.c
> +++ b/cxl/cxl.c
> @@ -80,6 +80,7 @@ static struct cmd_struct commands[] = {
>  	{ "disable-region", .c_fn = cmd_disable_region },
>  	{ "destroy-region", .c_fn = cmd_destroy_region },
>  	{ "monitor", .c_fn = cmd_monitor },
> +	{ "sanitize-memdev", .c_fn = cmd_sanitize_memdev },
>  };
>  
>  int main(int argc, const char **argv)
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 91eedd1c4688..4f44bf1b6185 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1414,6 +1414,21 @@ CXL_EXPORT int cxl_memdev_get_id(struct cxl_memdev *memdev)
>  	return memdev->id;
>  }
>  
> +CXL_EXPORT int cxl_memdev_sanitize(struct cxl_memdev *memdev, char *op)
> +{
> +	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> +	char *path = memdev->dev_buf;
> +	int len = memdev->buf_len;
> +
> +	if (snprintf(path, len,
> +		     "%s/security/%s", memdev->dev_path, op) >= len) {
> +		err(ctx, "%s: buffer too small!\n",
> +		    cxl_memdev_get_devname(memdev));
> +		return -ERANGE;
> +	}
> +	return sysfs_write_attr(ctx, path, "1\n");
> +}
> +
>  CXL_EXPORT int cxl_memdev_wait_sanitize(struct cxl_memdev *memdev,
>  					int timeout_ms)
>  {
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 304d7fa735d4..89a4c63cb874 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -281,4 +281,5 @@ global:
>  	cxl_memdev_get_ram_qos_class;
>  	cxl_region_qos_class_mismatch;
>  	cxl_port_decoders_committed;
> +	cxl_memdev_sanitize;
>  } LIBCXL_6;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index fc6dd0085440..a722bab8a65b 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -79,6 +79,7 @@ bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
>  size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
>  int cxl_memdev_update_fw(struct cxl_memdev *memdev, const char *fw_path);
>  int cxl_memdev_cancel_fw_update(struct cxl_memdev *memdev);
> +int cxl_memdev_sanitize(struct cxl_memdev *memdev, char *op);
>  int cxl_memdev_wait_sanitize(struct cxl_memdev *memdev, int timeout_ms);
>  
>  /* ABI spelling mistakes are forever */
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index 6e44d1578d03..60d1515b19f3 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -35,6 +35,8 @@ static struct parameters {
>  	bool align;
>  	bool cancel;
>  	bool wait;
> +	bool sanitize;
> +	bool secure_erase;
>  	const char *type;
>  	const char *size;
>  	const char *decoder_filter;
> @@ -160,6 +162,12 @@ OPT_STRING('\0', "pmem-err-alert",                                            \
>  	   &param.corrected_pmem_err_alert, "'on' or 'off'",                  \
>  	   "enable or disable corrected pmem error warning alert")
>  
> +#define SANITIZE_OPTIONS()			      \
> +OPT_BOOLEAN('e', "secure-erase", &param.secure_erase, \
> +	    "secure erase a memdev"),		      \
> +OPT_BOOLEAN('s', "sanitize", &param.sanitize,	      \
> +	    "sanitize a memdev")
> +
>  #define WAIT_SANITIZE_OPTIONS()                \
>  OPT_INTEGER('t', "timeout", &param.timeout,    \
>  	    "time in milliseconds to wait for overwrite completion (default: infinite)")
> @@ -226,6 +234,12 @@ static const struct option set_alert_options[] = {
>  	OPT_END(),
>  };
>  
> +static const struct option sanitize_options[] = {
> +	BASE_OPTIONS(),
> +	SANITIZE_OPTIONS(),
> +	OPT_END(),
> +};
> +
>  static const struct option wait_sanitize_options[] = {
>  	BASE_OPTIONS(),
>  	WAIT_SANITIZE_OPTIONS(),
> @@ -772,6 +786,27 @@ out_err:
>  	return rc;
>  }
>  
> +static int action_sanitize_memdev(struct cxl_memdev *memdev,
> +				  struct action_context *actx)
> +{
> +	int rc = 0;
> +
> +	if (cxl_memdev_is_enabled(memdev))
> +		return -EBUSY;
> +
> +	/* let Sanitize be the default */
> +	if (!param.secure_erase && !param.sanitize)
> +		param.sanitize = true;
> +	if (param.secure_erase)
> +		rc = cxl_memdev_sanitize(memdev, "erase");
> +	if (param.sanitize)
> +		rc = cxl_memdev_sanitize(memdev, "sanitize");
> +	else
> +		rc = -EINVAL;
> +
> +	return rc;
> +}
> +
>  static int action_wait_sanitize(struct cxl_memdev *memdev,
>  				struct action_context *actx)
>  {
> @@ -1228,6 +1263,19 @@ int cmd_set_alert_config(int argc, const char **argv, struct cxl_ctx *ctx)
>  	return count >= 0 ? 0 : EXIT_FAILURE;
>  }
>  
> +int cmd_sanitize_memdev(int argc, const char **argv, struct cxl_ctx *ctx)
> +{
> +	int count = memdev_action(
> +		argc, argv, ctx, action_sanitize_memdev, sanitize_options,
> +		"cxl sanitize-memdev <mem0> [<mem1>..<memn>] [<options>]");
> +
> +	log_info(&ml, "sanitize %s on %d mem device%s\n",
> +		 count >= 0 ? "completed/started" : "failed",
> +		 count >= 0 ? count : 0,  count > 1 ? "s" : "");
> +
> +	return count >= 0 ? 0 : EXIT_FAILURE;
> +}
> +
>  int cmd_wait_sanitize(int argc, const char **argv, struct cxl_ctx *ctx)
>  {
>  	int count = memdev_action(
> -- 
> 2.46.1
> 
> 
