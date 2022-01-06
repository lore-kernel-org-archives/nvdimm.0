Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F11D2C80
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 20:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641502386; x=1673038386;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NtM8x6HlhBTIiEDK4pMGsqoCkVrJ4LHrjOl8vdL5Bsk=;
  b=kDrLBMEXefwc1B4Kqt9Os9rjgYVpXTBUbrEguOt5ML/0Wie2XkLnh7/y
   2RxCfgqWl5XkpSW4F8WxByo0fYeaRaEgLkSUv5R7JAYRugjlAjy8eitzI
   5FTBOyU4MnjYszqXz9hfkSocSsNbakvLdHvfFgyICneag02lmq2/yTZjn
   vkswJRN25PqKhXAXnCL7Jh8DgyHQ7FAD6Gr7KZz3veVCRmjrsMu9hwsdm
   hpRr8FwdLTw9sIMl6rX20ug6stDGoGe+qc733ncJqd78Y7NCtHFdOkebd
   4r4GPZgLcnMtgtVWI8uuC78TmtSY8Lt5iZ/oD/S7QU7q7Kjl4/ziNC9iK
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242527824"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="242527824"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 12:53:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="513534912"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 12:53:03 -0800
Date: Thu, 6 Jan 2022 12:53:02 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: alison.schofield@intel.com
Cc: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 5/7] libcxl: add interfaces for SET_PARTITION_INFO
 mailbox command
Message-ID: <20220106205302.GF178135@iweiny-DESK2.sc.intel.com>
Mail-Followup-To: alison.schofield@intel.com,
	Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
References: <cover.1641233076.git.alison.schofield@intel.com>
 <fa45e95e5d28981b4ec41db65aab82c103bff0c3.1641233076.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa45e95e5d28981b4ec41db65aab82c103bff0c3.1641233076.git.alison.schofield@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Mon, Jan 03, 2022 at 12:16:16PM -0800, Schofield, Alison wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Add APIs to allocate and send a SET_PARTITION_INFO mailbox command.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  cxl/lib/private.h  |  9 +++++++++
>  cxl/libcxl.h       |  4 ++++
>  cxl/lib/libcxl.c   | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym |  3 +++
>  4 files changed, 61 insertions(+)
> 
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index dd9234f..841aa80 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -114,6 +114,15 @@ struct cxl_cmd_get_partition_info {
>  
>  #define CXL_CAPACITY_MULTIPLIER		SZ_256M
>  
> +struct cxl_cmd_set_partition_info {
> +	le64 volatile_capacity;
> +	u8 flags;
> +} __attribute__((packed));
> +
> +/* CXL 2.0 8.2.9.5.2 Set Partition Info */
> +#define CXL_CMD_SET_PARTITION_INFO_NO_FLAG				(0)
> +#define CXL_CMD_SET_PARTITION_INFO_IMMEDIATE_FLAG			(1)

BIT(0) and BIT(1)?

I can't remember which bit is the immediate flag.

> +
>  /* CXL 2.0 8.2.9.5.3 Byte 0 Health Status */
>  #define CXL_CMD_HEALTH_INFO_STATUS_MAINTENANCE_NEEDED_MASK		BIT(0)
>  #define CXL_CMD_HEALTH_INFO_STATUS_PERFORMANCE_DEGRADED_MASK		BIT(1)
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index d333b6d..67d6ffc 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -50,6 +50,8 @@ int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
>  		size_t offset);
>  int cxl_memdev_write_label(struct cxl_memdev *memdev, void *buf, size_t length,
>  		size_t offset);
> +int cxl_memdev_set_partition_info(struct cxl_memdev *memdev,
> +		unsigned long long volatile_capacity, int flags);
>  
>  #define cxl_memdev_foreach(ctx, memdev) \
>          for (memdev = cxl_memdev_get_first(ctx); \
> @@ -117,6 +119,8 @@ unsigned long long cxl_cmd_get_partition_info_get_active_volatile_cap(struct cxl
>  unsigned long long cxl_cmd_get_partition_info_get_active_persistent_cap(struct cxl_cmd *cmd);
>  unsigned long long cxl_cmd_get_partition_info_get_next_volatile_cap(struct cxl_cmd *cmd);
>  unsigned long long cxl_cmd_get_partition_info_get_next_persistent_cap(struct cxl_cmd *cmd);
> +struct cxl_cmd *cxl_cmd_new_set_partition_info(struct cxl_memdev *memdev,
> +		unsigned long long volatile_capacity, int flags);
>  
>  #ifdef __cplusplus
>  } /* extern "C" */
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 85a6c0e..877a783 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1227,6 +1227,21 @@ cxl_cmd_get_partition_info_get_next_persistent_cap(struct cxl_cmd *cmd)
>  	cmd_partition_get_capacity_field(cmd, next_persistent_cap);
>  }
>  
> +CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_partition_info(struct cxl_memdev *memdev,
> +		unsigned long long volatile_capacity, int flags)
> +{
> +	struct cxl_cmd_set_partition_info *set_partition;
> +	struct cxl_cmd *cmd;
> +
> +	cmd = cxl_cmd_new_generic(memdev,
> +			CXL_MEM_COMMAND_ID_SET_PARTITION_INFO);
> +
> +	set_partition = (struct cxl_cmd_set_partition_info *)cmd->send_cmd->in.payload;
> +	set_partition->volatile_capacity = cpu_to_le64(volatile_capacity);
> +	set_partition->flags = flags;
> +	return cmd;
> +}
> +
>  CXL_EXPORT int cxl_cmd_submit(struct cxl_cmd *cmd)
>  {
>  	struct cxl_memdev *memdev = cmd->memdev;
> @@ -1425,3 +1440,33 @@ CXL_EXPORT int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf,
>  {
>  	return lsa_op(memdev, LSA_OP_GET, buf, length, offset);
>  }
> +
> +CXL_EXPORT int cxl_memdev_set_partition_info(struct cxl_memdev *memdev,
> +	       unsigned long long volatile_capacity, int flags)
> +{
> +	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> +	struct cxl_cmd *cmd;
> +	int rc;
> +
> +	dbg(ctx, "%s: enter cap: %llx, flags %d\n", __func__,
> +		volatile_capacity, flags);
> +
> +	cmd = cxl_cmd_new_set_partition_info(memdev,
> +			volatile_capacity / CXL_CAPACITY_MULTIPLIER, flags);

I'll reiterate that I agree with this capacity being in bytes.  But I'm not
sure what the rest of libcxl does.

Ira

> +	if (!cmd)
> +		return -ENXIO;
> +
> +	rc = cxl_cmd_submit(cmd);
> +	if (rc < 0) {
> +		err(ctx, "cmd submission failed: %s\n", strerror(-rc));
> +		goto err;
> +	}
> +	rc = cxl_cmd_get_mbox_status(cmd);
> +	if (rc != 0) {
> +		err(ctx, "%s: mbox status: %d\n", __func__, rc);
> +		rc = -ENXIO;
> +	}
> +err:
> +	cxl_cmd_unref(cmd);
> +	return rc;
> +}
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index bed6427..5d02c45 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -78,6 +78,9 @@ global:
>  	cxl_cmd_get_partition_info_get_active_persistent_cap;
>  	cxl_cmd_get_partition_info_get_next_volatile_cap;
>  	cxl_cmd_get_partition_info_get_next_persistent_cap;
> +	cxl_cmd_new_set_partition_info;
> +	cxl_memdev_set_partition_info;
> +
>  local:
>          *;
>  };
> -- 
> 2.31.1
> 
