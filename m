Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3ED44400
	for <nvdimm@lists.linux.dev>; Thu,  5 Sep 2024 19:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725564639; cv=none; b=nD2Vv4JVOLSjNOTYaWDgwh2zVs1uBQBqmwtwYs0KMUFESRhfgbeWC6a1dnwmut+1ogPabqRi4QsyIsBAWq98mHxoXwYYWcABx1rgd5Tna4vKjGCzqYR0istY0kzf4IbEw9gGXoBgPSvTiVEf4i1kyvlTNlwHOd5q1ibFFouk+tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725564639; c=relaxed/simple;
	bh=edz1Y8cPH7nK/wkJBWl60AZ/9Ibna25B5YaZsnfzETQ=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iDaRZt9A6igEOQjD6Zc1ei7IwpSpUZp51o4AIu/SdKiBDI9w6kxcXpiQjHmWFqFb1asezRmW5N4WhDjTdfzwwYEF7dj6lSnGwO7jslSPFGaBwMCWKBE4D5xnOaWOjQcUJfANqExJCJhqum+4WVdyU7VjVXrhE/uUL8bYQPSDk2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dd34fHNJ; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dd34fHNJ"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-204d391f53bso12282595ad.2
        for <nvdimm@lists.linux.dev>; Thu, 05 Sep 2024 12:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725564637; x=1726169437; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MbrEFO3D2q7bIKaAwLKYWbNKa6L/7Ep2zWdh3jV7Rr4=;
        b=Dd34fHNJD7oU8lbLopBaKufOlnzwA1U4TVn1+OTJhu9T5/Hx7LTyZGHtJrDKMBYMsP
         HCCDw9Axmbv341LYw4TMzQceJAh0OkUz62Me8hRCHwx80/1Aitm0qi4CNY0z4gxRegzY
         hm64TLYSC+/cvDuzm5u7QXrZtfoyzP7L9FTRZTNmygbkNyKLcvqmxQHTk8O5mdvmEwVt
         A9XwwwVTVWr91Dlkbeb2aa4Zjal6zQ28xiFh5XP6LK+4lqUFIbXBurpldUs08ATfXlEa
         YE0lDrWpJ2lnYEQyLu3zpA+a7VpSbXH39WXwNWYaQTOfDf1jGmQ+2ETeLFCO//Xmy/T7
         hmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725564637; x=1726169437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MbrEFO3D2q7bIKaAwLKYWbNKa6L/7Ep2zWdh3jV7Rr4=;
        b=aoYygwhWP3odvCPKtFWGI2NboyiZkYIqiW1O9w4E36Da7+oZZ2vznvUiAAlxe/o3Y6
         lkkHWb13TaVk1e1PU/HDZNV88WJL8sx72FvYaONHw5zgPw7u7jvHvXH3fz4Og078H508
         pAwL6TBPls1TnauTHYeSNy12DMIAvFDBq3DpHW5FtyVrTga+XRdeGpZ2Y/ZcaoasdbhE
         Vv7QZbfSZAsQ4oH3cR3n3/4sQmAZfx+/ZxoMNuRu3RWCDFlJHmnvY7NwIv1AearwbpHu
         22MSCfYTlCWDDQhydkm5lq/BuBToatUjtu43A22Ov8g53/TT8TPaqF6E/tszS9uhTVRk
         OvHA==
X-Forwarded-Encrypted: i=1; AJvYcCULKxWAbureYn0f2orARThjTRDftTwo6deB0EeEHbUM/i9LC02NNwAlMm8qqVM91xpG2J5nKcA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1ML6ypHnHRnLiqOj9yL8TPRvVJ+nUvbdhjcL+BbEZ/qUQKI1F
	RAxlALAXLzahHbgJjs/7V8Hfh5XJCof/yzSs+lOE7f9N6nC2C4HG
X-Google-Smtp-Source: AGHT+IEXZGO8hCMMHsv0PnNONyTrag4Qx3WBh3WvRsXRhE+inBwlwGH8ekc0KBbwTXHDLfyibHm8iQ==
X-Received: by 2002:a17:902:cec9:b0:206:8c37:bcd0 with SMTP id d9443c01a7336-206f052e090mr1367825ad.27.1725564636900;
        Thu, 05 Sep 2024 12:30:36 -0700 (PDT)
Received: from leg ([2601:646:8f03:9fee:1d73:7db5:2b4a:dfdd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206ae952bd4sm31818995ad.113.2024.09.05.12.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 12:30:35 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 5 Sep 2024 12:30:20 -0700
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
Subject: Re: [PATCH v3 18/25] cxl/extent: Process DCD events and realize
 region extents
Message-ID: <ZtoGzNhrCOPvrnGV@leg>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-18-7c9b96cba6d7@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240816-dcd-type2-upstream-v3-18-7c9b96cba6d7@intel.com>

On Fri, Aug 16, 2024 at 09:44:26AM -0500, ira.weiny@intel.com wrote:
> From: Navneet Singh <navneet.singh@intel.com>
> 
> A dynamic capacity device (DCD) sends events to signal the host for
> changes in the availability of Dynamic Capacity (DC) memory.  These
> events contain extents describing a DPA range and meta data for memory
> to be added or removed.  Events may be sent from the device at any time.
> 
> Three types of events can be signaled, Add, Release, and Force Release.
> 
> On add, the host may accept or reject the memory being offered.  If no
> region exists, or the extent is invalid, the extent should be rejected.
> Add extent events may be grouped by a 'more' bit which indicates those
> extents should be processed as a group.
> 
> On remove, the host can delay the response until the host is safely not
> using the memory.  If no region exists the release can be sent
> immediately.  The host may also release extents (or partial extents) at
> any time.  Thus the 'more' bit grouping of release events is of less
> value and can be ignored in favor of sending multiple release capacity
> responses for groups of release events.
> 
> Force removal is intended as a mechanism between the FM and the device
> and intended only when the host is unresponsive, out of sync, or
> otherwise broken.  Purposely ignore force removal events.
> 
> Regions are made up of one or more devices which may be surfacing memory
> to the host.  Once all devices in a region have surfaced an extent the
> region can expose a corresponding extent for the user to consume.
> Without interleaving a device extent forms a 1:1 relationship with the
> region extent.  Immediately surface a region extent upon getting a
> device extent.
> 
> Per the specification the device is allowed to offer or remove extents
> at any time.  However, anticipated use cases can expect extents to be
> offered, accepted, and removed in well defined chunks.
> 
> Simplify extent tracking with the following restrictions.
> 
> 	1) Flag for removal any extent which overlaps a requested
> 	   release range.
> 	2) Refuse the offer of extents which overlap already accepted
> 	   memory ranges.
> 	3) Accept again a range which has already been accepted by the
> 	   host.  (It is likely the device has an error because it
> 	   should already know that this range was accepted.  But from
> 	   the host point of view it is safe to acknowledge that
> 	   acceptance again.)
> 
> Management of the region extent devices must be synchronized with
> potential uses of the memory within the DAX layer.  Create region extent
> devices as children of the cxl_dax_region device such that the DAX
> region driver can co-drive them and synchronize with the DAX layer.
> Synchronization and management is handled in a subsequent patch.
> 
> Process DCD events and create region devices.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
One more minor inline.
> +static int cxl_validate_extent(struct cxl_memdev_state *mds,
> +			       struct cxl_extent *extent)
> +{
> +	u64 start = le64_to_cpu(extent->start_dpa);
> +	u64 length = le64_to_cpu(extent->length);
> +	struct device *dev = mds->cxlds.dev;
> +
> +	struct range ext_range = (struct range){
> +		.start = start,
> +		.end = start + length - 1,
> +	};
> +
> +	if (le16_to_cpu(extent->shared_extn_seq) != 0) {
> +		dev_err_ratelimited(dev,
> +				    "DC extent DPA %par (%*phC) can not be shared\n",
> +				    &ext_range.start, CXL_EXTENT_TAG_LEN,
> +				    extent->tag);
> +		return -ENXIO;
> +	}
> +
> +	/* Extents must not cross DC region boundary's */
> +	for (int i = 0; i < mds->nr_dc_region; i++) {
> +		struct cxl_dc_region_info *dcr = &mds->dc_region[i];
> +		struct range region_range = (struct range) {
> +			.start = dcr->base,
> +			.end = dcr->base + dcr->decode_len - 1,
> +		};
> +
> +		if (range_contains(&region_range, &ext_range)) {
> +			dev_dbg(dev, "DC extent DPA %par (DCR:%d:%#llx)(%*phC)\n",
> +				&ext_range, i, start - dcr->base,
> +				CXL_EXTENT_TAG_LEN, extent->tag);
> +			return 0;
> +		}
> +	}

For extent validation, we may need to ensure its size is not 0 based on the spec.
Noted that during testing, do not see issue for the case as 0-sized
extents will be rejected when trying to add even though it passes the
validation.

Fan
 
