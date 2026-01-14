Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563012E06EA
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 17:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768411991; cv=none; b=lc19eMcVeWM0c0Y8VPM7bN/8Cxe4+N2g3K6PiUkCPv9Gpw1+/xJKFJb7nyTcPzPyzFK6bybb7bpnTMhNp2f3NLPpISqOv8HyRDxRzU88itKJ3sk88P7czkwWqI6llbYE79HcR0NVDVKQl3bfPMUNh9128nGtBmb3y6Q97BGnu5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768411991; c=relaxed/simple;
	bh=8O9PPhw4HJ1ghVcptQLNcB4UFjagJSyTGDFo/SN9nX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fyIObixvY/0qkr+JHb25i0bltYoRmz2gAcIdvDvaWv+v3oXZ87y2CFJYgif7widNcxyDZMn0bySBeMgTmbgxMeA0FmXjsOCIJXEEaRMD7ZmJa/KkzX9Y9K9Ne/z6TTSNRAMAzp87GUNQirz7Q5f2VRukSX9PvI3PfG608zBqA9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=QNcIv3cU; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="QNcIv3cU"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8c531473fdcso6467485a.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 09:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768411989; x=1769016789; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bCjYai9Len2QQEYBKyLKOlFSVdw2VqJPxFxPg7dhnMU=;
        b=QNcIv3cUeE+0QLsWEfGEwsWa4dVTYsM4X+PZUfYg65Q4yTIDZAHtqRCRY6Bvd/bdRk
         6Ew7U/8JrQgPuXXcgFWu9UOEsrCK9qVzbs3SgW2/LnyWEi2d0HGvXUtJE35o14/3qmuq
         J24wJOVveWNkAcxnpmhqduX7RvwC45k9enDvxNTpI+7DC0px7LSE6WitclAFjxK5LuVc
         tGdcdy8DGsMTmsRGpvbc6HQ7HQS6YYYrLlgUXZDlRWlbgEiUaxg/xtBnfiGj5m4kRRAF
         Ac98JUZZ3BfWXLg/x8wP5dIsT8Tqzc0698Icu/H86q8Qgz3BC9YZbR0NiqFoHJ4KL1wj
         gT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768411989; x=1769016789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bCjYai9Len2QQEYBKyLKOlFSVdw2VqJPxFxPg7dhnMU=;
        b=jd18iORjBHQmx510Xa275VfrAaDNfKF4Ac0srtommd4s1sG9l9lcOpJ6i4Zud5z+uR
         SfpfA2wVMfiyUOSC7WgkONKTK8XFiHNUUfzPct/ow1E65QfP7pPwZ3oLtoiVYg9dXulS
         RNyyAPaaSvskJe0EbqYqdDBSisaAO50yEMRal27KuakSZcLbvrh1IQhTwnwtXassKQCx
         d01Apc5S4G+30JvN5Kj9ChoQLcNG1IHyceOKqbHEWAgr/YpP0Ii+YhrbvKREyaZuCGVp
         Zc1Vao8VdgpSDim5af/xphYzY3nLB1Y87Asyc7pB/owdC4F9nVUbFdUoiKnYfl/dIUfj
         0Ddw==
X-Forwarded-Encrypted: i=1; AJvYcCXk46NcZC7DB/vT5W8DqBTo7VWnBaCQezWrxlKj8h7lw44KbXHCrgD6ZXhHaRambGJ53AUZNqQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YznANY8CErM5zRHoI1UHX0E9w+pn9GBPR3GFlvaPFpglk8JlvUr
	yv5uNCwJLNlvZRrj+ECEZ5p0QELPHKX9QP4Uj/TzZEaudWKaaY4PTM0WZetuTbRkyiw=
X-Gm-Gg: AY/fxX6fDc5sAunvs4lyxLsWhcgjB5cqHOjb+/cSj20PCayflA7WDBT9yDs5j0z8azK
	GzPhQdrKW3cf+c3pQ3aRjeq1f1TQ8W0rWMhLxehb8JO0DjSEjWOsM7zRsAXO1UMKqo9uf+SZNqz
	khTeBzj4z0PtM9PmeJdk447iszeA4fyOd/YiOZqYCYnISd7T2TQ9gBUvXdblfAwnBPqeNzE3tq2
	UZqPtKNHiCqk2PfcIwL0n3AcgeP1qgPgpPmWQh8llk7n3iJgIRlv9AjUSQJ53ia1mv+ExDt6QFK
	3XWgkO+J9mUPp94Ffo27s5Z1VqAuCvTh+oz/uTEl0oCM/GVsR4bw1TSCW4WdZvkhjWXLUILU9yk
	ifnGwE1bCfeEa52dQgRVU/rFtEwO6B6b3iQTmSlqHLiov4urN0J00u/E4QkEh7uLt6fUTJVCT/v
	QW+eEv0atnuIl8HHIabolZRijw8vDMl2un8x4mTAeEBlrtv0lq7UIB/Z62+qHjpkpvYHTWpg==
X-Received: by 2002:a05:620a:458b:b0:8b2:7290:27da with SMTP id af79cd13be357-8c52fafd245mr470291685a.12.1768411989233;
        Wed, 14 Jan 2026 09:33:09 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c530b6e7d4sm198764985a.28.2026.01.14.09.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:33:08 -0800 (PST)
Date: Wed, 14 Jan 2026 12:32:36 -0500
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
Message-ID: <aWfTNGMqn7S3b9z9@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-8-gourry@gourry.net>
 <3555385d-23de-492c-8192-a991f91d4343@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3555385d-23de-492c-8192-a991f91d4343@kernel.org>

On Wed, Jan 14, 2026 at 11:55:21AM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/14/26 09:51, Gregory Price wrote:
> > The dax kmem driver currently onlines memory automatically during
> > probe using the system's default online policy but provides no way
> > to control or query the memory state at runtime. Users cannot change
> > the online type after probe, and there's no atomic way to offline and
> > remove memory blocks together.
> > 
> > Add a new 'hotplug' sysfs attribute that allows userspace to control
> > and query the memory state. The interface supports the following states:
> > 
> >    - "offline": memory is added but not online
> >    - "online": memory is online as normal system RAM
> >    - "online_movable": memory is online in ZONE_MOVABLE
> >    - "unplug": memory is offlined and removed
> > 
> > The initial state after probe uses MMOP_SYSTEM_DEFAULT to preserve
> > backwards compatibility - existing systems with auto-online policies
> > will continue to work as before.
> > 
> > The state machine enforces valid transitions:
> >    - From offline: can transition to online, online_movable, or unplug
> >    - From online/online_movable: can transition to offline or unplug
> >    - Cannot switch directly between online and online_movable
> 
> Do we have to support these transitions right from the start?
> 
> What are the use cases for adding memory as offline and then onlining it,
> and why do we have to support that through this interface?
>

the default build config does this, so anyone using the SYSTEM_DEFAULT
will have to at least support this unless we want to change peoples
existing systems.  They'll expect to use the existing pattern.

That is:

add_memory_driver_managed(, SYSTEM_DEFAULT) -> offline
echo online[_*] -> memory*/state

If we disallow "offline", then we essentially leave it "unplugged" and
the second line (existing user policy) breaks.

I thought this would be considered "breaking userland".

I could see disallow "offline" if the memory is "online", and just force
"unplug".

> It would be a lot simpler if we would only allow
> 
> >    - "offline": memory is added but not online
> >    - "online": memory is online as normal system RAM
> >    - "online_movable": memory is online in ZONE_MOVABLE
> >    - "unplug": memory is offlined and removed
> 
> That is, transitioning from offline to online or vice versa fails with
> -ENOSUPP. User space can do that itself through sysfs and if there is ever a
> good use case we can extend this interface here to allow it.
> 
> Or is there a good use case that really requires this?
> 

There's no good use case, just existing users and expected behavior.

~Gregory
