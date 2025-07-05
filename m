Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196052E36E6
	for <nvdimm@lists.linux.dev>; Sat,  5 Jul 2025 19:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751743670; cv=none; b=U5K49vrvq0JfUPBgRHh9FqGZRnmnx28+YzjX3mE57N9kYnL0sFxIIhCBSEZ+cUzNFLw/tHSP4VcFcqi3pdVWqO0p3Rl0vapRVpLSm27bHpz60+/DyF72dZzBScXgrWru+HI29pJI+abof+Lf1jAsdng4hAVyLqFctoEB4tFQwOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751743670; c=relaxed/simple;
	bh=noCGX8JTMgk+VkhE3ajHW0gmlbUMW2TalG2eHJ7gQio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O3L2KeqXPHpQbmTsx3Oy5/XMn1gf4hZzDR0w2Yu8D1GG0ZDSTq8hYMdVVmn4n5gy4/gbLHjr13CDVP7fR6olhrT2BcXwNhQXm2AOPgcTt3f3u9H1xzDrThOIP6vIZBx6J8oCcxuJ7q/wgq5NJiP/7u29FuZ1ASzhPrf+Utf1KhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kt7+NBHo; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kt7+NBHo"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-2eb5cbe41e1so1635179fac.0
        for <nvdimm@lists.linux.dev>; Sat, 05 Jul 2025 12:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751743668; x=1752348468; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Uvi3Ssl9dhbiyb7WG5zZNIM65dwWn2BHeyM8ec+zc8=;
        b=Kt7+NBHoQknCGaypKToOBHdPC/gC/8o4m004O0j7gMUyu6LjCq1RnqGPcSr+rpFxvF
         Em3/JcRgb8cPoTF90079b5tCpwddxeEL15Zpp0oGgnyzVQKq7djQPpMux6e3sY5a6Mi/
         wABJ3eTD1K1I5qBBHL3u4W1QjdLOH/7G1+dp+QkMj8HwbCIvlM1a5vkTrFBhyxxPaf61
         czh69QJlGrco4pX7jvtdRpAeLdGMp4BSK29MFAT8mqCvFEr626cTQp3sYoFqJWhBS1pi
         WT2aSpht3nNkMEOCXYCBqSXUxsJCm5zmCotvfyQTiGLaUFR7O73VKU8+D8oIKuBEl1FY
         B4cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751743668; x=1752348468;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Uvi3Ssl9dhbiyb7WG5zZNIM65dwWn2BHeyM8ec+zc8=;
        b=DAkhY48YV/9XO3Jupqw5CL3kJacFQmRs8UbiDadxc9X7BIU9PdfZ0mwrVvpY7g2R6O
         0fRdCts5HiYOXcskgxLP/JAjiADuxwgYQOqR54/8EA5UamsdHj21+S6bxE1u6MJfyeSB
         mw0bH9lxhz9GKcaEX8Zwo8mvOMjEPEowk3DOCGy4gH+bM2s7Il3w/MuQigo/X4ZgHWOo
         p2wop+gsEcuCyIh35XJ7rOo0Akf9wh5Yo4OEKFcDmmCFHETOn+uFA248uFc16LMjy3XI
         BYNq1Hdex5o/BHx3YU8bt9Sd89SINqShiQMcGVcgmAAsNBpjCZWeVpZTxmONxK8ozxNV
         sQow==
X-Forwarded-Encrypted: i=1; AJvYcCWiRu2OtEQsiJzD3r0WDC0Oes0joVVSXqYZz/P6GAgL1Ue7e3WrzRmvAF+koDfeB52eUt+vm6U=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4v+juYoUDyfmlEUWHuwqv91QkKAZGHKt1OfBqd6pt1vpoKGyK
	SLuC0qPfQu6sUTDwLge57aluIUw7O1SyMezYVRudpuRQdM7jcmIqXHUz
X-Gm-Gg: ASbGncvJoxNkYmKGn2cbUrNiDXgbyB8eriuYbr5quAmOyJ8tv7PryM4z6bYmKsS4R4P
	0H9KNRY9gP1e+irWNW3MIR5Yd6RDiWC37bpFHGcuv+24lM2Ab2zCJ9jfoubu+p4AcJu4KoZi0vn
	9VYwt0AmlJQT/93RkFMQJ5gC2+extAZ6xPEbpjg/utzwzz/BBesqdikBLeZvTmjEuWFmkek3AQg
	ULgNNoGIQZybT0aTRoy8bGPJpq9wRpiUl+U25tq1OTSCigCfPvHdcbCjybc+Lm8sQZ4cDwN5zCx
	0coDjm+DboGfT4ETN5XJ7txWYvfT1hKeCbWcxR4aBVq2/JFOBcjlaFGTLhIQegsPqfMCdtOG30l
	/
X-Google-Smtp-Source: AGHT+IH5/ekfod+dK4/TpB2Sd1DQKASQYJbwHuxsumDvUc8YMsc2FL7gyW2TpiM3j94mzw4K5mpHqw==
X-Received: by 2002:a05:6870:ae08:b0:29e:3c8d:61a0 with SMTP id 586e51a60fabf-2f7afcf1e5emr2212398fac.8.1751743668059;
        Sat, 05 Jul 2025 12:27:48 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:5c68:c378:f4d3:49a4])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2f7902dbf5dsm1226132fac.48.2025.07.05.12.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 12:27:47 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Sat, 5 Jul 2025 14:27:45 -0500
From: John Groves <John@groves.net>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC V2 13/18] famfs_fuse: Create files with famfs fmaps
Message-ID: <custjjqmvxt2u3wfjztwjdxvdxr6vbpvcoptt4vvv2itt7d2os@zqg5es4g7xmf>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-14-john@groves.net>
 <CAOQ4uxgFoEByjaJPQv_QGMzGHLx=1hZvQcYjxM_ZZi_D063HEg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgFoEByjaJPQv_QGMzGHLx=1hZvQcYjxM_ZZi_D063HEg@mail.gmail.com>

On 25/07/04 11:01AM, Amir Goldstein wrote:
> On Thu, Jul 3, 2025 at 8:51 PM John Groves <John@groves.net> wrote:
> >
> > On completion of GET_FMAP message/response, setup the full famfs
> > metadata such that it's possible to handle read/write/mmap directly to
> > dax. Note that the devdax_iomap plumbing is not in yet...
> >
> > Update MAINTAINERS for the new files.
> >
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  MAINTAINERS               |   9 +
> >  fs/fuse/Makefile          |   2 +-
> >  fs/fuse/famfs.c           | 360 ++++++++++++++++++++++++++++++++++++++
> >  fs/fuse/famfs_kfmap.h     |  63 +++++++
> >  fs/fuse/file.c            |  15 +-
> >  fs/fuse/fuse_i.h          |  16 +-
> >  fs/fuse/inode.c           |   2 +-
> >  include/uapi/linux/fuse.h |  56 ++++++
> >  8 files changed, 518 insertions(+), 5 deletions(-)
> >  create mode 100644 fs/fuse/famfs.c
> >  create mode 100644 fs/fuse/famfs_kfmap.h
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index c0d5232a473b..02688f27a4d0 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -8808,6 +8808,15 @@ F:       Documentation/networking/failover.rst
> >  F:     include/net/failover.h
> >  F:     net/core/failover.c
> >
> > +FAMFS
> > +M:     John Groves <jgroves@micron.com>
> > +M:     John Groves <John@Groves.net>
> > +L:     linux-cxl@vger.kernel.org
> > +L:     linux-fsdevel@vger.kernel.org
> > +S:     Supported
> > +F:     fs/fuse/famfs.c
> > +F:     fs/fuse/famfs_kfmap.h
> > +
> 
> I suggest to follow the pattern of MAINTAINERS sub entries
> FILESYSTEMS [EXPORTFS]
> FILESYSTEMS [IOMAP]
> 
> and call this sub entry
> FUSE [FAMFS]
> 
> to order it following FUSE entry
> 
> Thanks,
> Amir.

Done, and queued to -next

Thanks,
John

