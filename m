Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB06E33D510
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 12:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765973275; cv=none; b=GBIK9G0EcgHF7Gz/FtxbJBcHG5Y9tvPAlZsKK2ameXLrqllKksHu6N2WbNsjdzMpA+hsKycHJJDzRwSUPWvfy3VsIQbfbCjUBnWNFioeX+kWovFPMKtfojTy7YSw5jPDfjrPjkO/pgIhtIr079W6ARnHM0MDzVdUxeEHToaPIu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765973275; c=relaxed/simple;
	bh=SB6bVlxIdKN3Jilw0/lGuiOTBaycEjpGHXmweO3ggbA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qz/hdZ3o3BAuS7jlw4Uo8g/4uiGkDuXtAGrDKJGjZc2o2wU61z8RTIda0w+EX0XTYc6w7XrUU7ghn2abGroz1Sb3q4c/cT/xKqkUtcwGLn2qP6YCc6u78O8oXJ0ZJrnDmY3B3h2Js8iAQobYEcaV1TJYSUFeeSE44hswtW3/Lqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dWXbs59nkzJ46Cy;
	Wed, 17 Dec 2025 20:07:21 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 09CB740565;
	Wed, 17 Dec 2025 20:07:51 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 17 Dec
 2025 12:07:49 +0000
Date: Wed, 17 Dec 2025 12:07:48 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dan
 Williams <dan.j.williams@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Matthew Wilcox" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Ying
 Huang <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>,
	"Nathan Fontenot" <nathan.fontenot@amd.com>, Terry Bowman
	<terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Zhijian Li <lizhijian@fujitsu.com>, "Borislav
 Petkov" <bp@alien8.de>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 3/9] dax/hmem: Gate Soft Reserved deferral on
 DEV_DAX_CXL
Message-ID: <20251217120748.0000581e@huawei.com>
In-Reply-To: <f35d86cd-03f8-4e0b-8373-8d8e749aaa8e@intel.com>
References: <20251120031925.87762-1-Smita.KoralahalliChannabasappa@amd.com>
	<20251120031925.87762-4-Smita.KoralahalliChannabasappa@amd.com>
	<f35d86cd-03f8-4e0b-8373-8d8e749aaa8e@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Tue, 2 Dec 2025 16:32:24 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> On 11/19/25 8:19 PM, Smita Koralahalli wrote:
> > From: Dan Williams <dan.j.williams@intel.com>
> > 
> > Replace IS_ENABLED(CONFIG_CXL_REGION) with IS_ENABLED(CONFIG_DEV_DAX_CXL)
> > so that HMEM only defers Soft Reserved ranges when CXL DAX support is
> > enabled. This makes the coordination between HMEM and the CXL stack more
> > precise and prevents deferral in unrelated CXL configurations.
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>  
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>> ---

Something odd happened with that tag from Dave so that might need manual
application if you use b4 or similar.

This seems sensible to me.
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


> >  drivers/dax/hmem/hmem.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> > index 02e79c7adf75..c2c110b194e5 100644
> > --- a/drivers/dax/hmem/hmem.c
> > +++ b/drivers/dax/hmem/hmem.c
> > @@ -66,7 +66,7 @@ static int hmem_register_device(struct device *host, int target_nid,
> >  	long id;
> >  	int rc;
> >  
> > -	if (IS_ENABLED(CONFIG_CXL_REGION) &&
> > +	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
> >  	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
> >  			      IORES_DESC_CXL) != REGION_DISJOINT) {
> >  		dev_dbg(host, "deferring range to CXL: %pr\n", res);  
> 
> 

