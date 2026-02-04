Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EEA3A784D
	for <nvdimm@lists.linux.dev>; Wed,  4 Feb 2026 18:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770231199; cv=none; b=gSd/4WP1t5vZGIR6rgagTCGlvzvlMquyUjaVa9/IWb1xtnUMuJcm7wrjEgtTUlypulXhgDBwJyXc+q8ntHJzVshQQkjSeqIUChl55BU7P56Hk04pbBeZ4LCw/+Q7LAwgfgpfEjog0K7k5tSqadtxkzPVM0ZMx4lxuOEUTIv2d4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770231199; c=relaxed/simple;
	bh=8NZrnCyGxgIyFgBhQIH24fDsIVh/tj3zfFyvb43nBZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J13MnJJQNDyi5UZKAa14EeAPcRdWYd/ss25kWE1fi5sPTQFje2pPzW+B7qzdgBq/cLp59E8OHYfsYEKcLYhR8jfBCGacMyAjorbHw4W7LAhLMpUGU3a4RgegxPy6nWaL97sS4AwDn3gXFbvpoSXk4KYCLH6MvJc7uBSqFC+w+8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=bJufydoP; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="bJufydoP"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50145d27b4cso1702451cf.2
        for <nvdimm@lists.linux.dev>; Wed, 04 Feb 2026 10:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770231198; x=1770835998; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uzI0FVTkG9+TFoyxK3GOdlcG286KX76a4+kWovvefOY=;
        b=bJufydoPXMsWlatb0aPNW4vVng+oYpVUVtwzXixHKYM7j7uR9J4S6HAy5SlLlGUH/F
         9cD3Rpp3U/Fm0FPxaj5VeWW9klrsN9sTlywRoPwMa8hSAHs2NALK3ZsiStRU4qhXfLm/
         EeDsoSTfFmO5ylPYWcRknlyNLeQvZSpcrFmv2wCM/VY1vbAD03rsrDAwqrx8L0xuwJdO
         6dLIoazOjQURlg/MuMEBpxHB+WRKWm/gLqgIPluIIOPZ1PSHop9OWC5NthQQnewxiOO+
         +J+vDBYqULD6iZVYG1/Z/+meyvif145mvqGaEkoGpFPHw4blS1yZt3P91JGzMF3C2X7v
         uDlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770231198; x=1770835998;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uzI0FVTkG9+TFoyxK3GOdlcG286KX76a4+kWovvefOY=;
        b=QzXzndQlTjsBygZuc8vVv6BMJ04kpZkSkqfTffrDXt4kz1FiRMPei8BJDT7/wyjdTH
         yB8p+rF4cZGl7Hy5Gh8pZRX9H1zHoSBL6HelBMlByUzEYpuQMWZ6RBrrggy42MchrmYT
         cX79Q64BmedR4VqiGbc+ujTkeNhHjiBE7LtHmgNkS35LLGUh8kkez6j0CWkpX6ebMkj1
         CEOmj5Y6lsFa6Pf34D3tZt2gIMJgmjgPgdLOHziFyadBuaQQ2wAAxGG5emQKfSzz75W9
         Q7Jvez5EqHU3U3nmtIqj0rsT4JG1sgIJl+j1ZhU+16CpvZpmr/Ia5c9HRyzXprEzRKx1
         dtdg==
X-Forwarded-Encrypted: i=1; AJvYcCXJfHvgoE5LQ0OZ0HD1TyQjasVzyTTGJSCZjWY+i9q4UMjn57Rkh/S8VN9I4rTfYP6RV192TOc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5pdy1YMXX2t5Mp9z/udFMn1Ym172J0HWESEKJHexd7D0VRNui
	ANbbEqV52HPyZoYdr0lhzXAmQqRKYykFRo+Lzx9SFvUE76ajZ6hdbdE7D9UIRsht26I=
X-Gm-Gg: AZuq6aKnWGJKzHYgado/BKSpvHmky2Hp5eyxhFLgmm4D8t5MbMMwyibQbhyNYQ09Ai4
	3p2qaB8zNC7m39p6oVbZVGvv1N4cZYyYUJpw3B8O00T2V3LIsxmHIf0JqUEE1aB86esPViN6Dgw
	FNSGn0fkc55KBLHMvebCShL1fi3NFECcRzEvqRlYSiu0a3g+hSz+3lGRq8LDBD4IEHSJcCBml4T
	KxV+gKwWUlT76m+uA29j5YcVKOkiObXOEyGROQTj6dIy35fg5s4tGGG8Mv4jsSn7oVGmDPzgdcJ
	HRqtrzUlxmEPT8rytsqZX3qu0uaXDrPRzIZM+MAvl/Mu09/kfPnvPaez48Fdg3yr6vG8L7o3Y2c
	7KARKTgMpLlDWgFHdCbxMoNNJ3ASKx0UFkkvlZ3Yoz/b+6lkHQ1rEjDGK8Jz1ZXjwuX+aY7VDFW
	zNpyl3vo5Fhkr61JM9fR3GhfjnIUiBOuA/tCaLLeQ17WbqO397R2a3KBLkfFsgLcXgOwbXYPwpL
	H2XLIoe
X-Received: by 2002:a05:622a:30a:b0:4ed:df82:ca30 with SMTP id d75a77b69052e-5061c0c6e77mr51937561cf.13.1770231197960;
        Wed, 04 Feb 2026 10:53:17 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ca2fa87841sm244327485a.16.2026.02.04.10.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 10:53:17 -0800 (PST)
Date: Wed, 4 Feb 2026 13:53:15 -0500
From: Gregory Price <gourry@gourry.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <aYOVm6PVfmQdZvlI@gourry-fedora-PF4VCD3F>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <aYEHmjmv-Z_WyrqV@gourry-fedora-PF4VCD3F>
 <698270e76775_44a22100c4@iweiny-mobl.notmuch>
 <aYNh-m8BEiOHKr9h@gourry-fedora-PF4VCD3F>
 <6983888e76bcc_58e211005e@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6983888e76bcc_58e211005e@iweiny-mobl.notmuch>

On Wed, Feb 04, 2026 at 11:57:34AM -0600, Ira Weiny wrote:
> Gregory Price wrote:
> 
> TLDR; I just don't want to see an explosion of 'drivers' for various
> 'policies'.  I think your use of the word 'policy' triggered me.
> 

Gotcha.  Yeah words are hard.  I'm not sure what to call the difference
between the dax pattern and the sysram pattern... workflow?

You're *kind of* encoding "a policy", but more like defining a workflow
i guess.  I suppose i'll update to that terminology unless someone has
something better.

> > - sysram : preferably doing direct hotplug - not via dax
> >            private-ram may re-use this cleanly with some config bits
> 
> Pre-reading this entire email I think what I was thinking was bundling a
> lot of this in here.  Put knobs here to control 'policy' not add to this
> list for more policies.
> 

yup, so you have some sysram_region/ specific knobs
	sysram_region0/online_type
	sysram_region0/extents/[A,B,C]


> >
> >
... snipping out virtio stuff until the end ...
> 
> But for sysram.  No.  It is easy enough to assign a tag to the region and
> any extent which shows up without that tag (be it NULL tag or tag A) gets
> rejected.  All valid tagged extents get hot plugged.
> 
> Simple.  Easy policy for user space to control.
> 

Of what use is a tag for a sysram region?

The HPA is effectively a tag in this case.

An HPA can only belong to one region.

> > 
> > I would need to think this over a bit more, I'm not quite seeing how
> > what you are suggesting would work.
> 
> I think you set it out above.  I thought the sysram driver would have a
> control for N_MEMORY_PRIVATE vs N_MEMORY which could control that policy
> during hotplug.  Maybe I'm hallucinating.
> 

I imagine a device driver setting up a sysram_region with a private bit
before it goes to hotplug.

this would dictate whether it called
   add_memory_driver_managed() or
   add_private_memory_driver_managed()

so like

my_driver_code:
   sysram = create_sysram_region(...);
   sysram.private_callbacks = my_driver_callbacks;
   ... continue with the rest of configuration ...
   probe(sysram); /* sysram does the registration */

Since private-memory users actually have *device-defined* POLICY (yes,
policy) of some kind, I can imagine those devices needing to provide
drivers that set up that policy.

example: compressed memory devices may want to be on a demote-only node
         and control page-table mappings to enforce Read-Only.

(note: don't get hung-up on callbacks, design here is not set, just
       things floating around)

But in the short term, we should try to design it such that additional
drivers are not needed where reasonable.

I can imagine this showing up as needing mm/cram.c and registering a
compressed-node with mm/cram.c rather than enabling driver callbacks
(i'm learning callbacks are a mess, and going to try to avoid it).

> Summary, it is fine to add new knobs to the sysram driver for new policy
> controls.  It is _not_ ok to have to put in a new driver.
>

Well, we don't have a sysram driver at the moment :P

We have a region driver :]

We should have a sysram driver and split up the workflows between dax
and sysram.

> I'm not clear if sysram could be used for virtio, or even needed.  I'm
> still figuring out how virtio of simple memory devices is a gain.
> 

Jonathan mentioned that he thinks it would be possible to just bring it
online as a private-node and inform the consumer of this.  I think
that's probably reasonable.

~Gregory
