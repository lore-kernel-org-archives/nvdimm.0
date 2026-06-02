Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC0F3D7A03
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 09:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780393571; cv=none; b=C3SKPPzb/HVi4Ysred9l1d06Xq4oJ71JndXYZPYItUlDtvc/sksmNaG05AOoW7dQvzpTrPH+fAt2K6aNpp0YZLaFLD3cibrfCLbFq1ziSThaQnUv0eIycvBCw95ppckxMoevC4xCsEnVms7p2A5MNY0ua8aKCUFwtGTKzvmbb1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780393571; c=relaxed/simple;
	bh=qwOzoxL1nfHFt1Z/yWF60fP6M1ITbnvyDCdRZEhb2vc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ua24hyHu02hsQyOy5z8+Vm9FnwQ6fqoV0B2N3QFoeHuLElxyT7zwkpSsvbtdIm9iOW9GJ1AITKX5zKUbH1YcfPm9QbkO3axOo2gfnJhA7agHbO48vuqggkuNe+g1Whw50lmf4Go/JC/h6gEY74ajJN6zeXze2xMF28SkfVtlLVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pma9j6nb; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pma9j6nb"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-304df7ff4c2so3038628eec.0
        for <nvdimm@lists.linux.dev>; Tue, 02 Jun 2026 02:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780393568; x=1780998368; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3lTY9oGN4197b14UYyts3x1t+0qjIngIJSSCllkUKes=;
        b=Pma9j6nbzohL5RHwvuGjtLKbzG5CB6tX3JXFrNCLcbiDa7HImwu2KqgeURWlqnXNNm
         r1X+4h4zVmLOeRDOZsmMQKEoIp2SnZ00lwp4yjXXTy3FNbGndjMuu0RHEiHUGTnoiPLK
         syFs8LvNP3odLQcQFMgNxLWAYwNw8Ryr+CiofFkPlrcR6V7KF1pKX+3v92/exZ4f9klS
         uTGN2n4/XB+SDICOgOAabTsJWnGQtvpfy4Go5nRZ+wWz9YPVtR02GK4+lMZAtn7QoygS
         6LD3JQXJb8tShDZRYJ2cJznYzzO/GxK0GPPGxPjmDapUaTyDBsaq3DzONnDbFjT9d+7T
         iKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780393568; x=1780998368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3lTY9oGN4197b14UYyts3x1t+0qjIngIJSSCllkUKes=;
        b=nmK8/+321odEczPnKoRkNotZDYQkQgatY7DLgfY7hxaUEx900hSDq/ObuZy7FIyxAN
         fkHLEUubm18hkB5xiARA83N6WAsu+gYpOm5/RX7hZs/6SzJkmFneSmoh5n3N304eV6qj
         DewXWEe7T/dmcxe2y2M1Db9CA97GkxIrhz1OhvhMp60XaBD5mW5oEmGKo1tbwhTAmHvK
         wPQ3lEMjmcZ/4TzUVkeswNub6V1yIGPH8NZSRf7WPJHhQJlBOzBEbPd5YAHkTQWnQ42a
         poRYrhyGFaK/mNOV4RhGFgCECfg7H7NpjtsvPqz7AR3U6Pft/sRcS71NQWJTH6cY9mSa
         Ixog==
X-Forwarded-Encrypted: i=1; AFNElJ9StLOLlh0aQZ8WO5KU5kPp7YFwGkIziIglr11kwgRc4Ywj0Tvios/fHKW12rG0xy9+K2LV2D8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIV40gJqartn7Ued1dcEQbrycaKQVhycDONu/ZxyXizeNwV+f9
	6sPzfTUh0aTM7e44qOGYC7MRzkEO1WWEOOoVaDFoBUPkZEAPOnkG+AAV
X-Gm-Gg: Acq92OGbKzlntfq5QSyu1SjidscTbA8ZaIJPYhBQOKdx4/JbwXkuF4eRmvh+gFqDOiv
	QbBf+moVudaAawKiOPqbCNa9qkZX0t012bNz7nQpr7g2L6NfTCH8s6KiKs8J+z8SfdEzHqpPiJr
	vtDGb5LkqWbmSfXDnKn8Geh8GC5HXsxi7oGIH7NzdlEqsjryT61VdraedwjhfmKMDLafZp+M1ON
	DQfjXRcEuT+9zLLRVk/uUDnQ96mcikhpfXaiFux034iNQSOB4adnkBs09BLvjSBHMeVYsQQfx2f
	vFwBdjeZvP9ZK0zI9qwAJQBIeelwG3XssmDs3J6WE90n7yxNaB4LBaLgZvnVi326mW2OAR5gzc1
	QzWO6kAbBc8H9pIC4hgnIte6ruxzDWS7oNBOkIvfEvcxEOjLmP4OW1PnrpRNjUrz27dBjTdPCol
	gQJE6kTEpXYlKkZhGJIJJ/NyqxeHfldtrje5d4GGp6cIsQR3XfgctRuPusPwmTd4Ro2WSi80Onu
	KLUZz2XYWqB8HzOPg==
X-Received: by 2002:a05:7300:220e:b0:2c6:67b6:3acc with SMTP id 5a478bee46e88-30734bd92efmr1546760eec.15.1780393568058;
        Tue, 02 Jun 2026 02:46:08 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304ed5d5385sm11088926eec.28.2026.06.02.02.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 02:46:07 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 2 Jun 2026 02:46:05 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v10 02/31] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <ah6mXWqTkooEoEKj@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <692890d6934d844cbbe90596499b28833e45f4f5.1779528761.git.anisa.su@samsung.com>
 <c250bffc-005c-4ce5-bf46-94219a7ba5b2@intel.com>
 <ahqGcScEzplyVSqw@AnisaLaptop.localdomain>
 <5def25f1-58ee-4bac-bc10-93492c1b1109@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5def25f1-58ee-4bac-bc10-93492c1b1109@intel.com>

On Mon, Jun 01, 2026 at 08:23:46AM -0700, Dave Jiang wrote:
> 
> 
> On 5/29/26 11:40 PM, Anisa Su wrote:
> > On Wed, May 27, 2026 at 03:28:56PM -0700, Dave Jiang wrote:
> >>
> >>
> >> On 5/23/26 2:42 AM, Anisa Su wrote:
[snip]
> >>> +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) =
> >>> +					kmalloc(dc_resp_size, GFP_KERNEL);
> >>> +	if (!dc_resp)
> >>> +		return -ENOMEM;
> >>> +
> >>> +	/**
> >>
> >> /*
> >>
> >>> +	 * Read and check all partition information for validity and potential
> >>> +	 * debugging; see debug output in cxl_dc_check()
> >>> +	 */
> >>> +	start_partition = 0;
> >>> +	num_partitions = 0;
> >>> +	do {
> >>> +		int rc, i, j;
> >>> +
> >>> +		rc = cxl_get_dc_config(mbox, start_partition, dc_resp, dc_resp_size);
> >>> +		if (rc < 0) {
> >>> +			dev_err(dev, "Failed to get DC config: %d\n", rc);
> >>> +			return rc;
> >>> +		}
> >>> +
> > 		if (rc == 0) {
> > 			dev_err(dev,
> > 				"Device reported %u partitions available but returned none at index %u\n",
> > 				dc_resp->avail_partition_count, start_partition);
> > 			return -EIO;
> > 		}
> >>> +		num_partitions += rc;
> >>
> >> Would cxl_get_dc_config() keep returning 0 be a problem? Not likely to happen unless device is malicious.
> >>
> > Not sure but I added a check anyway. ^ See above. It prohibits
> > cxl_get_dc_config() returning 0 at all though. But could be changed to
> > err only if 0 partitions are returned X amount of times...?
> 
> I think as long as we have a way to detect that we aren't moving forward in this loop and need to get out at some point.
> 
> DJ
> 
I'll keep the check above then, and just prohibit returning 0 partitions
when the device reports that it has more partitions available, since I don't
think it makes sense for the device to transiently return 0 and for some
reason make progress on retry anyway...

But need to move it below this check

if (num_partitions < 1 || num_partitions > CXL_MAX_DC_PARTITIONS) {

so the no forward progress check is differentiated from returning 0
partitions.

Thanks,
Anisa
> >>> +
> >>> +		if (num_partitions < 1 || num_partitions > CXL_MAX_DC_PARTITIONS) {
> >>> +			dev_err(dev, "Invalid num of dynamic capacity partitions %d\n",
> >>> +				num_partitions);
> >>> +			return -EINVAL;
> >>> +		}
> >>> +
> >>> +		for (i = start_partition, j = 0; i < num_partitions; i++, j++) {
> >>> +			rc = cxl_dc_check(dev, partitions, i,
> >>> +					  &dc_resp->partition[j]);
> >>> +			if (rc)
> >>> +				return rc;
> >>> +		}
> >>> +
> >>> +		start_partition = num_partitions;
> >>> +
> >>> +	} while (num_partitions < dc_resp->avail_partition_count);
> >>> +
> >>> +	/* Return 1st partition */
> >>> +	dc_info->start = partitions[0].start;
> >>> +	dc_info->size = partitions[0].size;
> >>> +	dev_dbg(dev, "Returning partition 0 %zu size %zu\n",
> >>> +		dc_info->start, dc_info->size);
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
> >>> +
>
[snip]
