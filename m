Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D527A
	for <nvdimm@lists.linux.dev>; Wed, 23 Mar 2022 02:01:56 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id bc27so26450pgb.4
        for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 19:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pLZM3xjvzATAsLNs03YNSwUezrjd1ot4WTDVTGm9fDQ=;
        b=dv8LG5HB7JnpRuMkmPhrs0gyUOu+bD49LFu7+b627kBf4rWuNRmgc0rti4WxA21+kK
         7w+itS9ljtKAYOBw3OgXRL9kow/G9BRpWyY3ySYr9hIqYP4Ipps6phxxPjcV+1L4J+bH
         HoiKS8GdIpwyHoTv64BZf+yBbs077mZH0F/6xVHSxEh5Z6G4yni+V5mYbyXrGwtN57qv
         K2x0bV67beRxQRArYeypA+jLNJK1eAfyIZs/KsvJrekBgrLHZBvZCZKRWey5X9jfoFr+
         7dkYG1dTdPbJWQDFFHndc823VsJiOOKfQQmYYi5rOVa4ik0xcgAlEQXAcbgt5OjSy36k
         kaFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pLZM3xjvzATAsLNs03YNSwUezrjd1ot4WTDVTGm9fDQ=;
        b=d+FzPK0rveqQWqrPIK9B2EW5v0w0xX0ueEapvN9dymlNhAravB9zXCQPtDBmf+9IEY
         Y4F0K7gpNhhfd1UmjgDcwUtVPIn8Af+PB0wSOd/qWy52PoHlgo2S1aKa4VhI7acqHCB9
         zW6BmQbmxlwUCjijfSMtvP8KLFdgKOFLRsLox1HRTq59mq5rTliPXlG3xoJNKvlDdk5F
         u628ImCXNdpTJi6xPuguaq3iqJRo4UYQLs0R0kJ70XRCO65VSAuHKjShBBYTRjyagYMN
         hUmI2S8avyCe/sCkLP7EllZBUm4A9N9io/dAwuyj2I778RAOI9FvbP8WktQvJXoWQANj
         sndQ==
X-Gm-Message-State: AOAM531trIdOX106LtYEg1rFpN3H7F84z8WvhOUuXt7yVaV5+W8V+uSY
	zIHIjwJF5XShfG1vVmbl5y6ey2bY/xDcP2qBKolTkw==
X-Google-Smtp-Source: ABdhPJyKPoJXGMTQ91hx4JC/7ULV6MnIthDq/HGw4oZirD4Bxtkpdyr/bbPYdPdmmWPBmXzOC81czBXmfdFw36HFaJw=
X-Received: by 2002:a63:5c53:0:b0:381:309e:e72c with SMTP id
 n19-20020a635c53000000b00381309ee72cmr24709569pgm.40.1648000916091; Tue, 22
 Mar 2022 19:01:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220228094938.32153-1-yaozhenguo1@gmail.com>
In-Reply-To: <20220228094938.32153-1-yaozhenguo1@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 Mar 2022 19:01:48 -0700
Message-ID: <CAPcyv4i=1BaEMSJsQWrmPx7ycMTVWXB035xmP8Rc2WEr976Y2w@mail.gmail.com>
Subject: Re: [PATCH v1] device-dax: Adding match parameter to select which
 driver to match dax devices
To: Zhenguo Yao <yaozhenguo1@gmail.com>
Cc: Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, yaozhenguo@jd.com, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 28, 2022 at 1:50 AM Zhenguo Yao <yaozhenguo1@gmail.com> wrote:
>
> device_dax driver always match dax devices by default. The other
> drivers only match devices by dax_id. There are situations which
> need kmem drvier match all the dax device at boot time. So
> adding a parameter to support this function.

What are the situations that happen at boot time that can't wait for
initramfs or userspace to move the device assignment?
