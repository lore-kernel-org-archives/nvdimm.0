Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2035C2CA0
	for <nvdimm@lists.linux.dev>; Fri, 17 Dec 2021 18:37:13 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id u17so2575291plg.9
        for <nvdimm@lists.linux.dev>; Fri, 17 Dec 2021 10:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jw3+o9tkTtZaFXuWp2piyMoDxF7elmFPwWeoUWpMXV8=;
        b=xEH1wEdUSk1xmiYH6ttaReiH5aeghdNG1EYWe4VzJd8UpXsRJ0qf7fKQwfbfjoAiMD
         qQRbrVQCNbFP0y2sBr7RPCzh8bk/vDdf0kLIHuaWJMfnressCyvgbEr13bk0uidFYB1a
         y+GFFrk8YicAA8/KS/HEyqWKedlu8bBssZnMXN4NsSQLE7bdKAtIx/Uvv6xlyOl8L++d
         h+OG2Bp2vB8zvWT3vgkPV+T12CqmDvx3XMFHkJfcmayOhbBsfP34YK166mx/VJxoh3Fa
         djf3lk2phSoFObMeS7U8K9L+drSJlVtE8fO1KWvC1O3/XXgr4e04060KG0B0r2R8MaPo
         beYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jw3+o9tkTtZaFXuWp2piyMoDxF7elmFPwWeoUWpMXV8=;
        b=X9FRPY88q2U0wSK/tIxAZ5D/XETgMqRsiI2LcJu5RNU9OSB5Un/VqA239r0VD5/b/e
         Mot375qm84VcfCxZuHfOuRwHu0X35JwR6qH7388UbiZzQkZJsGvx4kwLriWX79BDnbQi
         OnlgnGnrs+zq4hE3MglJQFDYdjvBhVrY/LqdYxo3yqcnMmc3yFsVph5hsWkPRdKcU5Ug
         S4fo5tXL86zlAtYzKj5lz2rNhgMv78QaB+ZikUZoW+/cNE2YaQUIoS9U2+1r5vidSGil
         esH/DIZB6c2Fh2tZEvuXJbIdw5dr33Duff+XesbvDS3u79Jh77h7ag2V5xMSDwyC49kc
         l8+Q==
X-Gm-Message-State: AOAM533U1cVL/04QF931VK7x+ycnkPdFdeq2ghCIlm3OZcLwlpJllvyx
	+lF57oY1wdWh94NHvV/vzl+iqab0OyySN7KmKv4lWQ==
X-Google-Smtp-Source: ABdhPJxDBkvgS9A026yO5Rs99/u8nNKM0OcQsqOSN3zAuOrNgAwJTO5XzM/AR0gZffNPUZNSYWtxvjhGqJ6Iy+HwKgw=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr5150038pjb.93.1639766232605;
 Fri, 17 Dec 2021 10:37:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211213204632.56735-1-andriy.shevchenko@linux.intel.com> <CAJZ5v0jq=XdH+xeHs5=wMGsu28i+r3nzZbhCNMJkfdOi65N0Gg@mail.gmail.com>
In-Reply-To: <CAJZ5v0jq=XdH+xeHs5=wMGsu28i+r3nzZbhCNMJkfdOi65N0Gg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Dec 2021 10:37:02 -0800
Message-ID: <CAPcyv4hA41u=RvNfvukrcRDjmw6i7t4Vg3u1cXReQGKi6MHwJA@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] ACPI: NFIT: Import GUID before use
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 17, 2021 at 10:10 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Mon, Dec 13, 2021 at 9:46 PM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> >
> > Strictly speaking the comparison between guid_t and raw buffer
> > is not correct. Import GUID to variable of guid_t type and then
> > compare.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>
> Dan, are you going to take care of this or should I?

I'll take it.

Apologies for the delay in responding. I am still catching up on some
patch merging backlog.
