Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3AF2C80
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 20:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641502146; x=1673038146;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YXIWpJSDkXCPKWmzsbTssesp7LszSl7Ai2Xqf3BMVhE=;
  b=XUtAgZTHYAi/6Ny7f3fBnKy5HhnAcDbxxYGgxIkw3xaD7mbFcM/KEqfE
   MirGrNQ5URoZZkYz0dzayaXWLjq/hW6tOxivWev6Ex76sYtw+nS0ByApv
   lYnQHikZLL5bKp/HMoZsx5V6q3GQsWwI9sJoqL+VV5SnGy1dXJsjbk/Om
   9eSxvUV/dFXT/bNYbq0v76QY1vBYTtqcKLyRtk8DuucXRSNMC+FbnBV0x
   Btf52l02inQvlgGO1LnltVWFTzeyBebIyLboYznpBFOq00/vp1Df5NOrg
   Qxyqld2exwwx7pWfHtrrQCyEweJ5jbAkzQsiwd88mkLbt2sIGF8AWHAMy
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="306095174"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="306095174"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 12:49:05 -0800
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="668558332"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 12:49:05 -0800
Date: Thu, 6 Jan 2022 12:49:05 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: alison.schofield@intel.com
Cc: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 4/7] cxl: add memdev partition information to
 cxl-list
Message-ID: <20220106204905.GE178135@iweiny-DESK2.sc.intel.com>
Mail-Followup-To: alison.schofield@intel.com,
	Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
References: <cover.1641233076.git.alison.schofield@intel.com>
 <78ff68a062f23cef48fb6ea1f91bcd7e11e4fa6e.1641233076.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78ff68a062f23cef48fb6ea1f91bcd7e11e4fa6e.1641233076.git.alison.schofield@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Mon, Jan 03, 2022 at 12:16:15PM -0800, Schofield, Alison wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 

"Users will want to be able to check the current partition information.  In
addition they will need to know the capacity values to form a valid set
partition information command."

> Add information useful for managing memdev partitions to cxl-list
     ^
   "optional"

> output. Include all of the fields from GET_PARTITION_INFO and the
> partitioning related fields from the IDENTIFY mailbox command.
> 

"Sample output for this section is:"

>     "partition":{
>       "active_volatile_capacity":273535729664,
>       "active_persistent_capacity":0,
>       "next_volatile_capacity":0,
>       "next_persistent_capacity":0,
>       "total_capacity":273535729664,
>       "volatile_only_capacity":0,
>       "persistent_only_capacity":0,
>       "partition_alignment":268435456
>     }
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  Documentation/cxl/cxl-list.txt |  23 +++++++
>  util/json.h                    |   1 +
>  cxl/list.c                     |   5 ++
>  util/json.c                    | 112 +++++++++++++++++++++++++++++++++
>  4 files changed, 141 insertions(+)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index c8d10fb..e65e944 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -85,6 +85,29 @@ OPTIONS
>    }
>  ]
>  ----
> +-P::
> +--partition::
> +	Include partition information in the memdev listing. Example listing:
> +----
> +# cxl list -m mem0 -P
> +[
> +  {
> +    "memdev":"mem0",
> +    "pmem_size":0,
> +    "ram_size":273535729664,
> +    "partition":{
> +      "active_volatile_capacity":273535729664,
> +      "active_persistent_capacity":0,
> +      "next_volatile_capacity":0,
> +      "next_persistent_capacity":0,
> +      "total_capacity":273535729664,
> +      "volatile_only_capacity":0,
> +      "persistent_only_capacity":0,
> +      "partition_alignment":268435456
> +    }
> +  }
> +]
> +----
>  
>  include::human-option.txt[]
>  
> diff --git a/util/json.h b/util/json.h
> index ce575e6..76a8816 100644
> --- a/util/json.h
> +++ b/util/json.h
> @@ -20,6 +20,7 @@ enum util_json_flags {
>  	UTIL_JSON_FIRMWARE	= (1 << 8),
>  	UTIL_JSON_DAX_MAPPINGS	= (1 << 9),
>  	UTIL_JSON_HEALTH	= (1 << 10),
> +	UTIL_JSON_PARTITION	= (1 << 11),
>  };
>  
>  struct json_object;
> diff --git a/cxl/list.c b/cxl/list.c
> index b1468b7..368ec21 100644
> --- a/cxl/list.c
> +++ b/cxl/list.c
> @@ -17,6 +17,7 @@ static struct {
>  	bool idle;
>  	bool human;
>  	bool health;
> +	bool partition;
>  } list;
>  
>  static unsigned long listopts_to_flags(void)
> @@ -29,6 +30,8 @@ static unsigned long listopts_to_flags(void)
>  		flags |= UTIL_JSON_HUMAN;
>  	if (list.health)
>  		flags |= UTIL_JSON_HEALTH;
> +	if (list.partition)
> +		flags |= UTIL_JSON_PARTITION;
>  	return flags;
>  }
>  
> @@ -62,6 +65,8 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>  				"use human friendly number formats "),
>  		OPT_BOOLEAN('H', "health", &list.health,
>  				"include memory device health information "),
> +		OPT_BOOLEAN('P', "partition", &list.partition,
> +				"include memory device partition information "),
>  		OPT_END(),
>  	};
>  	const char * const u[] = {
> diff --git a/util/json.c b/util/json.c
> index f97cf07..4254dea 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -1616,6 +1616,113 @@ err_jobj:
>  	return NULL;
>  }
>  
> +/*
> + * Present complete view of memdev partition by presenting fields from
> + * both GET_PARTITION_INFO and IDENTIFY mailbox commands.
> + */
> +static struct json_object *util_cxl_memdev_partition_to_json(struct cxl_memdev *memdev,
> +		unsigned long flags)
> +{
> +	struct json_object *jobj = NULL;
> +	struct json_object *jpart;
> +	unsigned long long cap;
> +	struct cxl_cmd *cmd;
> +	int rc;
> +
> +	jpart = json_object_new_object();
> +	if (!jpart)
> +		return NULL;
> +	if (!memdev)
> +		goto err_jobj;
> +
> +	/* Retrieve partition info in GET_PARTITION_INFO mbox cmd */
> +	cmd = cxl_cmd_new_get_partition_info(memdev);

Oh...  now I understand the 'new'...  Sorry...

> +	if (!cmd)
> +		goto err_jobj;
> +
> +	rc = cxl_cmd_submit(cmd);
> +	if (rc < 0)
> +		goto err_cmd;
> +	rc = cxl_cmd_get_mbox_status(cmd);
> +	if (rc != 0)
> +		goto err_cmd;
> +
> +	cap = cxl_cmd_get_partition_info_get_active_volatile_cap(cmd);
> +	if (cap != ULLONG_MAX) {
> +		jobj = util_json_object_size(cap, flags);
> +		if (jobj)
> +			json_object_object_add(jpart,
> +					"active_volatile_capacity", jobj);
> +	}
> +	cap = cxl_cmd_get_partition_info_get_active_persistent_cap(cmd);
> +	if (cap != ULLONG_MAX) {
> +		jobj = util_json_object_size(cap, flags);
> +		if (jobj)
> +			json_object_object_add(jpart,
> +					"active_persistent_capacity", jobj);
> +	}
> +	cap = cxl_cmd_get_partition_info_get_next_volatile_cap(cmd);
> +	if (cap != ULLONG_MAX) {
> +		jobj = util_json_object_size(cap, flags);
> +		if (jobj)
> +			json_object_object_add(jpart,
> +					"next_volatile_capacity", jobj);
> +	}
> +	cap = cxl_cmd_get_partition_info_get_next_persistent_cap(cmd);
> +	if (cap != ULLONG_MAX) {
> +		jobj = util_json_object_size(cap, flags);
> +		if (jobj)
> +			json_object_object_add(jpart,
> +					"next_persistent_capacity", jobj);
> +	}
> +	cxl_cmd_unref(cmd);
> +
> +	/* Retrieve partition info in the IDENTIFY mbox cmd */
> +	cmd = cxl_cmd_new_identify(memdev);
> +	if (!cmd)
> +		goto err_jobj;
> +
> +	rc = cxl_cmd_submit(cmd);
> +	if (rc < 0)
> +		goto err_cmd;
> +	rc = cxl_cmd_get_mbox_status(cmd);
> +	if (rc != 0)
> +		goto err_cmd;
> +
> +	cap = cxl_cmd_identify_get_total_capacity(cmd);
> +	if (cap != ULLONG_MAX) {
> +		jobj = util_json_object_size(cap, flags);
> +		if (jobj)
> +			json_object_object_add(jpart, "total_capacity", jobj);
> +	}
> +	cap = cxl_cmd_identify_get_volatile_only_capacity(cmd);
> +	if (cap != ULLONG_MAX) {
> +		jobj = util_json_object_size(cap, flags);
> +		if (jobj)
> +			json_object_object_add(jpart,
> +					"volatile_only_capacity", jobj);
> +	}
> +	cap = cxl_cmd_identify_get_persistent_only_capacity(cmd);
> +	if (cap != ULLONG_MAX) {
> +		jobj = util_json_object_size(cap, flags);
> +		if (jobj)
> +			json_object_object_add(jpart,
> +					"persistent_only_capacity", jobj);
> +	}
> +	cap = cxl_cmd_identify_get_partition_align(cmd);
> +	jobj = util_json_object_size(cap, flags);
> +	if (jobj)
> +		json_object_object_add(jpart, "partition_alignment", jobj);
> +
> +	return jpart;
> +
> +err_cmd:

Doesn't this need to be called always, not just on error?

Ira

> +	cxl_cmd_unref(cmd);
> +err_jobj:
> +	json_object_put(jpart);
> +	return NULL;
> +}
> +
>  struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  		unsigned long flags)
>  {
> @@ -1643,5 +1750,10 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  		if (jobj)
>  			json_object_object_add(jdev, "health", jobj);
>  	}
> +	if (flags & UTIL_JSON_PARTITION) {
> +		jobj = util_cxl_memdev_partition_to_json(memdev, flags);
> +		if (jobj)
> +			json_object_object_add(jdev, "partition", jobj);
> +	}
>  	return jdev;
>  }
> -- 
> 2.31.1
> 
