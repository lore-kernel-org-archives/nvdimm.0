Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFE98BF0
	for <nvdimm@lists.linux.dev>; Tue, 30 Apr 2024 02:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714443119; cv=none; b=O38fcfmJ30tMsnnX13mqMrB7K6y/2OhOLS8Z/0Q3TcGyC6pthPBbH4a5+7TtRwvK1Q95x5jFLdcissPsXCbKSCYI2h9wXzXaqvK7SUJqmo4TLhFWxrUKSsBS3z/upxPdkICOcD9NTggzbgbtFsrD2wu3w4Oy7Ojp56n2vOTvvao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714443119; c=relaxed/simple;
	bh=B4Q38GNWHiFrqJngPRPZyu+B4xXhaLo1u2hz1Gx73kg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TakkYZS/SQJjOttx3K6WP0lNjcUTGNGXvZgolsd+lwdavZtqAGASGau6WFNV5XCAQs+ErxMLeY5rXYx5EK8q89cWddZhD9zoWt36hUBtoQiYchwsfeKK4M36GA16oljdM12fgx8JzZdDm2efWken5GPvogAlMElROryzjcUwQz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cro6plvs; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cro6plvs"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6ee575da779so471394a34.2
        for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 19:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714443116; x=1715047916; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cz6LbTk3HDU9Gjsgqvf5euuqX2lyVCWJAHMvzGly8pc=;
        b=cro6plvsJwqUGxqeUeKfgMTOwFAN7R/IEEsppT7HfC47lZ7fMgNSxKPLU9BJMpv1V0
         0gtr96ncJhzmgVO+QoFbD3KuKboInS3fk4EgvK3bZ8rUw512UEbDWvuxVZXMcx7jDHWJ
         UFqnHqId7SLNmXGNnCTaBb7gHZTn9Gtxk3pXt6kldLzYQYNhwS4ndOcfaShEOz/yVPZH
         xhpLkMnVveKr8M+MY9f1BRMbhaBYHtdHyEFZ1EG/0OFDq1ITmhJH76+iVnf3+na9hQ1M
         oHRhT0yQRZjX3Rdn+HIZR83wYpdc/J55HA6P1Qz4cT5VX95b+FaLOpeBh0P+KL+YjFIC
         SYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714443116; x=1715047916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cz6LbTk3HDU9Gjsgqvf5euuqX2lyVCWJAHMvzGly8pc=;
        b=iY4OWs2PFRJcjNUXocMpXX97cZM9svaoTedpmHd82+7or36O2Em8NUPjHUGyPyYMK2
         RGpgTEu3OIRMNezzldPoxit7SYsQfFbjPlHmyoAHo+XZBs+rN+93trSLGNTXLEwwv1+3
         iu/SHKx0U4Wpv8bPWjekR4J77Sa12UfIyaGYKTIlOQot8/T8mkLYs906BJ9pvuqCelCo
         XLyymLnYfo9ij73EfQlRGn/iCxYXvemo2vZ0to3aI/1DLZqgJhbY29C2V731/R2iDLYo
         wd7mw09dTEsmUd2NXErw2veD6uLT1sYqPUjC0JOipT5RYa4FPjjaXxJq1DyEeg2Q9ygc
         nfdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJZQ3Zgqoe5J1kyN9XbYH2mYuObXLcmfwCjUIom5rgGnilYjuA8YfWaaq5xUOM/5Z3VWIg+p/3gpKB8h+YKJKm3qdIB6l/
X-Gm-Message-State: AOJu0Ywtn0yh8omX3YfAOnRVTzIx92hk/u3CYuAjMVfJJ1C+73uo+UBZ
	AKdnP3UEIM31TsQ7dsv6WK2I+7pkA1z3vF2rFbwGozR+NsNrolGY
X-Google-Smtp-Source: AGHT+IEgmqNybUXF8FHCit0cPMUSqtYSD/rjIQS96Y1wPstK+uXrwH04fBsGnUNreqzbmHVXUZCGvQ==
X-Received: by 2002:a05:6871:b2a:b0:23c:3afd:8770 with SMTP id fq42-20020a0568710b2a00b0023c3afd8770mr7668569oab.19.1714443115889;
        Mon, 29 Apr 2024 19:11:55 -0700 (PDT)
Received: from Borg-10.local ([70.114.203.196])
        by smtp.gmail.com with ESMTPSA id mk9-20020a0568700d0900b0022f939a3e2dsm5214410oab.55.2024.04.29.19.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 19:11:55 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 29 Apr 2024 21:11:52 -0500
From: John Groves <John@groves.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	John Groves <jgroves@micron.com>, john@jagalactic.com, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, gregory.price@memverge.com, 
	Randy Dunlap <rdunlap@infradead.org>, Jerome Glisse <jglisse@google.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Eishan Mirakhur <emirakhur@micron.com>, Ravi Shankar <venkataravis@micron.com>, 
	Srinivasulu Thanneeru <sthanneeru@micron.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Chandan Babu R <chandanbabu@kernel.org>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Steve French <stfrench@microsoft.com>, 
	Nathan Lynch <nathanl@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Julien Panis <jpanis@baylibre.com>, 
	Stanislav Fomichev <sdf@google.com>, Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: Re: [RFC PATCH v2 00/12] Introduce the famfs shared-memory file
 system
Message-ID: <c3mhc33u4yqhd75xc2ew53iuumg3c2vi3nk3msupt35fj7qkrp@pve6htn64e7c>
References: <cover.1714409084.git.john@groves.net>
 <Zi_n15gvA89rGZa_@casper.infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zi_n15gvA89rGZa_@casper.infradead.org>

On 24/04/29 07:32PM, Matthew Wilcox wrote:
> On Mon, Apr 29, 2024 at 12:04:16PM -0500, John Groves wrote:
> > This patch set introduces famfs[1] - a special-purpose fs-dax file system
> > for sharable disaggregated or fabric-attached memory (FAM). Famfs is not
> > CXL-specific in anyway way.
> > 
> > * Famfs creates a simple access method for storing and sharing data in
> >   sharable memory. The memory is exposed and accessed as memory-mappable
> >   dax files.
> > * Famfs supports multiple hosts mounting the same file system from the
> >   same memory (something existing fs-dax file systems don't do).
> 
> Yes, but we do already have two filesystems that support shared storage,
> and are rather more advanced than famfs -- GFS2 and OCFS2.  What are
> the pros and cons of improving either of those to support DAX rather
> than starting again with a new filesystem?
> 

Thanks for paying attention to this Willy.

This is a fair question; I'll share some thoughts on the rationale, but it's
probably something that should be an ongoing dialog. We already have a LSFMM
session planned that will discuss whether the famfs functionality should be
merged into fuse, but GFS2 and OCFS2 are also potential candidates.

(I've already seen Kent's reply and will get to that next)

I work for a memory company, and the motivation here is to make disaggregated
shared memory practically usable. Any approach that moves in that direction 
is goodness as far as we're concerned -- provided it doesn't insert years of 
delay. 

Some thoughts on famfs:

* Famfs is not, not, not a general purpose file system.
* One can think of famfs as a shared memory allocator where allocations can be
  accessed as files. For certain data analytics work flows (especially 
  involving Apache Arrow data frames) this is really powerful. Consumers of
  data frames commonly use mmap(MAP_SHARED), and can benefit from the memory
  de-duplication of shared memory and don't need any new abstractions.
* Famfs is not really a data storage tool. It's more of a shared-memroy 
  allocation tool that has the benefit of allocations being accesssible 
  (and memory-mappable) as files. So a lot of software can automatically use 
  it.
* Famfs is oriented to dumping sharable data into files and then allowing a
  scale-out cluster to share it (often read-only) to access a single copy in
  shared memory.
* Although this audience probably already understands this, please forgive me
  for putting a fine point on it: memory mapping a famfs/fs-dax file does 
  not use system-ram as a cache - it directly accesses the memory associated 
  with a file. This would be true of all file systems with proper fs-dax 
  support (of which there are not many, and currently only famfs that supports
  shared access to media/memory).

Some thoughts on shared-storage file systems:

* I'm no expert on GFS2 or OCFS2, but I've been around memory, file systems 
  and storage since well before the turn of the century...
* If you had brought up the existing fs-dax file systems, I would have pointed
  that they use write-back metadata, which does not reconcile with shared
  access to media - but these file systems do handle that.
* The shared media file systems are still oriented to block devices that
  provide durable storage and page-oriented access. CXL DRAM is a character 
  dax (devdax) device and does not provide durable storage.
* fs-dax-style memory mapping for volatile cxl memory requires the 
  dev_dax_iomap portion of this patch set - or something similar. 
* A scale-out shared media file system presumably requires some commitment to
  configure and manage some complexity in a distributed environment; whether
  that should be mandatory for enablement of shared memory is worthy of
  discussion.
* Adding memory to the storage tier for GFS2/OCFS2 would add non-persistent
  media to the storage tier; whether this makes sense would be a topic that
  GFS2/OCFS2 developers/architects should get involved in if they're 
  interested.

Although disaggregated shared memory is not commercially available yet, famfs 
is being actively tested by multiple companies for several use cases and 
patterns with real and simulated shared memory. Demonstrations will start to
surface in the coming weeks & months.

Regards,
John


