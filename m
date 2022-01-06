Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A0E173
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 20:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641500348; x=1673036348;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6rPUXqYtGgexKSG0o8mMR/rsuwXdicvHbvCYyB5h8gY=;
  b=cC2Q73tgIBn1IQPXCSh7Gxv9nYAcP7ok47ev3zFeJlNdj5JQ2uFd2PRn
   rvGhnBJpgpPhi+nXjBcX3skzZ0fNgqJ4GQ45vvLA31PEo28+QXeeW3FZ7
   swrlACIl/xmHSc5ZjedzjphBQ6K3FvHeAfN8CURRmN2q975DuRWawtQmU
   GH0I+nx0StQVU8s9L6+xvq4k6GPEcYC2bs4EvOyauPY+Tb2Dk5cuYqWzi
   Mx7p+IB5Qwa1afIknkuztWIg3aAMDtWqaFxa6o3Xuh76rtK/nE28PufGA
   m6Tatq9wlOGk8FdGI+ubcxnDm3SJ3CF6jAV4BDmNGwZ1mBvudHRk0Bmj+
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="229541260"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="229541260"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 12:19:08 -0800
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="621635488"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 12:19:07 -0800
Date: Thu, 6 Jan 2022 12:19:07 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: alison.schofield@intel.com
Cc: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 1/7] libcxl: add GET_PARTITION_INFO mailbox command
 and accessors
Message-ID: <20220106201907.GA178135@iweiny-DESK2.sc.intel.com>
Mail-Followup-To: alison.schofield@intel.com,
	Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
References: <cover.1641233076.git.alison.schofield@intel.com>
 <9d3c55cbd36efb6eabec075cc8596a6382f1f145.1641233076.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d3c55cbd36efb6eabec075cc8596a6382f1f145.1641233076.git.alison.schofield@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Mon, Jan 03, 2022 at 12:16:12PM -0800, Schofield, Alison wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Add libcxl APIs to create a new GET_PARTITION_INFO mailbox command, the
> command output data structure (privately), and accessor APIs to return
> the different fields in the partition info output.

I would rephrase this:

libcxl provides functions for C code to issue cxl mailbox commands as well as
parse the output returned.  Get partition info should be part of this API.

Add the libcxl get partition info mailbox support as well as an API to parse
the fields of the command returned.

All fields are specified in multiples of 256MB so also define a capacity
multiplier to convert the raw data into bytes.

> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  cxl/lib/private.h  | 10 ++++++++++
>  cxl/libcxl.h       |  5 +++++
>  util/size.h        |  1 +
>  cxl/lib/libcxl.c   | 41 +++++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym |  5 +++++
>  5 files changed, 62 insertions(+)
> 
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index a1b8b50..dd9234f 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -7,6 +7,7 @@
>  #include <cxl/cxl_mem.h>
>  #include <ccan/endian/endian.h>
>  #include <ccan/short_types/short_types.h>
> +#include <util/size.h>
>  
>  #define CXL_EXPORT __attribute__ ((visibility("default")))
>  
> @@ -104,6 +105,15 @@ struct cxl_cmd_get_health_info {
>  	le32 pmem_errors;
>  } __attribute__((packed));
>  
> +struct cxl_cmd_get_partition_info {
> +	le64 active_volatile_cap;
> +	le64 active_persistent_cap;
> +	le64 next_volatile_cap;
> +	le64 next_persistent_cap;
> +} __attribute__((packed));
> +
> +#define CXL_CAPACITY_MULTIPLIER		SZ_256M
> +
>  /* CXL 2.0 8.2.9.5.3 Byte 0 Health Status */
>  #define CXL_CMD_HEALTH_INFO_STATUS_MAINTENANCE_NEEDED_MASK		BIT(0)
>  #define CXL_CMD_HEALTH_INFO_STATUS_PERFORMANCE_DEGRADED_MASK		BIT(1)
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 89d35ba..7cf9061 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -109,6 +109,11 @@ ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd, void *buf,
>  		unsigned int length);
>  struct cxl_cmd *cxl_cmd_new_write_label(struct cxl_memdev *memdev,
>  		void *buf, unsigned int offset, unsigned int length);
> +struct cxl_cmd *cxl_cmd_new_get_partition_info(struct cxl_memdev *memdev);

why 'new'?  Why not:

cxl_cmd_get_partition_info()

?

> +unsigned long long cxl_cmd_get_partition_info_get_active_volatile_cap(struct cxl_cmd *cmd);
> +unsigned long long cxl_cmd_get_partition_info_get_active_persistent_cap(struct cxl_cmd *cmd);
> +unsigned long long cxl_cmd_get_partition_info_get_next_volatile_cap(struct cxl_cmd *cmd);
> +unsigned long long cxl_cmd_get_partition_info_get_next_persistent_cap(struct cxl_cmd *cmd);

These are pretty long function names.  :-/

I also wonder if the conversion to bytes should be reflected in the function
name.  Because returning 'cap' might imply to someone they are getting the raw
data field.

Ira

>  
>  #ifdef __cplusplus
>  } /* extern "C" */
> diff --git a/util/size.h b/util/size.h
> index a0f3593..e72467f 100644
> --- a/util/size.h
> +++ b/util/size.h
> @@ -15,6 +15,7 @@
>  #define SZ_4M     0x00400000
>  #define SZ_16M    0x01000000
>  #define SZ_64M    0x04000000
> +#define SZ_256M	  0x10000000
>  #define SZ_1G     0x40000000
>  #define SZ_1T 0x10000000000ULL
>  
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index f0664be..f3d4022 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1157,6 +1157,47 @@ CXL_EXPORT ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd,
>  	return length;
>  }
>  
> +CXL_EXPORT struct cxl_cmd *cxl_cmd_new_get_partition_info(struct cxl_memdev *memdev)
> +{
> +	return cxl_cmd_new_generic(memdev,
> +				   CXL_MEM_COMMAND_ID_GET_PARTITION_INFO);
> +}
> +
> +#define cmd_partition_get_capacity_field(cmd, field)			\
> +do {										\
> +	struct cxl_cmd_get_partition_info *c =					\
> +		(struct cxl_cmd_get_partition_info *)cmd->send_cmd->out.payload;\
> +	int rc = cxl_cmd_validate_status(cmd,					\
> +			CXL_MEM_COMMAND_ID_GET_PARTITION_INFO);			\
> +	if (rc)									\
> +		return ULLONG_MAX;							\
> +	return le64_to_cpu(c->field) * CXL_CAPACITY_MULTIPLIER;			\
> +} while (0)
> +
> +CXL_EXPORT unsigned long long
> +cxl_cmd_get_partition_info_get_active_volatile_cap(struct cxl_cmd *cmd)
> +{
> +	cmd_partition_get_capacity_field(cmd, active_volatile_cap);
> +}
> +
> +CXL_EXPORT unsigned long long
> +cxl_cmd_get_partition_info_get_active_persistent_cap(struct cxl_cmd *cmd)
> +{
> +	cmd_partition_get_capacity_field(cmd, active_persistent_cap);
> +}
> +
> +CXL_EXPORT unsigned long long
> +cxl_cmd_get_partition_info_get_next_volatile_cap(struct cxl_cmd *cmd)
> +{
> +	cmd_partition_get_capacity_field(cmd, next_volatile_cap);
> +}
> +
> +CXL_EXPORT unsigned long long
> +cxl_cmd_get_partition_info_get_next_persistent_cap(struct cxl_cmd *cmd)
> +{
> +	cmd_partition_get_capacity_field(cmd, next_persistent_cap);
> +}
> +
>  CXL_EXPORT int cxl_cmd_submit(struct cxl_cmd *cmd)
>  {
>  	struct cxl_memdev *memdev = cmd->memdev;
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 077d104..09d6d94 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -70,6 +70,11 @@ global:
>  	cxl_memdev_zero_label;
>  	cxl_memdev_write_label;
>  	cxl_memdev_read_label;
> +	cxl_cmd_new_get_partition_info;
> +	cxl_cmd_get_partition_info_get_active_volatile_cap;
> +	cxl_cmd_get_partition_info_get_active_persistent_cap;
> +	cxl_cmd_get_partition_info_get_next_volatile_cap;
> +	cxl_cmd_get_partition_info_get_next_persistent_cap;
>  local:
>          *;
>  };
> -- 
> 2.31.1
> 
