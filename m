Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF66B214A96
	for <nvdimm@lists.linux.dev>; Mon, 31 Mar 2025 18:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743445662; cv=none; b=mNcXza1CvDnXymV+SHhcRO6BTGlPFqocHsE8UuWArNhvLO0WNJ+HRcAYUl8W+rI0NhE98qRz6/hOX1PnWubPOMnukkJMZGXmfyEReB/6B9NBiGjRd2V+rOSFs8yXcyLjVp0WPoRCrTafstrsZnmhywKxSVKMQeb+bNw7i5kzaoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743445662; c=relaxed/simple;
	bh=zRT/zRjU6jVJSZn+qcLAB6z0VYtkrXkjOuI/iNaf2A0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AqtPwJwm1imDoMDY7Y8RZiJcGOjXrWQTwQBr4AURwp61yX/AyAJ+OFzgFaQtv4Nvxj2fjoWRoDgqRqtlDTvwDQOgQIVEcTh2cwFqrEi3EnO3k7R3NTemfWNH0cT7sjyJLM4tBb2jiQ9mBETjDPXTFS4r2GXt/WBpm0Aj9tvua6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Sio9TkCq; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Sio9TkCq"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-476f4e9cf92so35545391cf.3
        for <nvdimm@lists.linux.dev>; Mon, 31 Mar 2025 11:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1743445659; x=1744050459; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LZeAYSY+ZaMayGoTv0WvIa7xoyxPKFeQjfsqEI/he9A=;
        b=Sio9TkCq5zayIK54Z1//R2i7UkzIkU2LHFR9r1RBEG6kgTty25xHvHklTRoMEgdvgT
         AYQ984fCmH/KIKs3bMZUsy0L75gW1tVOIkKoOvLR6MwViNEd3WAt/yatWXjxvb07GBXm
         3jSL/jjxtbinvOrZP5JVEpF9O72rwZGy6ukmw4YOCxc3o00IkkeM3uRktrAAA481UKV6
         zpwtLUNQgakrmVgRiHWoaNjoPfp0NLdr19fMUUQoSkZB9ocPiNrqPZsbr0mwf9ffu77+
         p8Rz/TbEn8AmzcGVzg5crNVCLqi1yy88SbScxK4aUCGYWaENjU3JO7+xiX/In3CmoC1U
         za1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743445659; x=1744050459;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LZeAYSY+ZaMayGoTv0WvIa7xoyxPKFeQjfsqEI/he9A=;
        b=hReXE+uxvzMx+EaZ0Rg0eXPJDguH3XlUd1ZwKefcTLEnx3ESYI79HAGC4mylZtW4TQ
         VWummOhG7GF3kKVk7u6jidhXs7cR0aFWjBmEUaP4jaJAfTcY5SXNYS9nE8MJM4jik2pE
         H6AnjO2aV7Ivuk8Y7MEtLuecnO+cJdUaIs+KHH5GC/SinoqRV9lIDprjdwarVsrN7VUV
         7I119Vl2kmRdfqUtxiwK2YHX/9AKZdGiULC4ho7CC/zIki3XmOL5d8fABKTKDNHrwXSD
         KmhZ4NvR2fiRtycXframTNVJhke2V5YVasK3JAZ5ioIcv605ZRJME8apR2JDnFkQc+3t
         z6EA==
X-Gm-Message-State: AOJu0YyngUtPIuPTt5gCi4A+XImIHl+RsAwrwX77I4DsAwYXVm99zTUz
	uA5pQewWCxRofItwr7olZYdIUmR6acx1EmbTmJhsbf0MplsyfDqIHzEW2FxvqIQ=
X-Gm-Gg: ASbGnctF94RMFQaalgXyNqpzzLpyng1mEFn94JCRaWuygvUaQUqqqkumD4UIVQ9oQ7H
	eKNt4fdojDp6H8sj2Dn3rq3uaDTHGWtlEtELVCsGafUWzeowXthm+iUP3CNlTTogB2TgS2twrBB
	rggCfoQRmhR6vu9iExSiURs7SeCVz0HZzWMUO5tLGf7PHqahmBLiUV9oC3QdnstYRFmzyYCsjc0
	rQgx5X0gVRvF2drTBX8JASX90aHZkBucCc8OAAwjGTVoFbwQXdeDe+LX23CMOhuYY6g+U4c//Io
	qV4MfAkEzDS4r9oJ9xdv81p99NWPPuPeD1i3WmwI7GWyJU+rOhKh9zEUqmZJzOBxPtitWjU167A
	XvQ6QgcyArVgUMeMYZL+hy64A6Jg=
X-Google-Smtp-Source: AGHT+IEd+3g87j+NE/c3E2rg8hxwNLiV/aqryel6Odt64jpWEXnougpu8f4ZHVyaNCsH9/emYY2gMw==
X-Received: by 2002:a05:622a:291:b0:477:7007:7055 with SMTP id d75a77b69052e-477ed7c96cemr130037061cf.12.1743445658865;
        Mon, 31 Mar 2025 11:27:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-56-208.washdc.fios.verizon.net. [173.79.56.208])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-477831a4446sm53218521cf.80.2025.03.31.11.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 11:27:38 -0700 (PDT)
Date: Mon, 31 Mar 2025 14:27:36 -0400
From: Gregory Price <gourry@gourry.net>
To: dan.j.williams@intel.com
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	linux-cxl@vger.kernel.org, david@redhat.com
Subject: Re: [PATCH] DAX: warn when kmem regions are truncated for memory
 block alignment.
Message-ID: <Z-remBNWEej6KX3-@gourry-fedora-PF4VCD3F>
References: <20250321180731.568460-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321180731.568460-1-gourry@gourry.net>

On Fri, Mar 21, 2025 at 02:07:31PM -0400, Gregory Price wrote:
> Device capacity intended for use as system ram should be aligned to the
> architecture-defined memory block size or that capacity will be silently
> truncated and capacity stranded.
> 
> As hotplug dax memory becomes more prevelant, the memory block size
> alignment becomes more important for platform and device vendors to
> pay attention to - so this truncation should not be silent.
> 
> This issue is particularly relevant for CXL Dynamic Capacity devices,
> whose capacity may arrive in spec-aligned but block-misaligned chunks.
> 
> Example:
>  [...] kmem dax0.0: dax region truncated 2684354560 bytes - alignment
>  [...] kmem dax1.0: dax region truncated 1610612736 bytes - alignment
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

Gentle pokes.  There were a couple questions last week whether we should
warn here or actually fix something in memory-hotplug.

Notes from CXL Boot to Bash session discussions:


We discussed [1] how this auto-sizing can cause 1GB huge page
allocation failures (assuming you online as ZONE_NORMAL). That means
ACPI-informed sizing by default would potentially be harmful to existing
systems and adding yet-another-boot-option just seems nasty.

I've since dropped acpi-informed block size patch[2].  If there are opinions
otherwise, I can continue pushing it.


We also discussed[3] variable-sized blocks having some nasty corner cases.
Not unsolvable, but doesn't help users in the short term.


There was some brief discussion about whether a hotplug memblock with a
portion as offline pages would be possible.  This seems hacky?  There
was another patch set discussing this, but I can't seem to find it.


I debated whether to warn here or in ACPI.  This seemed more accurate,
as platforms could simply over-reserve HPA space to avoid the issue.

Thoughts?
~Gregory

[1] https://lore.kernel.org/all/bda4cf52-d81a-4935-b45a-09e9439e33b6@redhat.com/
[2] https://lore.kernel.org/linux-mm/20250127153405.3379117-1-gourry@gourry.net/
[3]https://lore.kernel.org/all/b4b312c8-1117-45cd-a3c3-c8747aca51bd@redhat.com/
