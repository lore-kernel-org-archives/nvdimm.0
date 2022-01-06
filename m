Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCF72C80
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 21:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641503128; x=1673039128;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=okntdEEgm6f+wGIvij8WxHiksNbTh7egR2BeI+WdecY=;
  b=C4xp3kkOdUF4zjTGvNnyuAuQQbdkX5aKRMbGWHWj236cuGrBh0akrM/1
   sJzM3gCo9HW02Fswe+2t6VRfIXW+AISFT6E4V0AApx4Y3l6QzZdUIiV6p
   5LY6ZYAtegnJXHSUD84S/Iy4LWhbpx2fWLC3pi/vkMA4E3ZXK1vA4lEpz
   e74k9/sYqBZ5upVQ5qLnpWkYZ7gm/tp9rjccbcU60zeDNfek68RQnEElu
   6OSLjGOnvqHBN2+JQZlckZmpp5nYCjy6Y30RhYaik8e4vFsggjsCsmxNQ
   o5l/yraFrYdUyvzRjevLfTOTy/eJYIZVxUCchObQ7KgPwf7Vi+6iRvkXk
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="222729519"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="222729519"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 13:05:27 -0800
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="527124722"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 13:05:26 -0800
Date: Thu, 6 Jan 2022 13:05:26 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: alison.schofield@intel.com
Cc: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 7/7] cxl: add command set-partition-info
Message-ID: <20220106210526.GH178135@iweiny-DESK2.sc.intel.com>
Mail-Followup-To: alison.schofield@intel.com,
	Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
References: <cover.1641233076.git.alison.schofield@intel.com>
 <fd590fbbc2f1abaeca1fd368d26c4e90c3a89d69.1641233076.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd590fbbc2f1abaeca1fd368d26c4e90c3a89d69.1641233076.git.alison.schofield@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Mon, Jan 03, 2022 at 12:16:18PM -0800, Schofield, Alison wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 

"User will need a command line option for setting partition info.  Add
'set-partition-info' to the cxl command line tool."

> The command 'cxl set-partition-info' operates on a CXL memdev,
> or a set of memdevs, allowing the user to change the partition
> layout of the device.
                ^^^^^^
		device(s).

> 
> Synopsis:
> Usage: cxl set-partition-info <mem0> [<mem1>..<memN>] [<options>]
> 
>     -v, --verbose         turn on debug
>     -s, --volatile_size <n>
>                           next volatile partition size in bytes
> 
> The MAN page explains how to find partitioning capabilities and
> restrictions.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  Documentation/cxl/cxl-set-partition-info.txt | 27 ++++++
>  Documentation/cxl/partition-description.txt  | 15 ++++
>  Documentation/cxl/partition-options.txt      | 19 +++++
>  Documentation/cxl/Makefile.am                |  3 +-
>  cxl/builtin.h                                |  1 +
>  cxl/cxl.c                                    |  1 +
>  cxl/memdev.c                                 | 89 ++++++++++++++++++++
>  7 files changed, 154 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/cxl/cxl-set-partition-info.txt
>  create mode 100644 Documentation/cxl/partition-description.txt
>  create mode 100644 Documentation/cxl/partition-options.txt
> 
> diff --git a/Documentation/cxl/cxl-set-partition-info.txt b/Documentation/cxl/cxl-set-partition-info.txt
> new file mode 100644
> index 0000000..32418b6
> --- /dev/null
> +++ b/Documentation/cxl/cxl-set-partition-info.txt
> @@ -0,0 +1,27 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-set-partition-info(1)
> +=========================
> +
> +NAME
> +----
> +cxl-set-partition-info - set the partitioning between volatile and persistent capacity on a CXL memdev
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl set-partition-info <mem> [ [<mem1>..<memN>] [<options>]'
> +
> +include::partition-description.txt[]
> +Partition the device on the next device reset using the volatile capacity
> +requested. Using this command to change the size of the persistent capacity
> +shall result in the loss of stored data.
> +
> +OPTIONS
> +-------
> +include::partition-options.txt[]
> +
> +SEE ALSO
> +--------
> +linkcxl:cxl-list[1],

Did I miss the update to the cxl-list command documentation?

> +CXL-2.0 8.2.9.5.2
> diff --git a/Documentation/cxl/partition-description.txt b/Documentation/cxl/partition-description.txt
> new file mode 100644
> index 0000000..b3efac8
> --- /dev/null
> +++ b/Documentation/cxl/partition-description.txt
> @@ -0,0 +1,15 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +DESCRIPTION
> +-----------
> +Partition the device into volatile and persistent capacity. The change
> +in partitioning will become the “next” configuration, to become active
> +on the next device reset.
> +
> +Use "cxl list -m <memdev> -P" to examine the partition capacities
> +supported on a device. Paritionable capacity must exist on the
> +device. A partition_alignment of zero means no partitionable
> +capacity is available.
> +
> +Using this command to change the size of the persistent capacity shall
> +result in the loss of data stored.
> diff --git a/Documentation/cxl/partition-options.txt b/Documentation/cxl/partition-options.txt
> new file mode 100644
> index 0000000..84e49c9
> --- /dev/null
> +++ b/Documentation/cxl/partition-options.txt
> @@ -0,0 +1,19 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +<memory device(s)>::
> +include::memdev-option.txt[]
> +
> +-s::
> +--size=::
> +	Size in bytes of the volatile partition requested.
> +
> +	Size must align to the devices partition_alignment.
> +	Use 'cxl list -m <memdev> -P' to find partition_alignment.
> +
> +	Size must be less than or equal to the devices partitionable bytes.
> +	(total_capacity - volatile_only_capacity - persistent_only_capacity)
> +	Use 'cxl list -m <memdev> -P' to find *_capacity values.
> +
> +-v::
> +	Turn on verbose debug messages in the library (if libcxl was built with
> +	logging and debug enabled).
> diff --git a/Documentation/cxl/Makefile.am b/Documentation/cxl/Makefile.am
> index efabaa3..c5faf04 100644
> --- a/Documentation/cxl/Makefile.am
> +++ b/Documentation/cxl/Makefile.am
> @@ -22,7 +22,8 @@ man1_MANS = \
>  	cxl-list.1 \
>  	cxl-read-labels.1 \
>  	cxl-write-labels.1 \
> -	cxl-zero-labels.1
> +	cxl-zero-labels.1 \
> +	cxl-set-partition-info.1
>  
>  EXTRA_DIST = $(man1_MANS)
>  
> diff --git a/cxl/builtin.h b/cxl/builtin.h
> index 78eca6e..7f11f28 100644
> --- a/cxl/builtin.h
> +++ b/cxl/builtin.h
> @@ -10,4 +10,5 @@ int cmd_read_labels(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_zero_labels(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_init_labels(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_check_labels(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_set_partition_info(int argc, const char **argv, struct cxl_ctx *ctx);
>  #endif /* _CXL_BUILTIN_H_ */
> diff --git a/cxl/cxl.c b/cxl/cxl.c
> index 4b1661d..3153cf0 100644
> --- a/cxl/cxl.c
> +++ b/cxl/cxl.c
> @@ -64,6 +64,7 @@ static struct cmd_struct commands[] = {
>  	{ "zero-labels", .c_fn = cmd_zero_labels },
>  	{ "read-labels", .c_fn = cmd_read_labels },
>  	{ "write-labels", .c_fn = cmd_write_labels },
> +	{ "set-partition-info", .c_fn = cmd_set_partition_info },
>  };
>  
>  int main(int argc, const char **argv)
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index 5ee38e5..fa63317 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -6,6 +6,7 @@
>  #include <unistd.h>
>  #include <limits.h>
>  #include <util/log.h>
> +#include <util/size.h>
>  #include <util/filter.h>
>  #include <cxl/libcxl.h>
>  #include <util/parse-options.h>
> @@ -23,6 +24,7 @@ static struct parameters {
>  	unsigned len;
>  	unsigned offset;
>  	bool verbose;
> +	unsigned long long volatile_size;
>  } param;
>  
>  #define fail(fmt, ...) \
> @@ -47,6 +49,10 @@ OPT_UINTEGER('s', "size", &param.len, "number of label bytes to operate"), \
>  OPT_UINTEGER('O', "offset", &param.offset, \
>  	"offset into the label area to start operation")
>  
> +#define SET_PARTITION_OPTIONS() \
> +OPT_U64('s', "volatile_size",  &param.volatile_size, \
> +	"next volatile partition size in bytes")
> +
>  static const struct option read_options[] = {
>  	BASE_OPTIONS(),
>  	LABEL_OPTIONS(),
> @@ -67,6 +73,12 @@ static const struct option zero_options[] = {
>  	OPT_END(),
>  };
>  
> +static const struct option set_partition_options[] = {
> +	BASE_OPTIONS(),
> +	SET_PARTITION_OPTIONS(),
> +	OPT_END(),
> +};
> +
>  static int action_zero(struct cxl_memdev *memdev, struct action_context *actx)
>  {
>  	size_t size;
> @@ -174,6 +186,73 @@ out:
>  	return rc;
>  }
>  
> +static int validate_partition(struct cxl_memdev *memdev,
> +		unsigned long long volatile_request)
> +{
> +	unsigned long long total_cap, volatile_only, persistent_only;
> +	unsigned long long partitionable_bytes, partition_align_bytes;
> +	const char *devname = cxl_memdev_get_devname(memdev);
> +	struct cxl_cmd *cmd;
> +	int rc;
> +
> +	cmd = cxl_cmd_new_identify(memdev);
> +	if (!cmd)
> +		return -ENXIO;
> +	rc = cxl_cmd_submit(cmd);
> +	if (rc < 0)
> +		goto err;
> +	rc = cxl_cmd_get_mbox_status(cmd);
> +	if (rc != 0)
> +		goto err;
> +
> +	partition_align_bytes = cxl_cmd_identify_get_partition_align(cmd);
> +	if (partition_align_bytes == 0) {
> +		fprintf(stderr, "%s: no partitionable capacity\n", devname);
> +		rc = -EINVAL;
> +		goto err;
> +	}
> +
> +	total_cap = cxl_cmd_identify_get_total_capacity(cmd);
> +	volatile_only = cxl_cmd_identify_get_volatile_only_capacity(cmd);
> +	persistent_only = cxl_cmd_identify_get_persistent_only_capacity(cmd);
> +
> +	partitionable_bytes = total_cap - volatile_only - persistent_only;
> +
> +	if (volatile_request > partitionable_bytes) {
> +		fprintf(stderr, "%s: volatile size %lld exceeds partitionable capacity %lld\n",
> +			devname, volatile_request, partitionable_bytes);
> +		rc = -EINVAL;
> +		goto err;
> +	}
> +	if (!IS_ALIGNED(volatile_request, partition_align_bytes)) {
> +		fprintf(stderr, "%s: volatile size %lld is not partition aligned %lld\n",
> +			devname, volatile_request, partition_align_bytes);
> +		rc = -EINVAL;
> +	}
> +err:
> +	cxl_cmd_unref(cmd);
> +	return rc;
> +}
> +
> +static int action_set_partition(struct cxl_memdev *memdev,
> +		struct action_context *actx)
> +{
> +	const char *devname = cxl_memdev_get_devname(memdev);
> +	unsigned long long volatile_request;
> +	int rc;
> +
> +	volatile_request = param.volatile_size;
> +
> +	rc = validate_partition(memdev, volatile_request);
> +	if (rc)
> +		return rc;
> +
> +	rc = cxl_memdev_set_partition_info(memdev, volatile_request, 0);

CXL_CMD_SET_PARTITION_INFO_NO_FLAG?

Ira

> +	if (rc)
> +		fprintf(stderr, "%s error: %s\n", devname, strerror(-rc));
> +	return rc;
> +}
> +
>  static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
>  		int (*action)(struct cxl_memdev *memdev, struct action_context *actx),
>  		const struct option *options, const char *usage)
> @@ -322,3 +401,13 @@ int cmd_zero_labels(int argc, const char **argv, struct cxl_ctx *ctx)
>  			count > 1 ? "s" : "");
>  	return count >= 0 ? 0 : EXIT_FAILURE;
>  }
> +
> +int cmd_set_partition_info(int argc, const char **argv, struct cxl_ctx *ctx)
> +{
> +	int count = memdev_action(argc, argv, ctx, action_set_partition,
> +			set_partition_options,
> +			"cxl set-partition-info <mem0> [<mem1>..<memN>] [<options>]");
> +	fprintf(stderr, "set_partition %d mem%s\n", count >= 0 ? count : 0,
> +			count > 1 ? "s" : "");
> +	return count >= 0 ? 0 : EXIT_FAILURE;
> +}
> -- 
> 2.31.1
> 
