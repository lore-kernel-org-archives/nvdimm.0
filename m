Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81DE168
	for <nvdimm@lists.linux.dev>; Thu, 13 Jan 2022 16:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642091214; x=1673627214;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2KqVysjo1STcaRcSk5SeVRCpxfh0h/KQt5/R8OYhhtA=;
  b=QEzLF/piTtyhu0rDAya2TjSW9a8BjpNiCGqqbB+W+aXCnKT2xywHvWYc
   +AYsSXWqh4fuyMcbEKiBPXuL4Ph6egTaVj0zWjwfy0bX5h6Y/oaCNj7Zi
   orfphqoYKM57MjFb80Tvc5Z3fgRrPz+Fg59gskVLxp6Xc6ddItBw77qy9
   PsMF5nmm8b5lEaTv8/pn24XWzg8+gDibelkmTbvuAFJ3ummlpVOYClZC6
   FsyB8gzDUrfLPDHwyjeyPFU4hFlYvYTnyS6E70tRC6c00noi5WrdOu62n
   fEhENCXrwDrIlAVDCM/ZF+Ic3nqKHcRp49zZtFOrSiycKD9hx5q1BzZQD
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="304777890"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="304777890"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 08:26:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="529720754"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 08:26:50 -0800
Date: Thu, 13 Jan 2022 08:31:49 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v2 3/6] libcxl: return the partition alignment
 field in bytes
Message-ID: <20220113163149.GA831535@alison-desk>
References: <cover.1641965853.git.alison.schofield@intel.com>
 <ca1821eee9f8e2372e378165d5c24bbf9161e6fe.1641965853.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca1821eee9f8e2372e378165d5c24bbf9161e6fe.1641965853.git.alison.schofield@intel.com>


On Tue, Jan 11, 2022 at 10:33:31PM -0800, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Per the CXL specification, the partition alignment field reports
> the alignment value in multiples of 256MB. In the libcxl API, values
> for all capacity fields are defined to return bytes.
> 
> Update the partition alignment accessor to return bytes so that it
> is in sync with other capacity related fields.
> 
> Rename the function to reflect the new return value:
> cxl_cmd_identify_get_partition_align_bytes()

Vishal,
Just realized that the cxl_identify_get_partition_align() API was released
in ndctl-v72. Does that mean NAK on changing the name here?
Alison

> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  cxl/lib/libcxl.c   | 4 ++--
>  cxl/lib/libcxl.sym | 2 +-
>  cxl/libcxl.h       | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 1fd584a..823bcb0 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1078,7 +1078,7 @@ CXL_EXPORT int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev,
>  	return 0;
>  }
>  
> -CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
> +CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align_bytes(
>  		struct cxl_cmd *cmd)
>  {
>  	struct cxl_cmd_identify *id =
> @@ -1089,7 +1089,7 @@ CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
>  	if (cmd->status < 0)
>  		return cmd->status;
>  
> -	return le64_to_cpu(id->partition_align);
> +	return le64_to_cpu(id->partition_align) * CXL_CAPACITY_MULTIPLIER;
>  }
>  
>  CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index b7e969f..1e2cf05 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -34,7 +34,7 @@ global:
>  	cxl_cmd_identify_get_total_bytes;
>  	cxl_cmd_identify_get_volatile_only_bytes;
>  	cxl_cmd_identify_get_persistent_only_bytes;
> -	cxl_cmd_identify_get_partition_align;
> +	cxl_cmd_identify_get_partition_align_bytes;
>  	cxl_cmd_identify_get_label_size;
>  	cxl_cmd_new_get_health_info;
>  	cxl_cmd_health_info_get_maintenance_needed;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 46f99fb..f19ed4f 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -71,7 +71,7 @@ int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev, int fw_len);
>  unsigned long long cxl_cmd_identify_get_total_bytes(struct cxl_cmd *cmd);
>  unsigned long long cxl_cmd_identify_get_volatile_only_bytes(struct cxl_cmd *cmd);
>  unsigned long long cxl_cmd_identify_get_persistent_only_bytes(struct cxl_cmd *cmd);
> -unsigned long long cxl_cmd_identify_get_partition_align(struct cxl_cmd *cmd);
> +unsigned long long cxl_cmd_identify_get_partition_align_bytes(struct cxl_cmd *cmd);
>  unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd);
>  struct cxl_cmd *cxl_cmd_new_get_health_info(struct cxl_memdev *memdev);
>  int cxl_cmd_health_info_get_maintenance_needed(struct cxl_cmd *cmd);
> -- 
> 2.31.1
> 
