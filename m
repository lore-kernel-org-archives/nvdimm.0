Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225FA43AA4
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 18:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768414342; cv=none; b=SHZFBoiy9slv4t2sa9Gpg5bc4kO7Oh+WHAWRSk9Qrsud3Kdb+o4ejHAHsBhM/BP/cwoa87qZvW4BLUdO/5oRjLy7C4DaiutuEUejF3/GTDVJkXNAfZBdcTDirYO8qOo0SHQN58eJThaPjwOkf5S0RpEjZ56LoBVcfgV17/gdo6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768414342; c=relaxed/simple;
	bh=Ludne4UyCmokfcKLruO0U5b344CQHhAN/3PEM1PYEik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0nOz1mNUNbIOEzRflz3vlEg9K+dnWQt3UakaMrRtAlpIVo3Fb9OKGSNDLMgfhCLK/YkeDA/VgCE1g/nRo4TelSSm4kpkrdKecGeBdb8X/vB0aH3CDAcMLkpc5hWP/J0EbPVoZO2OeEo305CLSxbafG5AHt/qk0DaTKMd85c3YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=qjTSAqbE; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="qjTSAqbE"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-88a3b9ddd40so232076d6.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 10:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768414340; x=1769019140; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MfgGnc8yYPLi9t7dHOsu001XcSCAHL7N89lmWN6W/2k=;
        b=qjTSAqbEmlU3OGHqjvZEqAZPUipd+VEjYtq8UoP+tbKupfm0U4aDzHM50iuwqZBgaH
         Cx8+8H0+CztoILYyozuIQiL0yme/ZsytvfDMJnetjydCYUt8fdY7z8FgoERvVlUKKEGp
         KnYaPZ7rI3lEoB8tj8hKez7Nw445/QkHkD5NX+D3U6A0tvMOG3tbzFyIyyoTsbLnEI2l
         6i5rBWGqzITASFbCcKNQ8et23cLd2csUQY4B1+Pp+ScIKFPUkfxwfZgeR2XdW8bdE8Pi
         IPZpTqLUBcVd3eG0dAa7rDGVlJum+0usCyM4+Xvp7S2RiAFvYRCFpAhzmPlMEsN+Tk7r
         4tBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768414340; x=1769019140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MfgGnc8yYPLi9t7dHOsu001XcSCAHL7N89lmWN6W/2k=;
        b=Wy0XJL2yvupNf4TTFOfqdgv9+7EJllrZeXhgwLyjFi58S2XL+Tn5em24Up5qOEAstO
         736iUvxE0Oza5WdiLTmbp9/HRuQPZkri5BSa3lRYFv923TFc9PAT7U2xP56xzOKgV/rY
         hfNAJR8SRfFHHIP8xIACxcEG8WlY9QoIUkcxHMt/wH2i1t+AFSHCRgpBudIuHt7LPALJ
         ivjWMRLuPHpD5wiEtpNt8Hgjcs/V5gEIqH/6nYUQW35k5oA6nUd+bZdniPdx3kgWNAHy
         2aDGh+3lI1LTF1Eq0vr45NTXcT35OCX5sBbvjFwhFIChNKKi7BC5qD+0Rvsfyvmn63gw
         7/2A==
X-Forwarded-Encrypted: i=1; AJvYcCV8gHPWjkpQm4PMnYQ1FCifEP7qHRuY/lxYfy0ajxlLsAP3xbQDZe+6SE3Vq49/2jaAP8r0Li0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8S0evNmOSsYwHes3JrWehSCM7Ebt8Q/A006+N4xd6myz1sEvw
	eJI589jUUk5c/uwIuyIS4UrNdWavSgLXOkJ1I8l4+9+S9h/QOGnMWXU01CHUzL3dwRI=
X-Gm-Gg: AY/fxX5dZbgAZGbxFm6Txog/9rT+3nXw3lbPEExYKXiDd9xvJZuVgwnbjDyNnnk3o0e
	Pv5Uw/wemu+/fUd5jfxZ701rOJibIUAqAZdy3N33ByWi4ti+j7BhO1VlLkQSJ7HxQ4enGjOuXts
	t09ENkjp4Ivc7v8XygaUy1zCXEplUKgPlQqSL3JId39Nibs2CGeGqvzA1ifdeO/Dit9YAwBO/34
	W0uL7iBHO/xZWqkBYlSIKCYaj21Lr4/4rgdhfe/IRrHv/vYVJYbXzX8klDVeqBIhizdVT4X5MK8
	jfySb3NkMGvqUyL44TtFcsqpRJV35iB31HS3oLFHee9GvDF5+fXkKMsgWNsrtMmRZwgPCNrM3W9
	6/J6N7mscLuy0IrsmndBkzDP1rnSuy+ggFjDN2zX9isA9nYIt9r/3oTiSRMRkkTV0X3gbgoBVG2
	r1sCTP9M5ErBIKff2oXYi8fSdX/MQ+6XdKkVcNuiESqrO164LIybJEqttWqz1I2Bf5S5JIlA==
X-Received: by 2002:a05:6214:10c2:b0:785:aa57:b5bb with SMTP id 6a1803df08f44-892743cfe92mr35226416d6.43.1768414339907;
        Wed, 14 Jan 2026 10:12:19 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770d17a3sm181634186d6.9.2026.01.14.10.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 10:12:19 -0800 (PST)
Date: Wed, 14 Jan 2026 13:11:46 -0500
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
Message-ID: <aWfcYjZVrROHfGyh@gourry-fedora-PF4VCD3F>
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

After a re-read of the feedback - are you suggested to basically kill the
entire offline state of blocks entirely? (e.g. if a driver calls to
offline a block, instead fully unplug it)

I took a look at the acpi and ppc code you suggested, and I think they
also have "expect offline then online" as a default expectation.  I
can't speak to those users requirements.

This would definitely break things like daxctl/ndctl, but maybe that's
preferable?  I pointed out that patch 8 does this anyway - and I'd like
input from ndctl folks as to whether that should end in a NACK.

~Gregory
