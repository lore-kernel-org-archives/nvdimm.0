Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD5F52F9E;
	Wed,  9 Oct 2024 18:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728497816; cv=none; b=XuuBhZtxlkhE3mDubL5q5SsWTsqFNv0tErv7ewRsEKW8UH6K0nJQaYHwIawdJpzKreoiJT3QWOYJEnO/fg+YxKnMzAxSopoRQa7tOEHZYYvtrzb3WNi8uVyA1n7h9BcBmpdq6lwdNea+XQixvlfj/gqemMfhFVRZMRl+K/VnyeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728497816; c=relaxed/simple;
	bh=pgwXgBk4u3VDmEKtGUQEApvK2p6Cbd2W1dgFQxkkxbs=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EXAvbbHSMXP2vdlT5KyV90UGSVbfcMvCtCIWyj8eiVGCnf75qgYzLIXzqxvUV6iImjjvoOqAlsTKcChcWiBGu396pQF/9frIEjfUzc8pOaoqJ6GfsTMoP1I8jwyABbARDJ0nlCyH8P2UR699R27cEpc79PxggtY819JolcIfTAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aJq1qDao; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJq1qDao"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e28fa28de37so22405276.3;
        Wed, 09 Oct 2024 11:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728497813; x=1729102613; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CMJHEoItCLKNQqTYhraWfgSOwnHOJJjA5T9nEdBreoo=;
        b=aJq1qDaoWIOopefUqr5g0xO6OTJTpuPlGJLeenG6A9ZQ0iWV2w3UuRiic07BXVo2M+
         Xv3K8JLESoi6Z+iWjUTtGwDyu2DoudWR+bRLH3WfhDtzehowULc14S6cwQ19yJptl19h
         4TaXiXajBegIZTFZAITLKMzx9UMyHkU9DtLOH1mrqka0mG2V+YVGsZKWmDCh/wez1lsW
         Mf54YxZAqF7hFMhzIcfNpxPLaFkPe5dpMAGN2CNgGye4miXCoyv6re9gDIkulZ5FiYwk
         YO4KVvIf95n5m7A5LSuWH4mbrWMW35B05PMb4y9b76IC7iDMwuBTKGSknbz4MkGcmIhv
         th0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728497813; x=1729102613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CMJHEoItCLKNQqTYhraWfgSOwnHOJJjA5T9nEdBreoo=;
        b=TN2IblCxw+r7R0KWQ4o2AX4HjMfnFi6wZ2gYx9oyK8OAjrPdz7q0AXIbjlJrnysJ3h
         +tIF1VZoUJ9MFjB3wl17zAZ03xj2QRhmnKdeztTy+gL2IRorMxmUkhVXIrjYURX/IJvy
         /sUpPFCUkbWfbhRDb+ps5rW6UvCHiSIQ5W34/cQL5TACV4dq963UQ00LY+ynCIiDExt3
         Ni89aEWf8CrOH4FkH9Lh2szq8qXau7XEJsB6Q1nlFkXVoJspLxesUJAYJ4atHVWOluFA
         hSaqAFOcl370fFbbjPjtDZpYHpPoeZppb2ZZB6z35iJZ40iPun1K2IWPEtr1ehLbYpla
         RyUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQofZtQEiobjcyc81+ljNsIb80w3IngM4qpZXjFAClh0KQqKP2Y9Ye3MHufdlTeLDfJq18Ig6s5YHBkpQ=@lists.linux.dev, AJvYcCXZY1Qh0ulOQkYjOCjyJdOYc2KBD+bEPiXOOm6s38Pesad31W0MdSYwNR9P11fBp8XzMM1l2Y05@lists.linux.dev
X-Gm-Message-State: AOJu0YyfaKjIr8TENYLQKIXtTyX7jJonbczCUpyc7W+a093CH3vFfBa5
	wp9WQuOyWgzBGtLgLuFd0+/M3xtOuwEZhxO1kIDlBKLT7HGB8OqA
X-Google-Smtp-Source: AGHT+IECrhvsoxz0tchfe2uj4Zhv6SF3YjPCuZouV+uInwFOYEXaWO6HLusBCmrFa51JFGrbxab3yQ==
X-Received: by 2002:a05:6902:218f:b0:e28:f176:105 with SMTP id 3f1490d57ef6-e28fe4dbdc4mr3312075276.36.1728497812917;
        Wed, 09 Oct 2024 11:16:52 -0700 (PDT)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e2908cde6d6sm142601276.24.2024.10.09.11.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 11:16:52 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Wed, 9 Oct 2024 11:16:49 -0700
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Robert Moore <robert.moore@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev
Subject: Re: [PATCH v4 12/28] cxl/cdat: Gather DSMAS data for DCD regions
Message-ID: <ZwbIkQCzaOoUwWki@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-12-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-12-c261ee6eeded@intel.com>

On Mon, Oct 07, 2024 at 06:16:18PM -0500, Ira Weiny wrote:
> Additional DCD region (partition) information is contained in the DSMAS
> CDAT tables, including performance, read only, and shareable attributes.
> 
> Match DCD partitions with DSMAS tables and store the meta data.
> 
> To: Robert Moore <robert.moore@intel.com>
> To: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> To: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> Cc: acpica-devel@lists.linux.dev
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 

One minor comment inline.

> ---
> Changes:
> [iweiny: new patch]
> [iweiny: Gather shareable/read-only flags for later use]
> ---
>  drivers/cxl/core/cdat.c | 38 ++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/core/mbox.c |  2 ++
>  drivers/cxl/cxlmem.h    |  3 +++
>  include/acpi/actbl1.h   |  2 ++
>  4 files changed, 45 insertions(+)
> 
> diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
> index bd50bb655741..9b2f717a16e5 100644
> --- a/drivers/cxl/core/cdat.c
> +++ b/drivers/cxl/core/cdat.c
> @@ -17,6 +17,8 @@ struct dsmas_entry {
>  	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
>  	int entries;
>  	int qos_class;
> +	bool shareable;
> +	bool read_only;
>  };
>  
>  static u32 cdat_normalize(u16 entry, u64 base, u8 type)
> @@ -74,6 +76,8 @@ static int cdat_dsmas_handler(union acpi_subtable_headers *header, void *arg,
>  		return -ENOMEM;
>  
>  	dent->handle = dsmas->dsmad_handle;
> +	dent->shareable = dsmas->flags & ACPI_CDAT_DSMAS_SHAREABLE;
> +	dent->read_only = dsmas->flags & ACPI_CDAT_DSMAS_READ_ONLY;
>  	dent->dpa_range.start = le64_to_cpu((__force __le64)dsmas->dpa_base_address);
>  	dent->dpa_range.end = le64_to_cpu((__force __le64)dsmas->dpa_base_address) +
>  			      le64_to_cpu((__force __le64)dsmas->dpa_length) - 1;
> @@ -255,6 +259,38 @@ static void update_perf_entry(struct device *dev, struct dsmas_entry *dent,
>  		dent->coord[ACCESS_COORDINATE_CPU].write_latency);
>  }
>  
> +
Unwanted blank line.

Fan
> +static void update_dcd_perf(struct cxl_dev_state *cxlds,
> +			    struct dsmas_entry *dent)
> +{
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
> +	struct device *dev = cxlds->dev;
> +
> +	for (int i = 0; i < mds->nr_dc_region; i++) {
> +		/* CXL defines a u32 handle while cdat defines u8, ignore upper bits */
> +		u8 dc_handle = mds->dc_region[i].dsmad_handle & 0xff;
> +
> +		if (resource_size(&cxlds->dc_res[i])) {
> +			struct range dc_range = {
> +				.start = cxlds->dc_res[i].start,
> +				.end = cxlds->dc_res[i].end,
> +			};
> +
> +			if (range_contains(&dent->dpa_range, &dc_range)) {
> +				if (dent->handle != dc_handle)
> +					dev_warn(dev, "DC Region/DSMAS mis-matched handle/range; region %pra (%u); dsmas %pra (%u)\n"
> +						      "   setting DC region attributes regardless\n",
> +						&dent->dpa_range, dent->handle,
> +						&dc_range, dc_handle);
> +
> +				mds->dc_region[i].shareable = dent->shareable;
> +				mds->dc_region[i].read_only = dent->read_only;
> +				update_perf_entry(dev, dent, &mds->dc_perf[i]);
> +			}
> +		}
> +	}
> +}
> +
>  static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
>  				     struct xarray *dsmas_xa)
>  {
> @@ -278,6 +314,8 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
>  		else if (resource_size(&cxlds->pmem_res) &&
>  			 range_contains(&pmem_range, &dent->dpa_range))
>  			update_perf_entry(dev, dent, &mds->pmem_perf);
> +		else if (cxl_dcd_supported(mds))
> +			update_dcd_perf(cxlds, dent);
>  		else
>  			dev_dbg(dev, "no partition for dsmas dpa: %pra\n",
>  				&dent->dpa_range);
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 4b51ddd1ff94..3ba465823564 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1649,6 +1649,8 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev)
>  	mds->cxlds.type = CXL_DEVTYPE_CLASSMEM;
>  	mds->ram_perf.qos_class = CXL_QOS_CLASS_INVALID;
>  	mds->pmem_perf.qos_class = CXL_QOS_CLASS_INVALID;
> +	for (int i = 0; i < CXL_MAX_DC_REGION; i++)
> +		mds->dc_perf[i].qos_class = CXL_QOS_CLASS_INVALID;
>  
>  	return mds;
>  }
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 0690b917b1e0..c3b889a586d8 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -466,6 +466,8 @@ struct cxl_dc_region_info {
>  	u64 blk_size;
>  	u32 dsmad_handle;
>  	u8 flags;
> +	bool shareable;
> +	bool read_only;
>  	u8 name[CXL_DC_REGION_STRLEN];
>  };
>  
> @@ -533,6 +535,7 @@ struct cxl_memdev_state {
>  
>  	u8 nr_dc_region;
>  	struct cxl_dc_region_info dc_region[CXL_MAX_DC_REGION];
> +	struct cxl_dpa_perf dc_perf[CXL_MAX_DC_REGION];
>  
>  	struct cxl_event_state event;
>  	struct cxl_poison_state poison;
> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
> index 199afc2cd122..387fc821703a 100644
> --- a/include/acpi/actbl1.h
> +++ b/include/acpi/actbl1.h
> @@ -403,6 +403,8 @@ struct acpi_cdat_dsmas {
>  /* Flags for subtable above */
>  
>  #define ACPI_CDAT_DSMAS_NON_VOLATILE        (1 << 2)
> +#define ACPI_CDAT_DSMAS_SHAREABLE           (1 << 3)
> +#define ACPI_CDAT_DSMAS_READ_ONLY           (1 << 6)
>  
>  /* Subtable 1: Device scoped Latency and Bandwidth Information Structure (DSLBIS) */
>  
> 
> -- 
> 2.46.0
> 

-- 
Fan Ni
