Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DF13803FF
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 17:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770054096; cv=none; b=k67LK8o9vStg8Tgwns+jsmMk6kEPVbnhG3EksyleCLa6HfxTl5kDnVL6Fz8L8aOeSgAsHpASE5Dp5B769TNplaK/ajbQaZqb5ONpj1i/FRS3vu9r52hFErG6Do4GJWku+TDeWizBesSOP55QIezifJSpdnW0lWK7SRUj0EM7SNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770054096; c=relaxed/simple;
	bh=NvSchrP/3iqVAPZQcFrmz3WZ5MlQLRFV2NZ/1rw7880=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBUscuQKW34Wrabq0mza6nHm824D1QcnztTGQk+3rDyPZHOTCNiPywZhnu9N4NUjYd4v/mT7iZ8318+7uS73YZDmkMB6837iQjDbCE1eutbGpS++97ypDu0Ma3Jx2jU/gKbqR1OeSIH8qeiiTCjfaj5WM2ZFDH8QcJg7t/HI8Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=qmV+fbov; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="qmV+fbov"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-894638da330so48166936d6.1
        for <nvdimm@lists.linux.dev>; Mon, 02 Feb 2026 09:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770054094; x=1770658894; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6OBDEWLEmHCzYPUVrTciErMQbNpqUwuoibpvHtq101E=;
        b=qmV+fbovHi7CXiwKl0eptMfNpucyfyUIimeLEbnD2JWpFVzwJsZ8d1nP5pcR+18GLg
         Tt9UpIfAzbSko5GyXptVst/CSLbh0ik0Rd1XPByIi7ow+FyZe18F8J8LmpSaKs728HdC
         Fmz4VIAS6Wf/yvAoG6L/t0FOVgQsrJCey5qxlJ7r+zSgXwI630GfxO8cOPNI9Cg/5Nd8
         a9Ce9GAqSwUVgtJrFiX4OH/5HR33yOzM4GEF+gCEf3/RY4zQsG+HA7TPlOjzjwp682fc
         b0qIXevajDylE3+8zo6dRu8mIRPNTuSiLL6E7RwE+wOn7o+NXiCeUyTwKieH5oZ1lcpW
         ijYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770054094; x=1770658894;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6OBDEWLEmHCzYPUVrTciErMQbNpqUwuoibpvHtq101E=;
        b=nY02KybPZAHSt1NWF0zBTBKFjLQ8InsMY77yR/jOyyJ74EtyF3haLn83dLXA3w9VI6
         0VFoPdmWUOuLEs1+XXAt0Qwx+6zitGjx18t00SSCeBkj/tFMIjx8KSJFJrOrddcZZxk6
         VBWWCjZoENa3j30mWvav68Y5AKnP2n5mZzxMvoRZxeuPM3+Tyv8vwYqtJRyhO822ysmr
         dooZqG7u7eUmLj2vXCdKt3z3Fy10odRJEWZr0KIZJDRlZ3kBwtQnsEuhzTXefc+ppexH
         OigMifeshX8ifEbPqX0QM6c1w4i5uNB612tNS2f/ORGKZP0Ts2bX8xWNcLtY1Z33KjGJ
         jidw==
X-Forwarded-Encrypted: i=1; AJvYcCXpDxOFIPqpCjUPyOWPFgFcVvUGomVRUdBjLgmkO5FlP9OlOmthm/fdboI6jjT8385bWpbkr1Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnU1tPLBrl+HWeW1LoWBLF1S2dmG1O4+W4V7HyYQEjomEqrUc1
	F0tvl5izHRSkpwy883EpcTtbBB95lO/G981mAuxFGEp6tnx0eR0rsvD8wJUewc8InWs=
X-Gm-Gg: AZuq6aJQjoMCRbsQ1uWy+Fro6ohYPW5vhqKAJi0mDbbkP3ckAgGTv1YosY4Dm7TvabI
	pkKyRE6e6MGyU8bb7HlPNyWjjHR8/eXhvh5MDlqwzDMznzMPJ7QocHEHrMkSQwV29P2E/kUa0Hi
	AuUDeNlhoN/Hrm9S1oB+A0isYIqnPDDCnv+qvZiheEiDDKS9SABflInbkTrTTCvalFsTQA/c0Tn
	n41TMuVj56Km79Q7yld1JYWhQfVUxsLg0P/PCOUhc/fEG1YICkuT55gF9vcAKOtXka/W+ewGul+
	j50YUFMFlTo2bd/gw7zblKHVk4SWi3CwAgFIuCbXxpnhgjJaPMe4QwCbjwjtTQVgztIbSBStqR2
	j9dyL40hsNDIl7TAwiZ6mSWGx30OK8FZemkcQfEHTzz4e3A9m9BlybbBP1pHbHOhANvs1jzyD2+
	lhZ6KygOJU9UEAD+4H5A+8fx25wiTeF+MKf+KIdl6FA1r1OsGJZT9aHWRY87cTgB9egSSz8s52o
	HN7QV16
X-Received: by 2002:a05:6214:20ae:b0:894:7fa3:7a32 with SMTP id 6a1803df08f44-894ea0f90c0mr191291886d6.68.1770054094267;
        Mon, 02 Feb 2026 09:41:34 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711b7c789sm1274632885a.7.2026.02.02.09.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 09:41:33 -0800 (PST)
Date: Mon, 2 Feb 2026 12:41:31 -0500
From: Gregory Price <gourry@gourry.net>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, willy@infradead.org,
	jack@suse.cz, terry.bowman@amd.com, john@jagalactic.com
Subject: Re: [PATCH 8/9] cxl/core: Add dax_kmem_region and sysram_region
 drivers
Message-ID: <aYDhyxjzKtbqFWdM@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-9-gourry@gourry.net>
 <c1d7d137-b7c2-4713-8ca4-33b6bc2bea2b@amd.com>
 <aX0s4i5OqFhHkEUp@gourry-fedora-PF4VCD3F>
 <9652a424-6eb1-462f-8cbd-181af880f98b@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9652a424-6eb1-462f-8cbd-181af880f98b@amd.com>

On Mon, Feb 02, 2026 at 11:02:37AM -0600, Cheatham, Benjamin wrote:
> > 
> > For auto-regions:
> >    region_probe() eats it and you get the default behavior.
> > 
> > For non-auto regions:
> >    create_x_region generates an un-configured region and fails to probe
> >    until the user commits it and probes it.
> 
> I think this was the source of my misunderstanding. I was trying to understand how it
> works for auto regions when it's never meant to apply to them.
> 
> Sorry if this is a stupid question, but what stops auto regions from binding to the
> sysram/dax region drivers? They all bind to region devices, so I assume there's something
> keeping them from binding before the core region driver gets a chance.
> 

Auto regions explicitly use the dax_kmem path (all existing code,
unchanged)- which auto-plugs into dax/hotplug.

I do get what you're saying that everything binds on a region type,
I will look a little closer at this and see if there's something more
reasonable we can do.

I think i can update `region/bind` to use the sysram driver with
   online_type=mhp_default_online_type

so you'd end up with effective the auto-region logic:

cxlcli create-region -m ram ... existing argument set
------
    echo region0 > create_ram_region
    /* program decoders */
    echo region0 > region/bind
    /* 
     * region_bind():
     *    1) alloc sysram_region object
     *    2) sysram_regionN->online_type=mhp_default_online_type()
     *    3) add device to bus
     *    4) device auto-probes all the way down to dax
     *    5) dax auto-onlines with system default setting
     */
------

and Non-auto-region logic (approximation)

cxlcli creation-region -m ram --type sysram --online-type=movable
-----
   echo region0 > create_ram_region
   /* program decoders */
   echo region0 > sysram/bind
   echo online_movable > sysram_region0/online_type
   echo sysram_region0 > dax_kmem/bind
-----


I want to retain the dax_kmem driver because there may be multiple users
other than sysram.   For example, a compressed memory region wants to
utilize dax_kmem, but has its own complex policy (via N_MEMORY_PRIVATE)
so it doesn't want to abstract through sysram_region, but it does want
to abstract through dax_kmem.

weeeee "software defined memory" weeeee

~Gregory
