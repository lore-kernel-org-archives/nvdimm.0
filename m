Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C791448DE
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 20:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708720753; cv=none; b=HNfSRbxjSVxlWNVZTxjWl1EZVROp7j7dkviJnQRFD0cpGhGHSQosIB+2K5iZyFWnl8BsmG0x921Czg9xgOPDQ4Wrmik1fUSOoVKxNpDy9Ccr1EN4ma6kpu6xbHLB7fe0elOU2N6vEJauE+I65NHOPicRljZUCjGYsp5yJAoYEnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708720753; c=relaxed/simple;
	bh=CWvz0jJizpnSo4+DoPe5JFFbeGIyISNG6la+TKtI1kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nWm9dhpplG6UkV80zw4qEkE4dVDDlDtp9EHirN2CwJKnfMcTd1EedfMrr8NAVOPH3RCq27i5UZhPvTtDJ/jaUMnkpcVHH/tQMZ9rH6LLc809Cf44jw09o5nav2oXShAe0Ffd3ZhFPdPIdR1XkLPTvQlf3shOUFkGpVDLJrc56d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X097Rl8i; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X097Rl8i"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6e2d83d2568so866344a34.3
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 12:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708720750; x=1709325550; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6rFejooLE94dTKXiepySeCh8pNdPgmcVv6PgnIh1W7c=;
        b=X097Rl8ir85pJIf2ctgu0rM+L2c1vekpW+9tqN8Xd3JLcjvRfxioChmN1JF06czgvR
         YOEFy8yPafKNSfuNCQ67OxSn82sB5QJ9IgnyDAJKWcSpV4sYNJ57wT56ZpYNJ2RFkJJe
         FkrNla6J8O4N1EmFocJNgYjL3WVL86PjU3ZI44guX5FAr4SLhwEZR0LnWx8X9+GcT2ZU
         IivDQl0l5TXEyrxhxrYwZSfsaAL4WT/Us6vAZibUUseCSlIJu6XbWtBmq24aF3I/kBKF
         Z7DAjOHqEt1OVzAfhbzoD1eQPty7l1JnF3c21c6lWP7ELpKBPqxthz0Ke2lCrSo4lMXY
         dXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708720750; x=1709325550;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6rFejooLE94dTKXiepySeCh8pNdPgmcVv6PgnIh1W7c=;
        b=bwAtpI1ZBVpzQjnobL+UppzAHrg3W9eX3NFB2qgrlLvkeDfZTC6mzj3Hy0KInANIw/
         vpgmES2IOO9au6m/Q8UpbssDHbXXPZj1aosPDvgxWYfSklZUub/hd0E+hF6QdP1Fw634
         A1k4wNLh6i/ksaKT1CfLuV9Jt4kGWSEmwsiqB3vIlpUQErP2y/Bvn6YUgViDyP+lSgsF
         yZ/pig0pJ8MRYgU8mNQtGB+I0HfDXvl799clTDwJx22ISZydj01/iWaSqhmFrDK9KX7y
         R7Jq1fIP/5Eq/n6b8D03ZrOh2UrShQbG0qM0LjjdFzfpvic6LSKGZg1I4g6e3pa1o9JM
         qdbw==
X-Forwarded-Encrypted: i=1; AJvYcCU/iDl81AXfg15pYifWtav+s/SRvCqTV/46KeFStfvfdFZ9Y9TIUjVLxknxUz/J4SSmmwjGhSXb85krNY4YFwqct8xqPa20
X-Gm-Message-State: AOJu0Yx0Jw6+VDfyQpgHi26o7B1820QUXo7wQA1Q246Xxxx2MhilDZpL
	wVcfPVa0E22MrQEbHHU7b2g8an3gB+Ij/FC8GRiKNeSdJks+E3uY
X-Google-Smtp-Source: AGHT+IHvVNjrfcKrmLp8J0RHHmkEdU6tIRc8D27FoJrKa2C7ggDQBJLV2BHA5c/4pF95RMFRkW2Ryg==
X-Received: by 2002:a05:6830:18e6:b0:6e4:8cb4:b4cc with SMTP id d6-20020a05683018e600b006e48cb4b4ccmr252402otf.1.1708720750269;
        Fri, 23 Feb 2024 12:39:10 -0800 (PST)
Received: from Borg-9 (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id ci3-20020a05683063c300b006e4878962ddsm193629otb.12.2024.02.23.12.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 12:39:09 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 23 Feb 2024 14:39:08 -0600
From: John Groves <John@groves.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 16/20] famfs: Add fault counters
Message-ID: <ytyzwnrpxrc4pakw763qytiz2uft66qynwbjqhuuxrs376xiik@iazam6xcqbhv>
References: <cover.1708709155.git.john@groves.net>
 <43245b463f00506016b8c39c0252faf62bd73e35.1708709155.git.john@groves.net>
 <05a12c0b-e3e3-4549-b02e-442e4b48a86d@intel.com>
 <l66vdkefx4ut73jis52wvn4j6hzj5omvrtpsoda6gbl27d4uwg@yolm6jx4yitn>
 <65d8fa6736a18_2509b29410@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65d8fa6736a18_2509b29410@dwillia2-mobl3.amr.corp.intel.com.notmuch>

On 24/02/23 12:04PM, Dan Williams wrote:
> John Groves wrote:
> > On 24/02/23 10:23AM, Dave Hansen wrote:
> > > On 2/23/24 09:42, John Groves wrote:
> > > > One of the key requirements for famfs is that it service vma faults
> > > > efficiently. Our metadata helps - the search order is n for n extents,
> > > > and n is usually 1. But we can still observe gnarly lock contention
> > > > in mm if PTE faults are happening. This commit introduces fault counters
> > > > that can be enabled and read via /sys/fs/famfs/...
> > > > 
> > > > These counters have proved useful in troubleshooting situations where
> > > > PTE faults were happening instead of PMD. No performance impact when
> > > > disabled.
> > > 
> > > This seems kinda wonky.  Why does _this_ specific filesystem need its
> > > own fault counters.  Seems like something we'd want to do much more
> > > generically, if it is needed at all.
> > > 
> > > Was the issue here just that vm_ops->fault() was getting called instead
> > > of ->huge_fault()?  Or something more subtle?
> > 
> > Thanks for your reply Dave!
> > 
> > First, I'm willing to pull the fault counters out if the brain trust doesn't
> > like them.
> > 
> > I put them in because we were running benchmarks of computational data
> > analytics and and noted that jobs took 3x as long on famfs as raw dax -
> > which indicated I was doing something wrong, because it should be equivalent
> > or very close.
> > 
> > The the solution was to call thp_get_unmapped_area() in
> > famfs_file_operations, and performance doesn't vary significantly from raw
> > dax now. Prior to that I wasn't making sure the mmap address was PMD aligned.
> > 
> > After that I wanted a way to be double-secret-certain that it was servicing
> > PMD faults as intended. Which it basically always is, so far. (The smoke
> > tests in user space check this.)
> 
> We had similar unit test regression concerns with fsdax where some
> upstream change silently broke PMD faults. The solution there was trace
> points in the fault handlers and a basic test that knows apriori that it
> *should* be triggering a certain number of huge faults:
> 
> https://github.com/pmem/ndctl/blob/main/test/dax.sh#L31

Good approach, thanks Dan! My working assumption is that we'll be able to make
that approach work in the famfs tests. So the fault counters should go away
in the next version.

John

