Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A93E39CD14
	for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 07:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784101942; cv=none; b=qXrBTgoIs4KNi0BhxP3KR0KpHOVAbMclfZ6v90LKvR8GHTWM5C29FUUc61MsnqhaVf1w6u23NTe6YUOXbO9ifm+GvTHdZvjUBG33s2ck43lDuWD1UW3So2OvJ6AU1yUwfQqnmCF9o9dxlTHSsjQ881uozKZqhhjNvy7YJQ/5jt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784101942; c=relaxed/simple;
	bh=SFfaixy5mSLcBLwBntye6Z3BtPZ39eJulCWZ9W5HDL0=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tpsGEHyWrJ37oBLJZzHdKmgEsLdWPGXgqH1xKU8gm48F55gUQiaiPF6ADosgNVWNv501gRiJ5gnerfP1yD7Hrna82nhJ3v2DVZrR0avWO7uSDmZ4X9Gihq6MyxoEhVB4Wewqn5dZfpm0yysTKN1n0SS0hP4CIEAU6Dd4h5OBcms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FIo4X9ss; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FIo4X9ss"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-382ef647e20so4831106a91.1
        for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 00:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784101940; x=1784706740; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LkoZxLu3mKiKId6IT2QmHjKJhmmkO8Ne64sGip4OZac=;
        b=FIo4X9ss1li+RJe2GbxewqCYzeV4BFJzdxXH9cDodcPhDPPJOgAqqstwP25jmemvU2
         kwbhFItozMcNgt4tjBHkt3iHp0Pv47eoIFH4Zv5e0FrspFopAg3P+JOpsM4hNwp6LMc6
         2+n4zpAz1SJz/YeVHbqYM/ZvCF+GgdtUMsNrwytgYfQfXJI4LTDCQtzgZAzwllQjyiSX
         7N6quwA8lZMeLW5yrN+EzqLtAQggGrAL2O7NCZnGaQocC5l4DisgRGXoRBZgwtJkW1Cl
         lJpEePvLSiQcC/dE5uymPehIT04C+XeugxwGCuiFY5n0aRxduLVe1eM5QVtGXS36ubzS
         mQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784101940; x=1784706740;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LkoZxLu3mKiKId6IT2QmHjKJhmmkO8Ne64sGip4OZac=;
        b=NPsrCsqaz4/1If8dtj5Xd+OwXDGb6nrHTF95BIvHbsOFruknVRK0BA6gmNU2u1KLZc
         1F6Y5DwzXyCJdJroBlxI2WvLwaKrEV18CGy7I82rXwEP5v/Ey9eQVWOp4OTk/HaPEOPK
         Jm6+srGWkJ18mTk0Bg/GVxVYaioXdgQ4u+kHoPxAtH/Fbe+a2o0him1qfpw91RJWPRUm
         B6Ko9EZOh29P8CsDMYMvmgLKLAdn2RPPjmidOobVu7v6kQ8FyHLF1dTPYqpNLUfvNqQg
         x99lGTBUoU+cXXiUHjWCdZWOA9Ji3CKc3qQma5DwAIXi7h7HUc5EQvMco2cehtLbUeCK
         ohBA==
X-Forwarded-Encrypted: i=1; AHgh+Ro3vVKIdfJC50eLvWCX8nuPoOiiHwU+ig5DFQPRV+G8TIP41zT9l+cVvDhmHRs2d+51KAnrjmY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHZVvj3ixoqPFJFYjfnMYKr4/8Lhs4FagDhOkigAgNLiZzRolV
	bE+uOkLCFjfHOAmcGCVlH1suR0J1M48iq4y7MS6vxV0Mo/i/WpkO9xYh
X-Gm-Gg: AfdE7cn4oKTw/C8mKQxRKALYVNv1wZQV6nB0IMqvJYDjz7i8rkDnhqZum+zajTcH11n
	adp7tJVjjQt0J5ilysEd3gbzAQhQEUsZ+nAfhnxXRMFDfwgQAGXp108mXUtLdr2kDxbnbL8zgth
	sBY7dIIx83szqvqTGGAgHONjrIYW4NEYiY1nGeDzSOgpuDUxmve1nvcDzrHpPwwPTCh+AHUGwJd
	MoEHZo8y3cbjqUGbaXSPVkl7Deat8J0XzcRDR8S0w+5PiDd45HGvyT/GfkhTwcZLBMqJYMMw2Os
	VBGD5ZviqRgIZQfw6PtBoRjAgWKWaQFNNUZhStXNVa1yS3W9168HMyLUMA4tLJZtxIek1mMvyrG
	0gUKm/8mf1I9uBOuhjOuLEfkTBK4utb2UsUfCAoKHu/QUqFuB2BDI3JREexLMrCeGPN0rydIWJP
	QvteFKE+HGU6BIYCrcQTfdrvDwXV8mLH/FST5I+ZI4Zw896UvLzFNfIDoeayk5JZzmx316dysVB
	+PZrHQ=
X-Received: by 2002:a17:90b:3142:b0:387:e0db:3d8e with SMTP id 98e67ed59e1d1-38e2a0a87cfmr1777436a91.41.1784101940512;
        Wed, 15 Jul 2026 00:52:20 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174ac14f2sm94910291eec.27.2026.07.15.00.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 00:52:20 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 15 Jul 2026 00:52:17 -0700
To: sashiko-reviews@lists.linux.dev
Cc: Anisa Su <anisa.su887@gmail.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v11 05/31] cxl/mem: Expose dynamic ram 1 partition in
 sysfs
Message-ID: <alc8MagZWKAAcNA_@AnisaLaptop.localdomain>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-6-anisa.su@samsung.com>
 <20260625181243.77F581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260625181243.77F581F000E9@smtp.kernel.org>

On Thu, Jun 25, 2026 at 06:12:42PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] Empty sysfs directory created for absent dynamic RAM partitions.

Fixed.

> --
> 
> commit 839299dd9514d54314e661cd789de765da08d4f4
> Author: Ira Weiny <iweiny@kernel.org>
> 
> cxl/mem: Expose dynamic ram 1 partition in sysfs
> 
> This commit exposes the details of the first dynamic ram partition via
> sysfs so user space can properly configure CXL regions.
> 
> > diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> > --- a/drivers/cxl/core/memdev.c
> > +++ b/drivers/cxl/core/memdev.c
> 
> [ ... ]
> 
> > @@ -519,6 +551,29 @@ static struct attribute_group cxl_memdev_pmem_attribute_group = {
> >  	.is_visible = cxl_pmem_visible,
> >  };
> >  
> > +static umode_t cxl_dynamic_ram_1_visible(struct kobject *kobj, struct attribute *a, int n)
> > +{
> > +	struct device *dev = kobj_to_dev(kobj);
> > +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> > +	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_1);
> > +
> > +	if (a == &dev_attr_dynamic_ram_1_qos_class.attr &&
> > +	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
> > +		return 0;
> > +
> > +	if (a == &dev_attr_dynamic_ram_1_size.attr &&
> > +	    (!cxl_part_size(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_1)))
> > +		return 0;
> 
> [Severity: Low]
> Should cxl_dynamic_ram_1_visible() return SYSFS_GROUP_INVISIBLE here when the
> dynamic RAM partition is absent?
> 
> Since cxl_memdev_dynamic_ram_1_attribute_group is a named group
> (.name = "dynamic_ram_1"), returning 0 hides the individual attributes but
> still creates the group directory.
> 
> Won't this result in a permanently empty "dynamic_ram_1" directory in sysfs if
> the size is 0, rather than suppressing the directory entirely?
> 
Fixed.

If a DC partition's size is 0, better not the expose the directory at
all, instead of hide both attributes.

Ram and pmem always expose the size attribute, even if the
size of the ram/pmem partition is 0, but that makes less sense for a DC
partition, especially if support for multiple partitions is added later.

> > +
> > +	return a->mode;
> > +}
> > +
> > +static struct attribute_group cxl_memdev_dynamic_ram_1_attribute_group = {
> > +	.name = "dynamic_ram_1",
> > +	.attrs = cxl_memdev_dynamic_ram_1_attributes,
> > +	.is_visible = cxl_dynamic_ram_1_visible,
> > +};
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260625112638.550691-1-anisa.su@samsung.com?part=5
