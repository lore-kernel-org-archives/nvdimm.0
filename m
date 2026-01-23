Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6A933F398
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 00:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769129032; cv=none; b=rQEnthJQ5jw3F5d22wMSsBne7aGiLE9X7NCOSozllLrDzTT2VTlls05UK8M4OHmPp62ybuIdZU1C8KvY5KP+6rdD8lCS/qVAYIf7eHWRLTivJ36fX7PyEriF2oQj3Pca4MCNPCddi5Urby4B8LLVOdQ1nHZQyxtUu3C7D+AC7SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769129032; c=relaxed/simple;
	bh=XGJ8do6DqiSNmZPIr9zz3bcxbAKjbH/slyEIBawIwRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+3YfQBaUdVXK5Cc1ZR/AKYLyK0FswR1CeqKpcup/f2cUiodJSeywWcFHvl6/YKwnXA3ja/+xwoRvzP38MJ1TQ7wyjdr82Faq7l87vZj0I5iv+/kkSmNHd2GQnA3+7/KJX3u0+3mTepTW67m3QDi3fW14bP+oQCw6Xa9p0JQkeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=ds+3xSJX; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="ds+3xSJX"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-88a35a00506so30858676d6.2
        for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 16:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769129021; x=1769733821; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UfDbc/em5bjOki5V5/p4q24wfcBoeK7m+V9bweSJP5A=;
        b=ds+3xSJXqjA5uKFz6PpzyEAghhuhWrbwnZGIaNikW9dL36wcC/ahkVGyazDpPSr+mo
         GZ4DP7buPsixk6uPF29b2DNApUP4wPbjoZWJbeOKyt5tmN8utbHMnQWXb5GmY1nvgVff
         PKLAu3xGfLATGEF7JtB4TtxZ8Nr0NRaNa5JQeyNmvFgEr1y0T8WLWlEFIossYsqaH+lv
         BLOx4x/9uUQ0eylf4C2dFNgj6lD+nKzi7w8AO/P9vVMbO7m9VakmTYP8T8c8+iYl3zF8
         oO6+SnOjVQMW4PN+dn3zS2VR1cfVWKBiq2SwBo5ihamo6z3D0TzAy9WJHTpR+2+ZDEAJ
         8Vow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769129021; x=1769733821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UfDbc/em5bjOki5V5/p4q24wfcBoeK7m+V9bweSJP5A=;
        b=oCpFUnhpAB57sqKBVztS1ln33B7athLPL6aG6xMmk0MigdjmFcFAxzgvjn6jBG5c/C
         Gzz/Pj2JXMJcNkM+UJtKCddufyF+LGoOSZ+sO6ByfEICJOdSOc8uVhbIYYyN965NuqjG
         JBYmp2wVqYX60k2/IPUGHzElg2sJHWJvr3nfNiT3+IpEixULUjnhONE2qmxe/jj9yBtp
         OZCsfr8aNrf07mMt3fLg1CRCGO8ahy6AvBhVnE1kbrs8dGiZS6a+b0mLZgKKhINWwqiK
         UrfqXqe9NzoAoTZsVl+cbV0dUBLocromJqT+8Ig5tfcL2YBeJbgTmUApcXSWKDgAnBZE
         GDHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnM8IbJVZKD9LOttZsPHwATM0iadAtjM9B7Yy9xVS/oKdTTmf9Oba+rCc7Vy6N96vv9Kq6mHE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyymk5lNSbQTLDgCNcIT1ty6B5DHwA982k023XgraQI3lhG/n4A
	QPOW5puXmuhgeFc4PRHBKkHDlSW/X6/pm9Zh1sJ96vyfebKi4ErfEqCsoTPZwnuv/J4=
X-Gm-Gg: AZuq6aJ1EszIHjso/JfDv3nPoF6vH3kmJgckd8GTCR4ZXTBzV2lrZhDf7po0GBu28aq
	DZA5vtZGemtpLHIhid2FquBWV8G80ofXSKMqrUBXPrioPhGavKm3EHVefxr11twBna2vVqZqeXJ
	BCvHjKpV1NzjFbF3jYqeQpM7G5R4Ma3/ns/6Biz0ZtKHZs6HubUZzX8F5KNbblk0H+E9O3GkYJ2
	iKS9tJk+NyTDpLxkh/e7z8jC8lyLD+81Vlz+DW7aKeJMiN4whW22rIEoMGIpUD6FPXRRoBDFgGx
	jxmi/6DsMckN7jsStNMJSsDdZ5VkL0V+6uNkXreUw6L2VABjbmMA1SXTMDQGG6hCwp/UdyGGzRQ
	7Z/sKnbjTU0hWYm/AnjMy+8lBN/Ca1mhcfXiOGUBXwDtKl8p4Em6o6+TZWYG6Noh4tNo45RMKUH
	ebc2UIZk49qXtPbLCwl2iR2HDXHf8CDNnssmx/3O0bBC4wbn7DiKSxKY4fV31sw/v2tsEJ4Q==
X-Received: by 2002:a05:6214:f2a:b0:88f:d4b1:4c2d with SMTP id 6a1803df08f44-894902209a0mr21597136d6.60.1769129020746;
        Thu, 22 Jan 2026 16:43:40 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89491853478sm5521546d6.25.2026.01.22.16.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 16:43:40 -0800 (PST)
Date: Thu, 22 Jan 2026 19:43:38 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 7/8] dax/kmem: add sysfs interface for runtime hotplug
 state control
Message-ID: <aXLEOjgVyGYAU_zk@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-8-gourry@gourry.net>
 <3555385d-23de-492c-8192-a991f91d4343@kernel.org>
 <aWfcYjZVrROHfGyh@gourry-fedora-PF4VCD3F>
 <57c5f44f-3921-478b-843b-877fae536591@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57c5f44f-3921-478b-843b-877fae536591@kernel.org>

On Thu, Jan 22, 2026 at 11:49:48PM +0100, David Hildenbrand (Red Hat) wrote:
> 
> I'm merely wondering why, in the new world, you would even want the offline
> state.
> 
> So what are the use cases for that?
> 

I don't have one, and in the 5-patch series I killed it.  You are right,
it makes no sense.

However:

> Why would user space possibly want that? [plugged-in offline blocks]
> 

I don't think anyone does.

This is baggage.

The CXL driver auto-creates dax_kmem w/ offline memory blocks

Changing this behavior breaks existing systems :[

> Can't ndctl just use the old (existing) interface if such an operation is
> requested, and the new one (you want to add) when we want to do something
> reasonable (actually use system ram? :) ).

I think we're in agreement, I think I'm doing a poor job of explaining
the interconnected issues.

summarizing the long email:

   cxl/region + dax/cxl.c + dax/bus.c auto-probe baggage for
   BIOS-configured regions prevents any userland policy from
   from being plumbed from cxl to dax.  There's no interposition step.

So yes - new interfaces would resolve this and the old interfaces
could be left for compat.

~Gregory
