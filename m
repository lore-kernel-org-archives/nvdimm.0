Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA60D2E8B9B
	for <nvdimm@lists.linux.dev>; Thu,  5 Feb 2026 04:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770265424; cv=none; b=fLl2K5ewz8ol34BcMLOIUdh2crjYoSg5XhnKhas5u5obTdpz5nDz5lFlpZxyc8ntmcnkIdlLYuI3NmnVgvu4sTDwgk4jI+ymHmXklMjUphknhXLfvGkZKO2uqtvme2Lcpkm26KPLBew5I01OGg2kHrxYIbd7h7ptXJU2vw2budI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770265424; c=relaxed/simple;
	bh=L03384jtDexDfzkRHHtzPIVJ4BKFBQWzJGNmJuCR4wU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/DQ87ZEdqGY/2/bderNZBzf6JT2n9IcEmHTd2DjUUYiNML33VOn5N0ARbs67Si9xZx2cFGqV70OpLpAQNMFBFYbdzPqFpXLECYyLoPDfIU1JMRx/6aKZW0CZMUvBH9LaTaSMWqb80WalJtrPpMHd5oxN9Q7bSxbwowbHrwp+ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=sJTPuNRQ; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="sJTPuNRQ"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8c52f15c5b3so42452585a.3
        for <nvdimm@lists.linux.dev>; Wed, 04 Feb 2026 20:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770265423; x=1770870223; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qW0+moZctApASOdwQkaNncsGOVFnNExxcEZS6yJkS4M=;
        b=sJTPuNRQze7+DOn5EWaYQP4o2fwSi+QTfOL+yynMIK3396vJmC8tYR0wIRMBuJVp1r
         MW9kEyFJPup+o2930hfZrHlHT5/hfrBHaP7sQbzedR7N3vSTQ/JmaLaGQCsggEKYxcTW
         bzOQkZr5v2JJ8ZRA9sgFw6shOcZ9PkGEXM0ZRgOwi4giqMM/vUKows0VX6oFD46xImYA
         NJU/uEQX0GjqUkDCHDA1+AxC97AsjnmqLD8MMTGKYHNaqsoSONao24Ek8vxs2+MZzRbc
         TTtHlvQhOTSvNFFmumjFzO2LnDbBv7bzaIlQFI3W5C5It4TsAgVnTe4ditkegiu9u7Wc
         hl9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770265423; x=1770870223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qW0+moZctApASOdwQkaNncsGOVFnNExxcEZS6yJkS4M=;
        b=meFZyiiP95uUiRTvE8sbb+Ql8dc8jORWz12RjmUsHkzLaCUZ+74GYz2/3FQJxAML+j
         4wBEQFzcrdBubGWOW7/ygRiiuaLn6dajhjFRPJHd0oZZT0b+QEmYCNAIV9tWyL42PR6b
         fzt6VFuPDr74LXcKbl0/9sqQIXpKjxubi5Kz6NMfu/jpRRWsI7ew+zBnlwZcpwnMPfQd
         439njyeNKrQItBqJS9sgXfufhFK5YlM8JQFQVq/ZD3uzvEB3UgT/n8Ye5Be7LkKbyHBh
         t7Z2pyxqXSWPDgFsoLrxgbtSLY6PRRT9xKxB8lzagfXkckq5Gb4xWy3/AaA4+ZDs6LfJ
         YCuw==
X-Forwarded-Encrypted: i=1; AJvYcCUdQVkM2bGSuXViNeBqzSetyCbWbfexc91zNzhHgccTKemc3+Lb6AZ0xmiL876b8Howkg3/+G0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxTkGueYVuMwKkOQIWpWuH+dswOoIWup6ruYoRxf7ou9CjkjOYe
	gBXXBDzrwFZuet/MOYKz5ApA0N1j9+Log7gEzTWNeagbP7JgzelOjnIyD0vtA62etm0=
X-Gm-Gg: AZuq6aLn1sdH25TIeWgNwHzEGDOmBc5C4KsjdZMR71oCorLV0pmE01b4ms4t5huEU8u
	su1I7eRPNwgP9fpEMet0FBucxSsnj0jHQZ1fARckwj5qNns6v/q987c2T0MQRdPlj/NMMD1p1FW
	04UKLF5JCtEjr06PRHFlvy7mNkef4bQexX/p/PxjPO6ex7mhWsE0rvAH1Q5tqrVPDlXIsCNIC/4
	cPhwGbe09nn/ewCmsIxGDykIQc6EjUW3d+O08fqaen702PwAYgXluOF1P49rtEg7bG9EBySEX48
	QLmInyUCDQ/F4efLfJMkFXTLiThdFxH2qjJG6xSY1hGRIjJhdBDiOj30SQ06TpeWtmwHCdTs7B9
	aLesbJuCXKc19vraQ071RATaMPTtew3YbdrvCrQdVl5NOgFLBjasHRem0JYnAkbjUMky6m39UOs
	+WHQENyg8ZD826qWzrXmEVDef4CJcymVCFODs6xHqbIVd9d3RcRyiQYsHQjrns/N2f3e3rxA==
X-Received: by 2002:a05:620a:c4d:b0:8c6:f74f:9b69 with SMTP id af79cd13be357-8ca2fa5e50cmr701545185a.83.1770265422854;
        Wed, 04 Feb 2026 20:23:42 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89521cf8619sm34240906d6.32.2026.02.04.20.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 20:23:42 -0800 (PST)
Date: Wed, 4 Feb 2026 23:23:40 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	terry.bowman@amd.com, john@jagalactic.com,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/9] mm/memory_hotplug: add __add_memory_driver_managed()
 with online_type arg
Message-ID: <aYQbTFLTRHiAnrKr@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-3-gourry@gourry.net>
 <20260202172524.00000c6d@huawei.com>
 <aYDmor_ruasxaZ-7@gourry-fedora-PF4VCD3F>
 <20260202184609.00004a02@huawei.com>
 <aYEZAUJMLWvaug50@gourry-fedora-PF4VCD3F>
 <3424eba7-523b-4351-abd0-3a888a3e5e61@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3424eba7-523b-4351-abd0-3a888a3e5e61@kernel.org>

On Wed, Feb 04, 2026 at 10:08:45PM +0100, David Hildenbrand (arm) wrote:
> > 
> > David do you have thoughts here?
> 
> I guess we should clean that all up where easily possible, but I don't
> expect you to do that.
> 
> For online_types I used it, obviously, to save memory. So I'd expect it to
> stay at least there, but cast it to the proper type once we take it out the
> array.
> 

I can do it pretty easily and pull it out ahead.

~Gregory
