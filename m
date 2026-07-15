Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F34D2F1FDE
	for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 06:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784097561; cv=none; b=sEWKJEBeM7R7ci4zzvHOCH3ysT7psJ9/RryZ3arSF5U1zn3NrHAvG0Q10FG2lqrbDN3JWcV8bZtfZJovKpgHHqkahwHjmqtMks5niVT0QzEZ7lrVRCJO1MTjO4iqCkr7e8332NTqHu9vnNm4rgl5Ew+2lSVhfJXmEN1Qz6Uo7+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784097561; c=relaxed/simple;
	bh=Q+S5MyrLBFotTM2ApBSafPZvPVjXTev7iXjdKGiWggM=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HEp35uVhvvUQtlULq6r1oKdPmkNKqIrm/kbQgagXP1XIa7S1LiR/MjBTJAsWJHFV4U5OVRtdfZV3SU2ZUH+j5A6sG7PjCtr1+JcsP+rSvF7ULlwIl3s+svy2jLJtLq6pZAvTJflcp/n107CsoZ5j2gmnLu7h/YRcURWTEQR1Wxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EVdMZfF+; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EVdMZfF+"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso56576295ad.1
        for <nvdimm@lists.linux.dev>; Tue, 14 Jul 2026 23:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784097557; x=1784702357; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Oaw2C662NAxBXaE/sxeCqL8mgVyr4U0c2QgFTM28Dbg=;
        b=EVdMZfF+FnzaHCQipT6JSYP2251HpQiPmuwKN1NGKAGsMY9RWQEX2UztWnFnnzh+lk
         ZLa/fzJ/zi2Q8S90mA1tsKuGensGtHHyR3r835pVR8iV0Dn4dN58k2aPqxsanBME2Rax
         28UgWi9gn+ryNtNgU6S9JDy6xwDMg4qLB93PsVLGRyfp+4Au912FxBv1JF9rJvikK6fW
         3GNAAZ7kEkAYhaMYyQKNg9fsLN76r3Adr2Gq432JQM0gU358h2pnRTOcKk8R9NuwNLDQ
         2HmOUY+AWJh7OxilYjn95xh6is1MXfA7fy1oBYsteeQq6enciwrDhQ2L6wXkTkc8p2mH
         gm4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784097557; x=1784702357;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Oaw2C662NAxBXaE/sxeCqL8mgVyr4U0c2QgFTM28Dbg=;
        b=cXlmxbREf09eHr7DZ4LLRxLLpXsOv0Omh10VQo/vi2ajTaushMHOUXHLQpE5Om+YDf
         OXaEhrMgX9RevWlCd3MhnRuCIhnfBP6GYaEK2rObYdtNzEJzrpttEJfNaH9NhdkSyxt0
         WT+dT6vULpaWkt7JIxrP+/jRmanDHNHKQ5ftxaj0dFrKafiIrg1h4vYzT1I9Yo7Bn1Sh
         Kby85JWHy0azmBNRGAh9U/p36FYJkXn5MC8jbohuIfXwQ7GZSUhLBdQXXSUe3pTsRGdP
         1ulj1BcObUjROBdXGno00L3qDtWYTn5PGrtJzF6sJsujUZgIwh4k+/AxeZlSL+oVW/Jm
         Wo2A==
X-Forwarded-Encrypted: i=1; AHgh+RrGHUA2ab0w5btQUD32xcxGrIIaxpirXb7Pjm0e7qJfJdJSIedoVezVudpdIPEUIjjMmU03cl0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYS01ou/l3sasZ+iZmaj/fH1A/W/oznHeEOs1l81kIliPXXcKU
	Ag3joY4ZVGyCZNndaprxslqMfZnsBjUSf5HRnGOMAeNjUmX2GPMSZFDU
X-Gm-Gg: AfdE7clQJS3SICZ30af5g7xnUadQCN8FGL9KVWBir8VvVF+GjRwpE04cGOV976MQ2Kj
	KSieJaEhmi7+P0hcsyLRiTFlV6Vx3+7DTeoaLhcmp8uDtCt7rVTC+UmgG3ABeTaIKTWyiYbTx/9
	d/YzuEMyZL/SFx4jlv5Fm25409EIK153EzDpYh6FrpR08pONfCmQ5zRQcR5bwEV3bRsGR0pdjGq
	oUXM3TaJdywL03iQjB/cUfRYgnXMXc5s0GBm12V20U0VxpKtaCjo9+6FpXCcQe7x5EuONp00As1
	085k7cvxjtdv4S4wd+EEFDnsLuoF7GoZSeeNZKd9sD7Xb3KObtmbhkuGsprHjJvzS4SmUa/WAs+
	pabzMT+sdHQp1vl+14IGMfDoNUZxNqjGnGt1jpgdUApZup/zKpd6yyaveDrcXbxVta46L96Ixn1
	kBntNMjuLU7C1vwoA+1J0TDWn4rBUyX+oW5PGqTk77q8fS4BUy2IxSQ3fiCHz/Tm3VVqeO28Zts
	cJv5Q4=
X-Received: by 2002:a17:903:2f10:b0:2cc:d192:50b5 with SMTP id d9443c01a7336-2cee9b8351emr70183745ad.34.1784097556720;
        Tue, 14 Jul 2026 23:39:16 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccf9b78e3asm103867565ad.69.2026.07.14.23.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 23:39:16 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 14 Jul 2026 23:39:15 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v11 05/31] cxl/mem: Expose dynamic ram 1 partition in
 sysfs
Message-ID: <alcrEwf13LAqRhIm@AnisaLaptop.localdomain>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-6-anisa.su@samsung.com>
 <8f8bbe74-57a3-4059-93b6-bcc6ba6ddffd@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f8bbe74-57a3-4059-93b6-bcc6ba6ddffd@intel.com>

On Fri, Jun 26, 2026 at 04:08:33PM -0700, Dave Jiang wrote:
> 
> 
> On 6/25/26 4:04 AM, Anisa Su wrote:
> > From: Ira Weiny <iweiny@kernel.org>
> > 
> > To properly configure CXL regions user space will need to know the
> > details of the dynamic ram partition.
> > 
> > Expose the first dynamic ram partition through sysfs.
> > 
> > Signed-off-by: Ira Weiny <iweiny@kernel.org>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> 
> Just a spelling error below
> 
oopsie, fixed!

> > 
> > ---
> > Changes:
> > 1. Documentation: bump kernel version to 7.3 and date to June 2026
> > 2. Pick up Dave's reviewed-by tag
> > 3. Rename dynamic_ram_a to dynamic_ram_1
> > ---
> >  Documentation/ABI/testing/sysfs-bus-cxl | 24 +++++++++++
> >  drivers/cxl/core/memdev.c               | 57 +++++++++++++++++++++++++
> >  2 files changed, 81 insertions(+)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> > index 16a9b3d2e2c0..435495de409c 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-cxl
> > +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> > @@ -89,6 +89,30 @@ Description:
> >  		and there are platform specific performance related
> >  		side-effects that may result. First class-id is displayed.
> >  
> > +What:		/sys/bus/cxl/devices/memX/dynamic_ram_1/size
> > +Date:		June, 2026
> > +KernelVersion:	v7.3
> > +Contact:	linux-cxl@vger.kernel.org
> > +Description:
> > +		(RO) The first Dynamic RAM partition capacity as bytes.
> > +
> > +
> > +What:		/sys/bus/cxl/devices/memX/dynamic_ram_1/qos_class
> > +Date:		June, 2026
> > +KernelVersion:	v7.3
> > +Contact:	linux-cxl@vger.kernel.org
> > +Description:
> > +		(RO) For CXL host platforms that support "QoS Telemmetry"
> 
> Telemetry
> 
> DJ
> 
> > +		this attribute conveys a comma delimited list of platform
> > +		specific cookies that identifies a QoS performance class
> > +		for the partition of the CXL mem device. These
> > +		class-ids can be compared against a similar "qos_class"
> > +		published for a root decoder. While it is not required
> > +		that the endpoints map their local memory-class to a
> > +		matching platform class, mismatches are not recommended
> > +		and there are platform specific performance related
> > +		side-effects that may result. First class-id is displayed.
> > +
> >  
> >  What:		/sys/bus/cxl/devices/memX/serial
> >  Date:		January, 2022
> > diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> > index 71602820f896..20417db933aa 100644
> > --- a/drivers/cxl/core/memdev.c
> > +++ b/drivers/cxl/core/memdev.c
> > @@ -101,6 +101,19 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
> >  static struct device_attribute dev_attr_pmem_size =
> >  	__ATTR(size, 0444, pmem_size_show, NULL);
> >  
> > +static ssize_t dynamic_ram_1_size_show(struct device *dev, struct device_attribute *attr,
> > +			      char *buf)
> > +{
> > +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> > +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> > +	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_DYNAMIC_RAM_1);
> > +
> > +	return sysfs_emit(buf, "%#llx\n", len);
> > +}
> > +
> > +static struct device_attribute dev_attr_dynamic_ram_1_size =
> > +	__ATTR(size, 0444, dynamic_ram_1_size_show, NULL);
> > +
> >  static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
> >  			   char *buf)
> >  {
> > @@ -443,6 +456,25 @@ static struct attribute *cxl_memdev_pmem_attributes[] = {
> >  	NULL,
> >  };
> >  
> > +static ssize_t dynamic_ram_1_qos_class_show(struct device *dev,
> > +				   struct device_attribute *attr, char *buf)
> > +{
> > +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> > +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> > +
> > +	return sysfs_emit(buf, "%d\n",
> > +			  part_perf(cxlds, CXL_PARTMODE_DYNAMIC_RAM_1)->qos_class);
> > +}
> > +
> > +static struct device_attribute dev_attr_dynamic_ram_1_qos_class =
> > +	__ATTR(qos_class, 0444, dynamic_ram_1_qos_class_show, NULL);
> > +
> > +static struct attribute *cxl_memdev_dynamic_ram_1_attributes[] = {
> > +	&dev_attr_dynamic_ram_1_size.attr,
> > +	&dev_attr_dynamic_ram_1_qos_class.attr,
> > +	NULL,
> > +};
> > +
> >  static ssize_t ram_qos_class_show(struct device *dev,
> >  				  struct device_attribute *attr, char *buf)
> >  {
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
> > +
> > +	return a->mode;
> > +}
> > +
> > +static struct attribute_group cxl_memdev_dynamic_ram_1_attribute_group = {
> > +	.name = "dynamic_ram_1",
> > +	.attrs = cxl_memdev_dynamic_ram_1_attributes,
> > +	.is_visible = cxl_dynamic_ram_1_visible,
> > +};
> > +
> >  static umode_t cxl_memdev_security_visible(struct kobject *kobj,
> >  					   struct attribute *a, int n)
> >  {
> > @@ -547,6 +602,7 @@ static const struct attribute_group *cxl_memdev_attribute_groups[] = {
> >  	&cxl_memdev_attribute_group,
> >  	&cxl_memdev_ram_attribute_group,
> >  	&cxl_memdev_pmem_attribute_group,
> > +	&cxl_memdev_dynamic_ram_1_attribute_group,
> >  	&cxl_memdev_security_attribute_group,
> >  	NULL,
> >  };
> > @@ -555,6 +611,7 @@ void cxl_memdev_update_perf(struct cxl_memdev *cxlmd)
> >  {
> >  	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_ram_attribute_group);
> >  	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_pmem_attribute_group);
> > +	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_dynamic_ram_1_attribute_group);
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_memdev_update_perf, "CXL");
> >  
> 
