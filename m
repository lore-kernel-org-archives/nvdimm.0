Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC5EC80
	for <nvdimm@lists.linux.dev>; Mon, 14 Feb 2022 20:10:02 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id e17so11622092pfv.5
        for <nvdimm@lists.linux.dev>; Mon, 14 Feb 2022 12:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=17Bsz2tDR9cv+r6+yn7G+p/1ar4tciGH3rzRstCpvzk=;
        b=j+pDsEQOlVPYsxzQ1X2T7ellEP2v/3Rap3g71hqa2HH9Snz9hF+a/BLY2uP2SUiOAL
         KaCv200/N6QR02DB0RkW6K2XaSg047kyLVbW9kGPiOieblI3bV715SxDOnunt6rJsxa1
         JvJV6XVgw/jSyDHhPnZ8aUrYJ1EkuFG/Ual94yrXo8DkHc/MNs48epBWLHc8QYScxIo9
         k+M/cZX/QPlGKGhZrKa1R4RGfmv7K5uJAB8OPuH3jYezUe6iVk1q82ruEg8Ib/d1rymi
         rZhREHlJ2A0OK8+l+lGlHtYS2aFUVhOytLVkUgMoDXHWQdgUvo1kzklV1fwBgvuBky60
         rPrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=17Bsz2tDR9cv+r6+yn7G+p/1ar4tciGH3rzRstCpvzk=;
        b=jgtkNbq+ggXm1Yf843Yc/B2NeEaAuSimcODv0zjIbX3hmw8CB4UombX8EH64QT3XYD
         p0eAUEtHVJnkaxiQTPiDps3V2/JajMdyfTEhBpwlefhpYqggwulQVU7dPvtiikV564u+
         YVl4Xo5KUczv6/f8nWqBY7Pwilh4bcFTLYOWLF3X475MuNhaJkqd0ATomATZ/luWhEPu
         +vXrw9i24ojiUHQnqGu0/u6CosFfAoNbmQX0DqKSbqcWXiIrQ7nKo1Pw5bqJqDpXivEk
         jUyx923UrwNhkjW4SbxbyyWJMGBtqcSMkBR+K4l99aFo5JqOZEDXnWoou/pgoZchTjq6
         xa5A==
X-Gm-Message-State: AOAM530igdg+234I0xhuQOq/Oqs+Cjm4Y1EX2K5kuT0agFZfhKlU+xhG
	cF1oPweuaQIcqx4E4eIfR/slYiH1V4SMRHgmn0EZNw==
X-Google-Smtp-Source: ABdhPJz0Oy/JgAUdiZIwNaa8W2W0mJGvuMr99W2I9UeRvepCocWgHMmOer0izZmus6n4NKI4NDsPxZZe9MeKAxdZ1p0=
X-Received: by 2002:a62:e907:: with SMTP id j7mr753345pfh.3.1644869401968;
 Mon, 14 Feb 2022 12:10:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220212071111.148575-1-ztong0001@gmail.com> <20220214175905.GV785175@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20220214175905.GV785175@iweiny-DESK2.sc.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Feb 2022 12:09:54 -0800
Message-ID: <CAPcyv4jrh5Xr3AnOj-YrOr3i4HTm=wVBuaQ1VBAxCoszHjHdfA@mail.gmail.com>
Subject: Re: [PATCH] dax: make sure inodes are flushed before destroy cache
To: Tong Zhang <ztong0001@gmail.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 14, 2022 at 9:59 AM Ira Weiny <ira.weiny@intel.com> wrote:
>
> On Fri, Feb 11, 2022 at 11:11:11PM -0800, Tong Zhang wrote:
> > A bug can be triggered by following command
> >
> > $ modprobe nd_pmem && modprobe -r nd_pmem
> >
> > [   10.060014] BUG dax_cache (Not tainted): Objects remaining in dax_cache on __kmem_cache_shutdown()
> > [   10.060938] Slab 0x0000000085b729ac objects=9 used=1 fp=0x000000004f5ae469 flags=0x200000000010200(slab|head|node)
> > [   10.062433] Call Trace:
> > [   10.062673]  dump_stack_lvl+0x34/0x44
> > [   10.062865]  slab_err+0x90/0xd0
> > [   10.063619]  __kmem_cache_shutdown+0x13b/0x2f0
> > [   10.063848]  kmem_cache_destroy+0x4a/0x110
> > [   10.064058]  __x64_sys_delete_module+0x265/0x300
> >
> > This is caused by dax_fs_exit() not flushing inodes before destroy cache.
> > To fix this issue, call rcu_barrier() before destroy cache.
>
> I don't doubt that this fixes the bug.  However, I can't help but think this is
> hiding a bug, or perhaps a missing step, in the kmem_cache layer?  As far as I
> can see dax does not call call_rcu() and only uses srcu not rcu?  I was tempted
> to suggest srcu_barrier() but dax does not call call_srcu() either.

This rcu_barrier() is associated with the call_rcu() in destroy_inode().

While kern_unmount() does a full sycnrhonize_rcu() after clearing
->mnt_ns. Any pending destroy_inode() callbacks need to be flushed
before the kmem_cache is destroyed.

> So I'm not clear about what is really going on and why this fixes it.  I know
> that dax is not using srcu is a standard way so perhaps this helps in a way I
> don't quite grok?  If so perhaps a comment here would be in order?

Looks like a common pattern I missed that all filesystem exit paths implement.
