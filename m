Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325A87B
	for <nvdimm@lists.linux.dev>; Wed, 14 Dec 2022 02:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670985633; x=1702521633;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Zqvfn8RMWF8loipg/fNFzxgDIQyWcSn2frl71a44CKw=;
  b=a9BhcbDPjb8egghu6KkFZGWCXuAcp35CkuZiwS5GwBAtpsm89kF9x2/k
   fkH4zkmIz9YKXD6kgfqs91FJ+iAps0EGHxaBa8nIvB5RCUEoqsPc8CRTo
   v6JNsgDgGx/ufcR/NKoB3cMLCvNRAhj4JD3IHjXN792Bq12W+a1ErXFAw
   lD1Q6izT73ni7ycV1UCTGz74g2Kj3C1PN2DxcCPgHPXAPVXUnMZ3BJ/du
   mgCXK3F0udzasQxwrz83N7+/Lic5dwyo3vuwc6JGDC9XrVUucYyU3jNVn
   I+vhbLwHVSX7D/AQgDyV6i6olfpdnW+lxYDgQiNSn9ft8Sb+ONl1qt8eY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="382596297"
X-IronPort-AV: E=Sophos;i="5.96,243,1665471600"; 
   d="scan'208";a="382596297"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 18:40:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="737574948"
X-IronPort-AV: E=Sophos;i="5.96,243,1665471600"; 
   d="scan'208";a="737574948"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.232.157])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 18:40:31 -0800
Date: Tue, 13 Dec 2022 18:40:29 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	vishal.l.verma@intel.com
Subject: Re: [PATCH 1/4] ndctl: add cxl bus detection
Message-ID: <Y5k3nRzfPbW+04MT@aschofie-mobl2>
References: <166379397620.433612.13099557870939895846.stgit@djiang5-desk3.ch.intel.com>
 <166379416245.433612.3109623615684575549.stgit@djiang5-desk3.ch.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166379416245.433612.3109623615684575549.stgit@djiang5-desk3.ch.intel.com>

On Wed, Sep 21, 2022 at 02:02:42PM -0700, Dave Jiang wrote:
> Add helper function to detect that the bus is cxl based.
> 

A couple of wonderings below about int vs bool usage.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/lib/libndctl.c   |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym |    1 +
>  ndctl/lib/private.h    |    1 +
>  ndctl/libndctl.h       |    1 +
>  4 files changed, 56 insertions(+)
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ad54f0626510..10422e24d38b 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -12,6 +12,7 @@
>  #include <ctype.h>
>  #include <fcntl.h>
>  #include <dirent.h>
> +#include <libgen.h>
>  #include <sys/stat.h>
>  #include <sys/types.h>
>  #include <sys/ioctl.h>
> @@ -876,6 +877,48 @@ static enum ndctl_fwa_method fwa_method_to_method(const char *fwa_method)
>  	return NDCTL_FWA_METHOD_RESET;
>  }
>  
> +static int is_ndbus_cxl(const char *ctl_base)

is_ndbus_cxl()  sounds like a boolean function.

> +{
> +	char *path, *ppath, *subsys;
> +	char tmp_path[PATH_MAX];
> +	int rc;
> +
> +	/* get the real path of ctl_base */
> +	path = realpath(ctl_base, NULL);
> +	if (!path)
> +		return -errno;
> +
> +	/* setup to get the nd bridge device backing the ctl */
> +	sprintf(tmp_path, "%s/device", path);
> +	free(path);
> +
> +	path = realpath(tmp_path, NULL);
> +	if (!path)
> +		return -errno;
> +
> +	/* get the parent dir of the ndbus, which should be the nvdimm-bridge */
> +	ppath = dirname(path);
> +
> +	/* setup to get the subsystem of the nvdimm-bridge */
> +	sprintf(tmp_path, "%s/%s", ppath, "subsystem");
> +	free(path);
> +
> +	path = realpath(tmp_path, NULL);
> +	if (!path)
> +		return -errno;
> +
> +	subsys = basename(path);
> +
> +	/* check if subsystem is cxl */
> +	if (!strcmp(subsys, "cxl"))
> +		rc = 1;
> +	else
> +		rc = 0;
> +
> +	free(path);
> +	return rc;
> +}
> +
>  static void *add_bus(void *parent, int id, const char *ctl_base)
>  {
>  	char buf[SYSFS_ATTR_SIZE];
> @@ -919,6 +962,11 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>  	else
>  		bus->has_of_node = 1;
>  
> +	if (is_ndbus_cxl(ctl_base))
> +		bus->has_cxl = 1;
> +	else
> +		bus->has_cxl = 0;
> +
>  	sprintf(path, "%s/device/nfit/dsm_mask", ctl_base);
>  	if (sysfs_read_attr(ctx, path, buf) < 0)
>  		bus->nfit_dsm_mask = 0;
> @@ -1050,6 +1098,11 @@ NDCTL_EXPORT int ndctl_bus_has_of_node(struct ndctl_bus *bus)
>  	return bus->has_of_node;
>  }
>  
> +NDCTL_EXPORT int ndctl_bus_has_cxl(struct ndctl_bus *bus)
> +{
> +	return bus->has_cxl;
> +}
> +
>  NDCTL_EXPORT int ndctl_bus_is_papr_scm(struct ndctl_bus *bus)
>  {
>  	char buf[SYSFS_ATTR_SIZE];
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index c933163c0380..3a3e8bbd63ef 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -465,4 +465,5 @@ LIBNDCTL_27 {
>  
>  LIBNDCTL_28 {
>  	ndctl_dimm_disable_master_passphrase;
> +	ndctl_bus_has_cxl;
>  } LIBNDCTL_27;
> diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
> index e5c56295556d..46bc8908bd90 100644
> --- a/ndctl/lib/private.h
> +++ b/ndctl/lib/private.h
> @@ -163,6 +163,7 @@ struct ndctl_bus {
>  	int regions_init;
>  	int has_nfit;
>  	int has_of_node;
> +	int has_cxl;

I was going to say boolean again, but I see the pattern above.
I guess, When in Rome...

>  	char *bus_path;
>  	char *bus_buf;
>  	size_t buf_len;
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index c52e82a6f826..91ef0f42f654 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -133,6 +133,7 @@ struct ndctl_bus *ndctl_bus_get_next(struct ndctl_bus *bus);
>  struct ndctl_ctx *ndctl_bus_get_ctx(struct ndctl_bus *bus);
>  int ndctl_bus_has_nfit(struct ndctl_bus *bus);
>  int ndctl_bus_has_of_node(struct ndctl_bus *bus);
> +int ndctl_bus_has_cxl(struct ndctl_bus *bus);
>  int ndctl_bus_is_papr_scm(struct ndctl_bus *bus);
>  unsigned int ndctl_bus_get_major(struct ndctl_bus *bus);
>  unsigned int ndctl_bus_get_minor(struct ndctl_bus *bus);
> 
> 
> 
