Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1D4134723
	for <nvdimm@lists.linux.dev>; Tue, 23 Apr 2024 13:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713879074; cv=none; b=t6YnY6QwQGwcos9ZlL2g6eYdoIk37WD34fw4fvOFlqAfY7ZP0rXSxZeY+DlXc2iEXUPZOn9jiD0jFjHdR4zAvVFX/lI89tAgvwTdeH8EB2Wqtb91eT/HNj4KaK9jTmygK+PIVv2jeAADWFWA6mEGTr4JPUUv7wCTLnPngekfYIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713879074; c=relaxed/simple;
	bh=IxPKUCzl68GmqyGXvxuy/DA5ZjDtg4FgIO2Z9g8hUmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ph8NmsuTGxYhdgEg4mfv1fKsHjbTlvyzthlJ98ZuFHBVp1QZktlwtSmLm6YsQ/T97JTHUsEENnaRaYMCt77uWvay6osgKBgT53p+/NQSv3+BCyeznKnLjh5TExTlTBos1PczE8DQYSKB99+R5XTrYjpok8erTKJfwhd8UtgFESI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ajXmAX6L; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ajXmAX6L"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-78f02c96c52so386297285a.1
        for <nvdimm@lists.linux.dev>; Tue, 23 Apr 2024 06:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713879071; x=1714483871; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UlzWX69uBnN1f6I1MGifs0qgiAW4SxcxpA314BcskT4=;
        b=ajXmAX6LCO/tVBL2UMpeUUVMsuuLIcb2bbk6+LNP+XjKcWFWPGGOz4cdkKmGzDe6MH
         yikVqAeFf9hiIvsddnRU6aMYkzCpPmZ6BNMoDWdu/7xpEK0epdF75Rdl8N3re/caMGDb
         TrAXFRy/x73f4cdUBqCyTqnL2EthrIWWZde8kxa0ctB3X8ipOAUqv7twYWYInQP+iQHO
         SsFoUInPYXQtc6Lqvaovk++hWd+fJDhphDukn4CHnbmKyKV0rVK4AsXH18PFgUMBC/ZB
         UTXcX7IonyVU2OkRHJSAJkAsTRtw3b62Me7RtZfTSEewEgDGqKd6mG1m2/rmGw13knyr
         Wazw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713879071; x=1714483871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UlzWX69uBnN1f6I1MGifs0qgiAW4SxcxpA314BcskT4=;
        b=a7xgFTWnrYnOVlGm1AhknBJ4A7t+NPvknIc4BNDg62Qwi9+LVr4MfjQelM6zpJN2vl
         OgOLrg2SXrLQC3P+15xJABI9m2c4e/f79LyPN93gvjt3evUaFmLH570EeWYON4XsQA4A
         o+LyGwgc3kAnfSi6ZKyI7sdv4P6hpANR4N1Yy2iT+yw8paM+R5YbzVFTEtHJgSCJyiAw
         tYCkQMllieu4Tqb3f+RMYQwKEb1DPRxS83dH6aJaNj4LWRk8+Yr2c1XcptsHGt3IU8Zy
         hc+EmvkIi04C4P9a36Ut3tbIJyCsBba0gPXkUXWdntCOLmp0OBF9S7pSDR7CsLCddmLY
         452g==
X-Forwarded-Encrypted: i=1; AJvYcCVGWcYXyM3SEcCLwk7zHQCFuKgwmRoutQZOtsPWw+AWujGFxm0mbF56CIsN+FA7h9fK9mztlVPdfwHmltLb2YJTF2AFXtMg
X-Gm-Message-State: AOJu0Yxv1LH19wSOriDFAZs7failxcmULO7JcFRsw5WppGn1yui8XK2z
	QTXXB4fVEiSjnHamb6sDzbLvOLUomLLpLHTo5vLwJjDMJGUFwUauNhMQTB3X5G3FekRhvP8LhcK
	5ipVeGSMTAUg5+t79wEkbrxFwdj8=
X-Google-Smtp-Source: AGHT+IGm9PNtptdr4RC0D9B0O/GNda/2xKMhHsdXlitZa7C3oPcFsgf+fpwsTHPA9gPA2XyfPZbLeP9q4GqY5s1m4TM=
X-Received: by 2002:a0c:e909:0:b0:69b:76f7:3653 with SMTP id
 a9-20020a0ce909000000b0069b76f73653mr13626939qvo.27.1713879071065; Tue, 23
 Apr 2024 06:31:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240229002020.85535-1-john@groves.net>
In-Reply-To: <20240229002020.85535-1-john@groves.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 23 Apr 2024 16:30:59 +0300
Message-ID: <CAOQ4uxi83HUUmMmNs9NeeOOfVVXhpWAdeAEDq8r31p0tK1sA2A@mail.gmail.com>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Famfs: shared memory file system for
 disaggregated memory [LSF/MM/BPF ATTEND]
To: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>, 
	Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: lsf-pc@lists.linux-foundation.org, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>, 
	Jon Grimm <jon.grimm@amd.com>, Dave Chinner <david@fromorbit.com>, john@jagalactic.com, 
	Bharata B Rao <bharata@amd.com>, Jerome Glisse <jglisse@google.com>, gregory.price@memverge.com, 
	Ajay Joshi <ajayjoshi@micron.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Hellwig <hch@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	David Rientjes <rientjes@google.com>, Ravi Shankar <venkataravis@micron.com>, 
	dave.hansen@linux.intel.com, John Hubbard <jhubbard@nvidia.com>, mykolal@meta.com, 
	Brian Morris <bsmorris@google.com>, Eishan Mirakhur <emirakhur@micron.com>, Wei Xu <weixugc@google.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Srinivasulu Thanneeru <sthanneeru@micron.com>, John Groves <jgroves@micron.com>, 
	Christoph Lameter <cl@gentwo.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Aravind Ramesh <arramesh@micron.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 29, 2024 at 2:20=E2=80=AFAM John Groves <John@groves.net> wrote=
:
>
> John Groves, Micron
>
> Micron recently released the first RFC for famfs [1]. Although famfs is n=
ot
> CXL-specific in any way, it aims to enable hosts to share data sets in sh=
ared
> memory (such as CXL) by providing a memory-mappable fs-dax file system
> interface to the memory.
>
> Sharable disaggregated memory already exists in the lab, and will be poss=
ible
> in the wild soon. Famfs aims to do the following:
>
> * Provide an access method that provides isolation between files, and doe=
s not
>   tempt developers to mmap all the memory writable on every host.
> * Provide an an access method that can be used by unmodified apps.
>
> Without something like famfs, enabling the use of sharable memory will in=
volve
> the temptation to do things that may destabilize systems, such as
> mapping large shared, writable global memory ranges and hooking allocator=
s to
> use it (potentially sacrificing isolation), and forcing the same virtual
> address ranges in every host/process (compromising security).
>
> The most obvious candidate app categories are data analytics and data lak=
es.
> Both make heavy use of "zero-copy" data frames - column oriented data tha=
t
> is laid out for efficient use via (MAP_SHARED) mmap. Moreover, these use =
case
> categories are generally driven by python code that wrangles data into
> appropriate data frames - making it straightforward to put the data frame=
s
> into famfs. Furthermore, these use cases usually involve the shared data =
being
> read-only during computation or query jobs - meaning they are often free =
of
> cache coherency concerns.
>
> Workloads such as these often deal with data sets that are too large to f=
it
> in a single server's memory, so the data gets sharded - requiring movemen=
t via
> a network. Sharded apps also sometimes have to do expensive reshuffling -
> moving data to nodes with available compute resources. Avoiding the shard=
ing
> overheads by accessing such data sets in disaggregated shared memory look=
s
> promising to make make better use of memory and compute resources, and by
> effectively de-duplicating data sets in memory.
>
> About sharable memory
>
> * Shared memory is pmem-like, in that hosts will connect in order to acce=
ss
>   pre-existing contents
> * Onlining sharable memory as system-ram is nonsense; system-ram gets zer=
oed...
> * CXL 3 provides for optionally-supported hardware-managed cache coherenc=
y
> * But "multiple-readers, no writers" use cases don't need hardware suppor=
t
>   for coherency
> * CXL 3.1 dynamic capacity devices (DCDs) should be thought of as devices=
 with
>   an allocator built in.
> * When sharable capacity is allocated, each host that has access will see=
 a
>   /dev/dax device that can be found by the "tag" of the allocation. The t=
ag is
>   just a uuid.
> * CXL 3.1 also allows the capacity associated with any allocated tag to b=
e
>   provided to each host (or host group) as either writable or read-only.
>
> About famfs
>
> Famfs is an append-only log-structured file system that places many limit=
s
> on what can be done. This allows famfs to tolerate clients with a stale c=
opy
> of metadata. All memory allocation and log maintenance is performed from =
user
> space, but file extent lists are cached in the kernel for fast fault
> resolution. The current limitations are fairly extreme, but many can be r=
elaxed
> by writing more code, managing Byzantine generals, etc. ;)
>
> A famfs-enabled kernel can be cloned at [3], and the user space repo can =
be
> cloned at [4]. Even with major functional limitations in its current form
> (e.g. famfs does not currently support deleting files), it is sufficient =
to
> use in data analytics workloads - in which you 1) create a famfs file sys=
tem,
> 2) dump data sets into it, 3) run clustered jobs that consume the shared =
data
> sets, and 4) dismount and deallocate the memory containing the file syste=
m.
>
> Famfs Open Issues
>
> * Volatile CXL memory is exposed as character dax devices; the famfs patc=
h
>   set adds the iomap API, which is required for fs-dax but until now miss=
ing
>   from character dax.
> * (/dev/pmem devices are block, and support the iomap api for fs-dax file
>   systems)
> * /dev/pmem devices can be converted to /dev/dax mode, but native /dev/da=
x
>   devices cannot be converted to pmem mode.
> * /dev/dax devices lack the iomap api that fs-dax uses with pmem, so the =
famfs
>   patch set adds that.
> * VFS layer hooks for a file system on a character device may be needed.
> * Famfs has uncovered some previously latent bugs in the /dev/dax mmap
>   machinery that probably require attention.
> * Famfs currently works with either pmem or devdax devices, but our
>   inclination is to drop pmem support to, reduce the complexity of suppor=
ting
>   two different underlying device types - particularly since famfs is not
>   intended for actual pmem.
>
>
> Required :-
> Dan Williams
> Christian Brauner
> Jonathan Cameron
> Dave Hansen
>
> [LSF/MM + BPF ATTEND]
>
> I am the author of the famfs file system. Famfs was first introduced at L=
PC
> 2023 [2]. I'm also Micron's voting member on the Software and Systems Wor=
king
> Group (SSWG) of the CXL Consortium, and a co-author of the CXL 3.1
> specification.
>
>
> References
>
> [1] https://lore.kernel.org/linux-fsdevel/cover.1708709155.git.john@grove=
s.net/#t
> [2] https://lpc.events/event/17/contributions/1455/
> [3] https://www.computeexpresslink.org/download-the-specification
> [4] https://github.com/cxl-micron-reskit/famfs-linux
>

Hi John,

Following our correspondence on your patch set [1], I am not sure that the
details of famfs file system itself are an interesting topic for the
LSFMM crowd??
What I would like to do is schedule a session on:
"Famfs: new userspace filesystem driver vs. improving FUSE/DAX"

I am hoping that Miklos and Bernd will be able to participate in this
session remotely.

You see the last time that someone tried to introduce a specialized
faster FUSE replacement [2], the comments from the community were
that FUSE protocol can and should be improved instead of introducing
another "filesystem in userspace" protocol.

Since 2019, FUSE has gained virtiofs/dax support, it recently gained
FUSE passthrough support and Bernd is working on FUSE uring [3].

My hope is that you will be able to list the needed improvements
to /dev/dax iomap and FUSE so that you could use the existing
kernel infrastructure and FUSE libraries to implement famfs.

How does that sound for a discussion?

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/3jwluwrqj6rwsxdsksfvdeo5uccgmnkh7=
rgefaeyxf2gu75344@ybhwncywkftx/
[2] https://lore.kernel.org/linux-fsdevel/8d119597-4543-c6a4-917f-14f4f4a6a=
855@netapp.com/
[3] https://lore.kernel.org/linux-fsdevel/20230321011047.3425786-1-bschuber=
t@ddn.com/
