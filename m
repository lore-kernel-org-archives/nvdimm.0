Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D897F7EC
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 21:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708982210; cv=none; b=LDbYsYiAHRxi6RsbI8+r22clocCo1ERjcba8YzEz3Ha+jIVVjoMSn+NTZzchrq4U8YJTet4XkZN4TiBVt622dNZelcCY2YlSvt+DFJZz5Ibr/MSDdXUgZ31SCZcpZGdpxl+0q+HYgcebPUTrnRMnpPEf/UvkfQvlT5Ky9S59iMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708982210; c=relaxed/simple;
	bh=B7t54qSi+zoh3echsorRhVmtP4AbNabSTWRzGhYGvFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bxulfs0axtWr3OPoEprf8TLrl+oliIh6cRPUfYj7EJ0ggaGSgG4H8cpEzBtYjszSozYTJl6EagAF69IvRYYBaglaNQQeWLn17cxO5WBhwSQglEtoqYZBE6TAX/yy9kkruBRSsFfnAfe1OaacWOGNFEPOzSmwH379pLpYWynGbb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M/Cabr/r; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/Cabr/r"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5a02eb63ebcso1818904eaf.0
        for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 13:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708982208; x=1709587008; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q69d1h5JpiCD7qWS7XjI5Cafa952a+GWKfJxcBwhJCk=;
        b=M/Cabr/rlGze1EekEPHrm8pEsH8jQ0awAZDA1Yt37D86BoJsb4FaV0PptX9Qze4VcR
         6mTwBXR5Uwj1GcizE8owag2OP8CGMDi1dLa/sE6kQxCFkONi663OYIZWFiUtCbmQ+tIR
         n1fb1zJIlCJpCP5T3nbxkrZ3Sx1ucHvwpwMW952KZCq2Xv6ycoE6O3TzkRY5nFPX/W/t
         8XzdVLwcg1F/xt2kYZO1t1+b/pijvH/FomvRPKUE/U3zaH2eNZORuYLlRVbtEh4xvhiC
         izP1cErfzfZq+jRMdr6Mrhuc/6uYzLhbpltqmxznm6di+P3bcb7VUfWnEP8y+nycL9nV
         RF7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708982208; x=1709587008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q69d1h5JpiCD7qWS7XjI5Cafa952a+GWKfJxcBwhJCk=;
        b=ZlpCqs4s2dnIgXmdiZGV7K18cCS+Wp5IMc1H4Au/nw9qkAQFNdo6xQlfhbdg8WswwJ
         k1B/bba7nFj+Deofeyta/oKLQ+ta3MboW9CqN182lGI9ld5yBRH5nPUY9hhrI1nKF8d+
         UPT6sF7+umqSOvjSFSvjG3QnCoahTeEBTOndB6dRVxyKnIHQqzwOZ9l4LDLHwZBQPPso
         qWgANhQHrtu5X9vkT9SbPdqw6xXPhBz0RvcQYJGsjRMuv+8pxUel30mtzVB7imHbru64
         TGdrSrBO1Itd1IQmeHqeRjj0mqPLr/ei7GC2LsSe1aAiOCTuas0BVncu6ZzNkXEarUwN
         vXwg==
X-Forwarded-Encrypted: i=1; AJvYcCUbi0qaQX0r+WRM87jVCCfYWzABNQjaw5UOgDWKoUIOTjhQoV9gmlE4bxJVFY3FE6hmYba9TCNeJzZjqUuTKh264nP7gDas
X-Gm-Message-State: AOJu0YzBaW5o3QOQelJ7W0DOUEBdwqKcSuMZWf2Dm3DWxcFI53B7uE4Q
	zzhey8wfsZFu5zSau14ex+l7B5ihdJY5g42N0dMNxRoQrQmX8BVQ
X-Google-Smtp-Source: AGHT+IHhhLJmYU/d2r1+Ut5/Toin/f9dQNa0cxvPaRI+/l1e1FNOPSpMxwaAX9XoEkiIQOr1qrg8HA==
X-Received: by 2002:a4a:6f4d:0:b0:5a0:12e1:312a with SMTP id i13-20020a4a6f4d000000b005a012e1312amr8346281oof.6.1708982207968;
        Mon, 26 Feb 2024 13:16:47 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id f3-20020a4a9203000000b0059d775eca88sm1402252ooh.29.2024.02.26.13.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 13:16:47 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 26 Feb 2024 15:16:45 -0600
From: John Groves <John@groves.net>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 00/20] Introduce the famfs shared-memory file system
Message-ID: <w5cqtmdgqtjvbnrg5okdgmxe45vjg5evaxh6gg3gs6kwfqmn5p@wgakpqcumrbt>
References: <cover.1708709155.git.john@groves.net>
 <ZdkzJM6sze-p3EWP@bombadil.infradead.org>
 <cc2pabb3szzpm5jxxeku276csqu5vwqgzitkwevfluagx7akiv@h45faer5zpru>
 <Zdy0CGL6e0ri8LiC@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zdy0CGL6e0ri8LiC@bombadil.infradead.org>

On 24/02/26 07:53AM, Luis Chamberlain wrote:
> On Mon, Feb 26, 2024 at 07:27:18AM -0600, John Groves wrote:
> > Run status group 0 (all jobs):
> >   WRITE: bw=29.6GiB/s (31.8GB/s), 29.6GiB/s-29.6GiB/s (31.8GB/s-31.8GB/s), io=44.7GiB (48.0GB), run=1511-1511msec
> 
> > This is run on an xfs file system on a SATA ssd.
> 
> To compare more closer apples to apples, wouldn't it make more sense
> to try this with XFS on pmem (with fio -direct=1)?
> 
>   Luis

Makes sense. Here is the same command line I used with xfs before, but 
now it's on /dev/pmem0 (the same 128G, but converted from devdax to pmem
because xfs requires that.

fio -name=ten-256m-per-thread --nrfiles=10 -bs=2M --group_reporting=1 --alloc-size=1048576 --filesize=256MiB --readwrite=write --fallocate=none --numjobs=48 --create_on_open=0 --ioengine=io_uring --direct=1 --directory=/mnt/xfs
ten-256m-per-thread: (g=0): rw=write, bs=(R) 2048KiB-2048KiB, (W) 2048KiB-2048KiB, (T) 2048KiB-2048KiB, ioengine=io_uring, iodepth=1
...
fio-3.33
Starting 48 processes
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
ten-256m-per-thread: Laying out IO files (10 files / total 2441MiB)
Jobs: 36 (f=360): [W(3),_(1),W(3),_(1),W(1),_(1),W(6),_(1),W(1),_(1),W(1),_(1),W(7),_(1),W(3),_(1),W(2),_(2),W(4),_(1),W(5),_(1)][77.8%][w=15.1GiB/s][w=7750 IOPS][eta 00m:02s]
ten-256m-per-thread: (groupid=0, jobs=48): err= 0: pid=8798: Mon Feb 26 15:10:30 2024
  write: IOPS=7582, BW=14.8GiB/s (15.9GB/s)(114GiB/7723msec); 0 zone resets
    slat (usec): min=23, max=7352, avg=131.80, stdev=151.63
    clat (usec): min=385, max=22638, avg=5789.74, stdev=3124.93
     lat (usec): min=432, max=22724, avg=5921.54, stdev=3133.18
    clat percentiles (usec):
     |  1.00th=[  799],  5.00th=[ 1467], 10.00th=[ 2073], 20.00th=[ 3097],
     | 30.00th=[ 3949], 40.00th=[ 4752], 50.00th=[ 5473], 60.00th=[ 6194],
     | 70.00th=[ 7046], 80.00th=[ 8029], 90.00th=[ 9634], 95.00th=[11338],
     | 99.00th=[16319], 99.50th=[17957], 99.90th=[20055], 99.95th=[20579],
     | 99.99th=[21365]
   bw (  MiB/s): min=10852, max=26980, per=100.00%, avg=15940.43, stdev=88.61, samples=665
   iops        : min= 5419, max=13477, avg=7963.08, stdev=44.28, samples=665
  lat (usec)   : 500=0.15%, 750=0.47%, 1000=1.34%
  lat (msec)   : 2=7.40%, 4=21.46%, 10=60.57%, 20=8.50%, 50=0.11%
  cpu          : usr=2.33%, sys=0.32%, ctx=58806, majf=0, minf=36301
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,58560,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=14.8GiB/s (15.9GB/s), 14.8GiB/s-14.8GiB/s (15.9GB/s-15.9GB/s), io=114GiB (123GB), run=7723-7723msec

Disk stats (read/write):
  pmem0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%


I only have some educated guesses as to why famfs is faster. Since files 
are preallocated, they're always contiguous. And famfs is vastly simpler
because it isn't aimed at general purpose uses cases (and indeed can't
handle them).

Regards,
John

