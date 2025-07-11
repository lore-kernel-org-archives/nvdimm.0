Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17B72E0401
	for <nvdimm@lists.linux.dev>; Fri, 11 Jul 2025 15:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752247706; cv=none; b=iTc5jcwFjrpGudNSFj4Ep46//Ajm6vIIXuv2ymKTj+HLUZ6kVOP4hZrmbp6GpzmnHhb6carIk9RTNI9R8ykpnRiMwSgNiiC59Trrd5vnmDZ1Sp+N+DtR6F8+qkvN4HIyQRiegqzjLoX1XAcivsSqxjJbIFbe80Dm5lIkhjET+w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752247706; c=relaxed/simple;
	bh=jJsQMAM8FiXHMdKty5y/XyaVhDgU86KQ3YEd2qZWf5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NmzmP1xVEN+jH+cXYdjybrNJMLWQXxduGHC35Em9le3+S95TKSk8r7ge4FPwuNls8UfUH+F2BrvULaxy5i6mt11YnJHSkBEa8Cmf8ELk1qKiGJ8cax3f1I+HNeIMY9uj4gZzHLsYKL2v9Jzqgf4GKfoBKJIIGLufIS3lwvoubRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HeFHWPue; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HeFHWPue"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-2ea08399ec8so1438772fac.1
        for <nvdimm@lists.linux.dev>; Fri, 11 Jul 2025 08:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752247703; x=1752852503; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RCT28qnij7KcqmnQf/Iz1goywJwPmt6gNk4a8gqOzGQ=;
        b=HeFHWPueRojaUIkud5dePafxpKB18OFawk/qZMtmPqayocASpl8nMlNbR+1uR+de3x
         GGRZ4YpJo7hel3MwJd0utcesh0JQOY5JTS4CXLDea/qG6UmzULn9d5URz7nPT2gv/8Oj
         vxxBDNJ/X13LHJM2X6dBuysqXGyCMHFwgQoBtyrI0r6dqJJiOH/a0DzDZBTKPk2AM0Z3
         KBLdDtHcgspxc4zl9Uo5DkLmq7YyGMfW4JYP0WSdOuQ6J4PYtml8SLKMphsTjThTpzF9
         ugO1e5aRltS+ZxXVhL86Wd4kaIdWWy8g57c7UE6KrDX3JZ+K/6qnosoEVdEtpvOyT2YW
         UUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752247703; x=1752852503;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RCT28qnij7KcqmnQf/Iz1goywJwPmt6gNk4a8gqOzGQ=;
        b=KtSMq6iuE8JjYZz867z6EziQS1WXAPjPSJAZsF8BjfxSn1pUmOO5KdNl8E4V5IundG
         41sOUSiX5z5BRUGH+VJifi/HrhL82QnBSMHyzkZ4LnNt3KOzENpqTb6su5O1sWDVTk2M
         iQnqKYGPv9/17lPvV6XEAVdkI8tH+v8Pn4+fYsG7zNi9jD6/97fGP3nSaywzSjWZOV1M
         +u9lcaxXt3bf/thzd4Fgpel0HGP2LbegaTcuq5G+3dQ6ztBWnHyb7Ebian9f3Ayry+qb
         X96F6n0ANv6Wvo9rSCOMLgFHHt4RCiwodFLBLynPGFIvlS+Tv0i/ONaCau6LVkagUpc/
         jPSA==
X-Forwarded-Encrypted: i=1; AJvYcCV8FW1bTosDuYvtjMuwCWpdJQYHIzxSjqBA0h7iPcoHIdmPn1IiLcx7hmGt3AwqrDf+Y3A2bjg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJa9QmRmgrMdyLK+3xIk4OQBX3HOIK0g9fRk05ubYj5ezbIy3S
	wrbc7oodUnn3fl0S9TxOEyIlbVfko8hUBws4sUwIuRdNfDuDWSCiOmtw
X-Gm-Gg: ASbGncu8mvniLpluf3JrX0CuEKZCABVT1wX4nldqoTj/pOmVZFqe+I+XAvkhb7L5fZp
	f2Ic6w/HmQkBMaPJYbyz+l5DoiJZFwVFfoH9zeS/kZxUFyVaTaBCR7ZE6M3dj3r7QudEhwX39GN
	U0da/3Yzb8L2OQLmx9Yw8AaypSQn5V5SrsS7Jw8JqqG7agKTqhrBIKne/i2c7acA1RBm3SD31Aa
	dHmxPSR1BbRXSWVTk+yBdkvlPR4hJLlwUwqhRpK/1fGUcpFJaSGPtjyox83NxzbHDr+VTyw71sC
	lEYyEBBkl73RRkwkOO2b4VPtXL+u1JJBh261owF84XBSWCVV7dqPNre+qHBeqbP62XCSgyZTD6L
	HrV0YM75CLcVV7m/SmNyX7ft0D2Qtx5w2ADwYzFlCp2wERYQ=
X-Google-Smtp-Source: AGHT+IGzBgxg7rIzuTtcrrEUrQvsX4CkyLDr3x3XrSAFIZzmksXTQyVmWxDZllhKHdsEcj10mjoRIg==
X-Received: by 2002:a05:6870:6c14:b0:2d5:2955:aa6b with SMTP id 586e51a60fabf-2ff2b4d9b3fmr1955440fac.5.1752247703301;
        Fri, 11 Jul 2025 08:28:23 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:25b0:db8a:a7d3:ffe1])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2ff1172e579sm762537fac.45.2025.07.11.08.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 08:28:22 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 11 Jul 2025 10:28:20 -0500
From: John Groves <John@groves.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 11/18] famfs_fuse: Basic famfs mount opts
Message-ID: <ttjh3gqk3fmykwrb7dg6xaqhkpxk7g773fkvuzvbdlefimpseg@l5ermgxixeen>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-12-john@groves.net>
 <20250709035911.GE2672029@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250709035911.GE2672029@frogsfrogsfrogs>

On 25/07/08 08:59PM, Darrick J. Wong wrote:
> On Thu, Jul 03, 2025 at 01:50:25PM -0500, John Groves wrote:
> > * -o shadow=<shadowpath>
> 
> What is a shadow?
> 
> > * -o daxdev=<daxdev>

Derp - OK, that's a stale commit message. Here is the one for the -next
version of this patch:

    famfs_fuse: Basic famfs mount opt: -o shadow=<shadowpath>

    The shadow path is a (usually tmpfs) file system area used by the famfs 
    user space to commuicate with the famfs fuse server. There is a minor 
    dilemma that the user space tools must be able to resolve from a mount 
    point path to a shadow path. The shadow path is exposed via /proc/mounts, 
    but otherwise not used by the kernel. User space gets the shadow path 
    from /proc/mounts...


> 
> And, uh, if there's a FUSE_GET_DAXDEV command, then what does this mount
> option do?  Pre-populate the first element of that set?
> 
> --D
> 

I took out -o daxdev, but had failed to update the commit msg.

The logic is this: The general model requires the FUSE_GET_DAXDEV message /
response, so passing in the primary daxdev as a -o arg creates two ways to
do the same thing.

The only initial heartburn about this was one could imagine a case where a
mount happens, but no I/O happens for a while so the mount could "succeed",
only to fail later if the primary daxdev could not be accessed.

But this can't happen with famfs, because the mount procedure includes 
creating "meta files" - .meta/.superblock and .meta/.log and accessing them
immediately. So it is guaranteed that FUSE_GET_DAXDEV will be sent right away,
and if it fails, the mount will be unwound.

Thanks Darrick!
John

<snip>

