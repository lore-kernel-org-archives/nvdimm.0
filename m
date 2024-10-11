Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E3E1C9EAC
	for <nvdimm@lists.linux.dev>; Fri, 11 Oct 2024 19:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728674092; cv=none; b=RK8+i7v74pd1I05TjevO0sJygNCvMMRieHjzHdi7abwbyhTVYkrHfn21D+1XdSEjt6cV94WzhxIYlcr6Es82hu2wSmac0jjL1bMQ+xbdupVejzIJ7uUXYlu5VxfspDRkp/cgW7HzPqSpgIS6+zUsQ7YX2mQ/39XE+ZU7r4dc8Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728674092; c=relaxed/simple;
	bh=aQRSA1yeJHJ4TV/I8uMqgU5sOulw5Aa610ReT/Pi0PE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h+Fncn5q9R9CyfmoHa36VwXfo4skzKs/xI3vfMELOb9BwS7SuykN1T4d3GR2aThSNLxP7Afz6T99QEt8zxKpC3775iGNMWjuzYUaRLhwYmW6EjtVrbm/VryzZ5R8Ws9zfTbmxW2p1VIx0h6giD2rWffPF+HwxEfVY1qS2ti7nbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NyKr2cPA; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NyKr2cPA"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-71e427e29c7so491575b3a.3
        for <nvdimm@lists.linux.dev>; Fri, 11 Oct 2024 12:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728674090; x=1729278890; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9RwrXc2bfBcpRHPltvXo1MSSyTQE/O8f245siaXgKRY=;
        b=NyKr2cPAYBSMxsW0vZeDehohSZpB+UQ+IvZuY52VNTWm5n0XITMJn4zaW8wTkQo7KS
         NJXOhjJavV6nXWjn/sIiE5OVbE0vo92UgQjZyyYLM8/7N+SfGyxwhdGj1ElqIgn9xOFK
         HpJ2jrYY5thRw0BceMQAcrVjlYrMksHsTtJwFsU8EpLztLYjdCSZH32IlamXGvBLxPTR
         u7NE9Kr+5QBpT39kWlCHxdeFiT19SIeU/cI5qQDH+ZvXQqdIj2eDLStzq8Xm4Q48PMlW
         f+DE8D12hVguJcvOY3C7gNxUFXPYQpQ3IiUuT9C49j+dsbmsauv9EO0f6n5FFG2SlzRC
         lFsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728674090; x=1729278890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9RwrXc2bfBcpRHPltvXo1MSSyTQE/O8f245siaXgKRY=;
        b=jNTBd/AqbuVzOON8xdL9d/rm8i7uSFwlPcr6XkeHJp+nCGDUm8ZC/scWppaUEEh/rG
         y8J1735FqumWf/I5Dxqwj1DzXOXUMadHuCeTMda1mSWrp8d1fMOTU3C5lSxBiAAXTX/r
         p7gKY4y5LrP13JSu4VD4p++4SjU4pZ6vPOg6qMITj0P/j51fEJh5Tw83SG6pIVuQdLQf
         B4WiQZSMCll36YBXelVY5TkFOVVpLKm1KtxI5WS4BLMFvU0mymof6szTeidGJS4vFYUD
         ihSGuFkyulhSDzqCqmH4MQA20eb9vhrSuGbLd/pg4jAW3xCKDzYdsayABYC/TI+8fHMa
         CzVg==
X-Forwarded-Encrypted: i=1; AJvYcCVdmpKsfDKzDtI8wAkKHdeQ6J7H9UBI165QurIYxMIxPIYhR4bbSk6FOkv9n8/rkmIVunRlJ6U=@lists.linux.dev
X-Gm-Message-State: AOJu0YyH9DY5zGG+4Ok76GDfdfBF506c66oO58wtL49UC0K7vGFbT0cX
	Waj6VCpQcEqwD+GRj9hKr80vmcs0M8BR+23fQmgxAV1tJlTzvD0o
X-Google-Smtp-Source: AGHT+IGVCV+SFYfjW4RcGOZJynL6OplbrhtCwww1MFkvESFVXDS6nOzvMGaek+UcLI4OxxU65Gaiug==
X-Received: by 2002:aa7:8890:0:b0:71d:e93e:f542 with SMTP id d2e1a72fcca58-71e4c1cfdffmr870472b3a.21.1728674089661;
        Fri, 11 Oct 2024 12:14:49 -0700 (PDT)
Received: from fan ([2601:646:8f03:9fee:fa84:fdda:e412:45e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e48e54f46sm643539b3a.57.2024.10.11.12.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 12:14:49 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Fri, 11 Oct 2024 12:14:26 -0700
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Ira Weiny <ira.weiny@intel.com>, "Li, Ming4" <ming4.li@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 21/28] cxl/extent: Process DCD events and realize
 region extents
Message-ID: <Zwl5Esr7uV8EpxMP@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-21-c261ee6eeded@intel.com>
 <4337ddd9-312b-4fb7-9597-81e8b00d57cb@intel.com>
 <6706de3530f5c_40429294b8@iweiny-mobl.notmuch>
 <20241010155014.00004bdd@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010155014.00004bdd@Huawei.com>

On Thu, Oct 10, 2024 at 03:50:14PM +0100, Jonathan Cameron wrote:
> On Wed, 9 Oct 2024 14:49:09 -0500
> Ira Weiny <ira.weiny@intel.com> wrote:
> 
> > Li, Ming4 wrote:
> > > On 10/8/2024 7:16 AM, ira.weiny@intel.com wrote:  
> > > > From: Navneet Singh <navneet.singh@intel.com>
> > > >  
> > 
> > [snip]
> > 
> > > >
> > > > Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> > > > Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> > > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > > >  
> > > Hi Ira,
> > > 
> > > I guess you missed my comments for V3, I comment it again for this patch.  
> > 
> > Apologies.  Yes I totally missed your reply.  :-(
> > 
> > >   
> > > > +static bool extents_contain(struct cxl_dax_region *cxlr_dax,
> > > > +			    struct cxl_endpoint_decoder *cxled,
> > > > +			    struct range *new_range)
> > > > +{
> > > > +	struct device *extent_device;
> > > > +	struct match_data md = {
> > > > +		.cxled = cxled,
> > > > +		.new_range = new_range,
> > > > +	};
> > > > +
> > > > +	extent_device = device_find_child(&cxlr_dax->dev, &md, match_contains);
> > > > +	if (!extent_device)
> > > > +		return false;
> > > > +
> > > > +	put_device(extent_device);  
> > > could use __free(put_device) to drop this 'put_device(extent_device)'  
> > 
> > Yep.
> > 
> > > > +	return true;
> > > > +}  
> > > [...]  
> > > > +static bool extents_overlap(struct cxl_dax_region *cxlr_dax,
> > > > +			    struct cxl_endpoint_decoder *cxled,
> > > > +			    struct range *new_range)
> > > > +{
> > > > +	struct device *extent_device;
> > > > +	struct match_data md = {
> > > > +		.cxled = cxled,
> > > > +		.new_range = new_range,
> > > > +	};
> > > > +
> > > > +	extent_device = device_find_child(&cxlr_dax->dev, &md, match_overlaps);
> > > > +	if (!extent_device)
> > > > +		return false;
> > > > +
> > > > +	put_device(extent_device);  
> > > Same as above.  
> > 
> > Done.
> > 
> > > > +	return true;
> > > > +}
> > > > +  
> > > [...]  
> > > > +static int cxl_send_dc_response(struct cxl_memdev_state *mds, int opcode,
> > > > +				struct xarray *extent_array, int cnt)
> > > > +{
> > > > +	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> > > > +	struct cxl_mbox_dc_response *p;
> > > > +	struct cxl_mbox_cmd mbox_cmd;
> > > > +	struct cxl_extent *extent;
> > > > +	unsigned long index;
> > > > +	u32 pl_index;
> > > > +	int rc;
> > > > +
> > > > +	size_t pl_size = struct_size(p, extent_list, cnt);
> > > > +	u32 max_extents = cnt;
> > > > +
> > > > +	/* May have to use more bit on response. */
> > > > +	if (pl_size > cxl_mbox->payload_size) {
> > > > +		max_extents = (cxl_mbox->payload_size - sizeof(*p)) /
> > > > +			      sizeof(struct updated_extent_list);
> > > > +		pl_size = struct_size(p, extent_list, max_extents);
> > > > +	}
> > > > +
> > > > +	struct cxl_mbox_dc_response *response __free(kfree) =
> > > > +						kzalloc(pl_size, GFP_KERNEL);
> > > > +	if (!response)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	pl_index = 0;
> > > > +	xa_for_each(extent_array, index, extent) {
> > > > +
> > > > +		response->extent_list[pl_index].dpa_start = extent->start_dpa;
> > > > +		response->extent_list[pl_index].length = extent->length;
> > > > +		pl_index++;
> > > > +		response->extent_list_size = cpu_to_le32(pl_index);
> > > > +
> > > > +		if (pl_index == max_extents) {
> > > > +			mbox_cmd = (struct cxl_mbox_cmd) {
> > > > +				.opcode = opcode,
> > > > +				.size_in = struct_size(response, extent_list,
> > > > +						       pl_index),
> > > > +				.payload_in = response,
> > > > +			};
> > > > +
> > > > +			response->flags = 0;
> > > > +			if (pl_index < cnt)
> > > > +				response->flags &= CXL_DCD_EVENT_MORE;  
> > > 
> > > It should be 'response->flags |= CXL_DCD_EVENT_MORE' here.  
> > 
> > Ah yea.  Good catch.
> > 
> > > 
> > > Another issue is if 'cnt' is N times bigger than 'max_extents'(e,g. cnt=20, max_extents=10). all responses will be sent in this xa_for_each(), and CXL_DCD_EVENT_MORE will be set in the last response but it should not be set in these cases.
> > >   
> > 
> > Ah yes.  cnt must be decremented.  As I looked at the patch just now the
> > 
> > 	if (cnt == 0 || pl_index)
> > 
> > ... seemed very wrong to me.  That change masked this bug.
> > 
> > This should fix it:
> > 
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index d66beec687a0..99200274dea8 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -1119,10 +1119,11 @@ static int cxl_send_dc_response(struct cxl_memdev_state *mds, int opcode,
> >                         if (rc)
> >                                 return rc;
> >                         pl_index = 0;
> > +                       cnt -= pl_index;
> >                 }
> >         }
> >  
> > -       if (cnt == 0 || pl_index) {
> 
> I thought this cnt == 0 check was to deal with the no valid
> extents case where an empty reply is needed.

Agreed. Based on current code logic, there are two cases that cnt == 0:
1. no extent is accepted so cnt is passed as 0;
2. cnt was decreased to 0 and response has already been sent.

For case 1, we still need to send a response with zero extents;
For case 2, we do not need to handle.

Fan

> 
> 
> > +       if (pl_index) {
> >                 mbox_cmd = (struct cxl_mbox_cmd) {
> >                         .opcode = opcode,
> >                         .size_in = struct_size(response, extent_list,
> > 
> > 
> > Thank you, and sorry again for missing your feedback.
> > 
> > Ira
> > 
> > [snip]
> > 
> 

-- 
Fan Ni
