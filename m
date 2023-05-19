Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A2212B6A
	for <nvdimm@lists.linux.dev>; Fri, 19 May 2023 18:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684522169; x=1716058169;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2xX2IwvxKcm60AhSKtlVEqz7quCbF12LJ4YBPFPMAso=;
  b=k01Qaq91EVwOMi2s7JQPXcG7IYvtv8bVTZspzQ1EbHIDwr0aTV9YVl2u
   xxTuUrxuMYUvtZYZWpS/EMiuM1thByt5Dg5MI8NOnnpmehqSrG8nUpEJ9
   WBnQoikYYzBBeyuSmtETDVYNxkZ75K3ukrz0/eYAgSl6sdkiUzP2+cSLJ
   5BwGtCea5tyIVMzCsjbzfAuQxOKxStZ3g/QnLdjf95rp/qfvV0RvCsPII
   gqTLJZOZtLg+7BaLex/SJIxYToNWjEZN8pw26DC7gE99TmEEbM2wxXYWg
   0YdjOrkvRN5ubqqZ+oGdv6F2pngpA09XyWjxU+w5QLZhWm0XmymiRBA81
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="351296061"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="351296061"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 11:49:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="949209217"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="949209217"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.29.189]) ([10.212.29.189])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 11:49:29 -0700
Message-ID: <2a0715b8-2a14-e6da-0af3-8f907d0b3271@intel.com>
Date: Fri, 19 May 2023 11:49:29 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH ndctl 3/5] cxl/fw_loader: add APIs to get current state of
 the FW loader mechanism
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>
References: <20230405-vv-fw_update-v1-0-722a7a5baea3@intel.com>
 <20230405-vv-fw_update-v1-3-722a7a5baea3@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230405-vv-fw_update-v1-3-722a7a5baea3@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/21/23 8:10 PM, Vishal Verma wrote:
> Add a way to interface with the firmware loader mechanism for cxl
> memdevs. Add APIs to retrieve the current status of the fw loader, and
> the remaining size if a fw upload is in progress. Display these in the
> 'firmware' section of memdev listings.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>   cxl/lib/private.h  |  10 ++++++
>   cxl/lib/libcxl.c   | 100 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   cxl/libcxl.h       |  27 +++++++++++++++
>   cxl/json.c         |  13 +++++++
>   cxl/lib/libcxl.sym |   2 ++
>   5 files changed, 152 insertions(+)
> 
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 590d719..95e0c43 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -20,6 +20,15 @@ struct cxl_pmem {
>   	char *dev_path;
>   };
>   
> +struct cxl_fw_loader {
> +	char *dev_path;
> +	char *loading;
> +	char *data;
> +	char *remaining;
> +	char *cancel;
> +	char *status;
> +};
> +
>   struct cxl_endpoint;
>   struct cxl_memdev {
>   	int id, major, minor;
> @@ -39,6 +48,7 @@ struct cxl_memdev {
>   	struct cxl_pmem *pmem;
>   	unsigned long long serial;
>   	struct cxl_endpoint *endpoint;
> +	struct cxl_fw_loader *fwl;
>   };
>   
>   struct cxl_dport {
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 75490fd..86873d7 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -63,12 +63,25 @@ static void free_pmem(struct cxl_pmem *pmem)
>   	}
>   }
>   
> +static void free_fwl(struct cxl_fw_loader *fwl)
> +{
> +	if (fwl) {
> +		free(fwl->loading);
> +		free(fwl->data);
> +		free(fwl->remaining);
> +		free(fwl->cancel);
> +		free(fwl->status);
> +		free(fwl);
> +	}
> +}
> +
>   static void free_memdev(struct cxl_memdev *memdev, struct list_head *head)
>   {
>   	if (head)
>   		list_del_from(head, &memdev->list);
>   	kmod_module_unref(memdev->module);
>   	free_pmem(memdev->pmem);
> +	free_fwl(memdev->fwl);
>   	free(memdev->firmware_version);
>   	free(memdev->dev_buf);
>   	free(memdev->dev_path);
> @@ -1174,6 +1187,45 @@ static void *add_cxl_pmem(void *parent, int id, const char *br_base)
>   	return NULL;
>   }
>   
> +static int add_cxl_memdev_fwl(struct cxl_memdev *memdev,
> +			      const char *cxlmem_base)
> +{
> +	const char *devname = cxl_memdev_get_devname(memdev);
> +	struct cxl_fw_loader *fwl;
> +
> +	fwl = calloc(1, sizeof(*fwl));
> +	if (!fwl)
> +		return -ENOMEM;
> +
> +	if (asprintf(&fwl->loading, "%s/firmware/%s/loading", cxlmem_base,
> +		     devname) < 0)
> +		goto err_read;
> +	if (asprintf(&fwl->data, "%s/firmware/%s/data", cxlmem_base, devname) <
> +	    0)
> +		goto err_read;
> +	if (asprintf(&fwl->remaining, "%s/firmware/%s/remaining_size",
> +		     cxlmem_base, devname) < 0)
> +		goto err_read;
> +	if (asprintf(&fwl->cancel, "%s/firmware/%s/cancel", cxlmem_base,
> +		     devname) < 0)
> +		goto err_read;
> +	if (asprintf(&fwl->status, "%s/firmware/%s/status", cxlmem_base,
> +		     devname) < 0)
> +		goto err_read;
> +
> +	memdev->fwl = fwl;
> +	return 0;
> +
> + err_read:
> +	free(fwl->loading);
> +	free(fwl->data);
> +	free(fwl->remaining);
> +	free(fwl->cancel);
> +	free(fwl->status);
> +	free(fwl);

Just call free_fwl()?

DJ

> +	return -ENOMEM;
> +}
> +
>   static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
>   {
>   	const char *devname = devpath_to_devname(cxlmem_base);
> @@ -1263,6 +1315,9 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
>   
>   	device_parse(ctx, cxlmem_base, "pmem", memdev, add_cxl_pmem);
>   
> +	if (add_cxl_memdev_fwl(memdev, cxlmem_base))
> +		goto err_read;
> +
>   	cxl_memdev_foreach(ctx, memdev_dup)
>   		if (memdev_dup->id == memdev->id) {
>   			free_memdev(memdev, NULL);
> @@ -1373,6 +1428,51 @@ CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev
>   	return memdev->firmware_version;
>   }
>   
> +static enum cxl_fwl_status cxl_fwl_get_status(struct cxl_memdev *memdev)
> +{
> +	const char *devname = cxl_memdev_get_devname(memdev);
> +	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> +	struct cxl_fw_loader *fwl = memdev->fwl;
> +	char buf[SYSFS_ATTR_SIZE];
> +	int rc;
> +
> +	rc = sysfs_read_attr(ctx, fwl->status, buf);
> +	if (rc < 0) {
> +		err(ctx, "%s: failed to get fw loader status (%s)\n", devname,
> +		    strerror(-rc));
> +		return CXL_FWL_STATUS_UNKNOWN;
> +	}
> +
> +	return cxl_fwl_status_from_ident(buf);
> +}
> +
> +CXL_EXPORT bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev)
> +{
> +	int status = cxl_fwl_get_status(memdev);
> +
> +	if (status == CXL_FWL_STATUS_IDLE)
> +		return false;
> +	return true;
> +}
> +
> +CXL_EXPORT size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev)
> +{
> +	const char *devname = cxl_memdev_get_devname(memdev);
> +	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> +	struct cxl_fw_loader *fwl = memdev->fwl;
> +	char buf[SYSFS_ATTR_SIZE];
> +	int rc;
> +
> +	rc = sysfs_read_attr(ctx, fwl->remaining, buf);
> +	if (rc < 0) {
> +		err(ctx, "%s: failed to get fw loader remaining size (%s)\n",
> +		    devname, strerror(-rc));
> +		return 0;
> +	}
> +
> +	return strtoull(buf, NULL, 0);
> +}
> +
>   static void bus_invalidate(struct cxl_bus *bus)
>   {
>   	struct cxl_ctx *ctx = cxl_bus_get_ctx(bus);
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 99e1b76..7509abe 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -33,6 +33,31 @@ void *cxl_get_userdata(struct cxl_ctx *ctx);
>   void cxl_set_private_data(struct cxl_ctx *ctx, void *data);
>   void *cxl_get_private_data(struct cxl_ctx *ctx);
>   
> +enum cxl_fwl_status {
> +	CXL_FWL_STATUS_UNKNOWN,
> +	CXL_FWL_STATUS_IDLE,
> +	CXL_FWL_STATUS_RECEIVING,
> +	CXL_FWL_STATUS_PREPARING,
> +	CXL_FWL_STATUS_TRANSFERRING,
> +	CXL_FWL_STATUS_PROGRAMMING,
> +};
> +
> +static inline enum cxl_fwl_status cxl_fwl_status_from_ident(char *status)
> +{
> +	if (strcmp(status, "idle") == 0)
> +		return CXL_FWL_STATUS_IDLE;
> +	if (strcmp(status, "receiving") == 0)
> +		return CXL_FWL_STATUS_RECEIVING;
> +	if (strcmp(status, "preparing") == 0)
> +		return CXL_FWL_STATUS_PREPARING;
> +	if (strcmp(status, "transferring") == 0)
> +		return CXL_FWL_STATUS_TRANSFERRING;
> +	if (strcmp(status, "programming") == 0)
> +		return CXL_FWL_STATUS_PROGRAMMING;
> +
> +	return CXL_FWL_STATUS_UNKNOWN;
> +}
> +
>   struct cxl_memdev;
>   struct cxl_memdev *cxl_memdev_get_first(struct cxl_ctx *ctx);
>   struct cxl_memdev *cxl_memdev_get_next(struct cxl_memdev *memdev);
> @@ -48,6 +73,8 @@ struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
>   unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
>   unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
>   const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
> +bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
> +size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
>   
>   /* ABI spelling mistakes are forever */
>   static inline const char *cxl_memdev_get_firmware_version(
> diff --git a/cxl/json.c b/cxl/json.c
> index e6bb061..5dc0bd3 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -22,6 +22,7 @@ static struct json_object *util_cxl_memdev_fw_to_json(
>   	struct json_object *jfw;
>   	u32 field, num_slots;
>   	struct cxl_cmd *cmd;
> +	size_t remaining;
>   	int rc, i;
>   
>   	jfw = json_object_new_object();
> @@ -79,6 +80,18 @@ static struct json_object *util_cxl_memdev_fw_to_json(
>   			json_object_object_add(jfw, jkey, jobj);
>   	}
>   
> +	rc = cxl_memdev_fw_update_in_progress(memdev);
> +	jobj = json_object_new_boolean(rc);
> +	if (jobj)
> +		json_object_object_add(jfw, "fw_update_in_progress", jobj);
> +
> +	if (rc == true) {
> +		remaining = cxl_memdev_fw_update_get_remaining(memdev);
> +		jobj = util_json_object_size(remaining, flags);
> +		if (jobj)
> +			json_object_object_add(jfw, "remaining_size", jobj);
> +	}
> +
>   	cxl_cmd_unref(cmd);
>   	return jfw;
>   
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 16a8671..9438877 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -254,4 +254,6 @@ global:
>   	cxl_cmd_fw_info_get_staged_slot;
>   	cxl_cmd_fw_info_get_online_activate_capable;
>   	cxl_cmd_fw_info_get_fw_ver;
> +	cxl_memdev_fw_update_in_progress;
> +	cxl_memdev_fw_update_get_remaining;
>   } LIBCXL_4;
> 
