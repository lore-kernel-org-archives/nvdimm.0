Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3065E2FB2
	for <nvdimm@lists.linux.dev>; Fri, 25 Jun 2021 23:15:12 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id w15so4877961pgk.13
        for <nvdimm@lists.linux.dev>; Fri, 25 Jun 2021 16:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mgoIpnyoUGsKuOAmGjFiqoU5m5SeFD0m93wqGX4IhMw=;
        b=U5fXPUKG4giN0X1sL8lIksOA2vKXvczs+lYJxR16NLWNcy+gkNzWTYz3lcisUn0j6D
         6yoiFTpPBIjsA35AzqYi7bMIKhhdjun1ffXvM1kXFMLK1sFxHPWYXWRU+1IVnfUPu1ig
         z+tNlHIFwuAVeCQJGDxSY+3TXzVIy8eWN98AOSEmrcs/XFaU449jCRclafmG50EyDgoL
         8CIyXIPyuuxmnxaHab6e5Ux/X0LX10hvWWpHCUEH/wW5rsG0d8ZOzcjn+/uKn9H/ePao
         MeF9KP8W839jSnnSqm47eNMcC6sCWYNtf/vR8ei6nDyt3yL/o7KM0vL+2fdVVb62b7NM
         fgyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mgoIpnyoUGsKuOAmGjFiqoU5m5SeFD0m93wqGX4IhMw=;
        b=RKTttWQ4aUcAuGMY80IqnS0i2KBRqOWEr1Rze2tF6l/y5QE7iY39zU0ronSBxOckKo
         Wf2JOXFn2fmZr9+uSdKzzu7ZS0ulFSNCzp1Iy3Y7NuaSij5KQAVRqcIO4flwCS184E2t
         Yk/LkKq7WmjD0Axcyp9O49FYLpExOM3QhImt85xQqU3BARn9gNlxT6Iw/r4R8DHbWMlV
         +prd8k9EI0l+Z1m0cFodRDI5g5uXXfbHvE84ex7hfp3o8gWnt77GFvK4EmHS4NUX9kWV
         drIIjykqEkFKZAKDWnlp6QIo3THl7rFgbG4jsJUfGaek0zvGmG4EP9/OZF0i9+zfBMO4
         jSKg==
X-Gm-Message-State: AOAM532k1WK2LHVvgbh5s8nkM4aYH2zu2BlAKW1zJpxr++D8ijbmLKkh
	GboDCFjo4y+GK1xoaGtRbe+YwQ419P4zQm3qJGAgkQ==
X-Google-Smtp-Source: ABdhPJwyOV5U7STlqu/JcA2M9n5Gq0SrAGgZMFfv7tLy4Rn1fjFT0WDbS79SPEhoTpZ4bdcN3mj3QUGJQWYe7ZfpzNg=
X-Received: by 2002:a63:195b:: with SMTP id 27mr11701216pgz.450.1624662912526;
 Fri, 25 Jun 2021 16:15:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <327f9156-9b28-d20e-2850-21c125ece8c7@oracle.com>
 <YNErtAaG/i3HBII+@garbanzo> <81b46576-f30e-5b92-e926-0ffd20c7deac@oracle.com>
In-Reply-To: <81b46576-f30e-5b92-e926-0ffd20c7deac@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Jun 2021 16:15:01 -0700
Message-ID: <CAPcyv4hDJiAwAfvdfvnnReMik=ZVM5oNv2SH5Qo+YV3oY=VLBQ@mail.gmail.com>
Subject: Re: set_memory_uc() does not work with pmem poison handling
To: Jane Chu <jane.chu@oracle.com>
Cc: Luis Chamberlain <mcgrof@suse.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	"Luis R. Rodriguez" <mcgrof@kernel.org>, "Luck, Tony" <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"

[ add Tony ]

Hi Jane,

I was out for a few days...

On Tue, Jun 22, 2021 at 10:22 AM Jane Chu <jane.chu@oracle.com> wrote:
>
>
> On 6/21/2021 5:15 PM, Luis Chamberlain wrote:
> > On Tue, Jun 15, 2021 at 11:55:19AM -0700, Jane Chu wrote:
> >> Hi, Dan,
> >>
> >> It appears the fact pmem region is of WB memtype renders set_memory_uc()
> >>
> >> to fail due to inconsistency between the requested memtype(UC-) and the
> >> cached
> >>
> >> memtype(WB).
> >>
> >> # cat /proc/iomem |grep -A 8 -i persist
> >> 1840000000-d53fffffff : Persistent Memory
> >>    1840000000-1c3fffffff : namespace0.0
> >>    5740000000-76bfffffff : namespace2.0
> >>
> >> # cat /sys/kernel/debug/x86/pat_memtype_list
> >> PAT memtype list:
> >> PAT: [mem 0x0000001840000000-0x0000001c40000000] write-back
> >> PAT: [mem 0x0000005740000000-0x00000076c0000000] write-back
> >>
> >> [10683.418072] Memory failure: 0x1850600: recovery action for dax page:
> >> Recovered
> >> [10683.426147] x86/PAT: fsdax_poison_v1:5018 conflicting memory types
> >> 1850600000-1850601000  uncached-minus<->write-back
> >>
> >> cscope search shows that unlike pmem, set_memory_uc() is primarily used by
> >> drivers dealing with ioremap(),
> >
> > Yes, when a driver *knows* the type must follow certain rules, it
> > requests it.
> >
> >> perhaps the pmem case needs another way to suppress prefetch?
> >>
> >> Your thoughts?
> >
> > The way to think about this problem is, who did the ioremap call for the
> > ioremap'd area? That's the driver that needs changing.
>
> I'm not sure if the pmem driver is doing something wrong, but rather the
> pmem memory failure handler.

This is a fixup that got lost in the shuffle. The issue is that the
memtype tracking needs to be updated before the set_memory_uc(), or
the memtype tracking needs to be bypassed.

You'll notice that this commit:

284ce4011ba6 x86/memory_failure: Introduce {set, clear}_mce_nospec()

...effectively replaced set_memory_np() with set_memory_uc(). However,
set_memory_np() does not check memtype and set_memory_uc() does.

I believe it should be sufficient to do the following, i.e. skip the
memtype sanity checking because the memory-failure code should have
already shot down all the conflicting WB mappings:

diff --git a/arch/x86/include/asm/set_memory.h
b/arch/x86/include/asm/set_memory.h
index 43fa081a1adb..0bf2274c5186 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -114,8 +114,13 @@ static inline int set_mce_nospec(unsigned long
pfn, bool unmap)

        if (unmap)
                rc = set_memory_np(decoy_addr, 1);
-       else
-               rc = set_memory_uc(decoy_addr, 1);
+       else {
+               /*
+                * Bypass memtype checks since memory-failure has shot
+                * down mappings.
+                */
+               rc = _set_memory_uc(decoy_addr, 1);
+       }
        if (rc)
                pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
        return rc;
