Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F8D6F2F2
	for <nvdimm@lists.linux.dev>; Thu, 13 Mar 2025 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741898240; cv=none; b=VbZ1jFryxPyGsL8cer5WwRh/KW8HlTeB45ENdGRDLSOKTRN0oSmy3SUVj8DzflGSLrBCPVO0APU4DMHbu1L2xqA8i9Xd/WJEodxRZbJfgWco3VR3vPwLa+VesP8nEHnjkjtdIS/hUGzKCFARo4XlJNZmsMnjwcWOYNnDkDAxnY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741898240; c=relaxed/simple;
	bh=Riz+i4ewUvQbitF11daR+1wtTdMa52JWkEbn8u2OGD4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sbgWAZ3GrCQZ8qsOIm9mWVf8t11BcmMCCWeTBG+L3gMAQDiuBpSvKZOdF2/csAJLVZLAI7TcMOwESJSCmIQny+WQlyz+nSemO2LNbwKNfUQHHZzTNu+3dEH071tkq/2rflh4AuGpXlHpHRAQ+7ZjZ3aEfwF8RDrEXwovABJ80JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sto9fn0b; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sto9fn0b"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5240a432462so1046438e0c.1
        for <nvdimm@lists.linux.dev>; Thu, 13 Mar 2025 13:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741898236; x=1742503036; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dqu3z7xLiOSf+mcYINqf8wHjgnmfkNcGWDDBMVjmjy8=;
        b=Sto9fn0bFehUqHiqzfxYoq6dzqArcFSa4oBN/YNv7Moot70uEYb4yNf00XqRYmxSBh
         +fvlDcDgJffC3PngmPI97WxmUcuftT1qabMjYdK0sAr+kP9NKRi+gPG/EwrUjODpreyi
         EDCjORgyrHPqaIymScBuu7tPtquEayvuOLpJTXXbxGbvxnNPlySA2iGegiRRddHanEdr
         l2O5HN7HYV1nisSbTj+VuY+Tye9XMW9543s2dFmT0GqxFrrGSCt/iGK53bS3kYltoawq
         dU4dRtLYlDR8U1DYeMLECQV0LEF2WGBseJD0Tkss7HK9NlrqBfiBbUqDsgBpOe2q88p6
         w6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741898236; x=1742503036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dqu3z7xLiOSf+mcYINqf8wHjgnmfkNcGWDDBMVjmjy8=;
        b=i5ooy3rmQ9/UuDApkO8cIShz1AJt67IXfcTSyZX1Ni5jCF8AeyZGEKljgfl2XQrS25
         ht6xnbFZ41NkMvvMDoLJQkK4VSH+Jx3iExWmF7BqPOST2prS/Hmt6TdF7sEVCyFReAbQ
         7lnnhnrs3I1Uc3ZKg0JUDLJamUHDIb+MNzOZzYPDjl06LsIB5SQqIzDNCGbY/nVp/4Xp
         1chetn+9K4F2nYPnh0uqPxx62jwcDaRwGzb0CNqtqKXeYErJIRi8VIQWyYRDuOYHdtPJ
         U/QoIm32yZ22g1BUNGjyTWpC906MfuqwzfVr6N9uOFAj2LsVxSqa4RCr8oO/Z41pl0Cg
         cQmQ==
X-Forwarded-Encrypted: i=1; AJvYcCX89b/6vD9W1RWi1mp3W3GFXFdZ7z58SBkQB1V9ftYcW0Tl6gkJ4ryS1khlIausixCxk3rV8QM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDUKzAplwxFVl8Yd4PKAUxQpmB9X10p+vxD4h0+TgeZ176BHdt
	o3GgmLcxaV2A7hRwqQ4GaqYFtlD0p1YZFSGKSi/uea4mxoRD61UVaAcyBLpSRaIheuXGpLGsphA
	1texj/gEKT4UPLS6Xgp3mQSqrNoc=
X-Gm-Gg: ASbGncus4lHzq480yVQjEhR9SgKWf9uJMrVX4VM/2/s/l6iBTtstH3jOf+46ZAdl4aW
	HAw6U0kP+nFC5sHlRqLKw/D+5eBPbpNXy7ZWkPUgec49rmo3KnAZQn0sLRVKnxAOa2jjZyy0Yi+
	evTUxlzuHABgfMPXLy8OJMQyguLA==
X-Google-Smtp-Source: AGHT+IGhWPno/cBlLy5i4JFgfTgN4go/KloyhLNpBTEj6UkmZZkGZMKDNDN1ix3of11Oz/UJSScIn1QWnKmOTjaulGI=
X-Received: by 2002:a05:6122:3115:b0:523:6eef:af62 with SMTP id
 71dfb90a1353d-5243a4082e2mr4188850e0c.4.1741898235977; Thu, 13 Mar 2025
 13:37:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <Z9HOavSkFf01K9xh@google.com> <5gqqbq67th4xiufiw6j3ewih6htdepa4u5lfirdeffrui7hcdn@ly3re3vgez2g>
 <CAGsJ_4xwnVxn1odj=j+z0VXm1DRUmnhugnwCH-coqBLJweDu9Q@mail.gmail.com>
 <Z9MCwXzYDRJoTiIr@google.com> <CAGsJ_4yaSx1vEiZdCouBveeH3D-bQDdvrhRpz=Kbvqn30Eh-nA@mail.gmail.com>
 <Z9MWzDUxUigJrZXt@google.com>
In-Reply-To: <Z9MWzDUxUigJrZXt@google.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 14 Mar 2025 09:37:04 +1300
X-Gm-Features: AQ5f1JogIHzZmp31Tn9SRX0wI-8utb1OhKH-ruNw33einw0Y1Le7Sq_FlEtZGgo
Message-ID: <CAGsJ_4z9pSt=LdfDUmQ7YhNocE6CJGxEwighSygGZrDFSyKU+A@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve Zram by separating compression context from kswapd
To: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Qun-Wei Lin <qun-wei.lin@mediatek.com>, 
	Jens Axboe <axboe@kernel.dk>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Chris Li <chrisl@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>, 
	Kairui Song <kasong@tencent.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	Casper Li <casper.li@mediatek.com>, Chinwen Chang <chinwen.chang@mediatek.com>, 
	Andrew Yang <andrew.yang@mediatek.com>, James Hsu <james.hsu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2025 at 6:33=E2=80=AFAM Minchan Kim <minchan@kernel.org> wr=
ote:
>
> On Fri, Mar 14, 2025 at 05:58:00AM +1300, Barry Song wrote:
> > On Fri, Mar 14, 2025 at 5:07=E2=80=AFAM Minchan Kim <minchan@kernel.org=
> wrote:
> > >
> > > On Thu, Mar 13, 2025 at 04:45:54PM +1300, Barry Song wrote:
> > > > On Thu, Mar 13, 2025 at 4:09=E2=80=AFPM Sergey Senozhatsky
> > > > <senozhatsky@chromium.org> wrote:
> > > > >
> > > > > On (25/03/12 11:11), Minchan Kim wrote:
> > > > > > On Fri, Mar 07, 2025 at 08:01:02PM +0800, Qun-Wei Lin wrote:
> > > > > > > This patch series introduces a new mechanism called kcompress=
d to
> > > > > > > improve the efficiency of memory reclaiming in the operating =
system. The
> > > > > > > main goal is to separate the tasks of page scanning and page =
compression
> > > > > > > into distinct processes or threads, thereby reducing the load=
 on the
> > > > > > > kswapd thread and enhancing overall system performance under =
high memory
> > > > > > > pressure conditions.
> > > > > > >
> > > > > > > Problem:
> > > > > > >  In the current system, the kswapd thread is responsible for =
both
> > > > > > >  scanning the LRU pages and compressing pages into the ZRAM. =
This
> > > > > > >  combined responsibility can lead to significant performance =
bottlenecks,
> > > > > > >  especially under high memory pressure. The kswapd thread bec=
omes a
> > > > > > >  single point of contention, causing delays in memory reclaim=
ing and
> > > > > > >  overall system performance degradation.
> > > > > >
> > > > > > Isn't it general problem if backend for swap is slow(but synchr=
onous)?
> > > > > > I think zram need to support asynchrnous IO(can do introduce mu=
ltiple
> > > > > > threads to compress batched pages) and doesn't declare it's
> > > > > > synchrnous device for the case.
> > > > >
> > > > > The current conclusion is that kcompressd will sit above zram,
> > > > > because zram is not the only compressing swap backend we have.
> > >
> > > Then, how handles the file IO case?
> >
> > I didn't quite catch your question :-)
>
> Sorry for not clear.
>
> What I meant was zram is also used for fs backend storage, not only
> for swapbackend. The multiple simultaneous compression can help the case,
> too.

I agree that multiple asynchronous threads might transparently improve
userspace read/write performance with just one thread or a very few threads=
.
However, it's unclear how genuine the requirement is. On the other hand,
in such cases, userspace can always optimize read/write bandwidth, for
example, by using aio_write() or similar methods if they do care about
the read/write bandwidth.

Once the user has multiple threads (close to the number of CPU cores),
asynchronous multi-threading won't offer any benefit and will only result
in increased context switching. I guess that is caused by the fundamental
difference between zram and other real devices with hardware offloads -
that zram always relies on the CPU and operates synchronously(no
offload, no interrupt from HW to notify the completion of compression).

>
> >
> > >
> > > >
> > > > also. it is not good to hack zram to be aware of if it is kswapd
> > > > , direct reclaim , proactive reclaim and block device with
> > > > mounted filesystem.
> > >
> > > Why shouldn't zram be aware of that instead of just introducing
> > > queues in the zram with multiple compression threads?
> > >
> >
> > My view is the opposite of yours :-)
> >
> > Integrating kswapd, direct reclaim, etc., into the zram driver
> > would violate layering principles. zram is purely a block device
>
> That's the my question. What's the reason zram need to know about
> kswapd, direct_reclaim and so on? I didn't understand your input.

Qun-Wei's patch 2/2, which modifies the zram driver, contains the following
code within the zram driver:

+int schedule_bio_write(void *mem, struct bio *bio, compress_callback cb)
+{
+ ...
+
+        if (!nr_kcompressd || !current_is_kswapd())
+                 return -EBUSY;
+
+}

It's clear that Qun-Wei decided to disable asynchronous threading unless
the user is kswapd. Qun-Wei might be able to provide more insight on this
decision.

My guess is:

1. Determining the optimal number of threads is challenging due to varying
CPU topologies and software workloads. For example, if there are 8 threads
writing to zram, the default 4 threads might be slower than using all 8 thr=
eads
synchronously. For servers, we could have hundreds of CPUs.
On the other hand, if there is only one thread writing to zram, using 4 thr=
eads
might interfere with other workloads too much and cause the phone to heat u=
p
quickly.

2. kswapd is the user that truly benefits from asynchronous threads. Since
it handles asynchronous memory reclamation, speeding up its process
reduces the likelihood of entering slowpath / direct reclamation. This is
where it has the greatest potential to make a positive impact.

>
> > driver, and how it is used should be handled separately. Callers have
> > greater flexibility to determine its usage, similar to how different
> > I/O models exist in user space.
> >
> > Currently, Qun-Wei's patch checks whether the current thread is kswapd.
> > If it is, compression is performed asynchronously by threads;
> > otherwise, it is done in the current thread. In the future, we may
>
> Okay, then, why should we do that without following normal asynchrnous
> disk storage? VM justs put the IO request and sometimes congestion
> control. Why is other logic needed for the case?

It seems there is still some uncertainty about why current_is_kswapd()
is necessary, so let's get input from Qun-Wei as well.

Despite all the discussions, one important point remains: zswap might
also need this asynchronous thread. For months, Yosry and Nhat have
been urging the zram and zswap teams to collaborate on those shared
requirements. Having one per-node thread for each kswapd could be the
low-hanging fruit for both zswap and zram.

Additionally, I don't see how the prototype I proposed here [1] would confl=
ict
with potential future optimizations in zram, particularly those aimed at
improving filesystem read/write performance through multiple asynchronous
threads, if that is indeed a valid requirement.

[1] https://lore.kernel.org/lkml/20250313093005.13998-1-21cnbao@gmail.com/

>
> > have additional reclaim threads, such as for damon or
> > madv_pageout, etc.
> >
> > > >
> > > > so i am thinking sth as below
> > > >
> > > > page_io.c
> > > >
> > > > if (sync_device or zswap_enabled())
> > > >    schedule swap_writepage to a separate per-node thread
> > >
> > > I am not sure that's a good idea to mix a feature to solve different
> > > layers. That wouldn't be only swap problem. Such an parallelism under
> > > device  is common technique these days and it would help file IO case=
s.
> > >
> >
> > zswap and zram share the same needs, and handling this in page_io
> > can benefit both through common code. It is up to the callers to decide
> > the I/O model.
> >
> > I agree that "parallelism under the device" is a common technique,
> > but our case is different=E2=80=94the device achieves parallelism with
> > offload hardware, whereas we rely on CPUs, which can be scarce.
> > These threads may also preempt CPUs that are critically needed
> > by other non-compression tasks, and burst power consumption
> > can sometimes be difficult to control.
>
> That's general problem for common resources in the system and always
> trace-off domain in the workload areas. Eng folks has tried to tune
> them statically/dynamically depending on system behavior considering
> what they priorites.

Right, but haven't we yet taken on the task of tuning multi-threaded zram?

>
> >
> > > Furthermore, it would open the chance for zram to try compress
> > > multiple pages at once.
> >
> > We are already in this situation when multiple callers use zram simulta=
neously,
> > such as during direct reclaim or with a mounted filesystem.
> >
> > Of course, this allows multiple pages to be compressed simultaneously,
> > even if the user is single-threaded. However, determining when to enabl=
e
> > these threads and whether they will be effective is challenging, as it
> > depends on system load. For example, Qun-Wei's patch chose not to use
> > threads for direct reclaim as, I guess,  it might be harmful.
>
> Direct reclaim is already harmful and that's why VM has the logic
> to throttle writeback or other special logics for kswapd or direct
> reclaim path for th IO, which could be applied into the zram, too.

I'm not entirely sure that the existing congestion or throttled writeback
can automatically tune itself effectively with non-offload resources. For
offload resources, the number of queues and the bandwidth remain stable,
but for CPUs, they fluctuate based on changes in system workloads.

Thanks
Barry
