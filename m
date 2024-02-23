Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512D61EB52
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 19:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708718207; cv=none; b=aklVokhgzUk494N5kWHCtobec+ARDD0Vjo9tNowNlNtJJcR4aZpxQvFMNh3yEraD1XChUavn9/iu6yzUJ2Cyry6joZcp5Ib+9ZPk+8hl9RMauJbUkIBmYCHc3TCn9UOSfUbGv1e2TfK07e0VVIRrjcyDT6xAGh1gcqo+5I8JgFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708718207; c=relaxed/simple;
	bh=V5uXT1I1WxLZr1gVzh31tRJlTZrs2HDa7enKzhMqPFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o2rULxQ2sPusbVDmWD1dFyU7f+T1AeNR5ZNrzUpE/Qax6Ob4QwB3zo5+UUkGqrMO2EUmUrhQlgrOOsJNfBMaF2ZNuovwyS+de+rhyL/AiJLPg9smc3GGBn4Eb2IedmDlX+cmNZUeo1hfCQsmxL7qWFwC/jxPFetqnKHUenLRNIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZGyBcRyu; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZGyBcRyu"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3c0d59a219dso866005b6e.0
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 11:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708718204; x=1709323004; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Smi/Sp7XgkONWFBICEY7Pi/t1Ktm49FpndchyfXCKuA=;
        b=ZGyBcRyuiWbQoR7OtgDA9wOVlRhqWc1HWarvxm1t3+w/QoY1u8eqf6zJMR6YZV5omh
         msjb5YCfFoKCTylA1rHg/AGVFSc9qVnvqZhgnrgPuKgMeMCVpCIX7CiqVS3IDvrBwPvy
         7ZwCol0bBD9shjGmGMO8g6WODGEC47vmfGrMxo60uFVCTobx/MPFZ8ZUGcYaUE/7clpo
         Y11Busnbx3tg3PP7tHsk7mgoV2a1x77OMjKpNkU4i1XF2qRG7BtDstARX9etlqsnejSU
         U7/EmXJap9hI6pU5075gOb86ur3pc3OzQ43cEJ70L25C4JU4+YfrvPqd3R/Zk2kF22un
         njdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708718204; x=1709323004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Smi/Sp7XgkONWFBICEY7Pi/t1Ktm49FpndchyfXCKuA=;
        b=nSwB8Mrr0XfAyWIUx7ZhqV6GnIgwoR1w3ublwQjFpo7pSInsVQBuiLQJU0AGh9cEtB
         JXN5AT3HTGwozmxL3w6FyQV6z1mzgkyhhl2i9eShIx14XSG5ZnJgqasgQsEVqciTLO6J
         GMyq7X2Cy7nLyAaR1z+LgECRwWwB8OQVpLJHk1mGPYioin+8M/WUfv0OJtLE3PaLQFyd
         pC3kfkmnmdR7s5MkJm4agpbVCncUSeWM4ESsGi6WvDitn7/OzTflPPh1I7z/Qjsue9hu
         atZVwGEFCuycGw0dvrn28J8HixqcYCtNMsCKDMVkX3W+H67sRVHBcM8HieHtNZF3YDeI
         L9Vg==
X-Forwarded-Encrypted: i=1; AJvYcCUAiSAJuhAgDAjaYW3wVWXJCyLbn8Muld1uDtuDJwMfKCk0R4Bk6X+AGhsUYBvQIuj6vNo5NgFG25RL1y7V94+IdVR9zgZH
X-Gm-Message-State: AOJu0YwK3E1TyYbT/XPabYglYc6UeyG9Nc7Nb9qASwFsWfTHqIxFazfw
	982PAr408WyNctn+H2WYucJqeAmV83PuBdWaXUcxjEFF6bHExRdg
X-Google-Smtp-Source: AGHT+IHv5O7Zzjo9iR5rZ4wp2Y09L1nqF5uadiqzZbbKIzO71izmp6TPS4UCh8sTcVQ34stK3LQaXA==
X-Received: by 2002:a05:6870:b250:b0:21e:7a1d:b4ec with SMTP id b16-20020a056870b25000b0021e7a1db4ecmr939717oam.7.1708718204401;
        Fri, 23 Feb 2024 11:56:44 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id gq19-20020a056870d91300b0021e8424e466sm3680600oab.25.2024.02.23.11.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 11:56:44 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 23 Feb 2024 13:56:42 -0600
From: John Groves <John@groves.net>
To: Dave Hansen <dave.hansen@intel.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 16/20] famfs: Add fault counters
Message-ID: <l66vdkefx4ut73jis52wvn4j6hzj5omvrtpsoda6gbl27d4uwg@yolm6jx4yitn>
References: <cover.1708709155.git.john@groves.net>
 <43245b463f00506016b8c39c0252faf62bd73e35.1708709155.git.john@groves.net>
 <05a12c0b-e3e3-4549-b02e-442e4b48a86d@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05a12c0b-e3e3-4549-b02e-442e4b48a86d@intel.com>

On 24/02/23 10:23AM, Dave Hansen wrote:
> On 2/23/24 09:42, John Groves wrote:
> > One of the key requirements for famfs is that it service vma faults
> > efficiently. Our metadata helps - the search order is n for n extents,
> > and n is usually 1. But we can still observe gnarly lock contention
> > in mm if PTE faults are happening. This commit introduces fault counters
> > that can be enabled and read via /sys/fs/famfs/...
> > 
> > These counters have proved useful in troubleshooting situations where
> > PTE faults were happening instead of PMD. No performance impact when
> > disabled.
> 
> This seems kinda wonky.  Why does _this_ specific filesystem need its
> own fault counters.  Seems like something we'd want to do much more
> generically, if it is needed at all.
> 
> Was the issue here just that vm_ops->fault() was getting called instead
> of ->huge_fault()?  Or something more subtle?

Thanks for your reply Dave!

First, I'm willing to pull the fault counters out if the brain trust doesn't
like them.

I put them in because we were running benchmarks of computational data
analytics and and noted that jobs took 3x as long on famfs as raw dax -
which indicated I was doing something wrong, because it should be equivalent
or very close.

The the solution was to call thp_get_unmapped_area() in
famfs_file_operations, and performance doesn't vary significantly from raw
dax now. Prior to that I wasn't making sure the mmap address was PMD aligned.

After that I wanted a way to be double-secret-certain that it was servicing
PMD faults as intended. Which it basically always is, so far. (The smoke
tests in user space check this.)

John
