Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F8E3FC2
	for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 19:08:32 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id q21so2406067plq.3
        for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 12:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BEE/mYBzvQWp3prikdXSn47IY+U22G13XwKCEBUX1Ms=;
        b=ZtIPKgVFZJf3WfYnqRkNilQq75gDXGwNjEHUQ4babkgTmRA1mN9E0ptGHOm02MeTYZ
         PHiGVKrduNjjpdyQxs33ErLvC48WcQl+08Bg+QNk5fo65R/8CPUuVKKldeS0tmAkwYxP
         tP5C7m/j4hewIFuJAmX9TynIYfPih/cuEIgm5rhYJa46MHX4VGBIa6rpm3uS6VlCqqGC
         CorkBDw5Iok/0ZRsoQP2Kb2Gb/HC9ZT/ikbqOMxDQMawOKHMaAJtnUeWFngavRRVbrlp
         U34kunwMyxbxmQ/qij5yaCuzMcMAmy/jfjydWwYwcvpQsR901FF/sfH4/8s9zOz13Lbq
         Vkdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BEE/mYBzvQWp3prikdXSn47IY+U22G13XwKCEBUX1Ms=;
        b=rTXeeiG0d631VzW4zRokjcw/IFQvkjQhVn76bkzrf5NMloPTQ4icrr0GelbG2pe0Aw
         pmnVo6lQxmiF6LrUiKjw3ahFXjgw3B5lyuSO4dCp+M9Lo0hmXs+Hn22u9sEegV9I9M5G
         o+ZM3UDMwYqDpmV+k7bTIBqY440C1RYztstktsyrD4BDErwZNbSCTR8PeUWmV83/Nf/K
         17hqrpF4cCKvy/pgzyQwnUtHojXpEFDNI3FsOtHMUE5WWeuzPbxwiQPb+/jgzlPedFB1
         ZLtdhOvHDozzi6n3va/lJeQYtWXWTnU6d+1vxxjsPIFyuJy4tSxFppzY6UH4oHgwfhds
         QldA==
X-Gm-Message-State: AOAM530NGdvfBzlPIe8rG9urXjKeb17C4BNj+rxK+MwhYvqr7/2/KYWA
	TpO3P4VOYN6rQZ8/1F5l+cxT0QoBTneA6UzCJT3ESGEWUIgIVg==
X-Google-Smtp-Source: ABdhPJz9sUd0oOEUrV2TRdi6f7vg3OCTARKlNfff+TslzcmZPWCZ8xyNKgujf9a4PVoI+ax3e+zUzOJCDCUX33IcUd4=
X-Received: by 2002:a17:90a:2f23:: with SMTP id s32mr18092802pjd.168.1630004911555;
 Thu, 26 Aug 2021 12:08:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 26 Aug 2021 12:08:20 -0700
Message-ID: <CAPcyv4jvamMXn_rWhqQZruSU6fqeNt+-LHmYb00=sZjOQOL42Q@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Linux NVDIMM <nvdimm@lists.linux.dev>
Cc: Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>, Borislav Petkov <bp@alien8.de>, 
	Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 6, 2021 at 6:01 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> When poison is discovered and triggers memory_failure() the physical
> page is unmapped from all process address space. However, it is not
> unmapped from kernel address space. Unlike a typical memory page that
> can be retired from use in the page allocator and marked 'not present',
> pmem needs to remain accessible given it can not be physically remapped
> or retired. set_memory_uc() tries to maintain consistent nominal memtype
> mappings for a given pfn, but memory_failure() is an exceptional
> condition.
>
> For the same reason that set_memory_np() bypasses memtype checks
> because they do not apply in the memory failure case, memtype validation
> is not applicable for marking the pmem pfn uncacheable. Use
> _set_memory_uc().
>
> Reported-by: Jane Chu <jane.chu@oracle.com>
> Fixes: 284ce4011ba6 ("x86/memory_failure: Introduce {set,clear}_mce_nospec()")
> Cc: Luis Chamberlain <mcgrof@suse.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Jane, can you give this a try and see if it cleans up the error you are
> seeing?
>
> Thanks for the help.

Jane, does this resolve the failure you reported [1]?

[1]: https://lore.kernel.org/r/327f9156-9b28-d20e-2850-21c125ece8c7@oracle.com

>
>  arch/x86/include/asm/set_memory.h |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
> index 43fa081a1adb..0bf2274c5186 100644
> --- a/arch/x86/include/asm/set_memory.h
> +++ b/arch/x86/include/asm/set_memory.h
> @@ -114,8 +114,13 @@ static inline int set_mce_nospec(unsigned long pfn, bool unmap)
>
>         if (unmap)
>                 rc = set_memory_np(decoy_addr, 1);
> -       else
> -               rc = set_memory_uc(decoy_addr, 1);
> +       else {
> +               /*
> +                * Bypass memtype checks since memory-failure has shot
> +                * down mappings.
> +                */
> +               rc = _set_memory_uc(decoy_addr, 1);
> +       }
>         if (rc)
>                 pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
>         return rc;
>
