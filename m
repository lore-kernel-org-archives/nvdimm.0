Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE21570
	for <nvdimm@lists.linux.dev>; Thu, 27 May 2021 00:29:02 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id p39so2277870pfw.8
        for <nvdimm@lists.linux.dev>; Wed, 26 May 2021 17:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ftoroUzZXRY9bwd+OSDDuuS/kOWlZm7gCKHrGQhm3YY=;
        b=lQjnnMpJpOwc7OKE3qlAmkuOKCYjWgPZuH0QYB5+MiXx7dZe3UOcLaV5c0atEYTrjJ
         RwQvdiAe51n0JlMS5ZetCqWkifkmxAih+fxrkt3uXUtV2fX4Eqh/RfZp4dPfQfbIYnhB
         ybV60/BAeW2gB2hxKFFTUqI5jfVgVLC93L5X7H0Z+bwIyXGVwbJuwE/TAoNxagAP3W0S
         5eDtyi0g21nlQBJ/zJlhZ2lVco0xcd8B8HFwf8P/n+EdNt6dHpM/wKXFSPBNmoeeR9se
         UeK7be+MU3wpNDf3+tw+D4RWpxHTau2atp+H/xgdg2+d5hFwco6LU//4eThlL/Bw8s6P
         RqAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ftoroUzZXRY9bwd+OSDDuuS/kOWlZm7gCKHrGQhm3YY=;
        b=XWXc1Lz4qTI3B4nX3FrYJZuaktdpy1SLNlD7zW+NAspGlL0ho2PoH6PiCDXOX1MXTl
         f+AFOJbOD0fdZzt4LxXSOg9T2FSYvu9XW73p6dclDFb1ZD0XFhAPGh3+w8SpPoo4dw/0
         VoE6ONcV3PYLwqZJqTB8rkN3iU8Vvx/jPD5TIwgD2V+Ddky4aJLVhySjdwU0JlSqazj9
         bIvbSno5WAhr1tAmc7NbWlASFrVQKH643YtjAQ9Dgq35Zerjfz9zdtaSsQiMBJLTPIwS
         EYC2Ay2Ng7FB+YEsR1Y7CUP15XxGSh/fXK1kHgcGiRQTrr1A0j3Wli+ekq1U5yHs2XhZ
         76YA==
X-Gm-Message-State: AOAM533hBZ5U53nLHXEi0KqiU2+bk2EMmFmKfO4+1KNLidVicALnDQDK
	xgIXdDgCQwhgYhGHAvqx4o3awg==
X-Google-Smtp-Source: ABdhPJw/aBI5El9RaDBNOV/4JiFhCusj50uSJkCJIvFJFI18F/jd3+QgMIWdsgKtSsJMwogCTwezlw==
X-Received: by 2002:a05:6a00:2ad:b029:2dc:900f:1c28 with SMTP id q13-20020a056a0002adb02902dc900f1c28mr1032220pfs.67.1622075342190;
        Wed, 26 May 2021 17:29:02 -0700 (PDT)
Received: from localhost ([103.21.79.4])
        by smtp.gmail.com with ESMTPSA id p14sm219362pgb.2.2021.05.26.17.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 17:29:01 -0700 (PDT)
From: Santosh Sivaraj <santosh@fossix.org>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "nvdimm@lists.linux.dev"
 <nvdimm@lists.linux.dev>
Cc: "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>, "harish@linux.ibm.com"
 <harish@linux.ibm.com>, "aneesh.kumar@linux.ibm.com"
 <aneesh.kumar@linux.ibm.com>
Subject: Re: [ndctl V5 4/4] Use page size as alignment value
In-Reply-To: <5cc6a4e35883fe8d77ad375de4aef64044b076f5.camel@intel.com>
References: <20210513061218.760322-1-santosh@fossix.org>
 <20210513061218.760322-4-santosh@fossix.org>
 <27307f1aceeda53154b9985f065fdada71cf1fd4.camel@intel.com>
 <6708790151b3f627bafb2eedd21dca000372a4e9.camel@intel.com>
 <5cc6a4e35883fe8d77ad375de4aef64044b076f5.camel@intel.com>
Date: Thu, 27 May 2021 05:58:56 +0530
Message-ID: <87lf81ggtz.fsf@fossix.org>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:
Hi Vishal,

> On Wed, 2021-05-26 at 19:31 +0000, Verma, Vishal L wrote:
>> On Thu, 2021-05-13 at 18:17 +0000, Verma, Vishal L wrote:
>> > On Thu, 2021-05-13 at 11:42 +0530, Santosh Sivaraj wrote:
>> > > The alignment sizes passed to ndctl in the tests are all hardcoded to 4k,
>> > > the default page size on x86. Change those to the default page size on that
>> > > architecture (sysconf/getconf). No functional changes otherwise.
>> > > 
>> > > Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
>> > > ---
>> > >  test/dpa-alloc.c    | 15 ++++++++-------
>> > >  test/multi-dax.sh   |  6 ++++--
>> > >  test/sector-mode.sh |  4 +++-
>> > >  3 files changed, 15 insertions(+), 10 deletions(-)
>> > 
>> > Thanks for the updates, these look good - I've applied them and pushed
>> > out on 'pending'.
>> > 
>> > 
>> Hi Santosh,
>> 
>> Dan noticed that this patch[1] got dropped from the series - just
>> making sure that was intentional?

Yes, that's right. It is intentional. The support SMART test cases are
here[1] sent by Shiva, which I have combined with error injection test and sent
as one patch series.

[1]: https://lkml.kernel.org/r/20210517084259.181236-1-santosh@fossix.org

Thanks,
Santosh
>
> Oops, hit send too early.
>
> [1]: https://lore.kernel.org/linux-nvdimm/20201222042516.2984348-4-santosh@fossix.org/
>
>> 
>> Thanks,
>> -Vishal
