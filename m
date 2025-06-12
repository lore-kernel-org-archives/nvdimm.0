Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4771D2BE7A3
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 17:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749751185; cv=none; b=Q6BO/UfQFa+ufZHjXgmreByjHdOWzrP3lIUaeWLt7N0edZwy88wOfuSavF1d9lX1mAHGI1YuAFsXFFYfliowa+MSOD8hXcnHXnbQsjOevngRzWaMbPiioNPcU35Bnh9SRWI7Ut2R+EP0BggZzGONpFC8cwB77J85n3Fb992AOzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749751185; c=relaxed/simple;
	bh=/KcpP3sd6NE+ea6NDiYmJmS5AFVotPbnqQ+fVjozi/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o8/OLORwVrYcFgS/dvWigpX4bzvEK2Wn+6x8rKPUj4NMjpmm9RgXDCony45z9b2H1Cu/ZSqWX8YBq+7hlBobVHget5oCCvsjZXCH+3K7VhNDIvYZQaH2sedGkIlGHb9a7FgyMPKrdPtodKxtL8r+mJoGj142hhvae9xb1BncGME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=XRCGw/tj; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XRCGw/tj"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6f0ad74483fso14658356d6.1
        for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 10:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1749751182; x=1750355982; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tXTM+CkzUjCCaEkCj05xO9AKr6j3JG1MebSjEIdnf+8=;
        b=XRCGw/tj6zGIZRnm7FkBVUtHRkbeC2svTzGWB6MS8x4riRZcDwIAtTHDIhSkdnmDnA
         Kex0UG6sCnEOwitmlUQ9DWjF6V22n5cyowS9nwXn0E9KxrSbdSkDmiPqd2EhwBb0RVp0
         lQdxMzoJYujjn/RFTbsCR2WYopHahxCTlBkmhjN5AqgVjE21JXfHAER6YKSmbCD5CPAU
         XmkaxCWhBlmYn2lDw3oAXR2LWzbn3j26rq0Rgi81uoqTH6YVmUdZxikKPE/fLH5Cb1Le
         cqTjWVBiPmbGYA0kE4OKrm+mp4OT7sS0b6SRe8Ok8azT84EvbWORoPhZcXzXaUbd0tN1
         oCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749751182; x=1750355982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tXTM+CkzUjCCaEkCj05xO9AKr6j3JG1MebSjEIdnf+8=;
        b=UCMJlRzhm9wBOLwVKqaQUpDe4okrg/qG0GW3ue4U0miZHrgIYq9YOHOzWajt7WCms0
         LX7qItSiMccaX067UjLPsmxua8ratbaWQo7I+BvekMRKHfU2sh0tLrgA2LBsewz7w9tw
         36mQP5E2thJeePWfUaJ9Xe+iB7GdzQ34SiephxfFxk8vyxDrG2aWJYyMlnzXZ+6jX4QZ
         noScc7ce92gETKsyr3UqdmwRsi4cdL/btpIDmVYlpDXlRA5D7W6rf7PZxBHgSwME9qYU
         m0AghraXQDgKDXN94AVoBmuEQfr+FWJj+VgD9DdVyNoUFX481deUKi1g/88rOuRTpKee
         E11g==
X-Forwarded-Encrypted: i=1; AJvYcCVgY4usdtNVwmppcluMwUXgfgHisjNgU4oreGSW/gi47LwG7iS6qPCvgh4EwEz2moqZlyaKv2w=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFG8T2TpB87puY41OoTJtPvhS9nbJYlyhuV+gfrapPpL3rqiX/
	sRj6Kc3BtyNEQaTJPJdUlXVVJNOdT0uHSU+ggf0a1QH2hScV3gwn9upRy3/XDaeGPrw=
X-Gm-Gg: ASbGncvxW/f5hOu1/3Ke0wn2meifBgOfwrjFPatN2zBqFJULkhrqpEuK/QoEYxcJJYm
	dNdCHWNB6WMqaxiZ1mpsy9a+Vr3Dq4Zcdv7HZABXN0bX7lcQca9TVLNozk7Z/59CoHh67gZ490B
	YgXxIxfcXEbCz/gbiLlKd1PAwzilL7m+XVgzXxdv69fHgZF7q8NkLn91eBGYyU78WtzS5bMLCyg
	h4nYbdqTZ7qffmKGdvU1UecoddbZ723wJCuuhVGlqk2zZ4L6llM+qOG8x0jPbe9HW+jLLtehqov
	8QYftYtXLNeQUC7LLikFl8A/gSoOdUgw1nsIdPswO+rugNvHTCzewzBivWhVLMoG8tFsjaItzvb
	OIQEzQ9AjF8eaCHnA0Yi5x9zPNkJ316Q3w2WUww==
X-Google-Smtp-Source: AGHT+IEsvSci92g9GrvFGh5NfCjtusJYIMdN3N/cEr2P+xXcnfBxDJAll2rQe2ppsiqe5qWlDpXtYA==
X-Received: by 2002:a05:6214:224e:b0:6f8:a978:d46 with SMTP id 6a1803df08f44-6fb2c334737mr142643026d6.19.1749751181973;
        Thu, 12 Jun 2025 10:59:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb35b2f9c4sm12808026d6.26.2025.06.12.10.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 10:59:41 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uPmDE-00000004kef-3k63;
	Thu, 12 Jun 2025 14:59:40 -0300
Date: Thu, 12 Jun 2025 14:59:40 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/huge_memory: don't ignore queried cachemode in
 vmf_insert_pfn_pud()
Message-ID: <20250612175940.GA1130869@ziepe.ca>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-2-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611120654.545963-2-david@redhat.com>

On Wed, Jun 11, 2025 at 02:06:52PM +0200, David Hildenbrand wrote:
> We setup the cache mode but ... don't forward the updated pgprot to
> insert_pfn_pud().
> 
> Only a problem on x86-64 PAT when mapping PFNs using PUDs that
> require a special cachemode.
> 
> Fix it by using the proper pgprot where the cachemode was setup.
> 
> Identified by code inspection.
> 
> Fixes: 7b806d229ef1 ("mm: remove vmf_insert_pfn_xxx_prot() for huge page-table entries")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/huge_memory.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
