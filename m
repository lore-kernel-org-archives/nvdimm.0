Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009F13B1ED7
	for <nvdimm@lists.linux.dev>; Fri, 29 May 2026 22:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780094479; cv=none; b=h9oVm7CqcCdvwj66Q5GaIR9u9g4gJCKSDW4/cIU+tZ5CVIR5k8KEwA0wWxkiefiMAAmUYL4If/cpgX1lW9zFRETjmeZdxulfR1nuG4f3+ygu0NZAattnoJ9BCh56hUf2cAXCaWLre9A1CK01+EChcPUed9VGzdAbV8UAI/ysAAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780094479; c=relaxed/simple;
	bh=lmSCp6FeEi2Dd5VohTQ0zzfawN5+yjiPi2XrwSnDCHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BvN4S1N3FLOJVfqiM9FJtABgzQRlAO4cMonqjOMFZ2x2w0Ayz0vIPccKWZatvh5QgriRXs9sVQJs6ghPz8nsDODsQv9Fxl4/pVLxuWCL8mU6GcVLqlEAE73gUPmyYdy2UJ3eLFqtLsC6cPLVqZQCt73dlXZleJhk2LVadoenRDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BfypJ3fx; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BfypJ3fx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780094478; x=1811630478;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lmSCp6FeEi2Dd5VohTQ0zzfawN5+yjiPi2XrwSnDCHQ=;
  b=BfypJ3fxgfHgtx7QvQveSO83wVzMlcSSqh90o/j+KIUykLmXdMRoVSnE
   Ah6t2o12RrDmk8FTw8Igzq8qb0N8z1nPIb9+oB6PsxHqtKsjC/h0JKppZ
   8QFaLEWHCq2LvLhZVVy5nC4O0NN/1GoWLI+BMg4rO2j/GJCpZsT4+IwD/
   StfqskQ4B52rPqtm8RgzQLi46N5+xgYmSqur2f5VlIeJnPUbjK1cdf/yF
   RomM4axE4g9PsVQyafOmZYfjNf18o7CpyMERvY/2fe3FCtG4B2KtJpQWg
   rX77mNFzEVawS0blE3gjRUgaEpvrY+1yGFmQ3YJPfEHA//wn37j81cU5K
   g==;
X-CSE-ConnectionGUID: RIyPoewnQf6E706ca/861Q==
X-CSE-MsgGUID: WIDDStFrTbu0nIgYrk1oag==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="84811396"
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="84811396"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 15:41:17 -0700
X-CSE-ConnectionGUID: OOSO2305S56VphsVFye3rw==
X-CSE-MsgGUID: 89Ljf0KyRfWePudUyTLTlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="239960901"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.111.151]) ([10.125.111.151])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 15:41:16 -0700
Message-ID: <5236aaf9-52d6-43e9-82b2-84fa08d35357@intel.com>
Date: Fri, 29 May 2026 15:41:15 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 28/31] cxl/mem: Trace Dynamic capacity Event Record
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, Fan Ni <fan.ni@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <54f9e863fac7a9c040267a13cd36aa7415e29f4f.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <54f9e863fac7a9c040267a13cd36aa7415e29f4f.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:43 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> CXL rev 3.1 section 8.2.9.2.1 adds the Dynamic Capacity Event Records.
> User space can use trace events for debugging of DC capacity changes.
> 
> Add DC trace points to the trace log.
> 
> Based on an original patch by Navneet Singh.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Fan Ni <fan.ni@samsung.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  drivers/cxl/core/mbox.c  |  5 ++++
>  drivers/cxl/core/trace.h | 65 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 70 insertions(+)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 486110e1c03d..271f4556db85 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1030,6 +1030,11 @@ static void __cxl_event_trace_record(struct cxl_memdev *cxlmd,
>  		ev_type = CXL_CPER_EVENT_MEM_MODULE;
>  	else if (uuid_equal(uuid, &CXL_EVENT_MEM_SPARING_UUID))
>  		ev_type = CXL_CPER_EVENT_MEM_SPARING;
> +	else if (uuid_equal(uuid, &CXL_EVENT_DC_EVENT_UUID)) {
> +/* FIXME still valid? */

? address or delete?

> +		trace_cxl_dynamic_capacity(cxlmd, type, &record->event.dcd);
> +		return;
> +	}
>  
>  	cxl_event_trace_record(cxlmd, type, ev_type, uuid, &record->event);
>  }
> diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
> index a972e4ef1936..421e492d1b3f 100644
> --- a/drivers/cxl/core/trace.h
> +++ b/drivers/cxl/core/trace.h
> @@ -1099,6 +1099,71 @@ TRACE_EVENT(cxl_poison,
>  	)
>  );
>  
> +/*
> + * Dynamic Capacity Event Record - DER
> + *
> + * CXL rev 3.1 section 8.2.9.2.1.6 Table 8-50

Let's move it to 4.0

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
> +		__field(u8, partition_id)
> +		__field(u64, dpa_start)
> +		__field(u64, length)
> +		__array(u8, uuid, UUID_SIZE)
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
> +		__entry->partition_id = rec->partition_index;

CXL r4.0 8.2.10.2.1.6 Table 8-229

Couple issues.
1. This is not partition_index, it's updated_region_index.
2. It's only valid for events of type Region Configuration Updated. Otherwise we may be displaying garbage or 0.

So it needs a rename and also a check for validity. Better to fix it before rasdaemon start picking it up.

DJ

> +		__entry->dpa_start = le64_to_cpu(rec->extent.start_dpa);
> +		__entry->length = le64_to_cpu(rec->extent.length);
> +		memcpy(__entry->uuid, &rec->extent.uuid, UUID_SIZE);
> +		__entry->sh_extent_seq = le16_to_cpu(rec->extent.shared_extn_seq);
> +	),
> +
> +	CXL_EVT_TP_printk("event_type='%s' host_id='%d' partition_id='%d' " \
> +		"starting_dpa=%llx length=%llx tag=%pU " \
> +		"shared_extent_sequence=%d",
> +		show_dc_evt_type(__entry->event_type),
> +		__entry->hostid,
> +		__entry->partition_id,
> +		__entry->dpa_start,
> +		__entry->length,
> +		__entry->uuid,
> +		__entry->sh_extent_seq
> +	)
> +);
> +
>  #endif /* _CXL_EVENTS_H */
>  
>  #define TRACE_INCLUDE_FILE trace

