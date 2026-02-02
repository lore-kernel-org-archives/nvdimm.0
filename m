Received: from mail-qv1-f67.google.com (mail-qv1-f67.google.com [209.85.219.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C5429ACD7
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 17:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770054391; cv=none; b=apF+wh6vIFPReOxdPujo6Lurc2hH0IeJ5eNiq+7412FlWQMirdbT38CIwx4Akuyew6YsS5p+gDtbAbtKovQk5pLKulOkA8Lfv00O5r2u+dQLEyxU46H8mNL9AiQmHPXZke9XoGB6EG3srcW/d+DI9aD5MVTcIpv/D9doy7+Wzdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770054391; c=relaxed/simple;
	bh=gL8uCUJiJhHkiRNkyf53CfWI8RBSbR1NS4lJMuLRlY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCfC95/t7CWMVtsn8e0E5HFUkNz7x86EWKjvTqxAlD/fW7DN+XFz0LBCEPZWVif/EWuV2ouZcHLhWNMNlarDq7KzmpAoTHQw2fEsEnZI0wvidaWn5hAxNhN4cl0/PF6z/VfQ4YnxdwacvjictPrcS7+duOmku/F7iOcUE1Kl4WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=e/ScfBs6; arc=none smtp.client-ip=209.85.219.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="e/ScfBs6"
Received: by mail-qv1-f67.google.com with SMTP id 6a1803df08f44-88a35a00506so84580596d6.2
        for <nvdimm@lists.linux.dev>; Mon, 02 Feb 2026 09:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770054388; x=1770659188; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P1wm0NexTqa+iJZbv1CobgpMNsP/JgzOw/JXCIX3sf8=;
        b=e/ScfBs6Ea2MM9HSphyiUmGw6/XlE6MGCO2X857cHa5AECvZeUFGYTTyxJBra7NnAa
         0jAIXuTnRNfWKfmfRhzgxYDCqPf/rJRYLGmCBbC6Um7lkrYkpViVeblO78jWx+lq1i/j
         jyxUpydnRfK5bFd9AEvhOXKfv4qvyOj5CSmnk4JBuhuKB4dhyf637nWUTkTJ8dwoPkK8
         CeAeGF4wp6xfsJH6oDu0In9lrRUUdZYmJ2K/HaZUb9PbpLMHcU4Czwv1FXyDYUjQucNl
         ZWflLLTDXPxq8M15OSfPVR/dJnLTVkdlG3FyHqu+qPIrg9OxpkPRw1SPrEdFUUnwIw4j
         Q/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770054388; x=1770659188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P1wm0NexTqa+iJZbv1CobgpMNsP/JgzOw/JXCIX3sf8=;
        b=EWYWDEbfC/9qCfii7l3h4ehlX4TRH5sRmH7PYiPrlQnvHOrCNjRlFY9L1YK4/ahB7M
         gpmvxtIDzJJK5J/nanoAlMYtNq7WEr1NbZE36K1F1yS212sfhBME0Ns7B1LOQXQzYAcl
         B0g4jVAN87zSiTh5IzCt0UdxPKsCGJRzqffnA3OFUiriKWZs50oExGsdeyDL1kwGt4pl
         FAqFdNbGnnouZyEdgPrPgSeeHFOBGnkLU7PkPAwOrAVNVrJSM9Va8xAiUufgvrNlgcOl
         uCnUaDq2sY6oI8MMSt11zUn0HORrY1wMeeEBg0JX/2So1i2/l2NFOfGfWAyfCfHlKQVx
         Bx2Q==
X-Forwarded-Encrypted: i=1; AJvYcCW5/B/9bheayTwVtXO2SK4Sf5JSmLdwmK2J5nl0/izvr2FurWcMRgfT8VdB/T/N6rKf6sz4yOE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPMF9FeQl7LxCZLMLxVQ9hLylptc+6Y2v50GfkPyWN143X9rsa
	OvZLrHYZRBVgIeV63Cj+Qg+7koHtXCwiIvaTLPoRcsRjoUrjS1BR1BlUmsBogiYMbmY=
X-Gm-Gg: AZuq6aLYZlWV7vwagmj829xGaNDLp8ZNrtpFyQaOyZbLbMyUHE22FqVLLX1IqmVsVnr
	lqfH8n4e7GDSBIvx2h3GK9mojh0vxLtyIaAj5qJg1AoKKm+Uk5MjFkfPuSCVL1vBLnJQKdeENn8
	8BDAPFlZETuiiny1gP7fo/P7woCc8V+s0NhvTbz2UFtHFKPchm+X5EB3RHNHuo9+2FtYsKQRikO
	7jUIPqBWxJZFHrHPAypK5koAmzQJwL6eUy766TsDtGeQ+8J5/sbCoOHTGACELtfvE8PdmLoJBA0
	9txsmoEI6BByy8Ucp07ZVGyiyN/HPO1zrdVQQZvvNrSgkAVEs8xbyPvH8bvlOae3hg+pdSVNUvR
	mLGfiPdWXhhHAsbFUJk9IsnJyJqx0pYp76M1A+UvFQ0sycb20GbtMa3bW6hDY0c+4UMepvotBsb
	9FLvgBnOeKcuXgMtY59ZmTKrhB0im2MtlJcf8T38PwNBwDZdKqzRrTQOfeCMamnqQdkm5TzEwJv
	62R/SNY
X-Received: by 2002:a05:6214:c8f:b0:888:4930:82aa with SMTP id 6a1803df08f44-894ea166512mr179211126d6.70.1770054387847;
        Mon, 02 Feb 2026 09:46:27 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d47e13sm1267680485a.45.2026.02.02.09.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 09:46:27 -0800 (PST)
Date: Mon, 2 Feb 2026 12:46:25 -0500
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	terry.bowman@amd.com, john@jagalactic.com,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH 1/9] mm/memory_hotplug: pass online_type to
 online_memory_block() via arg
Message-ID: <aYDi8bhxFnvMWl11@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-2-gourry@gourry.net>
 <20260202171029.00005e80@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202171029.00005e80@huawei.com>

On Mon, Feb 02, 2026 at 05:10:29PM +0000, Jonathan Cameron wrote:
> On Thu, 29 Jan 2026 16:04:34 -0500
> Gregory Price <gourry@gourry.net> wrote:
> 
> > Modify online_memory_block() to accept the online type through its arg
> > parameter rather than calling mhp_get_default_online_type() internally.
> > This prepares for allowing callers to specify explicit online types.
> > 
> > Update the caller in add_memory_resource() to pass the default online
> > type via a local variable.
> > 
> > No functional change.
> > 
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> 
> Trivial comment inline. I don't really care either way.
> Pushing the policy up to the caller and ensuring it's explicitly constant
> for all the memory blocks (as opposed to relying on locks) seems sensible to me
> even without anything else.
> 
> >  
> >  	/* online pages if requested */
> > -	if (mhp_get_default_online_type() != MMOP_OFFLINE)
> > -		walk_memory_blocks(start, size, NULL, online_memory_block);
> > +	if (mhp_get_default_online_type() != MMOP_OFFLINE) {
> > +		int online_type = mhp_get_default_online_type();
> 
> Maybe move the local variable outside the loop to avoid the double call.
> 

ack.  will update for next version w/ Ben's notes and the build fix.

Thanks!
~Gregory
