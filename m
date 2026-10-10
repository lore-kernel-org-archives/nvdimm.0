Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718CF27AC57
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 22:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791672330; cv=none; b=JBNekFv4W4RDgRqVMYdP+Qn8B9SxZXtQL9utpI+R+Hv4aHFC+v6UIEa2mY4wHtDUMCJVcsZGH/mkXQVzfo4Y3HQSr2dvRpydF1qztRndtqSReen+7T4CbL/rzBdLo7ZhuPS82MV3zgFkWmCYvBvIm7ConlCgNIrM7FgZG2XMSe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791672330; c=relaxed/simple;
	bh=wTgGw8DHW6xFD4B4hl4ywDHhFyN1oJ4qHHPGEJTEyaE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IqST6zg/ZjbbkBVURwH1nTWXDVZeXX9IXgBNgEhfpDosuNT8W+Q0TlT2bg0VGA/gmKfZN2ZVQiBmsPtEh+ASOF12dRrSZWjhFT8gUAmeMYbQuhdg2xPHAdML7Q7cKKfBJF6zweHZ16oLRZ5rIS51sDzoRcl0IjPsLC8OxeD+ReU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=csrLb1rH; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="csrLb1rH"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc4ca696de6so358224a12.2
        for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 15:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791672329; x=1792277129; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xivJcQZ1ooou86Bqdwfy9/e7A6VmVxGxUj1fMYYNf5s=;
        b=csrLb1rHvLeMZDwIFU3cXPo5/xR1r0YeegRR4Gw4OaLGRSAjdkQe0HP4ZuB3KJ8Jo9
         k8zLt1DJ3dkaeMDrgCSACl/I06lcuUoXTNsbVFBl+dCW/cwpgcxhvihjsy5VFfN8/+ul
         QaUh9E1VRaO0kCtAjjWMGN1xHSjzdXsJNiNf3JSGOIeLi8EMt7X0fw1MAFPcXey5jqVg
         x1y0GTlMJlvdDsZN1t8tNOOunES6yD94u4C4OMkBhv6lkmu3cmnEUcRlOYJEsgW+5zND
         uDDB3fDzc9De0u19T1zrltQ80qaSqgnq30djiD44Hnxz0Mpz9Im15zkXtfSTEKLCQOl/
         hJDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791672329; x=1792277129;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xivJcQZ1ooou86Bqdwfy9/e7A6VmVxGxUj1fMYYNf5s=;
        b=TMjqz7f+DBD1xTfgdzpzt00Fk8F5k2mRj0g1wncEQpzqF0mtRiAorY9HMUP/NwMlrJ
         fiwGlgG64jibSiUnTaZiUlA9TeRWiIaiuflbuP5GyNMMgF3wmrTM8p/uY0Ry08NuXZog
         RGNz+w9yoqKNlsuAMZ0twJc8J7fI0DD0xzNoIwm0as3MB+FoyEz4BPWhFreUj98Hs7zA
         Q65nNHBotUQAXzh7NU06BGhHCk9AxET382t6YqrLs0hnZC6Uq/IoIl0A6ApI5ByIrmsk
         p/rQSBhN5PJA58+ssRQTYcLjkOjrIlukHqHFjI79BlTOY1hRvNCdMev2hIzWltYKKjLD
         aZdw==
X-Forwarded-Encrypted: i=1; AKwUvBzkJhcV1EFZ+WcOb4pAUawfVMb8YehMXjBSSpp/COFRQj9Icqwxbd9RUj/O4Q+TihayofJbKec=@lists.linux.dev
X-Gm-Message-State: AFq9FYI5vDHX10U7plZQqfBll7vOPkYeTeFQd3O1umV65F8bMqeWqMWI
	sRKrFeZ0q8OBlxmvjxrLO+CMDzVE+Vw4MNbEOqDnEi+Ye4zPw9rkXUS1uOsYYr2O
X-Gm-Gg: AYBFou0iKAhjn8sgHYSTgwXSZ7UsX8ewQ+sQ2UXRoSTMHsx0p6iTCs8jfVcPFHwN3J3
	4ZAq+N+VNpr6o2Z4vB8Doayb4tBjKum8AdfSR+YYirTRUszugWlVbemV0ZfEVnaW5WdppQ42zww
	OIfdk1VhP+wfDIF6ixYut63fVqaa/NoFvx/jZPGzCenZkqgXS0nA3PELYfAFgl0dKqDsS0lPr9N
	6Eif3ZY1oMisD/ecYG3kQ+3Ly8hUlnjjt5dgWFamBHiY6BzfSjvAgD96emMaqM+sO3RnfD+Kqpn
	wxE90Xj5qkIdW99UxfDF44tzadUsEcnUITqBYcu0bZES2pOhq7ZkMNkZOk7zhOLAQ6+biYcTmr5
	+xq+zC5DFz0s/AtdY2JKwLSJFlMJ8nL9VuBvX0W3aejFnAMAfIa0hcfP6Kw9t1XlKUUkjwzDlVk
	9xDFIQejcPunSbjye1TxSr6VRvBgETTRIvnmei3+knMz31DDj7Mazv1dQ4w2EDAwpBGfD5MQjSB
	eBtmpOHE0zNqA5hCrWA0l8/PQ==
X-Received: by 2002:a17:90b:5486:b0:39e:6a7f:1dcd with SMTP id 98e67ed59e1d1-3ab3ab1d56cmr5351273a91.41.1791672328538;
        Sat, 10 Oct 2026 15:45:28 -0700 (PDT)
Received: from cxlqual ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab39822051sm4431351a91.4.2026.10.10.15.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 15:45:28 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Sun, 11 Oct 2026 07:47:21 +0900
To: sashiko-reviews@lists.linux.dev
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v15 3/8] cxl/cdat: Gather DSMAS data for DCD partitions
Message-ID: <asrAecwfhRU7kMLm@cxlqual>
References: <20261007201828.952-1-anisa.su@samsung.com>
 <20261007201828.952-4-anisa.su@samsung.com>
 <sashiko-outbox-163342@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-163342@kernel.org>

On Wed, Oct 07, 2026 at 08:33:12PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] cxl: Ineffective DCD disablement leaves partially configured partitions exposed
> - [Medium] cxl: QoS class 0 incorrectly overwrites CXL_QOS_CLASS_INVALID
> - [Low] cxl: Lockless modification of DPA partition attributes exposes torn reads
> --
> 
> commit 6722908eab4fa5c8dd9820d34f1ec3beb729c8f0
> Author: Ira Weiny <iweiny@kernel.org>
> 
> cxl/cdat: Gather DSMAS data for DCD partitions
> 
> Additional DCD partition (AKA region) information is contained in the
> DSMAS CDAT tables, including performance, shareable and read-only
> attributes. Match DCD partitions with DSMAS tables and store the meta
> data.
> 
> > diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
> > index 5c9f072625135..07aedff657d9e 100644
> > --- a/drivers/cxl/core/cdat.c
> > +++ b/drivers/cxl/core/cdat.c
> [ ... ]
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
> 
> [Severity: Medium]
> When this continue statement is taken, dent->qos_class remains 0 (from
> kzalloc_obj zero-initialization).
> 
> If at least one other entry succeeds, cxl_memdev_apply_dsmas() will be called
> with CXL_DSMAS_APPLY_FLAGS_PERF, which unconditionally calls update_perf_entry()
> and overwrites part->perf.qos_class (previously CXL_QOS_CLASS_INVALID) with 0.
> 
> Since 0 is a valid QoS class in CXL, does this falsely advertise a QoS class of
> 0 to userspace for partitions lacking DSLBIS performance coordinates?
> 
Fixed. dsams_entry.qos_class is initialized to CXL_QOS_CLASS_INVALID in
cdat_dsmas_handler().

> > +
> >  		cxl_coordinates_combine(dent->coord, dent->cdat_coord, ep_c);
> >  		dent->entries = 1;
> >  		rc = cxl_root->ops.qos_class(cxl_root,
> [ ... ]
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
> 
> [Severity: High]
> Does clearing the mds->dcd_supported flag effectively disable the partition?
> 
> Since cxl_configure_dcd() and cxl_dpa_setup() have already executed during
> cxl_pci_probe(), the DCD partition is permanently added to cxlds->part and its
> DPA resource is registered.
> 
> Because mds->dcd_supported is never evaluated again during region creation or
> sysfs access, does the partition remain fully exposed and usable by userspace
> without valid DSMAS attributes?
> 
Nothing is exposed in sysfs by this series. The rest of the series that does
adds those capabilities will hide the memdev dynamic_ram group and refuse the
decoder mode if dcd is not supported.
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
> [ ... ]
> > +			if (attrs == CXL_DSMAS_APPLY_FLAGS_PERF)
> > +				update_perf_entry(dev, dent, &part->perf);
> > +			if (part->mode == CXL_PARTMODE_DYNAMIC_RAM) {
> > +				part->shareable = dent->shareable;
> > +				part->read_only = dent->read_only;
> > +				dc_matched = true;
> > +			}
> 
> [Severity: Low]
> Are these partition attributes being modified locklessly?
> 
> The CXL memdev and its sysfs attributes are registered and visible during
> cxl_pci_probe(), while this CDAT parsing happens later in
> cxl_endpoint_port_probe().
> 
> If part->perf, part->shareable, and part->read_only are updated without holding
> the cxl_rwsem.dpa lock, can concurrent userspace sysfs readers observe
> intermediate, torn, or partially updated performance states?
> 
update_perf_entry() is the function that writes to part->perf and not
touched by this series.

shareable and read-only are bools, so stores are atomic.

> > +			break;
> >  		}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261007201828.952-1-anisa.su@samsung.com?part=3
