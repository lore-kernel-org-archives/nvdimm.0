Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075E832572F
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 22:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791671239; cv=none; b=ACt20frwl/UtSny/VuFCptVJ0/fajJfmMqJHlCo8sMsDqXsB6/7kQCgGIoIQNy4ANN8JiFlZH2pMocRbEMwgSe5vkt/psK3cOTAXRgLY1xmwqDzQzi3iyZbtsmORzP847jy193O+t8CqyD9K3R1k/28UG196xaS7V7Hg8QZ+Jkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791671239; c=relaxed/simple;
	bh=geSFjZIFbEgwMvKQjTIPe81xEJomJ2s7aTBDqJKH10I=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9rAu2xEcLiHexEYXO9FlNlt2oU+JV058qvpphR+6evqd0GfCGiq2PWYPXzPPYmiLtVGxXqRxoIDh+0si7CWJyKC5JfZGsA5SgCIhdd5lLlUDnikeeTHQnHqUysnH+jWkDpC7nWMdMkqJNkeQ7lK1Sw+A3kvuZ09Qugqnd92q3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=STE2BIFQ; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="STE2BIFQ"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38759bcd877so446402a91.2
        for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 15:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791671236; x=1792276036; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ef2rOQreX7ParG6i+WbVLJHCfV55gX5hfeh8vRXSUgo=;
        b=STE2BIFQ5yeDhRjTaewrf3QSnpHpvLm2s3GIoXVaONU5JxWCdiNC/TXiz+7dFyn3z8
         LWX/AKMmP5EJyf97scMPvZu0TecBRnvTyfhX+iYbhm7LUAHOQVjx3z+avOVZEIaBMMww
         jPqUht5CTx+Ok/iLF86UfjutdKJ1KglPVT85WVMgmqBrD/mAFyH61pC02RCAXo5l/vDl
         pY3WvRIxsbgMwYo3g8zB63XJMfJyfgdZZ24sUb05ef09CJWK1UjMNZN/fgX8Lh7Fl1Vp
         zEGiN6a90iq5PBn6gni8j1zBj81jh4ETyIfmQ5qvFou0TkOPtYBa3WPU4Q13sj7lhlw1
         p11g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791671236; x=1792276036;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ef2rOQreX7ParG6i+WbVLJHCfV55gX5hfeh8vRXSUgo=;
        b=jn4EyvYR9/+RHpuyP9JhF9Xj1UavvzbJZx1Lu+3zRbnOM7EZNg3flFAEpD4Jlw8P+E
         vF5hIm7GunoQC2VbbUnjVvipV5ClPSssBTJk925K31e4jsBRfFpKzzYi9oULA8ntjc4U
         aOou/Dn0R7ovzluKEtdeur1+Y0kp5R52OkPfJXySDX476U/ZW24oqYh7Sb28mzW/rvzv
         /CQsZxXvj6R3sr/p/FQIqSvI6vFhx+L3WDWuxh7FRSLy8YIMqcIheC84ATzRtIrdEfad
         bH4r02/RE/ElAEnL11d+G9jWLTZorqpa/H9XmgZZzIqiKPmuqLEnEm0OY3Q1m6GdG1Om
         tUKw==
X-Forwarded-Encrypted: i=1; AKwUvBzwe+wUvbGdtB9Dadd9+dz9Nr/TgCikH3ffq2BI6Hfk9E7Wg0hABRkHWeRFXHK8SG9C2L21BUM=@lists.linux.dev
X-Gm-Message-State: AFq9FYJsN1Bre22ltF1nNFtR5hiKetchOrMf66vlTIIOHs+/6kWbdQCn
	ZbVBM7DcHfu2IokazIGxP9lNkYXr/s1DWVM+Av5rUKjgShvYDdZjVyQ2
X-Gm-Gg: AYBFou1hJBjvT3JE5u7utcTDhk7M25geqqOg3wa/cXoDNGLmaiE8mJkT6RLU3DRQ4wx
	Q6fPQV+ztZuUT9UhI78jipg4k3igd7Jl51HfeZJ4KGOinwv4xSdgB95K1cVwLh8TeTTMc7OoTl/
	khU92miBvN4I9COPSZ0vM6Y96Si8iqOaATovQGqagsCAoBXV0gBg9aWtFxXXqQQfDmH7uvd0oQJ
	zgPf572o+QUJnvFEBnLlDiP4koCB1KtprzmWOHmZ422wzIjOJWMewvQAjfqSjNXNbPIDp6Xm4vp
	wW8hxgDth5bnNR2QpNSMJ4bBzkk0a9Y7lSTdvcTD+eiH281UNLkR3juIzgOZkdwwFiXrV2KLTdB
	NoX5mK9IdPTayYVeVh65fv3J0Va1R2ykLIZAF3YMeS8HqoAO/fKAl/Ru182LYf28w0M/yvvclDF
	fHe4SkhmuRUjXkRxsMrELTkDmbrAKU6osVEv4ZCTgroEvfoDQa/FuL/FKBaM41lt3Xe3r4SAUP5
	mLtv60kJiprYhhRW6cE3ovqMA==
X-Received: by 2002:a17:90b:224e:b0:3a8:9db2:a4f with SMTP id 98e67ed59e1d1-3ab3af75ac1mr4415504a91.51.1791671236214;
        Sat, 10 Oct 2026 15:27:16 -0700 (PDT)
Received: from cxlqual ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab37163e21sm10802592a91.14.2026.10.10.15.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 15:27:15 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Sun, 11 Oct 2026 07:29:06 +0900
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>
Subject: Re: [PATCH v15 3/8] cxl/cdat: Gather DSMAS data for DCD partitions
Message-ID: <asq8MhNhamoM3JwG@cxlqual>
References: <20261007201828.952-1-anisa.su@samsung.com>
 <20261007201828.952-4-anisa.su@samsung.com>
 <dc0fc04c-cc75-4e8d-bbb4-459825c58f20@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc0fc04c-cc75-4e8d-bbb4-459825c58f20@intel.com>

On Thu, Oct 08, 2026 at 02:29:12PM -0700, Dave Jiang wrote:
> 
> 
> On 10/7/26 1:16 PM, Anisa Su wrote:
> > From: Ira Weiny <iweiny@kernel.org>
> > 
> > Additional DCD partition (AKA region) information is contained in the
> > DSMAS CDAT tables, including performance, shareable and read-only
> > attributes.
> > 
> > Match DCD partitions with DSMAS tables and store the meta data. A DCD
> > shall describe its DC partition in a DSMAS entry (CXL r4.0 9.13.3), so
> > if the CDAT is absent, fails to parse, or has no entry matching the DC
> > partition, disable DCD rather than run with unknown attributes.
> > 
> > DSLBIS is optional, but cxl_cdat_endpoint_process() treated zero DSLBIS
> > entries as a parse failure, which would now disable DCD on a device with
> > a valid DSMAS. Accept an empty DSLBIS, and skip DSMAS entries with no
> > DSLBIS coordinates.
> > 
> > Signed-off-by: Ira Weiny <iweiny@kernel.org>
> > Co-developed-by: Anisa Su <anisa.su@samsung.com>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > 
> > ---
> > Changes:
> > 1. cdat.c: disable DCD when the DC partition has no valid DSMAS entry:
> >    no CDAT, CDAT parse failure, or no entry matching the partition.
> >    [Richard, Dave]
> > 2. cdat.c: DSLBIS is optional. An empty DSLBIS no longer fails the
> >    CDAT parse, and cxl_port_perf_data_calculate() skips entries that
> >    have no DSLBIS coordinates.
> >    [Richard, Dave]
> > 3. cdat.c: cxl_memdev_apply_dsmas() takes an enum cxl_dsmas_apply
> >    instead of a bool so the call sites say what is applied.
> >    [Dave]
> > 4. Also record the DSMAS read-only flag (CDAT 1.04, Flags bit 6) on
> >    the partition, alongside shareable.
> >    [Jonathan]
> > ---
> >  drivers/cxl/core/cdat.c   | 97 ++++++++++++++++++++++++++++++++++-----
> >  drivers/cxl/core/hdm.c    |  1 +
> >  drivers/cxl/core/mbox.c   |  9 ++++
> >  drivers/cxl/core/memdev.c | 17 ++++---
> >  drivers/cxl/cxlmem.h      |  2 +
> >  include/cxl/cxl.h         |  6 +++
> >  6 files changed, 113 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
> > index 5c9f07262513..07aedff657d9 100644
> > --- a/drivers/cxl/core/cdat.c
> > +++ b/drivers/cxl/core/cdat.c
> > @@ -17,6 +17,8 @@ struct dsmas_entry {
> >  	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
> >  	int entries;
> >  	int qos_class;
> > +	bool shareable;
> > +	bool read_only;
> >  };
> >  
> >  static u32 cdat_normalize(u16 entry, u64 base, u8 type)
> > @@ -74,6 +76,10 @@ static int cdat_dsmas_handler(union acpi_subtable_headers *header, void *arg,
> >  		return -ENOMEM;
> >  
> >  	dent->handle = dsmas->dsmad_handle;
> > +	/* Shareable is CDAT 1.03 and later, DSMAS Flags bit 3 */
> > +	dent->shareable = dsmas->flags & ACPI_CDAT_DSMAS_SHAREABLE;
> > +	/* Read Only is CDAT 1.04 and later, DSMAS Flags bit 6 */
> > +	dent->read_only = dsmas->flags & ACPI_CDAT_DSMAS_READ_ONLY;
> >  	dent->dpa_range.start = le64_to_cpu((__force __le64)dsmas->dpa_base_address);
> >  	dent->dpa_range.end = le64_to_cpu((__force __le64)dsmas->dpa_base_address) +
> >  			      le64_to_cpu((__force __le64)dsmas->dpa_length) - 1;
> > @@ -188,9 +194,10 @@ static int cxl_cdat_endpoint_process(struct cxl_port *port,
> >  	if (rc)
> >  		return rc;
> >  
> > +	/* DSLBIS is optional; zero entries is not an error */
> >  	rc = cdat_table_parse(ACPI_CDAT_TYPE_DSLBIS, cdat_dslbis_handler,
> >  			      dsmas_xa, port->cdat.table, port->cdat.length);
> > -	return cdat_table_parse_output(rc);
> > +	return rc < 0 ? rc : 0;
> >  }
> >  
> >  static int cxl_port_perf_data_calculate(struct cxl_port *port,
> > @@ -219,6 +226,13 @@ static int cxl_port_perf_data_calculate(struct cxl_port *port,
> >  	xa_for_each(dsmas_xa, index, dent) {
> >  		int qos_class;
> >  
> > +		/* No DSLBIS for this DSMAS; nothing to hand the QTG _DSM */
> > +		if (!dent->cdat_coord[ACCESS_COORDINATE_CPU].read_bandwidth &&
> > +		    !dent->cdat_coord[ACCESS_COORDINATE_CPU].write_bandwidth &&
> > +		    !dent->cdat_coord[ACCESS_COORDINATE_CPU].read_latency &&
> > +		    !dent->cdat_coord[ACCESS_COORDINATE_CPU].write_latency)
> > +			continue;
> > +
> >  		cxl_coordinates_combine(dent->coord, dent->cdat_coord, ep_c);
> >  		dent->entries = 1;
> >  		rc = cxl_root->ops.qos_class(cxl_root,
> > @@ -255,35 +269,90 @@ static void update_perf_entry(struct device *dev, struct dsmas_entry *dent,
> >  		dent->coord[ACCESS_COORDINATE_CPU].write_latency);
> >  }
> >  
> > -static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
> > -				     struct xarray *dsmas_xa)
> > +/*
> > + * A DCD shall describe its DC partition in a DSMAS entry (CXL r4.0 9.13.3).
> > + * Without one the partition's attributes are unknown, so disable DCD.
> > + */
> > +static void cxl_dcd_dsmas_missing(struct cxl_dev_state *cxlds, const char *why)
> > +{
> > +	struct cxl_memdev_state *mds;
> > +
> > +	if (cxlds->type != CXL_DEVTYPE_CLASSMEM)
> > +		return;
> > +
> > +	mds = to_cxl_memdev_state(cxlds);
> > +	if (!cxl_dcd_supported(mds) ||
> > +	    !cxl_part_size(cxlds, CXL_PARTMODE_DYNAMIC_RAM))
> > +		return;
> > +
> > +	dev_warn(cxlds->dev, "DC partition has no valid DSMAS entry (%s), disabling DCD\n",
> > +		 why);
> > +	cxl_disable_dcd(mds);
> > +}
> > +
> > +enum cxl_dsmas_apply {
> > +	CXL_DSMAS_APPLY_FLAGS,		/* shareable etc.; no QTG data */
> > +	CXL_DSMAS_APPLY_FLAGS_PERF,	/* perf coordinates and qos_class */
> > +};
> > +
> > +/*
> > + * DSMAS flags such as shareable are properties of the CDAT entry and are
> > + * applied regardless; perf data is applied only if the QTG lookup produced
> > + * recommendations.
> > + */
> > +static void cxl_memdev_apply_dsmas(struct cxl_dev_state *cxlds,
> > +				   struct xarray *dsmas_xa,
> > +				   enum cxl_dsmas_apply attrs)
> >  {
> >  	struct device *dev = cxlds->dev;
> >  	struct dsmas_entry *dent;
> > +	bool dc_matched = false;
> >  	unsigned long index;
> >  
> >  	xa_for_each(dsmas_xa, index, dent) {
> >  		bool found = false;
> >  
> >  		for (int i = 0; i < cxlds->nr_partitions; i++) {
> > -			struct resource *res = &cxlds->part[i].res;
> > +			struct cxl_dpa_partition *part = &cxlds->part[i];
> >  			struct range range = {
> > -				.start = res->start,
> > -				.end = res->end,
> > +				.start = part->res.start,
> > +				.end = part->res.end,
> >  			};
> >  
> > -			if (range_contains(&range, &dent->dpa_range)) {
> > -				update_perf_entry(dev, dent,
> > -						  &cxlds->part[i].perf);
> > -				found = true;
> > +			if (!range_contains(&range, &dent->dpa_range))
> > +				continue;
> > +
> > +			found = true;
> > +			/*
> > +			 * part->handle is from Get DC Config, dent->handle
> > +			 * from the CDAT DSMAS entry.
> > +			 */
> > +			if (part->mode == CXL_PARTMODE_DYNAMIC_RAM &&
> > +			    dent->handle != part->handle) {
> > +				dev_warn(dev,
> > +					 "DSMAD handle mismatch: %pra has %u, DSMAS %pra has %u\n",
> > +					 &range, part->handle,
> > +					 &dent->dpa_range, dent->handle);
> >  				break;
> >  			}
> > +
> > +			if (attrs == CXL_DSMAS_APPLY_FLAGS_PERF)
> > +				update_perf_entry(dev, dent, &part->perf);
> > +			if (part->mode == CXL_PARTMODE_DYNAMIC_RAM) {
> > +				part->shareable = dent->shareable;
> > +				part->read_only = dent->read_only;
> > +				dc_matched = true;
> 
> Should be able to just return here and avoid the dc_matched flag right?
> 
No, that would break out of the xa_for_each and skip any remaining DSMAS
entries.

> 
> > +			}
> > +			break;
> >  		}
> >  
> >  		if (!found)
> >  			dev_dbg(dev, "no partition for dsmas dpa: %pra\n",
> >  				&dent->dpa_range);
> >  	}
> > +
> > +	if (!dc_matched)
> > +		cxl_dcd_dsmas_missing(cxlds, "no matching entry");
> >  }
> >  
> >  static int match_cxlrd_qos_class(struct device *dev, void *data)
> > @@ -409,22 +478,26 @@ void cxl_endpoint_parse_cdat(struct cxl_port *port)
> >  	int rc;
> >  
> >  	xa_init(&__dsmas_xa);
> > -	if (!port->cdat.table)
> > +	if (!port->cdat.table) {
> > +		cxl_dcd_dsmas_missing(cxlds, "no CDAT");
> >  		return;
> > +	}
> >  
> >  	rc = cxl_cdat_endpoint_process(port, dsmas_xa);
> >  	if (rc < 0) {
> >  		dev_dbg(&port->dev, "Failed to parse CDAT: %d\n", rc);
> > +		cxl_dcd_dsmas_missing(cxlds, "CDAT parse failed");
> >  		return;
> >  	}
> >  
> >  	rc = cxl_port_perf_data_calculate(port, dsmas_xa);
> >  	if (rc) {
> >  		dev_dbg(&port->dev, "Failed to do perf coord calculations.\n");
> > +		cxl_memdev_apply_dsmas(cxlds, dsmas_xa, CXL_DSMAS_APPLY_FLAGS);
> >  		return;
> >  	}
> >  
> > -	cxl_memdev_set_qos_class(cxlds, dsmas_xa);
> > +	cxl_memdev_apply_dsmas(cxlds, dsmas_xa, CXL_DSMAS_APPLY_FLAGS_PERF);
> >  	cxl_qos_class_verify(cxlmd);
> >  	cxl_memdev_update_perf(cxlmd);
> >  }
> > diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> > index 5fa2177cefcc..379540246333 100644
> > --- a/drivers/cxl/core/hdm.c
> > +++ b/drivers/cxl/core/hdm.c
> > @@ -486,6 +486,7 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
> >  
> >  		cxlds->part[i].perf.qos_class = CXL_QOS_CLASS_INVALID;
> >  		cxlds->part[i].mode = part->mode;
> > +		cxlds->part[i].handle = part->handle;
> >  
> >  		/* Require ordered + contiguous partitions */
> >  		if (i) {
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 72af23ba288e..12598d329e95 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -1366,6 +1366,7 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part,
> >  	u64 decode_len = le64_to_cpu(dev_part->decode_length);
> >  	u64 blk_size = le64_to_cpu(dev_part->block_size);
> >  	u64 len = le64_to_cpu(dev_part->length);
> > +	u32 handle = le32_to_cpu(dev_part->dsmad_handle);
> >  	u64 size;
> >  
> >  	/*
> > @@ -1378,6 +1379,13 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part,
> >  		return 0;
> >  	}
> >  
> > +	/* The CDAT DSMAD handle this refers to is 8 bits */
> > +	if (handle & ~0xFF) {
> 
> Define a mask?
> 
Changed it to if (handle > U8_MAX)

> DJ
> 
Thanks,
Anisa

> > +		dev_warn(dev, "DSMAD handle 0x%x exceeds the 8 bit CDAT DSMAD handle\n",
> > +			 handle);
> > +		return -EINVAL;
> > +	}
> > +
> >  	/*
> >  	 * Decode length is a count of 256M units, so a device reporting 2^36
> >  	 * or more wraps.
> > @@ -1391,6 +1399,7 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part,
> >  	*part = (struct cxl_dc_partition_info) {
> >  		.start = le64_to_cpu(dev_part->base),
> >  		.size = size,
> > +		.handle = handle,
> >  	};
> >  
> >  	/*
> > diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> > index def26c490dfe..7aa79a1a53e4 100644
> > --- a/drivers/cxl/core/memdev.c
> > +++ b/drivers/cxl/core/memdev.c
> > @@ -594,7 +594,8 @@ bool is_cxl_memdev(const struct device *dev)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(is_cxl_memdev, "CXL");
> >  
> > -static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
> > +static void add_part(struct cxl_dpa_info *info, u64 start, u64 size,
> > +		     enum cxl_partition_mode mode, u8 handle)
> >  {
> >  	int i = info->nr_partitions;
> >  
> > @@ -606,6 +607,7 @@ static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_pa
> >  		.end = start + size - 1,
> >  	};
> >  	info->part[i].mode = mode;
> > +	info->part[i].handle = handle;
> >  	info->nr_partitions++;
> >  }
> >  
> > @@ -623,9 +625,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> >  	info->size = mds->total_bytes;
> >  
> >  	if (mds->partition_align_bytes == 0) {
> > -		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM);
> > +		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM, 0);
> >  		add_part(info, mds->volatile_only_bytes,
> > -			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM);
> > +			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM, 0);
> >  		return 0;
> >  	}
> >  
> > @@ -635,9 +637,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> >  		return rc;
> >  	}
> >  
> > -	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM);
> > +	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM, 0);
> >  	add_part(info, mds->active_volatile_bytes, mds->active_persistent_bytes,
> > -		 CXL_PARTMODE_PMEM);
> > +		 CXL_PARTMODE_PMEM, 0);
> >  
> >  	return 0;
> >  }
> > @@ -685,7 +687,8 @@ int cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> >  	info->size = total;
> >  	dev_dbg(dev, "Adding dynamic ram partition; %#llx size %#llx\n",
> >  		dc_info.start, dc_info.size);
> > -	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM);
> > +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM,
> > +		 dc_info.handle);
> >  
> >  	return 0;
> >  }
> > @@ -703,7 +706,7 @@ int cxl_set_capacity(struct cxl_dev_state *cxlds, u64 capacity)
> >  		.size = capacity,
> >  	};
> >  
> > -	add_part(&range_info, 0, capacity, CXL_PARTMODE_RAM);
> > +	add_part(&range_info, 0, capacity, CXL_PARTMODE_RAM, 0);
> >  	return cxl_dpa_setup(cxlds, &range_info);
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_set_capacity, "CXL");
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 4fac65dbb808..9fd5af2e41d4 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -140,6 +140,7 @@ struct cxl_dpa_info {
> >  	struct cxl_dpa_part_info {
> >  		struct range range;
> >  		enum cxl_partition_mode mode;
> > +		u8 handle;
> >  	} part[CXL_NR_PARTITIONS_MAX];
> >  	int nr_partitions;
> >  };
> > @@ -851,6 +852,7 @@ int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> >  struct cxl_dc_partition_info {
> >  	u64 start;
> >  	u64 size;
> > +	u8 handle;
> >  };
> >  
> >  int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> > diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> > index e07360849344..728decda57fd 100644
> > --- a/include/cxl/cxl.h
> > +++ b/include/cxl/cxl.h
> > @@ -141,11 +141,17 @@ enum cxl_partition_mode {
> >   * @res: shortcut to the partition in the DPA resource tree (cxlds->dpa_res)
> >   * @perf: performance attributes of the partition from CDAT
> >   * @mode: operation mode for the DPA capacity, e.g. ram, pmem, dynamic...
> > + * @handle: DSMAS handle that represents this partition
> > + * @shareable: Is the partition shareable (from its CDAT DSMAS entry)
> > + * @read_only: Is the partition read-only (from its CDAT DSMAS entry)
> >   */
> >  struct cxl_dpa_partition {
> >  	struct resource res;
> >  	struct cxl_dpa_perf perf;
> >  	enum cxl_partition_mode mode;
> > +	u8 handle;
> > +	bool shareable;
> > +	bool read_only;
> >  };
> >  
> >  #define CXL_NR_PARTITIONS_MAX 3
> 
