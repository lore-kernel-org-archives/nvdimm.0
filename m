Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3209518D621
	for <nvdimm@lists.linux.dev>; Thu,  5 Sep 2024 19:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725565098; cv=none; b=TVz3m01Ma2pWwXGRbLezkb5VNUURMqzL3wUC3rugqfK0GSHQ3DAjcx8BVOzd5SJYjUh9DA5k56p2qW39hyWRwFsZ+cN2BPdgDPQ4zNYZlMFl51tjwuIhaGktHMTtnVSr4wK++qooueLlswrLmphoDJ03psb4JXzaGj6b54Vq3tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725565098; c=relaxed/simple;
	bh=rEJrEfWK2wPvFeVhNDwB89FCx/XdnVGw9p3eDmGzjRg=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QgvkzKzjWw11nDE/NL0DCdebka8CDJLzp0JUYSgGzLpBwgBhIfkZAxB4s9wXRx7CMrXDYOBhUmF0VH+dCjpM537PFHfc32pivC0J1vJEJuZ9Ocie4vV6u5vh2A6aNl7/u7MKQyM/bXNLaAOoJujUzU7JR+ls9OARWtOMbbpZUF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ScjcTN0K; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ScjcTN0K"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7179802b8fcso559093b3a.1
        for <nvdimm@lists.linux.dev>; Thu, 05 Sep 2024 12:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725565096; x=1726169896; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RoJ5iogFwW0VL1Q5zPpiH2JOLsryAHxoNpCbuiCSojg=;
        b=ScjcTN0K6Kd/HFTQDhm61AYCgNDArHfDhP/DOltyGN7snZPcgPpb+EPCh+qBljJhUx
         AXJ1K/EMlPauDEg8AvzU8LLjAqVt4vD3mTeU5JlgYDDJdpUv8WWDX8t54UNBHbqxljDs
         Bp76KzTh0Ft5WYT4IY21AOQgAq9eWNYqWBIvrNw0r1DCwwyHEljtAYAvBZHDrKeC4cYm
         CvlafiQe+v4eIj8WY3GmWFNDtsWCyueIA8d7CmuDN3GmmgjBqcaEFwP02xil2+lRg88p
         ErB++VmrQkz9KqLMAjrmJ+NgnIsZ49CONRD1sKhnL+IUmXBeu8UrQFuylLhGm7uOB4QB
         vVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725565096; x=1726169896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RoJ5iogFwW0VL1Q5zPpiH2JOLsryAHxoNpCbuiCSojg=;
        b=YdGpcspp3BHGYzqAEFM1+q0U5ojf5EDjeutR7/bPusQxANubfw+1aASdPYZgN5mrRa
         kxKQM6eZYxWqBbziN90exO9SQioYHC24W1SBbjJmqliea4xIvLnwaa4IgegPl/bi8pPK
         er5IiVKUv7iNRtNikdOaHHQ4JcwDmbU3qj95TnOKh26wrjqmIU1icER21Qet3Y3JVkHE
         Am22ilD/gNXM/uFOT46DHqR10rxK3Fs4KAqdMknHeTW7wdVUyMcyL3xyyhQPDSkbv/nM
         zs8hUJOeNVcbMNgxs5L48W+BxVHvaIjoPE9FATjLVPgwIN+0DFwcorfj0geO3I7/PJkT
         tiCA==
X-Forwarded-Encrypted: i=1; AJvYcCXFZ6mfiERc0/VCfS6HapfVouM9PRI1wJUvgq+anKePTbv6JUFz+d5Lu70lnGSrBD/IKS/yYjg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzkjGreKC8oDkQKyY/ijRmV0ywMn5mKunAXa88pMADjLdI+SUGC
	SEt+xyRzLKVA1Vc2k/yXHQjS+N4wX+VNh0//0kqNRzLdU5Gk8DDTIaM5yw==
X-Google-Smtp-Source: AGHT+IGK2spoXPBisM3guR58ybMmPqq5eHv3CjkwY02CviGpcbGkNbrkJXjlFUMuIM5nJNPUesBG+A==
X-Received: by 2002:a05:6a00:949e:b0:714:19f8:f135 with SMTP id d2e1a72fcca58-718d5eefa91mr280494b3a.21.1725565096490;
        Thu, 05 Sep 2024 12:38:16 -0700 (PDT)
Received: from leg ([2601:646:8f03:9fee:1d73:7db5:2b4a:dfdd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-718532df5b3sm268114b3a.155.2024.09.05.12.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 12:38:16 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 5 Sep 2024 12:38:13 -0700
To: ira.weiny@intel.com
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 23/25] cxl/mem: Trace Dynamic capacity Event Record
Message-ID: <ZtoIpQ343e0NKoI6@leg>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-23-7c9b96cba6d7@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240816-dcd-type2-upstream-v3-23-7c9b96cba6d7@intel.com>

On Fri, Aug 16, 2024 at 09:44:31AM -0500, ira.weiny@intel.com wrote:
> From: Navneet Singh <navneet.singh@intel.com>
> 
> CXL rev 3.1 section 8.2.9.2.1 adds the Dynamic Capacity Event Records.
> User space can use trace events for debugging of DC capacity changes.
> 
> Add DC trace points to the trace log.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
With the following cxl spec version fixed, 

Reviewed-by: Fan Ni <fan.ni@samsung.com>

> ---
> Changes:
> [Alison: Update commit message]
> ---
>  drivers/cxl/core/mbox.c  |  4 +++
>  drivers/cxl/core/trace.h | 65 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 69 insertions(+)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index d43ac8eabf56..8202fc6c111d 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -977,6 +977,10 @@ static void __cxl_event_trace_record(const struct cxl_memdev *cxlmd,
>  		ev_type = CXL_CPER_EVENT_DRAM;
>  	else if (uuid_equal(uuid, &CXL_EVENT_MEM_MODULE_UUID))
>  		ev_type = CXL_CPER_EVENT_MEM_MODULE;
> +	else if (uuid_equal(uuid, &CXL_EVENT_DC_EVENT_UUID)) {
> +		trace_cxl_dynamic_capacity(cxlmd, type, &record->event.dcd);
> +		return;
> +	}
>  
>  	cxl_event_trace_record(cxlmd, type, ev_type, uuid, &record->event);
>  }
> diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
> index 9167cfba7f59..a3a5269311ee 100644
> --- a/drivers/cxl/core/trace.h
> +++ b/drivers/cxl/core/trace.h
> @@ -731,6 +731,71 @@ TRACE_EVENT(cxl_poison,
>  	)
>  );
>  
> +/*
> + * DYNAMIC CAPACITY Event Record - DER
> + *
> + * CXL rev 3.0 section 8.2.9.2.1.5 Table 8-47
Update to reflect r3.1
Fan
> + */
> +
> +#define CXL_DC_ADD_CAPACITY			0x00
> +#define CXL_DC_REL_CAPACITY			0x01
> +#define CXL_DC_FORCED_REL_CAPACITY		0x02
> +#define CXL_DC_REG_CONF_UPDATED			0x03
> +#define show_dc_evt_type(type)	__print_symbolic(type,		\
> +	{ CXL_DC_ADD_CAPACITY,	"Add capacity"},		\
> +	{ CXL_DC_REL_CAPACITY,	"Release capacity"},		\
> +	{ CXL_DC_FORCED_REL_CAPACITY,	"Forced capacity release"},	\
> +	{ CXL_DC_REG_CONF_UPDATED,	"Region Configuration Updated"	} \
> +)
> +
> +TRACE_EVENT(cxl_dynamic_capacity,
> +
> +	TP_PROTO(const struct cxl_memdev *cxlmd, enum cxl_event_log_type log,
> +		 struct cxl_event_dcd *rec),
> +
> +	TP_ARGS(cxlmd, log, rec),
> +
> +	TP_STRUCT__entry(
> +		CXL_EVT_TP_entry
> +
> +		/* Dynamic capacity Event */
> +		__field(u8, event_type)
> +		__field(u16, hostid)
> +		__field(u8, region_id)
> +		__field(u64, dpa_start)
> +		__field(u64, length)
> +		__array(u8, tag, CXL_EXTENT_TAG_LEN)
> +		__field(u16, sh_extent_seq)
> +	),
> +
> +	TP_fast_assign(
> +		CXL_EVT_TP_fast_assign(cxlmd, log, rec->hdr);
> +
> +		/* Dynamic_capacity Event */
> +		__entry->event_type = rec->event_type;
> +
> +		/* DCD event record data */
> +		__entry->hostid = le16_to_cpu(rec->host_id);
> +		__entry->region_id = rec->region_index;
> +		__entry->dpa_start = le64_to_cpu(rec->extent.start_dpa);
> +		__entry->length = le64_to_cpu(rec->extent.length);
> +		memcpy(__entry->tag, &rec->extent.tag, CXL_EXTENT_TAG_LEN);
> +		__entry->sh_extent_seq = le16_to_cpu(rec->extent.shared_extn_seq);
> +	),
> +
> +	CXL_EVT_TP_printk("event_type='%s' host_id='%d' region_id='%d' " \
> +		"starting_dpa=%llx length=%llx tag=%s " \
> +		"shared_extent_sequence=%d",
> +		show_dc_evt_type(__entry->event_type),
> +		__entry->hostid,
> +		__entry->region_id,
> +		__entry->dpa_start,
> +		__entry->length,
> +		__print_hex(__entry->tag, CXL_EXTENT_TAG_LEN),
> +		__entry->sh_extent_seq
> +	)
> +);
> +
>  #endif /* _CXL_EVENTS_H */
>  
>  #define TRACE_INCLUDE_FILE trace
> 
> -- 
> 2.45.2
> 
