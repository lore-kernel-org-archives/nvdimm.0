Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B0172
	for <nvdimm@lists.linux.dev>; Sat, 30 Oct 2021 01:44:58 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id t7so11469319pgl.9
        for <nvdimm@lists.linux.dev>; Fri, 29 Oct 2021 18:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZKTw3bz9bxgBBAoCCzkjGx+o8K0N/KdabvDcNy3fVRM=;
        b=u08qxRJATUG7LTmmZF39rZHz0BSUlFRnDdaOp/cdJWtUoPJsIzug9rkcp+xiLOw5vu
         ajIppaB0A2iI3j/uQ13t6VuTfDGdvC3Gz8/SA/3ycf+eSsHP02uwaNtfI67n0g/ECi0u
         T047O2AaNu6qLF+GT16jjZCbnAd0ruj8f7tKmc1d6JLXBki8FprZ4LU3gNRBC0uCiosq
         DTs/ZB7UjIX1MJuf8o2X0u3RII1uHRbJonbI4AJF4TiQJsiYdmCrjKAi3LRxa5lfFWXw
         2JjyJx73m9zz7Zi/WdyVGbCrIrrXQ9HQiO7BB4e/fdcfjoP3f8oPLsmA5/HEiPiR/aPw
         nTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZKTw3bz9bxgBBAoCCzkjGx+o8K0N/KdabvDcNy3fVRM=;
        b=OKU0FAgmimL7vSZOEcbx2fk2oGq+ICfwLGE0xu+bWrg+To0WPE97+EsJYDbLiEr50q
         UwKlsjZ7lnOTtxqT57RKd+srk2gNTuCua8sfrMWR2OI10kC9VL+GzIhVfO2NFLksNGBZ
         SS1XOxCUSjxVNtSSbcOtG3eQkmXHdcc9atF+H7rmWRYGO1ji43nRk4g94Yz3kd+moIrL
         +OHWocFNqTovBGm3z3NAs7qNMQRR4NQI+wbY5tQaDUZtgd6jwGRf8SVm+RjT+gq6DDzy
         z7IpYd54G3jxEC8XJZPH7OIessSrOT4zDfDICbiyGGN+klLvgjtylb4A5m54W9qN/XC4
         c6Ww==
X-Gm-Message-State: AOAM531vB6jZE22WHVbPVpb9KyUsv8u/dgdOjFntR6WRcvlXJ+5BawEc
	+tXyxFOViAeFWW1PBDoOwWtfODcpzk/j2L+I3nnS5g==
X-Google-Smtp-Source: ABdhPJyPeYadoFfvpDR8yMdDrQVQwbm98jsSV/axBDYgDY32qbHU1LM0JZktTDnAN6vHey7+r8ZZo2vb4sjam6zknQs=
X-Received: by 2002:aa7:8019:0:b0:44d:d761:6f79 with SMTP id
 j25-20020aa78019000000b0044dd7616f79mr14625339pfi.3.1635558297759; Fri, 29
 Oct 2021 18:44:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163543595723.2281838.11942022992765100714.stgit@dwillia2-desk3.amr.corp.intel.com>
 <53eaa74c-0cfb-a333-4e57-8f59949b91e9@oracle.com>
In-Reply-To: <53eaa74c-0cfb-a333-4e57-8f59949b91e9@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Oct 2021 18:44:46 -0700
Message-ID: <CAPcyv4j-6tEOZg8pW_pfuftdqqFReD29e-fG0vu=GSP7YxbF2Q@mail.gmail.com>
Subject: Re: [PATCH] dax: Kill DEV_DAX_PMEM_COMPAT
To: Jane Chu <jane.chu@oracle.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, Ira Weiny <ira.weiny@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 29, 2021 at 5:19 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Hi, Dan,
>
> I think we're still using _COMPAT, but likely don't need to.

Ugh, really? I hope not, that would be unfortunate. Perhaps are you
using libndctl / libdaxctl rather than going to /sys/class/dax
directly? Those have shipped backwards compatibility for a while now,
so applications using those libraries should not notice the switch to
the /sys/bus/dax ABI. The only other open source application I could
find that had /sys/class/dax dependencies was fio, but I fixed that up
years ago as well.

 > What is your patch based on?

This is based on a branch I have with Christoph's recent dax reworks.
I have a test merge of that pushed out on my libnvdimm-pending branch
if you want to give it a try.

https://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git/log/?h=libnvdimm-pending
