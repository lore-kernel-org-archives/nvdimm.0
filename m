Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A542CA6
	for <nvdimm@lists.linux.dev>; Wed,  8 Dec 2021 21:52:05 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso4135086otf.12
        for <nvdimm@lists.linux.dev>; Wed, 08 Dec 2021 13:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vRCh7LN7zhiVa3lMWibijYpAssN+6uZYLPHSZBBbm6A=;
        b=cXr3pkKI7jYmNYyDhNz2jhvOyFLTobh+CPedVrOvrM9EXPzkmCpQuNf2lNEbk7JtoP
         8ppXK6OQkMq1e4fIT0t/jvlyWb7HR/n74+eslHdBZ8cDS+u0+voZeykJVkfEhYln/gvM
         Ohq6ztJA/gIRfPJjPeMHNPtIDgVBC3hPG9x7GFIkLzx9rK6OGlJIX+AVyBQsU+ruURCs
         nUHW+1eiPzwBNpAOhiAcU185d6kS4WCXR/0RL2ksuKFdMb6D9Jd1kHrgAWdMUAmizNmL
         g0dXnE/FtWwy8t36QU7vF2qGg3EOPrV0URvl1bCmBzsRJ0xExzUTcfz9BuZMJgyJHC7U
         433Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vRCh7LN7zhiVa3lMWibijYpAssN+6uZYLPHSZBBbm6A=;
        b=UtDYxvAwtJfbZrbpm4cVEaPS0SzhtMyh15aV6dRjdKqretlKtyVIZ40FgpR3u+0V7u
         WLx/dvMW0Gdr3YhNZm4Qd95Qhjq7uA2syt/sZ/4ZQ+1oy33x1K/pGTYCrK6HsBvtmtyp
         usItf+YQfQ67yHzwaoUzR/WLCr0QkK16B7f29V3yuNPxx2sgK28CDyUkuRsfNPn2sLac
         1z5J9hxFpp26qSf5hf/XQlT7eKvy6dUxb6e2hsl6zowIVd/RcDrZo4/KYbCQSHoelwy9
         uEcppX1crP/g2KrzEJZQKBIAVwXh2BALJMW6nlfzBPD4X2jRJwAkPOoxY1Rl1rg5PW+/
         sjsA==
X-Gm-Message-State: AOAM533DhaZiDSw5XUWEcS1amza0/95hmZq8HslD4SEGqCpRYk9KWJC8
	1tMkadUMEfxZo5we6fCmxV5N0/8gA3lLGO/3ltIkI/NC5bk=
X-Google-Smtp-Source: ABdhPJyIWBTcq33rhHa/Xji/p13EAmX7XmC4GvJGDmdKX0f2mHOW2cP6ZdOZDrIwt485022XCD0GxoQofTii9/9uldI=
X-Received: by 2002:a05:6830:2b20:: with SMTP id l32mr1849291otv.333.1639000324329;
 Wed, 08 Dec 2021 13:52:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211206222830.2266018-1-vishal.l.verma@intel.com> <20211206222830.2266018-8-vishal.l.verma@intel.com>
In-Reply-To: <20211206222830.2266018-8-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Dec 2021 13:51:54 -0800
Message-ID: <CAPcyv4hrhA=6nYzSyfeTHUP2r2arWRh-zCqBAr7te0t-MpTPjw@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 07/12] daxctl: Documentation updates for
 persistent reconfiguration
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 6, 2021 at 2:28 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add a man page update describing how daxctl-reconfigure-device(1) can
> be used for persistent reconfiguration of a daxctl device using a
> config file.

Looks good, although this makes me think we need to immediately
proceed to make an attempt at populating a /dev/dax/by-path that works
across both NVDIMM dax devices and soft-reserved dax devices.

You can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
