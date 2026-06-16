Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC99B423A77
	for <nvdimm@lists.linux.dev>; Tue, 16 Jun 2026 09:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781603981; cv=none; b=q0jC/iXEx6Nj2oC26l6ju1qN1rEZavjnHpr04uoxgdaXg03V9jXWlAs3keuBLMtIa+2OffxKzaNpq92Awo1ZJF4qO4/HLcqxGi7x+j82So3CVB64in89DtAl5R+OxJBUX9DWLRMb4//6kbg/Js3EIO35AkFvy4+765Eby+sg02w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781603981; c=relaxed/simple;
	bh=bojPaIcm7fbrozNEnnRptLaNPO9TlasC023MkdeJG9k=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gb4NNt0GKWrOv1NiacavdjuuEiO66duJlvjR+yyy5X4dsGBbmVX+DnuISPKFVLhL7aD60u8HUeb5d/A1g8lENb7EWpFE423GyT3sKRT77PFj1SnaZ6r4/C444vFYZZbrt0XA/2yOgtMIKMcPgweMhcJ2NxfMebNNLDV4P64l69w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aqhk6XTl; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aqhk6XTl"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3078e0dcd67so4596714eec.0
        for <nvdimm@lists.linux.dev>; Tue, 16 Jun 2026 02:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781603979; x=1782208779; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dBVOa1pu803IEceovUcuADFNvl748B5cRLmHI1waIHs=;
        b=aqhk6XTljXWARKiJqvgPhVE7HUGxIzyW4CpXCFdOarRzFVQO48MyflGeIvmAEK8TnJ
         7N+l4YgeOiheznS0n9voPsiz0J9vEbH3X4V2k5nKvUmfFPqDwVYn3x1STcnap6qmk7Od
         18CmGGDn1YcjdEK215oSiv+2z1Jemt3u4xRdNyuDIFADQ1u9BXcgmEO2gJK9HVldnEjT
         9FFJiKRhfAeVTpeZA2Uc9Gi+SRyE+LzTviriW+SSWHVNz9PDcpmkYQVvqVYp9yCMIRDg
         xf5mPCxQKotfhwJc9/xetsDRalz4QCznFCgUaPl6gkDgf5t4zK/n3YO0IDWXdsp4pBw7
         2zQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781603979; x=1782208779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dBVOa1pu803IEceovUcuADFNvl748B5cRLmHI1waIHs=;
        b=mzT+GwKrVFVA2Yo9LThTHym+HsU459JrIWmH14ZCevmu4mBzwiz884kaC/6vPmkP6c
         yey3UmcQzroMN35gxVEkyK399/5e8yEKstpXfI+Wu2ot0UnwIjIexbriYtyVqelAAIpF
         D8dI/w4Uvg8mX/tGna2I94Wo6X7nDSYuWeW1sZk0W102/yjzXAAyqiZegv4H3HAMp0PA
         F6PrnNYGzUqeHCpyAptuwAHbtOD9eXoZyZwy64tAmUq/t6ajVWOEzQoghxwfRwsw5i/i
         gh9yECgexbDl6xozKF3f5NjP0hva8jRrUW6aDWSAcJQ0qX0LZaMq/kdhOYPAwax/HNRD
         xSSQ==
X-Forwarded-Encrypted: i=1; AFNElJ8FB/wFDkBf6wRROo0WuoqGuT4bSlAkv+x8AHtdlBR1yIFrmZuQ+VXxDdZgr6JFj9qaiAq2qjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxIXqyPjnUKKuMF37b+RMgtpr96OBhk0QwmuMmZfsUSUeCwrnvP
	hhQe1hQBvNp1a3XnwFMPHscyZg9g2xy0opTK1TjH9CnbIbNfxgcC6/Bh
X-Gm-Gg: Acq92OEbjqbZ9AADnggd2DdSxMbJhApv3kEY6p+l/53hCgdFc2VvnKUso7D463VRk8R
	CHO33ukN+3hgbJ+mXwzUGzXKWKvtMDLyMQhSI/+K+eb+7sk7d+Y33e9FN2E+qjHKNYSiW3xc5e6
	wYrb+sRS6WQLL4UAa1K/quTj3YcMRhAtNVq0AxjARdx1TgON7wqzFA7ytqs7wcbxjj6ryrdvsXQ
	znwK8/fdNE9RyOBw/EcXzTTkTAUoKAdtWP+7HAVwGRu3ZupxpI5bMV5XE26KVz7rm9nOQpuSi0p
	NjO81lt/6XQLycjgclx9YzC3yerfuoRCcOMq9VzUTJk6jahFSLrNLt1Uc+l/LMXnJjID8R2zvU1
	2DjzQwVgi1D9PLfN/0wVDSWnc1S7kNiMBsBXX3glpF/0ucgUjJZQn+yodp0Mta6fM9Dh1PJqa+T
	ifMrVXBM4ADPnxvx2CnDhOWvPzQUGl8df2Ks+T+PRjhZFz/7VMW2mbCxrm1rSoXu2TW/+ycN8NF
	00MD7g=
X-Received: by 2002:a05:7300:4355:b0:2ed:e14:42e9 with SMTP id 5a478bee46e88-30940357f24mr9366806eec.34.1781603978807;
        Tue, 16 Jun 2026 02:59:38 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30b6191bf9asm12784185eec.31.2026.06.16.02.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 02:59:38 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 16 Jun 2026 02:59:36 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>
Subject: Re: [PATCH v10 28/31] cxl/mem: Trace Dynamic capacity Event Record
Message-ID: <ajEeiDkUgchAs7Hn@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <54f9e863fac7a9c040267a13cd36aa7415e29f4f.1779528761.git.anisa.su@samsung.com>
 <5236aaf9-52d6-43e9-82b2-84fa08d35357@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5236aaf9-52d6-43e9-82b2-84fa08d35357@intel.com>

On Fri, May 29, 2026 at 03:41:15PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:43 AM, Anisa Su wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > CXL rev 3.1 section 8.2.9.2.1 adds the Dynamic Capacity Event Records.
> > User space can use trace events for debugging of DC capacity changes.
> > 
> > Add DC trace points to the trace log.
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Reviewed-by: Fan Ni <fan.ni@samsung.com>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>

added my signoff

> > ---
> >  drivers/cxl/core/mbox.c  |  5 ++++
> >  drivers/cxl/core/trace.h | 65 ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 70 insertions(+)
> > 
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 486110e1c03d..271f4556db85 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -1030,6 +1030,11 @@ static void __cxl_event_trace_record(struct cxl_memdev *cxlmd,
> >  		ev_type = CXL_CPER_EVENT_MEM_MODULE;
> >  	else if (uuid_equal(uuid, &CXL_EVENT_MEM_SPARING_UUID))
> >  		ev_type = CXL_CPER_EVENT_MEM_SPARING;
> > +	else if (uuid_equal(uuid, &CXL_EVENT_DC_EVENT_UUID)) {
> > +/* FIXME still valid? */
> 
> ? address or delete?
> 
Oopsie, deleted! 

> > +		trace_cxl_dynamic_capacity(cxlmd, type, &record->event.dcd);
> > +		return;
> > +	}
> >  
> >  	cxl_event_trace_record(cxlmd, type, ev_type, uuid, &record->event);
> >  }
> > diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
> > index a972e4ef1936..421e492d1b3f 100644
> > --- a/drivers/cxl/core/trace.h
> > +++ b/drivers/cxl/core/trace.h
> > @@ -1099,6 +1099,71 @@ TRACE_EVENT(cxl_poison,
> >  	)
> >  );
> >  
> > +/*
> > + * Dynamic Capacity Event Record - DER
> > + *
> > + * CXL rev 3.1 section 8.2.9.2.1.6 Table 8-50
> 
> Let's move it to 4.0
> 
Bumped up to 4.0

> > + */
> > +
> > +#define CXL_DC_ADD_CAPACITY			0x00
> > +#define CXL_DC_REL_CAPACITY			0x01
> > +#define CXL_DC_FORCED_REL_CAPACITY		0x02
> > +#define CXL_DC_REG_CONF_UPDATED			0x03
> > +#define show_dc_evt_type(type)	__print_symbolic(type,		\
> > +	{ CXL_DC_ADD_CAPACITY,	"Add capacity"},		\
> > +	{ CXL_DC_REL_CAPACITY,	"Release capacity"},		\
> > +	{ CXL_DC_FORCED_REL_CAPACITY,	"Forced capacity release"},	\
> > +	{ CXL_DC_REG_CONF_UPDATED,	"Region Configuration Updated"	} \
> > +)
> > +
> > +TRACE_EVENT(cxl_dynamic_capacity,
> > +
> > +	TP_PROTO(const struct cxl_memdev *cxlmd, enum cxl_event_log_type log,
> > +		 struct cxl_event_dcd *rec),
> > +
> > +	TP_ARGS(cxlmd, log, rec),
> > +
> > +	TP_STRUCT__entry(
> > +		CXL_EVT_TP_entry
> > +
> > +		/* Dynamic capacity Event */
> > +		__field(u8, event_type)
> > +		__field(u16, hostid)
> > +		__field(u8, partition_id)
> > +		__field(u64, dpa_start)
> > +		__field(u64, length)
> > +		__array(u8, uuid, UUID_SIZE)
> > +		__field(u16, sh_extent_seq)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		CXL_EVT_TP_fast_assign(cxlmd, log, rec->hdr);
> > +
> > +		/* Dynamic_capacity Event */
> > +		__entry->event_type = rec->event_type;
> > +
> > +		/* DCD event record data */
> > +		__entry->hostid = le16_to_cpu(rec->host_id);
> > +		__entry->partition_id = rec->partition_index;
> 
> CXL r4.0 8.2.10.2.1.6 Table 8-229
> 
> Couple issues.
> 1. This is not partition_index, it's updated_region_index.

fixed

> 2. It's only valid for events of type Region Configuration Updated. Otherwise we may be displaying garbage or 0.
> 
also fixed

/*
 * The Updated Region Index is only defined for Region
 * Configuration Updated events (Table 8-229); report U8_MAX
 * (not a valid index) for other event types where the field
 * is reserved.
 */
if (rec->event_type == CXL_DC_REG_CONF_UPDATED)
	__entry->updated_region_index = rec->updated_region_index;
else
	__entry->updated_region_index = U8_MAX;

> So it needs a rename and also a check for validity. Better to fix it before rasdaemon start picking it up.
> 
> DJ
> 
Thanks,
Anisa

> > +		__entry->dpa_start = le64_to_cpu(rec->extent.start_dpa);
> > +		__entry->length = le64_to_cpu(rec->extent.length);
> > +		memcpy(__entry->uuid, &rec->extent.uuid, UUID_SIZE);
> > +		__entry->sh_extent_seq = le16_to_cpu(rec->extent.shared_extn_seq);
> > +	),
> > +
> > +	CXL_EVT_TP_printk("event_type='%s' host_id='%d' partition_id='%d' " \
> > +		"starting_dpa=%llx length=%llx tag=%pU " \
> > +		"shared_extent_sequence=%d",
> > +		show_dc_evt_type(__entry->event_type),
> > +		__entry->hostid,
> > +		__entry->partition_id,
> > +		__entry->dpa_start,
> > +		__entry->length,
> > +		__entry->uuid,
> > +		__entry->sh_extent_seq
> > +	)
> > +);
> > +
> >  #endif /* _CXL_EVENTS_H */
> >  
> >  #define TRACE_INCLUDE_FILE trace
> 
