Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280CF3093B4
	for <nvdimm@lists.linux.dev>; Fri, 15 Aug 2025 16:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755275887; cv=none; b=Q/dT4QE14cv8euFDHJtAcfDhxWpTO5HNX3bDWyFIDZPx9adCPaRr626+yV+5k4ea4qSUCJZh9BlarGcviG1+YZtK0+JOvVLt0+Ihqh0XQCg+SawJZJw/hPCQNqRf30yAz3w4EafkvCgwfLWSuGmgra7NcGwNTX7oBvy+uJ/v7TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755275887; c=relaxed/simple;
	bh=wvKG9q6ho4RgZrrJIdGv5TeB043vsJ7FH5BLK3VX8eA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SN7PFrd+hV+N58DH5PHX3QtsVD/7ziim93aHLRTRfIszyMZyZhZKUrqnzhexqxSgwYOMsulChwvLwqK+Y7zSvwyj6fmUgat2CFVqjDSO3iot/tdbHXOVSxp+a1rCOZlDcE3a+msK4SQM3iRVKUfDTBFyJZjAFrsFCE5jsVNhUcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SeaT1J+u; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SeaT1J+u"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-61bd4eaa7adso446474eaf.3
        for <nvdimm@lists.linux.dev>; Fri, 15 Aug 2025 09:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755275885; x=1755880685; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dsMGeBFSMhVbn3vuzD+PKSwFX2QkoR6dSZaKAtY6lT0=;
        b=SeaT1J+unF0RPwV3hy+KiAvDBakEZZ/McsEkocE0e7O3Ce90b6rNXOv3A1wSFeySLF
         RTTJHUW7OnE7foyPDnGFD2GRF/pmUhzRqcwHTdwnBa4/fDExzzhNc2krbLp57K8TE6mo
         IA4fYCZ7fua/5M61g17RV3r7LW+nr10mKvL9NmTRU9cS2TiaWKuRrGzdk9JYEvEH3kzz
         UJJXoD5FOG6SNF80yuQrH7cAD8hfcKlE1XQgoHSGqUQvIgaC6/FmCzydam5fJa3xSxhU
         MYe1AZC4f104W5JRaZymzShPEdEV2c8JFTzGvgET0Y4USs6lphCemqwbNXgCT1F/YzGR
         A/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755275885; x=1755880685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dsMGeBFSMhVbn3vuzD+PKSwFX2QkoR6dSZaKAtY6lT0=;
        b=v1WxlmDbRFpToXH8FXzQFpdhdIEsCq+xV0kDBn2cx9KTN/bUJVaHhoQBdxjAbYSWKA
         FXew/VM70vIfhH+u7m9HSUt4QsU74cbgDVHGGt3hHcxb5FIPMSclxOTXbpyIPskvC38z
         Oi0sZc60pvDsj0fxVYTiqTlmKF/GLawXsNdsN0lTWCtGlTo4x9BHnb2WbHYSpkd4EpBW
         n8x+lw9Rv4CXonrs2O/e9TFdl0FfXpUYIvN51zi64ID5sRCrujMjXeDqCQnzLTJ3WjIR
         EGV+/0CrnUIKtDboiMFpyxB7A6elM+rjXw1V/FmEh2uo4nHEBPDX/2TlafGyakWMYR8Z
         HeYg==
X-Forwarded-Encrypted: i=1; AJvYcCVicGJZPw8eI5ggi0Jx7USuyePfZuT6tJqWIFTgGcTfxcXzBOqn8L7kCdnH6lcMDMa5RDoo2AE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6Ht4hkmbDRscVmfEJfHBZbcksMlQeYwIBaCCgGAOhS69+cJx/
	hPlAxg/DpOLG2hi84ff8lfRo1JWvAV9//fclcQELlmeOdNnA7WNVzJak
X-Gm-Gg: ASbGncvVSJRJuqyP52FFYFQKknzrUMiSlMMS1vpE94UoNP9ANWPgpNWfT8PHjB74VUp
	4htlHx8ECGdyl6wIyRfFgJZFFaIrsv9oYsKm0tTe1kEHv/nFzN2M6v3vs8pDRauh7aW4ulH4IgM
	8ewxNRGAmDWPPRWWxWg8/vIT8IrHjBXQUumr27ymON2373artZmyA0X4fJYOYPdKFca3mOyYDil
	FrjUOz4teE3ghLkcDE/sZhf6XqljhlI7cDczbYr/WnbO+M2yietxPd5KhV4fGrLA+GYIMkTkEnN
	qGNfuUdw9y27TjyPGgNgsftQhLj3tvH4oyxxUoQ1/7HpZnTynJna64MZIgBMWHPSmdeezw7+sN0
	iGU+GzA2DMHPwYHPEO8Wm889NaDPhcX7TZIjW
X-Google-Smtp-Source: AGHT+IFcdjxfw9AaYkhVjHgYkiqDkUXLAcvGkFoOPrg34Eo+AprZt6K9wZhsOSbhz56+5rnDzpwgzw==
X-Received: by 2002:a05:6871:61c5:b0:2f4:da72:5689 with SMTP id 586e51a60fabf-310aab51ff6mr1625953fac.15.1755275885079;
        Fri, 15 Aug 2025 09:38:05 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:c95b:3a76:bbcf:777c])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-310ab87a7c7sm518355fac.4.2025.08.15.09.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 09:38:04 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 15 Aug 2025 11:38:02 -0500
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, john@groves.net
Subject: Re: [RFC V2 14/18] famfs_fuse: GET_DAXDEV message and daxdev_table
Message-ID: <oolcpxrjdzrkqnmj4xvcymnyb6ovdt7np7trxlgndniqe35l3s@ru5adqnjxexh>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-15-john@groves.net>
 <CAJfpegv19wFrT0QFkwFrKbc6KXmktt0Ba2Lq9fZoihA=eb8muA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegv19wFrT0QFkwFrKbc6KXmktt0Ba2Lq9fZoihA=eb8muA@mail.gmail.com>

On 25/08/14 03:58PM, Miklos Szeredi wrote:
> On Thu, 3 Jul 2025 at 20:54, John Groves <John@groves.net> wrote:
> >
> > * The new GET_DAXDEV message/response is enabled
> > * The command it triggered by the update_daxdev_table() call, if there
> >   are any daxdevs in the subject fmap that are not represented in the
> >   daxdev_dable yet.
> 
> This is rather convoluted, the server *should know* which dax devices
> it has registered, hence it shouldn't need to be explicitly asked.

That's not impossible, but it's also a bit harder than the current
approach for the famfs user space - which I think would need to become
stateful as to which daxdevs had been pushed into the kernel. The
famfs user space is as unstateful as possible ;)

> 
> And there's already an API for registering file descriptors:
> FUSE_DEV_IOC_BACKING_OPEN.  Is there a reason that interface couldn't
> be used by famfs?

FUSE_DEV_IOC_BACKING_OPEN looks pretty specific to passthrough. The
procedure for opening a daxdev is stolen from the way xfs does it in 
fs-dax mode. It calls fs_dax_get() rather then open(), and passes in 
'famfs_fuse_dax_holder_ops' to 1) effect exclusivity, and 2) receive
callbacks in the event of memory errors. See famfs_fuse_get_daxdev()...

A *similar* ioctl could be added to push in a daxdev, but that would
still add statefulness that isn't required in the current implementation.
I didn't go there because there are so few IOCTLs currently (the overall 
model is more 'pull' than 'push').

Keep in mind that the baseline case with famfs will be files that are 
interleaved across strips from many daxdevs. We commonly create files 
that are striped across 16 daxdevs, selected at random from a
significantly larger pool. Because interleaving is essential to memory 
performance...

There is no "device mapper" analog for memory, so famfs really does 
have to span daxdevs. As Darrick commented somewhere, famfs fmaps do 
repeating patterns well (i.e. striping)...

I think there is a certain elegance to the current approach, but
if you feel strongly I will change it.

Thanks!
John

