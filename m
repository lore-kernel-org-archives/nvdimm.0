Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633351852
	for <nvdimm@lists.linux.dev>; Thu, 23 May 2024 02:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716432573; cv=none; b=RE++p2uxpxEVWSWryqSTYynavrddk0I+Kudl29Re+0vDmYpY4Ad9W9Vj1AcgGIqhZRCSu6yWychefTPvyzRRhHTR0X7Fg8mB+Dv5v7Mf19CO403svCYL0vcYy6ab60VMw+/7eAaQaU+Q5KUvRy4R604xPdiR5v+DwYf8mza5B30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716432573; c=relaxed/simple;
	bh=SL3rqfkHSw5QxRujDLLLkJv7+VRn3353omQIkm9bpaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iheFiQ9bkE8wyA6HFsjkbg21kQlTFH7HT41WmZ7Et+jbrqdSNIBNPTM1QyERQ2eSUlBHne9L5qtXkgWl1JYbJzBz7wnjXCeFuiEG/suaZV7Byqx+SQN2HMDOt2mh4TnffgI8xEZFwvvT4UIPL1SrMHuON4IaZBwEfuy6RsX4oIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ObTVPb2W; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ObTVPb2W"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5b27369b0e3so3766498eaf.1
        for <nvdimm@lists.linux.dev>; Wed, 22 May 2024 19:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716432570; x=1717037370; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nAW4PBEZpqdUqGs1sPsnAjNoBP69IHzEf0qSsxT3opw=;
        b=ObTVPb2W4kvPsGFNMWzU+mC746qfqwIQK8G9YvUyRN7EffD50JK0V3afZLSnkslvbV
         Za4GZyUvNpVg3KQeuB7/09KWmXT06uofj42uYrj8yvlIG0LDzp9hiR/eQVRbiMuV3CrU
         0NWj75OjAm5CzQQsA12BhBy4YYTWF6TPqW9j3m9Cp/7bM+4ko70D3d0leY4ZoKiaLLW6
         Txnmp+vG8luBAOauWaQGMSD19uxUECEIgam7Yp9ukaf94BFCRgPpvvbBINoQzyM0OuwP
         VI9vkL/+SIbviqqAL0poNRYFG+012d2n2NGMIM5oUU3Io74PwMmTiOlX2IBb9NrdZec1
         Ft/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716432570; x=1717037370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nAW4PBEZpqdUqGs1sPsnAjNoBP69IHzEf0qSsxT3opw=;
        b=nFo6pcZYdKwRg3ZD/CFcZcEYJvnR0XpB+d1cD1l0Yu5/SWdKsZeRhNQI9eVHSLCyzB
         xJLdgYJyl0PuivqpwOGMKyWZUC3WOkBjMCWYNSAHTgVl0HZHorUqQjfiibAlCGPFdsVc
         cEyBsqbFdEZbrNQSUJf33C2g97KsXf3f6uOzRcDfkhVEHgEuSYVdXoHXuWEDZ9EJ8eiW
         DjfQt2Ee5J2RKxdE18hdhPVXWIyDmq6nMR+oGXYaQicAQhbreDjckq9aJ2efVCzRkd/z
         T4H7zXAoRpbOIA/ggyYpCfAhC3U7yiDLKXslU9ZMwRRGiazSpzkNxBqFw+uxXY8AtpBS
         V4NQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZzmVk65Wg2QzwV1FRAPESa/xoE5gveYo7MRvhc4CFYoAC6RdFOmb0+8Zdmjr9xAc2o+8DB9UlHcSrxYVNqhGfCJu4Mqoi
X-Gm-Message-State: AOJu0YxDf/mueq0NCD313GH0/evmGjSyqqToshPmLwu8rNinKoT3cgMD
	gzmibSbq35pbujv3eQZ98CDALKs3wlljAGY4Dym6k/xpH1K2WLM/
X-Google-Smtp-Source: AGHT+IFZM4618nFwqVkK9hEvO7dFkY2TwgL+KO3fo91K9CM4WoqimHvtumIPolCf2ZrznSU8xU8dog==
X-Received: by 2002:a05:6820:618:b0:5b2:ff69:97c3 with SMTP id 006d021491bc7-5b6a0c0eb82mr3862417eaf.2.1716432570365;
        Wed, 22 May 2024 19:49:30 -0700 (PDT)
Received: from Borg-10.local (syn-070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5b5158a3bffsm2194203eaf.28.2024.05.22.19.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 19:49:29 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Wed, 22 May 2024 21:49:28 -0500
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	john@jagalactic.com, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, gregory.price@memverge.com, 
	Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 00/20] Introduce the famfs shared-memory file system
Message-ID: <l2zbsuyxzwcozrozzk2ywem7beafmidzp545knnrnkxlqxd73u@itmqyy4ao43i>
References: <cover.1708709155.git.john@groves.net>
 <CAOQ4uxiPc5ciD_zm3jp5sVQaP4ndb40mApw5hx2DL+8BZNd==A@mail.gmail.com>
 <CAJfpegv8XzFvty_x00UehUQxw9ai8BytvGNXE8SL03zfsTN6ag@mail.gmail.com>
 <CAOQ4uxg9WyQ_Ayh7Za_PJ2u_h-ncVUafm5NZqT_dt4oHBMkFQg@mail.gmail.com>
 <kejfka5wyedm76eofoziluzl7pq3prys2utvespsiqzs3uxgom@66z2vs4pe22v>
 <CAJfpegvQefgKOKMWC8qGTDAY=qRmxPvWkg2QKzNUiag1+q5L+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvQefgKOKMWC8qGTDAY=qRmxPvWkg2QKzNUiag1+q5L+Q@mail.gmail.com>

On 24/05/22 10:58AM, Miklos Szeredi wrote:
> On Wed, 22 May 2024 at 04:05, John Groves <John@groves.net> wrote:
> > I'm happy to help with that if you care - ping me if so; getting a VM running
> > in EFI mode is not necessary if you reserve the dax memory via memmap=, or
> > via libvirt xml.
> 
> Could you please give an example?
> 
> I use a raw qemu command line with a -kernel option and a root fs
> image (not a disk image with a bootloader).

That's not the way I'm running VMs, but... I presume you know how to add
kernel command line arguments to VMs that you run this way?

- memmap=<size>!<hpa_offset> will reserve a pretend pmem device at <hpa_offset>
- memmap=<size>$<hpa_offset> will reserve a pretend dax device at <hpa_offset>

Both of the above will work regardless of whether the VM is in EFI mode.
The '$' is harder to escape through grub; and the pmem device can be converted
to devdax via 'ndctl reconfigure-device --mode=devdax...'. A dax device would
likely also need to be put in devdax mode (as the default seems to be 
system-ram mode).  

Incomplete documentation (that you have probably already seen) is at [1]

I can dig deeper if needed.

Otherwise the feedback in this thread makes sense to me and I'm planning to 
start hacking on famfs patches Thursday. Watch this space ;)

Regards,
John

[1] https://github.com/cxl-micron-reskit/famfs/blob/master/markdown/vm-configuration.md

