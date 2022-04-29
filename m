Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17117B
	for <nvdimm@lists.linux.dev>; Fri, 29 Apr 2022 18:57:30 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so11301140pju.2
        for <nvdimm@lists.linux.dev>; Fri, 29 Apr 2022 11:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2vtS1l3ByqcKp4N7+o2M0gYmr7gF9CuohmWWp8cIX+M=;
        b=7BTPYeZm6O6br9G8ZnSMamE4WFCR+yQdOZo77dRK50AG8mGG3VK9Hn0vPinMR+ESJm
         SsKWquBLv2xxGeLcIDsMT08i/xHTrL/nhZLRLSAnlhwrW5VRZF9rnSWQaLuIB2KFmiNb
         hbdNQ9QZur5zCasj4RxCZqgBpht29OnNnVAcZBY47ZpI+8AUbkIkxgNFaG7jkGCfP56o
         JdWaEI/sCIsRYSWOV5BilhskD0iw6G7Y1MGI4YiwhHfQclPmc6fQvQyRfx1XaYwqccbS
         wtQ0w0Bym4ZSVMvSs6ydYtnqaAPMWO60WI4wgmgwCNdpV+xalKPEyHy2SzTOnQFTp2SU
         Jb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2vtS1l3ByqcKp4N7+o2M0gYmr7gF9CuohmWWp8cIX+M=;
        b=Sj8jCjZ31Uc3ZAiYKrRCBO3/HwrFbJPY6k79nUAHRMtrupftOQnD/pwBEU+8/PybAo
         RsgMyq817IiH17nzP+ZqkTwoek3jzqKV3G+FZSkatk0bc3bQuT5Ekmllb/a8QYaYiGY3
         7FKf2vy7ZbJ7A6HPsavKVReZNtDclvIN91l+Otld4NJ3dLC25/hnWfKyqzn2Aegr3C+q
         j2HGVcDdiYMt1IV9rk3hlsYQ2bDJmfJ1gyqYh6KnYcATMIkQq5zimA97CFXWwOOXQFOb
         UT3aUxtPi7mOFNrQXfpkcrKtX0Qg/MSVBrIiVqr1Qh63Gv+9bl88DwwBq3PrxYrVzJyD
         JSFA==
X-Gm-Message-State: AOAM531cXhTHOghySrpzG3zScc5X8FaikIJn9OSM2Qqnc9FykMbntpRa
	93y2pA7uWK5yY0oYa1JrMlggJ2WgjE2LOXT1zGDD0Q==
X-Google-Smtp-Source: ABdhPJwdqLhfstoZ6bPoO4KDf1n09Pq3Iw1TL9z97hcDMOCJaLSFAAWLKM/fIGq+rBZgLfZKdp7cOIdPUkhY1qXhOrM=
X-Received: by 2002:a17:902:da81:b0:15d:37b9:70df with SMTP id
 j1-20020a170902da8100b0015d37b970dfmr796734plx.34.1651258650114; Fri, 29 Apr
 2022 11:57:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220429074334.21771-1-msuchanek@suse.de>
In-Reply-To: <20220429074334.21771-1-msuchanek@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Apr 2022 11:57:19 -0700
Message-ID: <CAPcyv4i_frNg+pvayHyDcMSRLfGiCLDmSpPcCtocTKrAeypijQ@mail.gmail.com>
Subject: Re: [PATCH] testing: nvdimm: asm/mce.h is not needed in nfit.c
To: Michal Suchanek <msuchanek@suse.de>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, 
	Jane Chu <jane.chu@oracle.com>, Borislav Petkov <bp@suse.de>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Apr 29, 2022 at 12:43 AM Michal Suchanek <msuchanek@suse.de> wrote:
>
> asm/mce.h is not available on arm, and it is not needed to build nfit.c.
> Remove the include.
>
> It was likely needed for COPY_MC_TEST
>
> Fixes: 3adb776384f2 ("x86, libnvdimm/test: Remove COPY_MC_TEST")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>

Yup, good catch, applied.
