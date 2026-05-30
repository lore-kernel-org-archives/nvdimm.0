Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477A3311C1D
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 06:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780124230; cv=none; b=uLME45oTuvTCTtYJqiEKq9+hwjYao7cOvle8LccO4C++9vHX8DKaSu0eOzxuJKQg7wNpZChw/blx1lahESKyJ1tRD97mFZ6qQaouhxlPz86IWcTM6GNvu3sK1kdXZYIwiwkBEORwk0cONUzraz4RNPomvffSFwm8Ipftadbbp1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780124230; c=relaxed/simple;
	bh=ptOJ2M0UZQKXLgtWO06fAWLNwj8RGsAUYc3Mni54jMk=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ua8uXu2mtGv50wIWp9/C6vmA+bXf8NBViVJutv9MUtDQwfiwIhqN8VV/jtMzNS1/YBxXw30jCI6FmOuH6mWYtA6Wg9eOw2DNdufNSft29Rs7TTAMfmeHhPLajoIXb2atGIsy/371BYvZA9ZdAh85kZOYvVMwSFzu3NBRxQ+BAfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kUDzCi36; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kUDzCi36"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-304f0039c02so2565950eec.1
        for <nvdimm@lists.linux.dev>; Fri, 29 May 2026 23:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780124228; x=1780729028; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vNqX6axv+OwYZf8pJ3sGM9wZCTdhSmLjoPecyaFqaUQ=;
        b=kUDzCi36CaoZnenjbU3l1d5P8+BaZ5vMescIznW3QeqjTlwzR+GaEspir6fC8jCAxT
         LeMRSTtv0qvkiSn0WUfAfjUZDlEIXs4JKWzRWFbM6gJ0MMc6sMIl26Ryo7zCTlJE5/Rg
         mPGuDHa8fOR6JOtC6V6dgFtGRBrynsBdrzProLGZcuhKaHbMV9G/fClBizASLCr+XRB/
         QJ21KVLq+CTmIZ62N/B74tHMrs2wrIgHdg6QJSddagmoMV3m+o3M2GBrzR7ZurygxQ5v
         KbxFTFyAGI7VsapjYtD57CY8Gje7wbRhZjIDhRTowfVAxHSbEHT6hkgJEUmaOUmK8OHf
         aA7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780124228; x=1780729028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vNqX6axv+OwYZf8pJ3sGM9wZCTdhSmLjoPecyaFqaUQ=;
        b=M02Ky/cEbQ7dB2l9y/574hO0MGRVUMDyPuVDkvCd6DOxnm7C9bKRAaGF7HEoMjeQjS
         Gi2o5UPIkwsYL5B+0GaG1juIuwtx7Sm/auL/uvmmgeMYpX8NNPpWwfwoxe96nqaD/YuF
         6pH9w8HIggrKcwzEN58kvupZcmlHKVxJgLL+bRc1DszfleZ3Y1I37l0BQJ+9Q5JigNL5
         eIRpnF3ZU8qDj/zYJ45aZQ9F3HCuRzLPJ7SOW0oC5PTc2/wqdcBrnRqdoBNS4OpdnPvf
         prmnZXw4eLbGahhDcLym6A2DT2J+ZSoL+HPZoH84+PO8kadTQxudzYJncXU1GHu1v8KH
         FeBA==
X-Forwarded-Encrypted: i=1; AFNElJ+tKuwg8MUK8lnm4rHiC3dnCP/2E1XENUZedxQv3G6xFECVMfAeSvwGy7wW3eEc0ar75UADMf4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxO7Ez5MySylPOTKpjCcer/uLx8zprbMpmzmHekR1bfs/drUALv
	+EP1jCaxm/jzQnI+Ci29QnjWAYJGkCkkOLblJ01qhwaSfIAkmXoNavT2
X-Gm-Gg: Acq92OEUwIQLFN702LOpeAMbEpbqNTGoZMk3QD/6lJGmH8zPOeOrPRJ/k0WldvwdbX7
	IQHb2XjTuvGZNyGnY0qUK3V/ws+BtLNNIz+8+zUp/KlBHGZq7xQvCsuZkKNf//ilt8vIX30Uzt0
	5pnr5wmBKmK2UMawbkDh0bCaHj3uX/oJNHgmw5FQn3vpnl4/CYDt/KfAYGDIl5dUT48JrooTMRG
	m242dash3xSbJ1m4ENAwpfL/EoC4xqlk7ank9OvT6P0PFCQK/hOu5xiM9F9X9qAHlpqPceGdmNp
	zvfXGpEaNrwAWek0CxJ/LPfYARzLvnzD1SQjcvxejSEAL0nDo//Jwm4v4mFK4f6KpGLydGFVPR5
	YVDWPrFsSNDYi/g2/Amo5qPF7VsesD4P1IpH3SqRcS730U4L/LEH/oiQvJsnBE2K7V2U2Gq5S2u
	D6v2QnpEW68LaKEQiVmp3swzmUagqqxUA1r6kIhfuN2pNq3p3AwUge+KhMa1UPrjEuhlFjl9qtj
	KGLqF1XXtY9U4YlNg==
X-Received: by 2002:a05:693c:8859:b0:305:56a:c38f with SMTP id 5a478bee46e88-305056ac792mr367592eec.26.1780124228282;
        Fri, 29 May 2026 23:57:08 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304ed2c312csm3568826eec.6.2026.05.29.23.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 23:57:07 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Fri, 29 May 2026 23:57:06 -0700
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
Subject: Re: [PATCH v10 04/31] cxl/core: Enforce partition order/simplify
 partition calls
Message-ID: <ahqKQm87k0Z4MLSQ@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <22ae445b8a99d26299520e2429c5bf4e64b0d9e6.1779528761.git.anisa.su@samsung.com>
 <c1f55b99-31d2-4c5f-9f22-05f363e31e5b@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1f55b99-31d2-4c5f-9f22-05f363e31e5b@intel.com>

On Wed, May 27, 2026 at 04:37:11PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:42 AM, Anisa Su wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > Device partitions have an implied order which is made more complex by
> > the addition of a dynamic partition.
> > 
> > Remove the ram special case information calls in favor of generic calls
> > with a check ahead of time to ensure the preservation of the implied
> > partition order.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > 
> > ---
> > Changes::
> > [anisa: rebase]
> > [davidlohr: core/hdm.c: return -EINVAL instead of 0 in cxl_dpa_setup
> > if partitions are out of order]
> > ---
> >  drivers/cxl/core/hdm.c    | 11 ++++++++++-
> >  drivers/cxl/core/memdev.c | 32 +++++++++-----------------------
> >  drivers/cxl/cxlmem.h      |  9 +++------
> >  drivers/cxl/mem.c         |  2 +-
> >  4 files changed, 23 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> > index 28974adaab75..7a5812971f8f 100644
> > --- a/drivers/cxl/core/hdm.c
> > +++ b/drivers/cxl/core/hdm.c
> > @@ -464,6 +464,7 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
> >  int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
> >  {
> >  	struct device *dev = cxlds->dev;
> > +	int i;
> >  
> >  	guard(rwsem_write)(&cxl_rwsem.dpa);
> >  
> > @@ -476,9 +477,17 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
> >  		return 0;
> >  	}
> >  
> > +	/* Verify partitions are in expected order. */
> > +	for (i = 1; i < info->nr_partitions; i++) {
> > +		if (cxlds->part[i].mode < cxlds->part[i-1].mode) {
> 
> I think we need to check info->part[i].mode and not cxlds here. cxlds mode is assigned later in this function.
> 
fixed!
> DJ
> 
Thanks,
Anisa
> 
> > +			dev_err(dev, "Partition order mismatch\n");
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> >  	cxlds->dpa_res = DEFINE_RES_MEM(0, info->size);
> >  
> > -	for (int i = 0; i < info->nr_partitions; i++) {
> > +	for (i = 0; i < info->nr_partitions; i++) {
> >  		const struct cxl_dpa_part_info *part = &info->part[i];
> >  		int rc;
> >  
> > diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> > index 80e65690eb77..71602820f896 100644
> > --- a/drivers/cxl/core/memdev.c
> > +++ b/drivers/cxl/core/memdev.c
> > @@ -75,20 +75,12 @@ static ssize_t label_storage_size_show(struct device *dev,
> >  }
> >  static DEVICE_ATTR_RO(label_storage_size);
> >  
> > -static resource_size_t cxl_ram_size(struct cxl_dev_state *cxlds)
> > -{
> > -	/* Static RAM is only expected at partition 0. */
> > -	if (cxlds->part[0].mode != CXL_PARTMODE_RAM)
> > -		return 0;
> > -	return resource_size(&cxlds->part[0].res);
> > -}
> > -
> >  static ssize_t ram_size_show(struct device *dev, struct device_attribute *attr,
> >  			     char *buf)
> >  {
> >  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> >  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> > -	unsigned long long len = cxl_ram_size(cxlds);
> > +	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_RAM);
> >  
> >  	return sysfs_emit(buf, "%#llx\n", len);
> >  }
> > @@ -101,7 +93,7 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
> >  {
> >  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> >  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> > -	unsigned long long len = cxl_pmem_size(cxlds);
> > +	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_PMEM);
> >  
> >  	return sysfs_emit(buf, "%#llx\n", len);
> >  }
> > @@ -424,10 +416,11 @@ static struct attribute *cxl_memdev_attributes[] = {
> >  	NULL,
> >  };
> >  
> > -static struct cxl_dpa_perf *to_pmem_perf(struct cxl_dev_state *cxlds)
> > +static struct cxl_dpa_perf *part_perf(struct cxl_dev_state *cxlds,
> > +				      enum cxl_partition_mode mode)
> >  {
> >  	for (int i = 0; i < cxlds->nr_partitions; i++)
> > -		if (cxlds->part[i].mode == CXL_PARTMODE_PMEM)
> > +		if (cxlds->part[i].mode == mode)
> >  			return &cxlds->part[i].perf;
> >  	return NULL;
> >  }
> > @@ -438,7 +431,7 @@ static ssize_t pmem_qos_class_show(struct device *dev,
> >  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> >  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> >  
> > -	return sysfs_emit(buf, "%d\n", to_pmem_perf(cxlds)->qos_class);
> > +	return sysfs_emit(buf, "%d\n", part_perf(cxlds, CXL_PARTMODE_PMEM)->qos_class);
> >  }
> >  
> >  static struct device_attribute dev_attr_pmem_qos_class =
> > @@ -450,20 +443,13 @@ static struct attribute *cxl_memdev_pmem_attributes[] = {
> >  	NULL,
> >  };
> >  
> > -static struct cxl_dpa_perf *to_ram_perf(struct cxl_dev_state *cxlds)
> > -{
> > -	if (cxlds->part[0].mode != CXL_PARTMODE_RAM)
> > -		return NULL;
> > -	return &cxlds->part[0].perf;
> > -}
> > -
> >  static ssize_t ram_qos_class_show(struct device *dev,
> >  				  struct device_attribute *attr, char *buf)
> >  {
> >  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> >  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> >  
> > -	return sysfs_emit(buf, "%d\n", to_ram_perf(cxlds)->qos_class);
> > +	return sysfs_emit(buf, "%d\n", part_perf(cxlds, CXL_PARTMODE_RAM)->qos_class);
> >  }
> >  
> >  static struct device_attribute dev_attr_ram_qos_class =
> > @@ -499,7 +485,7 @@ static umode_t cxl_ram_visible(struct kobject *kobj, struct attribute *a, int n)
> >  {
> >  	struct device *dev = kobj_to_dev(kobj);
> >  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> > -	struct cxl_dpa_perf *perf = to_ram_perf(cxlmd->cxlds);
> > +	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_RAM);
> >  
> >  	if (a == &dev_attr_ram_qos_class.attr &&
> >  	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
> > @@ -518,7 +504,7 @@ static umode_t cxl_pmem_visible(struct kobject *kobj, struct attribute *a, int n
> >  {
> >  	struct device *dev = kobj_to_dev(kobj);
> >  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> > -	struct cxl_dpa_perf *perf = to_pmem_perf(cxlmd->cxlds);
> > +	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_PMEM);
> >  
> >  	if (a == &dev_attr_pmem_qos_class.attr &&
> >  	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index cee936fb3d03..10175ca3b7ee 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -383,14 +383,11 @@ struct cxl_security_state {
> >  
> >  #define CXL_MAX_DC_PARTITIONS 8
> >  
> > -static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
> > +static inline resource_size_t cxl_part_size(struct cxl_dev_state *cxlds,
> > +					    enum cxl_partition_mode mode)
> >  {
> > -	/*
> > -	 * Static PMEM may be at partition index 0 when there is no static RAM
> > -	 * capacity.
> > -	 */
> >  	for (int i = 0; i < cxlds->nr_partitions; i++)
> > -		if (cxlds->part[i].mode == CXL_PARTMODE_PMEM)
> > +		if (cxlds->part[i].mode == mode)
> >  			return resource_size(&cxlds->part[i].res);
> >  	return 0;
> >  }
> > diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> > index fcffe24dcb42..f19e08279ec7 100644
> > --- a/drivers/cxl/mem.c
> > +++ b/drivers/cxl/mem.c
> > @@ -114,7 +114,7 @@ static int cxl_mem_probe(struct device *dev)
> >  		return -ENXIO;
> >  	}
> >  
> > -	if (cxl_pmem_size(cxlds) && IS_ENABLED(CONFIG_CXL_PMEM)) {
> > +	if (cxl_part_size(cxlds, CXL_PARTMODE_PMEM) && IS_ENABLED(CONFIG_CXL_PMEM)) {
> >  		rc = devm_cxl_add_nvdimm(dev, parent_port, cxlmd);
> >  		if (rc) {
> >  			if (rc == -ENODEV)
> 
