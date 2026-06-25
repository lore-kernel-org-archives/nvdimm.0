Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97B93C109D
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 06:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782369836; cv=none; b=KinINxiyW22wtxmJKcPSPRUtBEQ7ZqCRsh41QCgo71KekQOxnOffJ7yVex5RE+qOgLHNc0vxk5D6aJ5+HMc9mCsrhy2pqKHYWBQ8NM4ISdwzzRTLZk7NUCCahp+cDekBycdNHu/CRTdVj0fC6ijP+yTFCTekjkK1ZsIg/rQoXmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782369836; c=relaxed/simple;
	bh=J3ogWlHgltCmMWC539Oq83gosIFEq131LmU2pKtUrtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QQ2fhk/ZXCl9/DpRmB6H2E/wvG7pgcuVewWxUSVqL5Uv7+HCgPAKFfqljnjat/N+zLiB8xsaGl124swcB2AzNkyEMcmoNIepFO4sQsI0WIJlwUdXfNTVmJJhm1w/wPrQT4D7Yhf40gaxhk7Fn/dL0ZE1sAZjdOyzkeS5J16wHjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=kjlqYfw2; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="kjlqYfw2"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-519ddebce3dso16850861cf.0
        for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 23:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782369834; x=1782974634; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZAbcZ3NxbmsxcgeRZOVz8olu265ZXR9ZINnNyOlf82k=;
        b=kjlqYfw2jC8SdJCvVR/TY64CPBsLMt2Bafq+UAtMvldG6aFmhmBiLiEbWBSqkhZe7T
         nhkVfNYHz5Q2v0cVSJzqVubyFUops+6U4QaSb7O17hc2Rv1K32t6H3XuzqB40brql03E
         Mm01MgWfwEYuojtG/gYAOtmvzFqQ34JGudHPVqJZHb8rvORQ7JznhBy/GGcv6PcIxeUD
         xW8QJC3h23Tw5K3pnUgpqe0VOZX7HoXQkWxcm33UV/JkxLxWpbtn+p5m4bYpfEq7yV0f
         LUZXCobO7/7/zpVkHzociXNYhJ8Ptqq+i5G4nsT6nbHIMoyrdZ2VJjLO6tw42Iq/W3rU
         stZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782369834; x=1782974634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZAbcZ3NxbmsxcgeRZOVz8olu265ZXR9ZINnNyOlf82k=;
        b=T/+Fj85K/uhcgQCjUzx8JTYQIKiEM/DoMY1G9LEW9umt2gvZN/OkWI5m3Ollqsl/po
         bX0VzuGJqjemN3F0qyRTiFtNIk+RQ3sIEW47mO1T1v5jrpI71/NB7Z+YED9pnkgpQWyn
         MfMiUjVUpYdRSBz+E7FSVOxFDNe/EUtYJGUJcSDU9Z08wFEWINOd+YmXdjv7EuwdwSPC
         aGiEOzz7otJksTWZdxaUWDZCttsdNBkoz9S09sJlrn3zbi7xvgKYE2k2V7RvUn1OSqfV
         YK9EgO7cEJvgl/guFqGj1IYRBhDd0FnrXFB5wf+mofhY/9QuHsHYDDIthijFrZdmuQ39
         gtHg==
X-Forwarded-Encrypted: i=1; AFNElJ8V1Lagi4U4D+BOCohgb9Xdqvv+gu1Aur2TOCHVd1LzMEIUijuXp7kU24+lr7EivVFoMNfUGdo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqzWxZy8HfUq7saDJUp0tuB4uOr/fHTLsXjIY54GZA/bhpi8wN
	rBuBpJEFUksjzWqOvWE5roOjARBzQ3rNTPQ5kYI8wdywQZ3/Lc012tKhemtRkoCXY/k=
X-Gm-Gg: AfdE7cnU96xXIrOSiTLYBUQQFHIFluIoj2GfIy+zquYMY8roVDSH6OMZ22LLGEnetHz
	p2vRNFjUWjfYKRadruGeLnkWzfbeAlQY9YrtJWpdpSwqGC2qTFcqdcz70CIg4HZGb9sxC+32s0R
	cgWRTLgVvAvLCGKMn3lOJZg7f3Dm5hgEzyZQF097OfxtGcARnV4Tkeh4DVAOn+YNG+ISgCNzo6A
	yYimnmOC0YVC63vIFboyfveUR1jAVhkZC52HHM0yVLUbU5fxr8W6KmZlRnWbDT4K7XK4cs5ZEiN
	B2HAqSc6czznWPqW7VUXT5Ns8cJ51xOR/tPpoSL2F9YsmIGKF2obQR8uFswmtZ5+7skv+18Ewlq
	2ZLQ9Shhn11PcAhw9kPTJGyoPvvw/5O5YJBsAcYPPqMiYnq113CUNAH3DVizOh/UCcXxYS1Ur24
	vetwFeBSz9sPL30q5Gzih9SkfUVuXCe2p/VMuJHsS5iKSuO6FFPEdByuJBxOm70D+ockqa
X-Received: by 2002:ac8:5f85:0:b0:517:83e5:7859 with SMTP id d75a77b69052e-51a72a8d81fmr15082801cf.53.1782369833788;
        Wed, 24 Jun 2026 23:43:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df7f015e50sm171495166d6.6.2026.06.24.23.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 23:43:53 -0700 (PDT)
Date: Thu, 25 Jun 2026 02:43:48 -0400
From: Gregory Price <gourry@gourry.net>
To: Hannes Reinecke <hare@suse.de>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com, ira.weiny@intel.com,
	apopple@nvidia.com
Subject: Re: [PATCH v5 8/9] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <ajzOJPgV1acrUfr4@gourry-fedora-PF4VCD3F>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-9-gourry@gourry.net>
 <8e42587a-d614-4259-ae6b-5bca1479b425@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e42587a-d614-4259-ae6b-5bca1479b425@suse.de>

>
> Why do we need to treat the 'unbind' call as a given thing?
> If we know that we cannot handle online memory during unbind,
> can't we just disallow unbind in that case?

No.  Unbind is a violent operation - unbinds cannot fail, and a
straight, uncoordinated unbind is essentially a `--force` flag:
the admin accepts the risks.

To your point, the admin either does the nice thing are they
muck up the system.

But we should still try to do something sane to defend the kernel,
in this case we should try to prevent that task from becoming
deadlocked.  The only way to do that is to leak the resources.

I'm making a small modification to this code to reinstate the
legacy behavior when "state!=UNPLUGGED".

~Gregory
