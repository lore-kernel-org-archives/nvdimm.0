Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650032916
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 02:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708999564; cv=none; b=R+tkMFXpJzTOfaHop/50dfe9WzAMS/+VZd6NwXRId4s6g+9NJ8CTewBpAoGQT4mRIJL7uYwWEBNGz8ahHvSt5EHCDtmwpE4D0Df2lUV5GkbcZM2sOxOO6viekKNbZEK3cwrs7fgLZnLHNHmDZEvgF2Bl9P3nP6zGYg1+hCcz7RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708999564; c=relaxed/simple;
	bh=p/sc65/Y89SirN+8xPleSpJF18VTWd6zEoKYs9P9wXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U47XXXdJ8CQBmysujd3RAkgpRQcAB+B9rpcvdLWugBw/+8mZoBRxG6IgEEF4wNajT4A/0Lt6rJW7N/Bx4utFEyI0Uigx/OQheHri5DKYR/U3/rXU5RA9xVZHZnUA+XBCjUmzC0kdvhQgs9h8DXqMMRZOviIKz2Lg2+F+VuHZWlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VWGNg78G; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VWGNg78G"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3c19b7d9de7so913149b6e.2
        for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 18:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708999561; x=1709604361; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SV9pHyGiurUhVbqmy78OWf51SeUPEW4JNQf5fgdiwuI=;
        b=VWGNg78G33GxXjEPXXoek6XIOMS59tEG2WWTaB9kTodxm2BIAwcm9V4CZUEvMmDXe7
         39X+JB9OIdByRLnGSx13cPlAWFFNNm3fFULU8D6n2cTRJ/c8Tcta/At5QGx+kxKCy5QC
         8secDTQERKc1TzkCoWyFRYruOTYFpntMFEYMDPwN4TzwUKjYhaxsHYkBpwzCXVMAf/Lv
         HfHKF4jqTqi8O0YfwmL+aqy05F/t7dQi18+YP1PXJuGXQq7wix3Pbh8fGxnny8lbCnqV
         tySxbI86t74vn/Dl0CdbRbwPNycrjOluFFQrkaNCjmy5VznHWXDcAJ9Zf3MlW0OBV7TA
         WLuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708999561; x=1709604361;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SV9pHyGiurUhVbqmy78OWf51SeUPEW4JNQf5fgdiwuI=;
        b=eEbkFStw+rlC1gvsG4CvRBWV2oGe2O9w0mfafOsh8UeJz1pX407NqbCN7DJVB+vmJ7
         p8yoI+AkfPD38p4Q2UN8tW2WsHD/S2NssRPJ+21Ldq4Hn5CFa82Z5nA8io+ib8bwE4x9
         xqxVYTv55Z6wcuMIis3mC4++dr/uV+ipwT57JKSJJXcT+j7TgMV3Lkv8+prEci30dgEj
         d5GPPHWgYnv9nCy2F9l63rs++998iGBUYGlJZTAbKiyWpNvCDQZ1pnWhoWBmxQGeikXW
         QIfknbo+HWLQxWsdouoguxZ7MG/dm6sZ23bstX0ruMP3n14rq0D9IXUHtf/YLifHdbrl
         v7MA==
X-Forwarded-Encrypted: i=1; AJvYcCWsSqMr4top59pY1v4rctx/S9ruNMqarEF08/tUIMhdZ8ioKZCUKA3rf//WQysxK8+Nb2vTSKCDZcorXHYZ0Z9ZQWS+EZFj
X-Gm-Message-State: AOJu0YzlJxdjlOIna0XtLt4OExHhFfHCJgaveZ2nnvLRN2SbVVzJovE/
	tAk8d0/hH6NrDAeKGKDKhgkwXWY+LW10E2RBQxIheGF4VWYrfW2y
X-Google-Smtp-Source: AGHT+IEto5Hv/5kS0NEzNyuamOC5figEue036XmH8VnitTet5uL5i9qxzmLAbquKR88Rimd4Iq2s8A==
X-Received: by 2002:a05:6870:7315:b0:21e:877d:78d5 with SMTP id q21-20020a056870731500b0021e877d78d5mr10124312oal.50.1708999561459;
        Mon, 26 Feb 2024 18:06:01 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id t22-20020a0568301e3600b006e12266433csm1343052otr.27.2024.02.26.18.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 18:06:00 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 26 Feb 2024 20:05:58 -0600
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
Message-ID: <mw4yhbmza4idassgbqeiti4ue7jq377ezxfrqrcbsbzsrmfiln@kn7qmqljvswl>
References: <cover.1708709155.git.john@groves.net>
 <ZdkzJM6sze-p3EWP@bombadil.infradead.org>
 <cc2pabb3szzpm5jxxeku276csqu5vwqgzitkwevfluagx7akiv@h45faer5zpru>
 <Zdy0CGL6e0ri8LiC@bombadil.infradead.org>
 <w5cqtmdgqtjvbnrg5okdgmxe45vjg5evaxh6gg3gs6kwfqmn5p@wgakpqcumrbt>
 <CAB=NE6UvHSvTJJCq-YuBEZNo8F5Kg25aK+2im=V7DgEsTJ8wPg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB=NE6UvHSvTJJCq-YuBEZNo8F5Kg25aK+2im=V7DgEsTJ8wPg@mail.gmail.com>

On 24/02/26 04:58PM, Luis Chamberlain wrote:
> On Mon, Feb 26, 2024 at 1:16 PM John Groves <John@groves.net> wrote:
> >
> > On 24/02/26 07:53AM, Luis Chamberlain wrote:
> > > On Mon, Feb 26, 2024 at 07:27:18AM -0600, John Groves wrote:
> > > > Run status group 0 (all jobs):
> > > >   WRITE: bw=29.6GiB/s (31.8GB/s), 29.6GiB/s-29.6GiB/s (31.8GB/s-31.8GB/s), io=44.7GiB (48.0GB), run=1511-1511msec
> > >
> > > > This is run on an xfs file system on a SATA ssd.
> > >
> > > To compare more closer apples to apples, wouldn't it make more sense
> > > to try this with XFS on pmem (with fio -direct=1)?
> > >
> > >   Luis
> >
> > Makes sense. Here is the same command line I used with xfs before, but
> > now it's on /dev/pmem0 (the same 128G, but converted from devdax to pmem
> > because xfs requires that.
> >
> > fio -name=ten-256m-per-thread --nrfiles=10 -bs=2M --group_reporting=1 --alloc-size=1048576 --filesize=256MiB --readwrite=write --fallocate=none --numjobs=48 --create_on_open=0 --ioengine=io_uring --direct=1 --directory=/mnt/xfs
> 
> Could you try with mkfs.xfs -d agcount=1024
> 
>  Luis

$ luis/fio-xfsdax.sh 
+ sudo mkfs.xfs -d agcount=1024 -m reflink=0 -f /dev/pmem0
meta-data=/dev/pmem0             isize=512    agcount=1024, agsize=32768 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=33554432, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
+ sudo mount -o dax /dev/pmem0 /mnt/xfs
+ sudo chown jmg:jmg /mnt/xfs
+ ls -al /mnt/xfs
total 0
drwxr-xr-x  2 jmg  jmg   6 Feb 26 19:56 .
drwxr-xr-x. 4 root root 30 Feb 26 14:58 ..
++ nproc
+ fio -name=ten-256m-per-thread --nrfiles=10 -bs=2M --group_reporting=1 --alloc-size=1048576 --filesize=256MiB --readwrite=write --fallocate=none --numjobs=48 --create_on_open=0 --ioengine=io_uring --direct=1 --directory=/mnt/xfs
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
Jobs: 17 (f=170): [_(2),W(1),_(8),W(2),_(7),W(3),_(2),W(2),_(3),W(2),_(2),W(1),_(2),W(1),_(1),W(3),_(4),W(2)][Jobs: 1 (f=10): [_(47),W(1)][100.0%][w=8022MiB/s][w=4011 IOPS][eta 00m:00s]                                                                                
ten-256m-per-thread: (groupid=0, jobs=48): err= 0: pid=141563: Mon Feb 26 19:56:28 2024
  write: IOPS=6578, BW=12.8GiB/s (13.8GB/s)(114GiB/8902msec); 0 zone resets
    slat (usec): min=18, max=60593, avg=1230.85, stdev=1799.97
    clat (usec): min=2, max=98969, avg=5133.25, stdev=5141.07
     lat (usec): min=294, max=99725, avg=6364.09, stdev=5440.30
    clat percentiles (usec):
     |  1.00th=[   11],  5.00th=[   46], 10.00th=[  217], 20.00th=[ 2376],
     | 30.00th=[ 2999], 40.00th=[ 3556], 50.00th=[ 3785], 60.00th=[ 3982],
     | 70.00th=[ 4228], 80.00th=[ 7504], 90.00th=[13173], 95.00th=[14091],
     | 99.00th=[21890], 99.50th=[27919], 99.90th=[45351], 99.95th=[57934],
     | 99.99th=[82314]
   bw (  MiB/s): min= 5085, max=27367, per=100.00%, avg=14361.95, stdev=165.61, samples=719
   iops        : min= 2516, max=13670, avg=7160.17, stdev=82.88, samples=719
  lat (usec)   : 4=0.05%, 10=0.72%, 20=2.23%, 50=2.48%, 100=3.02%
  lat (usec)   : 250=1.54%, 500=2.37%, 750=1.34%, 1000=0.75%
  lat (msec)   : 2=3.20%, 4=43.10%, 10=23.05%, 20=14.81%, 50=1.25%
  lat (msec)   : 100=0.08%
  cpu          : usr=10.18%, sys=0.79%, ctx=67227, majf=0, minf=38511
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,58560,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=12.8GiB/s (13.8GB/s), 12.8GiB/s-12.8GiB/s (13.8GB/s-13.8GB/s), io=114GiB (123GB), run=8902-8902msec

Disk stats (read/write):
  pmem0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%


I ran it several times with similar results.

Regards,
John

