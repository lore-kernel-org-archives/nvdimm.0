Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A379168
	for <nvdimm@lists.linux.dev>; Sat, 18 Dec 2021 16:00:30 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id f125so5175963pgc.0
        for <nvdimm@lists.linux.dev>; Sat, 18 Dec 2021 08:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t5I9q1MergRqDgxQAZhnu2aEGD1jh8fmtTPgd72gmVs=;
        b=S2SYoXO5jczj4Sdu9u0JYJwq0T6k2DvsrelMuU2w0ECXYIE8JE098Zbwsa6hdEkb7e
         wLOFZcEUHTP/K8TGLHBVFfvdaqKhUjPs+L5B6qUgXWeZS47C3knMlABR0BYuq45FYZnS
         LvIMsC8lWzvSTMH0AuPuDLgEu1CkjfsiIBgSqjotrVKwnob3BNibs50bfMCznHO2leHg
         dCfnl8+ADRXfXAu/uvqMfKIrDZcuSBgArQJjpiN5zDOeVffIQ49hlxrouRRlbv6T5fdd
         Y3d56PAc5wB24HSgmlWVagwg0VRn7Zz70odny+7Z7W9ikkPzyYd+hxQKaqX4AS4LRedg
         IglQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t5I9q1MergRqDgxQAZhnu2aEGD1jh8fmtTPgd72gmVs=;
        b=EP7ITlfxe8ECBcfKded+2ZQCMCgWW4ERp+Ww7kxdjZy5SvySjWvn6FX3a/PfJ7Qfmj
         tWVRpU977iL+exr+GJOsxWcdIRok7/29ewYeSRVWi/xL3m87TVtL3YAiS+FNqrLqa5ob
         kPy+zJMwCo3/0dDHNTaeySyTmBjGpLjYLi1HoabOnvssRfYVppbac02iXgOq7fw69nPR
         GDgt2aKbchmj+f7CRMbir9Ed32j07E32o3hidDNAheh4O0rvBzZB76HJzEItzdjK45M8
         mw2YLOyzj9fca9R78HGC6jISPyyjP10xdNQgZKngL31w2Wi6xgsRX8Cr0I7/F9lmIUL8
         gzuQ==
X-Gm-Message-State: AOAM53034x1rMLaiGi5tnXt7l8hEfz7toJhcUvMDeKMLBz8dNk0xBjMW
	DO+CrJGIYW7qQ2tI+B26Ims0CgduY05mHJZUACCRaQ==
X-Google-Smtp-Source: ABdhPJy90udIWMItBjJSlGKcSUSzE4dTDCINdQaCd4skBaIUdB0ddNpItdIMXHDqaZQRSMlU+RveNDme2A5RMBAMjOk=
X-Received: by 2002:a05:6a00:2405:b0:4a8:3294:743e with SMTP id
 z5-20020a056a00240500b004a83294743emr8108701pfh.61.1639843229870; Sat, 18 Dec
 2021 08:00:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210225061303.654267-1-santosh@fossix.org> <20210225061303.654267-3-santosh@fossix.org>
In-Reply-To: <20210225061303.654267-3-santosh@fossix.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 18 Dec 2021 08:00:19 -0800
Message-ID: <CAPcyv4jCUtuWG+Hwc-sndF=OFMXNK2hFDUkhUnEUzJUJTEL8zA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] test/libndctl: skip SMART tests on non-nfit devices
To: Santosh Sivaraj <santosh@fossix.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, 
	Shivaprasad G Bhat <sbhat@linux.ibm.com>, Harish Sriram <harish@linux.ibm.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 24, 2021 at 10:13 PM Santosh Sivaraj <santosh@fossix.org> wrote:
>
> This is just a temporary check till the new module has SMART capabilities
> emulated.
>

Hey Vishal, one for the v73 queue...

> Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
> ---
>  test/libndctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/test/libndctl.c b/test/libndctl.c
> index 5043ae0..001f78a 100644
> --- a/test/libndctl.c
> +++ b/test/libndctl.c
> @@ -2427,7 +2427,8 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
>          * The kernel did not start emulating v1.2 namespace spec smart data
>          * until 4.9.
>          */
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0)))
> +       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))
> +           || !ndctl_bus_has_nfit(bus))
>                 dimm_commands &= ~((1 << ND_CMD_SMART)
>                                 | (1 << ND_CMD_SMART_THRESHOLD));
>
> --
> 2.29.2
>
