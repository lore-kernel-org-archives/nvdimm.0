Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8F01DDC1E
	for <nvdimm@lists.linux.dev>; Thu, 16 Jan 2025 10:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737023537; cv=none; b=tDWXH5j8rH3I/NWF1LjSpPfpX88yls/DrV/vU3Aed6Vg7TjTNCo9JYiLKJgIgck63hrzc2NiZvU5+WKrfCW6weEPF+Iti+bkWUUCbiY16fqW1fe9WD7fvOF2dvY8CbBZEhzbh7nH7qkjYvfa4GcJrmzhFKFTCztZXqJckGzBjEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737023537; c=relaxed/simple;
	bh=JrxqlXeV+1EMrKAwWg2I5zva3xkZUNbBW8jB4JaHh28=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OKcrrmLuD8eeb4g8hX52cfG8yXEVz8GF56K6XKKA765PvGGgULgMxraFEnCvpYA7THDIfSCkuReOZbI/m3HfpNU4E43edyR5bWMVQtFaFpeo5fOIUPkanKJmBTewSgldwBb22BKepaO2HLm3NVGNE14tyPBoHDYxOnwQKXScCEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YYfJb5yM2z6M4HV;
	Thu, 16 Jan 2025 18:30:23 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 4A858140393;
	Thu, 16 Jan 2025 18:32:10 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 16 Jan
 2025 11:32:09 +0100
Date: Thu, 16 Jan 2025 10:32:07 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Fan
 Ni" <fan.ni@samsung.com>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton
	<akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, "Gustavo A. R.
 Silva" <gustavoars@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>, Li Ming
	<ming.li@zohomail.com>
Subject: Re: [PATCH v8 02/21] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <20250116103207.00005461@huawei.com>
In-Reply-To: <678837fcc0ed_20f3294fb@dwillia2-xfh.jf.intel.com.notmuch>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
	<20241210-dcd-type2-upstream-v8-2-812852504400@intel.com>
	<67871f05cd767_20f32947f@dwillia2-xfh.jf.intel.com.notmuch>
	<67881b606ca4e_1aa45f2948b@iweiny-mobl.notmuch>
	<678837fcc0ed_20f3294fb@dwillia2-xfh.jf.intel.com.notmuch>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Wed, 15 Jan 2025 14:34:36 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> Ira Weiny wrote:
> > Dan Williams wrote:  
> > > Ira Weiny wrote:  
> > 
> > [snip]
> >   
> > > > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > > > index e8907c403edbd83c8a36b8d013c6bc3391207ee6..05a0718aea73b3b2a02c608bae198eac7c462523 100644
> > > > --- a/drivers/cxl/cxlmem.h
> > > > +++ b/drivers/cxl/cxlmem.h
> > > > @@ -403,6 +403,7 @@ enum cxl_devtype {
> > > >  	CXL_DEVTYPE_CLASSMEM,
> > > >  };
> > > >  
> > > > +#define CXL_MAX_DC_REGION 8  
> > > 
> > > Please no, lets not sign up to have the "which cxl 'region' concept are
> > > you referring to?" debate in perpetuity. "DPA partition", "DPA
> > > resource", "DPA capacity" anything but "region".
> > >   
> > 
> > I'm inclined to agree with Alejandro on this one.  I've walked this
> > tightrope quite a bit with this series.  But there are other places where
> > we have chosen to change the verbiage from the spec and it has made it
> > difficult for new comers to correlate the spec with the code.
> > 
> > So I like Alejandro's idea of adding "HW" to the name to indicate that we
> > are talking about a spec or hardware defined thing.  
> 
> See below, the only people that could potentially be bothered by the
> lack of spec terminology matching are the very same people that are
> sophisticated enough to have read the spec to know its a problem.

It's confusing me.  :)  I know the confusion source exists but
that doesn't mean I remember how all the terms match up.

> 
> > 
> > That said I am open to changing some names where it is clear it is a
> > software structure.  I'll audit the series for that.
> >   
> > > >  	u64 serial;
> > > >  	enum cxl_devtype type;
> > > >  	struct cxl_mailbox cxl_mbox;
> > > >  };
> > > >  
> > > > +#define CXL_DC_REGION_STRLEN 8
> > > > +struct cxl_dc_region_info {
> > > > +	u64 base;
> > > > +	u64 decode_len;
> > > > +	u64 len;  
> > > 
> > > Duplicating partition information in multiple places, like
> > > mds->dc_region[X].base and cxlds->dc_res[X].start, feels like an
> > > RFC-quality decision for expediency that needs to reconciled on the way
> > > to upstream.  
> > 
> > I think this was done to follow a pattern of the mds being passed around
> > rather than creating resources right when partitions are read.
> > 
> > Furthermore this stands to hold this information in CPU endianess rather
> > than holding an array of region info coming from the hardware.  
> 
> Yes, the ask is translate all of this into common information that lives
> at the cxl_dev_state level.
> 
> > 
> > Let see how other changes fall out before I go hacking this though.
> >   
> > >   
> > > > +	u64 blk_size;
> > > > +	u32 dsmad_handle;
> > > > +	u8 flags;
> > > > +	u8 name[CXL_DC_REGION_STRLEN];  
> > > 
> > > No, lets not entertain:
> > > 
> > >     printk("%s\n", mds->dc_region[index].name);
> > > 
> > > ...when:
> > > 
> > >     printk("dc%d\n", index);
> > > 
> > > ...will do.  
> > 
> > Actually these buffers provide a buffer for the (struct
> > resource)dc_res[x].name pointers to point to.  
> 
> I missed that specific detail, but I still challenge whether this
> precision is needed especially since it makes the data structure
> messier. Given these names are for debug only and multi-partition DCD
> devices seem unlikely to ever exist, just use a static shared name for
> adding to ->dpa_res.

Given the read only shared concept relies on multiple hardware dc regions
(I think they map to partitions) then we are very likely to see
multiples.  (maybe I'm lost in terminology as well).


...

> > > 
> > > Linux is not obligated to follow the questionable naming decisions of
> > > specifications.  
> > 
> > We are not.  But as Alejandro says it can be confusing if we don't make
> > some association to the spec.
> > 
> > What do you think about the HW/SW line I propose above?  
> 
> Rename to cxl_dc_partition_info and drop the region_ prefixes, sure.
> 
> Otherwise, for this init-time only concern I would much rather deal with
> the confusion of:
> 
> "why does Linux call this partition when the spec calls it region?":
> which only trips up people that already know the difference because they read the
> spec. In that case the comment will answer their confusion.
> 
> ...versus:
> 
> "why are there multiple region concepts in the CXL subsystem": which
> trips up everyone that greps through the CXL subsystem especially those
> that have no intention of ever reading the spec.

versus one time rename of all internal infrastructure to align to the spec
and only keep the confusion at the boundaries where we have ABI.

Horrible option but how often are those diving in the code that bothered
about the userspace /kernel interaction terminology?

Anyhow, they are all horrible choices.

Jonathan

> 

