Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504A3128819
	for <nvdimm@lists.linux.dev>; Sat, 16 Aug 2025 16:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755361374; cv=none; b=IMpeMyvX6tYAjEjsolW6EHCA0KWwHeHcVkSskS2nw2QOr53PWBm6HOB9B071Kg6Mc1F7efLRDA2GI4Sw4BiI18Oag3gRTdG8v0iG5uMRW3vispz70oCIg5y2fisCNNKHTLhULPQ1D2njniRfCeXVK3zAbCMFicSctREV03hKdqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755361374; c=relaxed/simple;
	bh=NZM13o2Exswd9U+U96wypdU8sDgj2Ia3oSNRi53SxnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bKy6+E7ubn+ue7dT97Uq2IeHLt9jnDlZhWNmzFzxDLvuL6dSwMOC2NzEvB7PqLKnDaA0HX8evQENrPNVUVmtZh+twIV7H+xP7qzhWpErJ90Xcf7wkPCi2luWFsjSR5Oja/KwBQ7uXjW/+RlIn+U2OBSTvJGrZIUfVoKMRosDA1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UFgDpYHJ; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UFgDpYHJ"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-30ccec2515dso2251149fac.3
        for <nvdimm@lists.linux.dev>; Sat, 16 Aug 2025 09:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755361372; x=1755966172; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Rtpc5s7M7/+q1cABKsKTJfzX3/F+/4NGbX+n4VhZH8=;
        b=UFgDpYHJJjr783B0zCBpR+0xCNcJqCsojeRSsCTfTqQToQDVKiooj8xWCzA9PFmUTr
         T1XbbFhGqCxeS5xz/DjmLa5jgtzJpOMcpWK7pPfFS/gd+O+7tsNVPas9PNoWftBFwygR
         Q2UnXF7WH9S27bkBQrIZ5y7qF73G7Hn23nzwY0596NGnLg42MxUPHMLQaME9voiNx9kS
         8HGEOofNVfAbvU18E9w1EysmYpKLLif6p2AoSlcpoh1V756SqlYfabZBOdU0PoluuAPr
         VJycHAAKh+kF9LFoXWAwvDoX5o8mrCEFHO2Ejd2jFr3AVcJ6A7ug8XbE0DBuLg4KoAX+
         Hf6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755361372; x=1755966172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Rtpc5s7M7/+q1cABKsKTJfzX3/F+/4NGbX+n4VhZH8=;
        b=xQTz8jDADGoLbQfugqS0kn8HAbSrqf/2unzGn+GjvB6ZYB4w3c8mOt8xMGHyfDoBbb
         JuyI/oPLKUt/yIFzY3MI6df0DrD7DIqUO0hmq927V317aIX9LWoRfAvICxdwByj2oblt
         XYG0AVCSQHjeT46L6t4qd7DA2/fVsVYxTxblnTvrIW5YcPDql5taSb/3gBRDs1A+oLiH
         PUJi3qcf2Cb5RCSfxqTyMXYYXwlJtPRGaOnXELWOiHZkryWIvRJcIv4c85Xe0T0vXbvj
         Z6RH6gL30lu7xml4uPDNpQYBkaIEDzVRtDzpOgONWpGkPwJHc08l8eTyZN05FfXE+j0W
         9QBg==
X-Forwarded-Encrypted: i=1; AJvYcCUZfmlx83/UmItF1gpfAmdhOO5iC+yelpP+bpBjRzOTRTOH5XhOok/bZkkP57HbWhaJzwbdLm8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyje8RcBcRlT5KZccAgvtD9QgEJRUqTSt0CDu6ee0mqsKea/0jl
	7TOQmP0t5Xa0kLR32dMXgxTLpS7OlXrDp5/nYR3mCaSrsaAZ5TrPgXja
X-Gm-Gg: ASbGncvKI1Hs4l1i9zFJP7ADqyHw4dGkl1+Kt7wI5CKI3vrdg0bg5zxBqMWXVWVYYtU
	KJgBIKUzsiNR95mQMo+dv2gZPxmSGXqbyYA0NVsPuz5d21yCUQCr4ETVciVoiBwFUCPSSe3R7bY
	RnjQQoOn5UzM7JqINw4bkgZSM5WhcOfP0aZrmAT4vRWsX23sINXf/siodabFCRRQB74e6a4qVNH
	R4DqhqXYyvS1ZjvDMbebI/Wn7hAfEFVAWShlq523t5+Km+nVaHRrKQue9r/zyr8wiaGcb83vQF2
	Nlfly4YlQeA9ogcFRa9iGYbt+ewk6Za1/tc8iF10seVgc+5+ThFSZZjtM/EJIQlCF+PH2jNCuON
	MGQwWb6jgHqDdEvpFETQV0XeVBqSmZUK6fC96
X-Google-Smtp-Source: AGHT+IHCxUIkdlGxbKhRgkda2hbannURDDEsuMBjaUCvPESePWFZyXXJu5EUcQ/LJ4zZvF6BnvAeCQ==
X-Received: by 2002:a05:6870:15c8:b0:30c:5189:5707 with SMTP id 586e51a60fabf-310aae9750cmr3295321fac.28.1755361372333;
        Sat, 16 Aug 2025 09:22:52 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:1d43:22e9:7ffa:494a])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-74391bd20a3sm911591a34.21.2025.08.16.09.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Aug 2025 09:22:51 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Sat, 16 Aug 2025 11:22:49 -0500
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
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
	Ajay Joshi <ajayjoshi@micron.com>, john@groves.net
Subject: Re: [RFC V2 14/18] famfs_fuse: GET_DAXDEV message and daxdev_table
Message-ID: <vfg7t7dzqjf6g6374wavesakk332n4dqabgokw4xobsar5jnxm@m7xfan6vhyty>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-15-john@groves.net>
 <CAJfpegv19wFrT0QFkwFrKbc6KXmktt0Ba2Lq9fZoihA=eb8muA@mail.gmail.com>
 <20250814171941.GU7942@frogsfrogsfrogs>
 <CAJfpegv8Ta+w4CTb7gvYUTx3kka1-pxcWX_ik=17wteU9XBT1g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegv8Ta+w4CTb7gvYUTx3kka1-pxcWX_ik=17wteU9XBT1g@mail.gmail.com>

On 25/08/14 08:25PM, Miklos Szeredi wrote:
> On Thu, 14 Aug 2025 at 19:19, Darrick J. Wong <djwong@kernel.org> wrote:
> > What happens if you want to have a fuse server that hosts both famfs
> > files /and/ backing files?  That'd be pretty crazy to mix both paths in
> > one filesystem, but it's in theory possible, particularly if the famfs
> > server wanted to export a pseudofile where everyone could find that
> > shadow file?
> 
> Either FUSE_DEV_IOC_BACKING_OPEN detects what kind of object it has
> been handed, or we add a flag that explicitly says this is a dax dev
> or a block dev or a regular file.  I'd prefer the latter.
> 
> Thanks,
> Miklos

I have future ideas of famfs supporting non-dax-memory files in a mixed
namespace with normal famfs dax files. This seems like the simplest way 
to relax the "files are strictly pre-allocated" rule. But I think this 
is orthogonal to how fmaps and backing devs are passed into the kernel. 

The way I'm thinking about it, the difference would be handled in
read/write/mmap. Taking fuse_file_read_iter as the example, the code 
currently looks like this:

	if (FUSE_IS_VIRTIO_DAX(fi))
		return fuse_dax_read_iter(iocb, to);
	if (fuse_file_famfs(fi))
		return famfs_fuse_read_iter(iocb, to);

	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
	if (ff->open_flags & FOPEN_DIRECT_IO)
		return fuse_direct_read_iter(iocb, to);
	else if (fuse_file_passthrough(ff))
		return fuse_passthrough_read_iter(iocb, to);
	else
		return fuse_cache_read_iter(iocb, to);

If the famfs fuse servert wants a particular file handled via another 
mechanism -- e.g. READ message to server or passthrough -- the famfs 
fuse server can just provide an fmap that indicates such.  Then 
fuse_file_famfs(fi) would return false for that file, and it would be 
handled through other existing mechanisms (which the famfs fuse 
server would have to handle correctly).

Famfs could, for example, allow files to be created as generic or
passthrough, and then have a "commit" step that allocated dax memory, 
moved the data from a non-dax into dax, and appended the file to the 
famfs metadata log - flipping the file to full-monty-famfs (tm). 
Prior to the "commit", performance is less but all manner of mutations 
could be allowed.

So I don't think this looks very be hard, and it's independent of the 
mechanism by which fmaps get into the kernel.

Regards,
John


