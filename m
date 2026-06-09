Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6991A47DFA3
	for <nvdimm@lists.linux.dev>; Tue,  9 Jun 2026 15:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781019351; cv=none; b=MJGeUDJQ5hd+nBijv+B5fBwr4lV4HcK7juG2tERDmIFdBX59jjrT05tVfLUIW2VfiZlR3MRSg4ZQM2DKaKctusebuLgKQDfi9rastldqiN7q3+NQ3ihVgkmOWb9bxZIgrz8+DD7FCgDVx06hZ+Ol4Ro3cDt/hkiK8p347rjU8nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781019351; c=relaxed/simple;
	bh=/TgtOuaONvsUnR+aXOPnuRF8ZAqdZP8tr7TwdKuIOt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rrVEKByVy+j78rmMmjv3JynhfHJkTXzTpuGoXBY7j1MDcq/ZSo2UtfTs9LqQKqG3jDz+KDTSAFYOU7Iulcu6+yMEHMVwlYoeaC6gZc6naMDNJg+0oUXnesbL3+v+pzfEECWXH5JYRbpM2y8jdOktYfKCAvVVLbhvh+20U+mxpbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=YusbviOq; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="YusbviOq"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8ccedaf0b54so37499516d6.0
        for <nvdimm@lists.linux.dev>; Tue, 09 Jun 2026 08:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781019349; x=1781624149; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fMNVrJ+zylUZaoWsNGMkq8FYpb2q8Its7Sc70f0OoMM=;
        b=YusbviOqK2NNZgB9eiBamM8EYDC5NnTci5SVtRehvriLJ65PTSPxTHPEyqE+lKYMg0
         h2avipmx05C/LDwwintWswIUeAQu/FUcRWWdIcGbznlKEmiPmY4FknB7JR1z2bBzuoz1
         ex8FHNPtXt5oJZnANCptPwaF00Na1kb5XuOm3+GVZiD3N0N3OmCAgBtnrvSbfkjU/XfL
         yS53yDtE4+9y42dCgBw0sloxHFYCtjY9kJ1NRpDYEuGgxxa9kwgI0MvfM1d1D33ytOxP
         EWuPDi0zIyxYYpOpeLS5A/S5l6ePwHOXDFTJjlkkcIS0L1L9cNtHJOtBYCjyhW8RZy6a
         MO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781019349; x=1781624149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fMNVrJ+zylUZaoWsNGMkq8FYpb2q8Its7Sc70f0OoMM=;
        b=qmkVzcyTKQS+SsiA9hWFcIPtslJXwUzT7V6cgBOMo9frF2SKT++vzERP8lUaX7Rh80
         Ki7P3q5mhu/sAH/wwyFC1qTn4OhVXInFGDTMTBYKOVhDfutgnlCFXzl2MHcW6+lVHL01
         5M+GIarX4/1GkdyeEYEe67G+kl0pKRXM7xKY25NOe6GqQ8snaPXvyvvUFqyzbdTztcHG
         IPw4/qPhS6feA23qZLJ6B1yLCdFgbDp06x3m8v2/SI0pMKQ/BrYIIN40DSVMDwVS8fDl
         sBP6WxrC1jafT/nmSFhVBlg1MVw5FTNqxlfUO/N/GZydI+toEBK0kMnEnlTRD3GPlipR
         VXqw==
X-Forwarded-Encrypted: i=1; AFNElJ/k7TGo6JoxaN9Eq2sNkahq7GHqgynU0ns5fYB3Kgvo5azeBIlUcftuilcaS9ZVsBz89VDawQw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzADWovCI95pZ+1cyYEmq5Fw5fYAJV3Z5JGcrjlIUCba/2JbWj3
	gf7Tb3vXvdw0ucfqUuPOA9rmQH16Y0EW06oqbPfTlN6Xv5VBXDkvWYIy41XsUH6KSOI=
X-Gm-Gg: Acq92OHLx7GQg5x5z80eOXBt1SSO9IYWAU3z9o63aDQSuKV7VU+E6Vg1bKeB4ht/n12
	6Dzev9pbhex1jVE+57P9NCXRHeckFxzjiwnf3KqlAsXzDr/SkAZKEyt8rNK4hCLj2NXVZitPPX2
	28LqMhkFAa/uSdhqkLSTrQc+eWpmArRu/sL2qbJJ71gRgTBbs+cjNa/Rxiw1JMwRSOiuSGKZphC
	hi2z1e/VeOLScp2mCIgZhufPaZAmDpIWzNudS/aUoZWYWp2cxfpFoNK6k8c31PgkQ78GzfBs5Hq
	hPeJDREeZ7eSn+Bf+RGReIkN6laAsMTi/wHgclMl+ut+MxBPPAD+FWaGhaoQy6XivtGdWvxd1fi
	fxMnNZAt+9Da0DgqcBJwFeC95eLf9884ZBgx/TDfuHGgte9flRe2KM/UlvThrkkKy3Fzw1WWNnN
	9FuCMu9wyswppdW6FvK8n81HdvS+wAalNr3AeJXkbkfjnDcNNkxuKlnh6gXQRx0adIzwEk5GYHz
	HrkFG1upUV5F7lEhQ==
X-Received: by 2002:a05:620a:454b:b0:915:7732:ea7c with SMTP id af79cd13be357-915a9da3801mr3475555585a.43.1781019349028;
        Tue, 09 Jun 2026 08:35:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a3bf5f9sm2173658385a.35.2026.06.09.08.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:35:48 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:35:46 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
	alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 8/9] dax/kmem: add sysfs interface for atomic hotplug
Message-ID: <aigy0ut410TItkgB@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-9-gourry@gourry.net>
 <1cb0514b-c753-411e-8ff8-80fa29837441@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cb0514b-c753-411e-8ff8-80fa29837441@kernel.org>

On Tue, Jun 09, 2026 at 12:26:07PM +0200, David Hildenbrand (Arm) wrote:
> On 6/5/26 23:19, Gregory Price wrote:
> 
> >  
> > +static int dax_kmem_parse_state(const char *buf)
> > +{
> > +	if (sysfs_streq(buf, "unplugged"))
> > +		return DAX_KMEM_UNPLUGGED;
> > +	if (sysfs_streq(buf, "online"))
> > +		return MMOP_ONLINE;
> > +	if (sysfs_streq(buf, "online_kernel"))
> > +		return MMOP_ONLINE_KERNEL;
> > +	if (sysfs_streq(buf, "online_movable"))
> > +		return MMOP_ONLINE_MOVABLE;
> > +	return -EINVAL;
> 
> Should we try making use of mhp_online_type_from_str()/online_type_to_str()
> [possibly a nicer exported function for the latter] to avoid duplicating this ...
> 

In patch 6 response i point out adding MMOP_UNPLUGGED

If we add MMOP_UNPLUGGED as a state that is only use by callers of
memory hotplug to represent the current state - but not as a valid input
to memory_hotplug.c - then we can simply this as you request.

Although we'll need to add a couple lines to memoryN/state parsing code
to disallow MMOP_UNPLUGGED as a valid input (otherwise you could
permanently unplug memory without the ability to get it back... unless
you want that?  Seems useless to me.)

~Gregory
