Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A1B259D
	for <nvdimm@lists.linux.dev>; Fri, 16 Dec 2022 17:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671211422; x=1702747422;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=KSrVBxpOXxqJOcnLF7/46N0CdtSJTcUfL9ReH804vx4=;
  b=amn7KKe2oeu3sT8L70Sf7ONr2+BoAeSoz8jglHdOCQm4CvMkBWW3DzXq
   vSFKjGsQUEznkCPsCSRx4cq4CDqd7RyV7fZOBqAlU6vKzEB0ZPadybQjZ
   Uft8XLEZgcu4HA4p2eSsBkYxGDNETiVg7lq5w77dKkx63wqXYRtPD2ofX
   tQUUzFx/W8ZxwfJ+Ivqre/E6tQoyGDDiW0pr+KrwBvtyoX3biBQFMoeSV
   Z++VcWoFsjnPCJ1neczvmKYGuMBRCEHXEqv0egX8r/8s4i6fizC3HAIKH
   HMBT6My4WHCUe0CL2pm7naaP4jzeQlmZBKtYU0VAsBt8WWaHMNv/VFtF4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="319067377"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="319067377"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 09:23:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="895300226"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="895300226"
Received: from guptapra-mobl2.amr.corp.intel.com (HELO [10.212.229.121]) ([10.212.229.121])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 09:23:20 -0800
Message-ID: <f804d081-abb9-cb46-e14f-a37f3ac63f21@intel.com>
Date: Fri, 16 Dec 2022 10:23:19 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [ndctl PATCH v3 1/4] ndctl: add CXL bus detection
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, jmoyer@redhat.com, vishal.l.verma@intel.com
References: <639b9f6062c69_b05d12941f@dwillia2-xfh.jf.intel.com.notmuch>
 <167121128334.3620577.18417349282991011007.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <167121128334.3620577.18417349282991011007.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/16/2022 10:21 AM, Dave Jiang wrote:
> Add a CXL bus type, and detect whether a 'dimm' is backed by the CXL
> subsystem.
> 
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> 
> ---
> v3:
> - Simplify detecting cxl subsystem. (Dan)
> v2:
> - Improve commit log. (Vishal)
> ---
>   ndctl/lib/libndctl.c   |   30 ++++++++++++++++++++++++++++++
>   ndctl/lib/libndctl.sym |    1 +
>   ndctl/lib/private.h    |    1 +
>   ndctl/libndctl.h       |    1 +
>   4 files changed, 33 insertions(+)
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ad54f0626510..9cd5340b5702 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -12,6 +12,7 @@
>   #include <ctype.h>
>   #include <fcntl.h>
>   #include <dirent.h>
> +#include <libgen.h>

Of course I missed removing this change.

>   #include <sys/stat.h>
>   #include <sys/types.h>
>   #include <sys/ioctl.h>
> @@ -876,6 +877,24 @@ static enum ndctl_fwa_method fwa_method_to_method(const char *fwa_method)
>   	return NDCTL_FWA_METHOD_RESET;
>   }
>   
> +static int is_subsys_cxl(const char *subsys)
> +{
> +	char *path;
> +	int rc;
> +
> +	path = realpath(subsys, NULL);
> +	if (!path)
> +		return -errno;
> +
> +	if (!strcmp(subsys, "/sys/bus/cxl"))
> +		rc = 1;
> +	else
> +		rc = 0;
> +
> +	free(path);
> +	return rc;
> +}
> +
>   static void *add_bus(void *parent, int id, const char *ctl_base)
>   {
>   	char buf[SYSFS_ATTR_SIZE];
> @@ -919,6 +938,12 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>   	else
>   		bus->has_of_node = 1;
>   
> +	sprintf(path, "%s/device/../subsys", ctl_base);
> +	if (is_subsys_cxl(path))
> +		bus->has_cxl = 1;
> +	else
> +		bus->has_cxl = 0;
> +
>   	sprintf(path, "%s/device/nfit/dsm_mask", ctl_base);
>   	if (sysfs_read_attr(ctx, path, buf) < 0)
>   		bus->nfit_dsm_mask = 0;
> @@ -1050,6 +1075,11 @@ NDCTL_EXPORT int ndctl_bus_has_of_node(struct ndctl_bus *bus)
>   	return bus->has_of_node;
>   }
>   
> +NDCTL_EXPORT int ndctl_bus_has_cxl(struct ndctl_bus *bus)
> +{
> +	return bus->has_cxl;
> +}
> +
>   NDCTL_EXPORT int ndctl_bus_is_papr_scm(struct ndctl_bus *bus)
>   {
>   	char buf[SYSFS_ATTR_SIZE];
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index 75c32b9d4967..2892544d1985 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -464,4 +464,5 @@ LIBNDCTL_27 {
>   } LIBNDCTL_26;
>   LIBNDCTL_28 {
>   	ndctl_dimm_disable_master_passphrase;
> +	ndctl_bus_has_cxl;
>   } LIBNDCTL_27;
> diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
> index e5c56295556d..46bc8908bd90 100644
> --- a/ndctl/lib/private.h
> +++ b/ndctl/lib/private.h
> @@ -163,6 +163,7 @@ struct ndctl_bus {
>   	int regions_init;
>   	int has_nfit;
>   	int has_of_node;
> +	int has_cxl;
>   	char *bus_path;
>   	char *bus_buf;
>   	size_t buf_len;
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index c52e82a6f826..91ef0f42f654 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -133,6 +133,7 @@ struct ndctl_bus *ndctl_bus_get_next(struct ndctl_bus *bus);
>   struct ndctl_ctx *ndctl_bus_get_ctx(struct ndctl_bus *bus);
>   int ndctl_bus_has_nfit(struct ndctl_bus *bus);
>   int ndctl_bus_has_of_node(struct ndctl_bus *bus);
> +int ndctl_bus_has_cxl(struct ndctl_bus *bus);
>   int ndctl_bus_is_papr_scm(struct ndctl_bus *bus);
>   unsigned int ndctl_bus_get_major(struct ndctl_bus *bus);
>   unsigned int ndctl_bus_get_minor(struct ndctl_bus *bus);
> 
> 
