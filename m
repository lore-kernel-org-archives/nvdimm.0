Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A062E92C3
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 17:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410462; cv=none; b=H5kH2SF4/r6FuV8YAqoI9j81dwkN5HKIkAKNYnh71sPJQf34nJ6t8xpec1Nofav3i9dW30OBTcKxMaMJLA5mTQZUFy51unTmx8cQOx8hOiEya36Ayb/HHNLwK4AnMOSiqdjh2giWiKoVfIAFDeJcy0GMhIpxcgH/7vaDICtoDgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410462; c=relaxed/simple;
	bh=uQspQgAYPv3Cb8Bx+9DY3tUvsrynhhsH1nDv4+whjaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rjw+L39IlypFc3sJLLJ6DHO7etA8QszkUBtbX8nUaVfq1r6+BOGvL/ryWsmun5mgyMv3rouyIS104HqnDanwJ0IDlVv0mUPFCOstBYL188s50RLN/22AUDEr+vFS6MoKtSo4mUIIl/IHAabytAQRt2pY0vlJbltsL4AIc0NkMi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=BtyO1x3g; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="BtyO1x3g"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5013c912f9fso22200791cf.2
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 09:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768410458; x=1769015258; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8RFOwDQBVEpg9rej94TvEUAdCP3OvqZFUczDhVsj6Jg=;
        b=BtyO1x3g2lktzGu3iRJbVPOet7Gm7p6NReDB2dbdhrFOQ5AB8iJcElYN5pQa3/FwX6
         Z0YmyIwdUtHwHT752mBEChD0fXKQDlFymbxBTcoHwFFY5WE05Bxbe+GAxIkVq4vzBMrT
         BuWOXepmJj/4elVgrEocMYVE7Rl5FlZXFAuGgZkgc9njZ33Z4BDEjZjrmuoDwrRIvA4U
         Hr2Rz2O9aY03YLeIJngquyr/moAGlg2XDYZmXDg216APyai7v7GeXWwnnwcZA66Us0pH
         N1zvVqYkqB1zDv1nxa0rHSYRhzokODmGpBFIsNCdsaDrH60cRaLztY2hcN0I8S7nsC/r
         VP0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768410458; x=1769015258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8RFOwDQBVEpg9rej94TvEUAdCP3OvqZFUczDhVsj6Jg=;
        b=QaZEm9A4ZFPeH+2tJqThtY3PtkJ7FQ495ApnhDManr++hxMMNJf61ixe1n8uJWzBcc
         xfWC6m2FOULJlQS44J/Hh/xLo7Cl588dxhHxT7VWqKiP9IES9axxrCQ51dc0BGj/to72
         rRfengoHe6dg2Tp37UpjvufmnnPOezSIpQU0qxZbi+JvuBXkUp26V6MoeG6TOXyq4CLt
         GjrmeHTQTMwy2P9X6wM4ZJfgIFSPaqAaOcqtMFO6Rznfv0/t6Cq0kgSJe72Kfxf2+YXm
         KXDBrdj/C12MYgPmINGQZwug07BwEKMA7vT9WbcscwF4t1QUwAwRLVlu1hsC645B4GLM
         YBag==
X-Forwarded-Encrypted: i=1; AJvYcCXnhhXx3bh6VYRnhJEP+boo9udsFGqC8EUY43RFAg05Xu+XZm6bloB49BQIDAYdkZX8KrLO4Iw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyfFqEYFY91GUZoA6PDa7YGFBRu/a5/bncSSGcdq3qZTGjKlYEO
	+vX5Grr23iBwY325UPjTmeqLSO4my89tV9g1Bgd89S3Onbg7KTWp4xYV/WAJnvXqsdU=
X-Gm-Gg: AY/fxX7lo9DfF/2QrDL2sMGHH4viwfD9lM8Qx63/avrspLWVOAc6U8DQdF44P8s+kBi
	Xj2iv8PpqIPEI7be1hSE6ryHVDmtykoEQYAwKUIPZD+XioW6pU1Jppk4dy9kqGK8S0+msWyl4Rh
	zg73rONLMMRGt2/ZBgUUwXVQBtqk2/19Nil28GWs87bZKIgnVPfNlTBlFCI/0X0RINdNNl5+Pdi
	im60pvD3ckKFmgxXL2yldm5N7tr1AjDw+SChUvJIlF1NdutqjvVkg+oCo1vO3h8O3oEPBwLxLhs
	Iip/l6427z9KFtskND0kfrKxGh/d7GlF8KSGxxN7m1sL+M7uONyoVN4vBvMOMKI9lZPeQK6E9Ok
	tql9d5HI/Wj9ubVsVdWTxEBhNgbpzniAx7sEGcOaLX4fy9ZatO+eOzUOGdvjmjpD/ELkDv0/OtG
	V+oVdnYclfkdRkxUISHrr7kDE+VYCdETXROn8ZXJ+PDcHPB3g4wd+bAVpPTVCZdKmxmZGVBQ==
X-Received: by 2002:a05:622a:4203:b0:501:3c88:131 with SMTP id d75a77b69052e-501481f8ff5mr39550561cf.22.1768410456999;
        Wed, 14 Jan 2026 09:07:36 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148eccd7fsm17076341cf.25.2026.01.14.09.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:07:36 -0800 (PST)
Date: Wed, 14 Jan 2026 12:07:03 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/8] dax/kmem: add memory notifier to block external
 state changes
Message-ID: <aWfNN-hy64bGw6p2@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-9-gourry@gourry.net>
 <d1938a63-839b-44a5-a68f-34ad290fef21@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1938a63-839b-44a5-a68f-34ad290fef21@kernel.org>

On Wed, Jan 14, 2026 at 10:44:08AM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/14/26 09:52, Gregory Price wrote:
> > Add a memory notifier to prevent external operations from changing the
> > online/offline state of memory blocks managed by dax_kmem. This ensures
> > state changes only occur through the driver's hotplug sysfs interface,
> > providing consistent state tracking and preventing races with auto-online
> > policies or direct memory block sysfs manipulation.
> > 
> > The notifier uses a transition protocol with memory barriers:
> >    - Before initiating a state change, set target_state then in_transition
> >    - Use a barrier to ensure target_state is visible before in_transition
> >    - The notifier checks in_transition, then uses barrier before reading
> >      target_state to ensure proper ordering on weakly-ordered architectures
> > 
> > The notifier callback:
> >    - Returns NOTIFY_DONE for non-overlapping memory (not our concern)
> >    - Returns NOTIFY_BAD if in_transition is false (block external ops)
> >    - Validates the memory event matches target_state (MEM_GOING_ONLINE
> >      for online operations, MEM_GOING_OFFLINE for offline/unplug)
> >    - Returns NOTIFY_OK only for driver-initiated operations with matching
> >      target_state
> > 
> > This prevents scenarios where:
> >    - Auto-online policies re-online memory the driver is trying to offline
> 
> Is this still a problem when using offline_and_remove_memory() ?
>

I suppose this commit more than the others is actually an RFC.

DAX might not want it.  Other drivers might.  Now at least I have the
code to do that.

> >    - Users manually change memory state via /sys/devices/system/memory/
> 
> I don't see why we would want to care about that :)
> 

Absolutely critical if we have something like a CXL DCD region that
wants to try to protect hot-unplug.  But that is probably an argument
for implementing this in a cxl region driver than DAX.

> >    - Other kernel subsystems interfere with driver-managed memory state
> What do you have in mind?
> 
> Not sure if this functionality here is really needed when the driver does
> add+online and offline+remove in a single operation. So please elaborate :)

See above - so yeah I'll probably drop this and come back to it in the
sysram_region driver in CXL.

~Gregory
