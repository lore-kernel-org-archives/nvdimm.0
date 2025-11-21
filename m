Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9172877D7
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 21:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763759270; cv=none; b=GLVZhssQUm667ZckHPactlSJj9YXQtYB8TbpJWSTpPo9laLHDW7hm9KOM592VznzXYGcY3t4iR5t9AGBnQmsICZueSPtSDFqbWcFcmac805AWTPWF/dyEI6wjB0Vynm2yoYwLUUaVcv7mo1TSsTddEGWXH6JAWtwcdwTHrt14iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763759270; c=relaxed/simple;
	bh=shSHymcVpVsJRS3DnGEq5zOC8PBxp/thlGXIe4I1Liw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XSIkwuK+N/2zRt0FL0p0Fu/JTHsabCnbOdfwFJe0ws5XNL2+cE5S1lGZSR1ZylEaMa31GE3VV9GRln2cbRBgJMQc2PN1mGbG/PbePlbcbcjgDqjumyQK38yt3PMY1c4W0xqO4zu9UMUd6vs2rIJ+8cBk+DkKpVPh/Kb373qGD3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=q36k2ero; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="q36k2ero"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ee257e56aaso22882231cf.0
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 13:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1763759267; x=1764364067; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Svi+I8ywJ8k5uxtzxqjpEGX4Qh9Fr5IeUT/6ziPIoB4=;
        b=q36k2eroSfGfBhYAUdPtgc8hyIy+HFaDSj+sWmKXyt+gK1/84cj0FhGzfpk7xXvRx/
         mPbEyd21tW1D3UYtk3GN3eyqB7+uHYSWh1GPUQAyldwpYiyjU56igOWQICelbSfAtsVI
         GyZZzAN/mjEIqtxL/bPjqY6zlrONtJBzfC4Isi/9yX11Q4HZcqlpgpPzLtByjJRIdRNJ
         fDo1tmKcHVc/76us0/keTQFYX8MXtSZuPvouVYi8SrypzTbXxwO6pDrGPYI/wzJJSs0+
         5DZ/T8abCL5uIqZyLXxsuC01YGMzyjTa0kqrmxB6/N8/KgiUSlx4H2QnrC3x++cR0qtX
         Rf3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763759267; x=1764364067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Svi+I8ywJ8k5uxtzxqjpEGX4Qh9Fr5IeUT/6ziPIoB4=;
        b=Xet4e9wg/m34A1pCDn4Njf/p1o+oX4s0+wrcMmVG7e79SlDFmXMbI+owRRsNPzCVFU
         c6NUwNalXgkNOlP4vNNNMayFHI4eDZ/ed17mhT0dgXBvG03ZteUT0iX17HwrztAjtP6q
         fO9bVw6dpLvVP7cEBf/eZ1xjuHB/lpS409au3ie5PoqwDHKWtCK/gC4jv8y1W5R2vu3+
         Yki+xvhc6iswLuOXvHKPV2kGVmh75wQJ5vqCacw6hW8sMON5kqp7ftseGmfFKKt5ldgO
         QHqP/qdGNvXkA3s15tTzcHwo9eT5XjEUFI23Twm6PfnupQayK3ZktRx4HmfZSr3zr/Qb
         XVdQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8Ak3U8IOW/xa5u5gymc84hS4E2FLTRaHNrvgLo+kBEze2BrI/3Zi5h/gF+f2k6DypJ+Xn9sk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyfwnCO5G56klvqBwBrbN4WY6SCrsX0AnzRB528QAypAUrzmpob
	/7dwRKhazCshCcjOM1RQSOjbQpmgx65hvcTRtXzm+0r1GWq15hDL/brslN7hglRxL6Q=
X-Gm-Gg: ASbGncuL7+ADGA4FlW3AqcQX1Te8eErVx6jWfbHi3t6dYnLvU+jRIUo2ytUF/yUX6pr
	YcBIksRD2WQKko0v/KBIGkgXT7C9ctrj2vt2NNsMzRoPmTGW96biq9TQcoDIbTYEA3T3VRIU95p
	BzKQduIYc8jHx4yvX+Ewre0FCHj26R1+ilw5S6BwMnkasVrlGOqPmOjW6xzR/TWBASdzzitrobA
	46klpJFvzWjfsgHn2J22oHkKDhR7TK88nKQ+h/bnTDgYGTszIyYIxA2vf12RLuANgShJDCto9wv
	b3+1gjDrqsc89K/e5jwcbdGp2luzQP02R98UlxRkW0NFDPxrT5ddDSZqjkR0JX40w1WbuNjwv2d
	yTF2/6YaiypyPNY/sqdK0bCg3C2oVs6MwBqTbJMqAa1eP1joAHZaPm+obET/JMKjlQOgKcRYq6T
	vJswVd0sIsQmHG740LQnKe52EMkH/n2aio3E3Z0dbr2w25iGtcHZ9zbN7uQ7rO5fwRUr2ZIA==
X-Google-Smtp-Source: AGHT+IHB54I5/pxWYI0YylL4DbWXryCZhFk7bd7fb71QpMMtzOgbCdkOeFKpCqsEbmreSLGZDE/f8Q==
X-Received: by 2002:a05:622a:c6:b0:4eb:a457:394 with SMTP id d75a77b69052e-4ee587d2ef1mr64635291cf.12.1763759267374;
        Fri, 21 Nov 2025 13:07:47 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee48e65e3bsm42420991cf.17.2025.11.21.13.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 13:07:46 -0800 (PST)
Date: Fri, 21 Nov 2025 16:07:35 -0500
From: Gregory Price <gourry@gourry.net>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, mingo@redhat.com,
	peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	rientjes@google.com, jackmanb@google.com, cl@gentwo.org,
	harry.yoo@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com, rrichter@amd.com,
	ming.li@zohomail.com, usamaarif642@gmail.com, brauner@kernel.org,
	oleg@redhat.com, namcao@linutronix.de, escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
Message-ID: <aSDUl7kU73LJR78g@gourry-fedora-PF4VCD3F>
References: <20251112192936.2574429-1-gourry@gourry.net>
 <aktv2ivkrvtrox6nvcpxsnq6sagxnmj4yymelgkst6pazzpogo@aexnxfcklg75>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aktv2ivkrvtrox6nvcpxsnq6sagxnmj4yymelgkst6pazzpogo@aexnxfcklg75>

On Tue, Nov 18, 2025 at 06:02:02PM +1100, Alistair Popple wrote:
> 
> I'm interested in the contrast with zone_device, and in particular why
> device_coherent memory doesn't end up being a good fit for this.
> 
> > - Why mempolicy.c and cpusets as-is are insufficient
> > - SPM types seeking this form of interface (Accelerator, Compression)
> 
> I'm sure you can guess my interest is in GPUs which also have memory some people
> consider should only be used for specific purposes :-) Currently our coherent
> GPUs online this as a normal NUMA noode, for which we have also generally
> found mempolicy, cpusets, etc. inadequate as well, so it will be interesting to
> hear what short comings you have been running into (I'm less familiar with the
> Compression cases you talk about here though).
> 

after some thought, talks, and doc readings it seems like the
zone_device setups don't allow the CPU to map the devmem into page
tables, and instead depends on migrate_device logic (unless the docs are
out of sync with the code these days).  That's at least what's described
in hmm and migrate_device.  

Assuming this is out of date and ZONE_DEVICE memory is mappable into
page tables, assuming you want sparse allocation, ZONE_DEVICE seems to
suggest you at least have to re-implement the buddy logic (which isn't
that tall of an ask).

But I could imagine an (overly simplistic) pattern with SPM Nodes:

fd = open("/dev/gpu_mem", ...)
buf = mmap(fd, ...)
buf[0] 
   1) driver takes the fault
   2) driver calls alloc_page(..., gpu_node, GFP_SPM_NODE)
   3) driver manages any special page table masks
      Like marking pages RO/RW to manage ownership.
   4) driver sends the gpu the (mapping_id, pfn, index) information
      so that gpu can map the region in its page tables.
   5) since the memory is cache coherent, gpu and cpu are free to
      operate directly on the pages without any additional magic
      (except typical concurrency controls).

Driver doesn't have to do much in the way of allocationg management.

This is probably less compelling since you don't want general purposes
services like reclaim, migration, compaction, tiering - etc.  

The value is clearly that you get to manage GPU memory like any other
memory, but without worry that other parts of the system will touch it.

I'm much more focused on the "I have memory that is otherwise general
purpose, and wants services like reclaim and compaction, but I want
strong controls over how things can land there in the first place".

~Gregory

