Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB57A19C569
	for <nvdimm@lists.linux.dev>; Fri,  1 Nov 2024 12:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730462886; cv=none; b=KyfsJ+F14V6RGBkznkv3pMpX9QBSdIFxKgsBsMO44rRm4RdaIrPxn4GK/kuEjycus0+g/L8eE71BbP421RVSnczFjXh2YNUbxWnrKGHa9m57nwVeEBnfe1jfU15LJVTqROMTUd24u/dui78581tzfEuXOQbsg6hREOg5jOms6R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730462886; c=relaxed/simple;
	bh=/4kZC+ZCOEXnxMgCCkREutWG+jRk6O0PFIWcBSF/p8g=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wcr4WItb/CbT4jWidsAhebKro2YNYZnWZW+goPlZXOvtMqo9QwshStIViKT/v2y2UFJDG1u1FU/5m5IsXzolSOHbXVh0RBRMaAii2i8Q6rBmNE8wj+sNycT0Pn/e1TfHg6X0+oSTwWo55aWGQwYn0cv6hr9mL1ysKFIUWg4x7TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Xfzyc6hTmz6LD4F;
	Fri,  1 Nov 2024 20:03:04 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id E957B140B3C;
	Fri,  1 Nov 2024 20:07:58 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 1 Nov
 2024 13:07:58 +0100
Date: Fri, 1 Nov 2024 12:07:56 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Alison Schofield"
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 20/27] cxl/extent: Process DCD events and realize
 region extents
Message-ID: <20241101120756.00002abe@Huawei.com>
In-Reply-To: <672260877ccb7_483142942f@iweiny-mobl.notmuch>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
	<20241029-dcd-type2-upstream-v5-20-8739cb67c374@intel.com>
	<20241030143232.000013b8@Huawei.com>
	<672260877ccb7_483142942f@iweiny-mobl.notmuch>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 frapeml500008.china.huawei.com (7.182.85.71)


> 
> > > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > > index 16e06b59d7f04762ca73a81740b0d6b2487301af..85b30a74a6fa5de1dd99c08c8318edd204e3e19d 100644
> > > --- a/drivers/cxl/cxlmem.h
> > > +++ b/drivers/cxl/cxlmem.h  
> > 
> > Is the xarray header included in here already?
> > If not it should be.  
> 
> Looking around we have been lax in this behavior.  cxl.h does not explicitly
> include xarray.h either.  I agree they both should after this.
> 
> Let me send a follow on patch to add it.

Works for me.

J
> 
> Ira
> 
> >   
> > > @@ -506,6 +506,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
> > >   * @pmem_perf: performance data entry matched to PMEM partition
> > >   * @nr_dc_region: number of DC regions implemented in the memory device
> > >   * @dc_region: array containing info about the DC regions  
> 
> 
> 

