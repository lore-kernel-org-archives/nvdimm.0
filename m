Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9031EBFE0
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 09:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782378525; cv=none; b=lgRuDolYpXUq3EzOQEcKWIJ1WRNOmR8KwdYIw0CxtRY6iyks0KHocFzeKQcUp1u31jFi/3mYb9pbKlgxeSWlPLlM8KWuWAhUaQLFzdL4lDcFCrf1BGnTmZNAkbnlWoyvsODTX5g0/Va50XMxtOqkVDk68OUsJelZ0R2U3h6xww0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782378525; c=relaxed/simple;
	bh=YGWfzGQORLJkRM4iXt4veDpJWzcxQCLpMbCh3q7RdrA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrUXrTfSo4LEnTOz94K9H/2BOWnTBJx8JiEiEpanXVJjwylxYYe+fcZ+UjJNkiqoGadkgZ4SULT73jPqgOmCqak/RlghL6RIIE8k+wR8b3k5gf9Ah60QQUIDCJCWHueDBI5DYMUZr8cmBo7XJ2dgUBZnVHJlAuQf9h0bWfu3vTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ausnc2SM; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ausnc2SM"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-30c591fb1cbso2967141eec.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 02:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782378523; x=1782983323; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vh+XojUQaqMIviFBsHEt7W4dW/CY/ggastnUo3Mk/nU=;
        b=ausnc2SM9qc9901VSD/IbwicPfLNUzGEbuyaszoPwog8301sK9Kons6xTM0Y6nJkVC
         hEkEU4ma6/kgvZvU8hBc3h0+n3dv/7pcsSh9WUdCgYPILh2xH8CNcoiLEJtjBQmjvvlF
         PjMDPXH7uVcyOtuDoKUrTj6xRhZO8q9Tl3EPmNtO4koCzpmPqbYeWsK73TlFKyyWo5Ng
         60K2ZB7nyuWXtryBcZVmM9XXYOuRqofi1V6jAjijUIIgUFtqK3zrFADuvSDt9pH8IiSp
         q1C7fj4Tdt5u33X1jDSkDPBrXslFmYsTqrnId9NQgdCWuGZ0YBd4fKchcB1+tvfD7w5X
         YIaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782378523; x=1782983323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vh+XojUQaqMIviFBsHEt7W4dW/CY/ggastnUo3Mk/nU=;
        b=p7yX3SCtpZA0gJ+FU0TKrzF/WUvpXeRsw6ln1sCVb13/xibMZ/4h1PxwS9WYCH5mb9
         1qdZg5QMSH30vSLy1YrveJtp6vZFFjR71FAV5g2WD/Ob3ktDqFXjlRbCO/65cex6CurV
         J6BoYaMXIitSekKGxmRHMKwgF68+KDdDyVMrGrHvKRxQFL4ADtB6QNixFZtlp1xRReyf
         5WWKj/mDDg4l55BVMqMhu0utXp1w/HRGiCqOVC+m0ZM9SlpfFv3wLl8Shgcg1Wt+DsLI
         j132BxYNwD4TBKOoi/QbMd+9FzgkW682Vzv6FBXewDCoWYXxp/RIws32HiNYxC/S6P+X
         bzeA==
X-Forwarded-Encrypted: i=1; AHgh+RosXivVPPj7AVMZZb/HQa8szwqw4X9Z6bTGQ+iKgLXr7cjshwWmfVNwGB62kZE89F0O4kR2dew=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTuDF63onaG7/XwwHEFgP26/zilrMLmS2vD0sminwJoOpSVrgU
	ZyskrvHXVMvzS/4Lp/KEDsn+GH5QHvv0QcGAjhYvhmAb2eVOTKIYP7ET
X-Gm-Gg: AfdE7cm9BfJGFI+LfQQ7gNX5dGL2DUlPQFg22E/c9ikPV5NPpAqEa2jDTykt0r0yRDg
	LRSQlS857z9XiEB4fGDgw30xTgEdBOg0WBXWpyx7N4YpIEUEEFw/kT3GDgLheYCdr/wu4akFDP0
	ird5Xe6EAlec32XLXmBPcigPwEGwn8Vc6tO/dcfzfwbh+6WUHFmclRJ+kodFo8bCxPzkLuyovCb
	qybfT+4D8v8dx49IZ3Pa3HsezlsLozX/aPOvgms1jtk46j7SkaCqRubXN39BruKrzqH8zl2B8GN
	jeG1KEKpINon8W4rQkLoG+l/8Aer50STYpFQ0uvYfK7Xbtdo4I70crH/iZzAeZlUaKuIDbpjGT9
	Uj/p8kUfsJf7cvbKquwe1plE/TsrV06r3Ij2OeLZtqX0l+Gf3HiDMKBWwOM5RcsZ5++9xf/l5+R
	i77gGEuy1wg7YHFldsvEDLwgKGPq5gTkU9R3zO3mNyqqcqBHyYIaSEpoZT74DpOVczRGYi
X-Received: by 2002:a05:7300:e8a4:b0:2ed:935:aa33 with SMTP id 5a478bee46e88-30c84b1e852mr1902737eec.5.1782378523429;
        Thu, 25 Jun 2026 02:08:43 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c8afca8sm6375872eec.17.2026.06.25.02.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 02:08:43 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Thu, 25 Jun 2026 02:08:42 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Richard Cheng <icheng@nvidia.com>, Anisa Su <anisa.su887@gmail.com>,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v6 2/7] libcxl: Add Dynamic RAM A partition mode support
Message-ID: <ajzwGj0wjaqMTLPE@AnisaLaptop.localdomain>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-3-anisa.su@samsung.com>
 <06747633-ed22-48a2-b8d0-c9b544a682f8@intel.com>
 <aijefVjI2x6hgxH8@MWDK4CY14F>
 <8656e29c-79ff-4b96-87ba-7919ad32a6a2@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8656e29c-79ff-4b96-87ba-7919ad32a6a2@intel.com>

On Wed, Jun 10, 2026 at 09:55:49AM -0700, Dave Jiang wrote:
> 
> 
> On 6/9/26 8:51 PM, Richard Cheng wrote:
> > On Mon, Jun 08, 2026 at 04:19:47PM +0800, Dave Jiang wrote:
> >>
> >>
> >> On 5/23/26 2:50 AM, Anisa Su wrote:
> >>> From: Ira Weiny <ira.weiny@intel.com>
> 
> <-- snip -->
> 
> >>> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> >>> index ed4429f..258bdd3 100644
> >>> --- a/cxl/lib/libcxl.sym
> >>> +++ b/cxl/lib/libcxl.sym
> >>> @@ -294,6 +294,10 @@ global:
> >>>  	cxl_memdev_get_fwctl;
> >>>  	cxl_fwctl_get_major;
> >>>  	cxl_fwctl_get_minor;
> >>> +	cxl_memdev_get_dynamic_ram_a_size;
> >>> +	cxl_memdev_get_dynamic_ram_a_qos_class;
> >>> +	cxl_decoder_is_dynamic_ram_a_capable;
> >>> +	cxl_decoder_create_dynamic_ram_a_region;
> >>>  } LIBECXL_8;
> >>>  
> >>>  LIBCXL_10 {
> > 
> > Shouldn't new exported symbols go in a fresh top-level node ?
> > Something like LIBCXL_12 ? please note that Patch 4 has the same
> > issue.
> > 
> > Please let me know if I'm wrong or misunderstand anything.
> You are correct. These need to be moved to a new block for a new release. 

Thank you for finding this! It's gone into LIBCXL_13 after rebasing on
the latest pending branch.

Thanks,
Anisa
