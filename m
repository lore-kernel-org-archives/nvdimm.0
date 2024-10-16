Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5AE20F5A2
	for <nvdimm@lists.linux.dev>; Wed, 16 Oct 2024 15:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729094062; cv=none; b=Q3d67FggDWXDsjw25J7TMAmru+Pgj+9WDSb+w2swF6TB25AQRrY1OkBIZ+Aw9BJsAqIn78o6BP7HrN/TWUmnJS1bL1kG8scIQlFljpHVkph4Uj2FeHJM1yCzTjBrjD8/JL1XSm4oDwIpUHPrs4Nec0V7uQ0sJ8zcigD66qdE4KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729094062; c=relaxed/simple;
	bh=f2YcMYHqbgPbm0iLj6I8A56c/wgX1Rur/7jRD2+2v78=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NMfTXjPXhKXcMmYMDkIweUTba1VAjIeUBqVCWtbdCEfml4+buFurb58/6lIruWVKD183cgiIQedAjlmGrYuyTodrqZjTPx5qa7lzcULxbAszUdaSvredVm5GWOkXA0/I35kqlVvs1CTBcpC1X8+m2zBTTtKuaTadch2ttLaO+Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XTFlb3RC9z6D9BH;
	Wed, 16 Oct 2024 23:49:47 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id A09101400DD;
	Wed, 16 Oct 2024 23:54:17 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 16 Oct
 2024 17:54:16 +0200
Date: Wed, 16 Oct 2024 16:54:15 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Alison Schofield"
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-btrfs@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, "Li, Ming" <ming4.li@intel.com>, "Gustavo A .
 R . Silva" <gustavoars@kernel.org>, "Kees Cook" <kees@kernel.org>
Subject: Re: [PATCH v4 08/28] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <20241016165415.00002bad@Huawei.com>
In-Reply-To: <670c6037718f_9710f294d0@iweiny-mobl.notmuch>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
	<20241007-dcd-type2-upstream-v4-8-c261ee6eeded@intel.com>
	<20241009134936.00003e0e@Huawei.com>
	<670c6037718f_9710f294d0@iweiny-mobl.notmuch>
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
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Sun, 13 Oct 2024 19:05:11 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> Jonathan Cameron wrote:
> > On Mon, 07 Oct 2024 18:16:14 -0500
> > ira.weiny@intel.com wrote:
> >   
> > > From: Navneet Singh <navneet.singh@intel.com>
> > > 
> > > Devices which optionally support Dynamic Capacity (DC) are configured
> > > via mailbox commands.  CXL 3.1 requires the host to issue the Get DC
> > > Configuration command in order to properly configure DCDs.  Without the
> > > Get DC Configuration command DCD can't be supported.
> > > 
> > > Implement the DC mailbox commands as specified in CXL 3.1 section
> > > 8.2.9.9.9 (opcodes 48XXh) to read and store the DCD configuration
> > > information.  Disable DCD if DCD is not supported.  Leverage the Get DC
> > > Configuration command supported bit to indicate if DCD support.
> > > 
> > > Linux has no use for the trailing fields of the Get Dynamic Capacity
> > > Configuration Output Payload (Total number of supported extents, number
> > > of available extents, total number of supported tags, and number of
> > > available tags). Avoid defining those fields to use the more useful
> > > dynamic C array.
> > > 
> > > Cc: "Li, Ming" <ming4.li@intel.com>
> > > Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> > > Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>  
> > 
> > Looks fine to me.  Trivial comment inline  
> 
> Thanks.
> 
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > 
> > 
> >   
> > > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > > index e8907c403edb..0690b917b1e0 100644
> > > --- a/drivers/cxl/cxlmem.h
> > > +++ b/drivers/cxl/cxlmem.h  
> > ...
> >   
> > > +/* See CXL 3.1 Table 8-164 get dynamic capacity config Output Payload */
> > > +struct cxl_mbox_get_dc_config_out {
> > > +	u8 avail_region_count;
> > > +	u8 regions_returned;
> > > +	u8 rsvd[6];
> > > +	/* See CXL 3.1 Table 8-165 */
> > > +	struct cxl_dc_region_config {
> > > +		__le64 region_base;
> > > +		__le64 region_decode_length;
> > > +		__le64 region_length;
> > > +		__le64 region_block_size;
> > > +		__le32 region_dsmad_handle;
> > > +		u8 flags;
> > > +		u8 rsvd[3];
> > > +	} __packed region[];  
> > 
> > Could throw in a __counted_by I think?  
> 
> I was not sure if this would work considering this is coming from the hardware.
> From what I have read I think it will but only because the region count can't
> be byte swapped.

__counted_by_le() deals potentially larger values by just making
the __counted_by go away on big endian architectures.


> 
> Is this something we want to do with structs coming from hardware when we can?

I think we still do.  Gustavo, Kees?
> Ira
> 

