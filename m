Return-Path: <SRS0=lvEg=XI=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD91C4CEC9
	for <linux-nvdimm@archiver.kernel.org>; Fri, 13 Sep 2019 17:58:07 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F1E072089F
	for <linux-nvdimm@archiver.kernel.org>; Fri, 13 Sep 2019 17:58:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1E072089F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 62F3D202EA3E5;
	Fri, 13 Sep 2019 10:57:59 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=209.85.210.68; helo=mail-ot1-f68.google.com;
 envelope-from=geert.uytterhoeven@gmail.com;
 receiver=linux-nvdimm@lists.01.org 
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com
 [209.85.210.68])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37BD3202E8428
 for <linux-nvdimm@lists.01.org>; Fri, 13 Sep 2019 10:57:58 -0700 (PDT)
Received: by mail-ot1-f68.google.com with SMTP id g19so30212718otg.13
 for <linux-nvdimm@lists.01.org>; Fri, 13 Sep 2019 10:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Fc8ArwY2yHMv3VLGfSx43u0p3YGfGGpe4m6tepZiINk=;
 b=CYmC//gltYK5e3YGRFWZSvlJf1RPDXNjrNLM37ba7HJyJrGIIQtTHwbCWB/6qR5Tmg
 Ycgk2LmJ0neRY8++gt6SUysl7k6KYqc6McBSiQxYcMCzOfAAwyelqnhWV4oChH0enLkG
 /UId6foukGOvadUP6PCjlcnZKKI+HO09MWnTvprFPH3jLz5kHn5uFymMovP4ry+3sIbN
 kV/6OVuaYyNoGm2yrvTRx+6O3aubTD7iBSsYAq3wU/AeD5tjhZskoUw2P9x0RB7f8vNG
 KYzx5bObU3+7o69cimvIRz2KXiVLmeCzy+zC4X39gOqRBCQ5p6UyL1KZpnjesBywYRhB
 6qTQ==
X-Gm-Message-State: APjAAAWPLdhEeDL0CAniw0lE6TsdJrZVz57KaZpg+ObkYyCdsLjgWAv8
 mC40W7AkcIcykPMG3AFY22B/iQZ/pCT6k6j5Xxw=
X-Google-Smtp-Source: APXvYqzyImSnQNT/1nq0D+U2KoEgWBUwap3ooX9gDEXxtzeKquL0nJSL5mI7pRuhD9SS70qXmVNHPZNrhoiX0dxj2SU=
X-Received: by 2002:a05:6830:1196:: with SMTP id
 u22mr1341707otq.39.1568397484322; 
 Fri, 13 Sep 2019 10:58:04 -0700 (PDT)
MIME-Version: 1.0
References: <156821692280.2951081.18036584954940423225.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156821693963.2951081.11214256396118531359.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190911184332.GL20699@kadam>
 <9132e214-9b57-07dc-7ee2-f6bc52e960c5@kernel.dk>
 <20190913010937.7fc20d93@lwn.net> <20190913114849.GP20699@kadam>
 <b579153b-3f6d-722c-aea8-abc0d026fa0d@infradead.org>
In-Reply-To: <b579153b-3f6d-722c-aea8-abc0d026fa0d@infradead.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 13 Sep 2019 19:57:52 +0200
Message-ID: <CAMuHMdWZyJ-z6dLFMOdCLotP8J114hGX9C7+bGgxk9ReQ-Si=w@mail.gmail.com>
Subject: Re: [Ksummit-discuss] [PATCH v2 3/3] libnvdimm, MAINTAINERS:
 Maintainer Entry Profile
To: Randy Dunlap <rdunlap@infradead.org>
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Cc: ksummit <ksummit-discuss@lists.linuxfoundation.org>,
 "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 bpf <bpf@vger.kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

Hi Randy,

On Fri, Sep 13, 2019 at 5:00 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> On 9/13/19 4:48 AM, Dan Carpenter wrote:
> >> So I'm expecting to take this kind of stuff into Documentation/.  My own
> >> personal hope is that it can maybe serve to shame some of these "local
> >> quirks" out of existence.  The evidence from this brief discussion suggests
> >> that this might indeed happen.
> >
> > I don't think it's shaming, I think it's validating.  Everyone just
> > insists that since it's written in the Book of Rules then it's our fault
> > for not reading it.  It's like those EULA things where there is more
> > text than anyone can physically read in a life time.
>
> Yes, agreed.
>
> > And the documentation doesn't help.  For example, I knew people's rules
> > about capitalizing the subject but I'd just forget.  I say that if you
> > can't be bothered to add it to checkpatch then it means you don't really
> > care that strongly.
>
> If a subsystem requires a certain spelling/capitalization in patch email
> subjects, it should be added to MAINTAINERS IMO.  E.g.,
> E:      NuBus

Oh, I understood the question differently.  I thought it was about
"sub: system: Fix foo" vs. "sub: system: fix foo".

For simple and trivial things, I tend to make changes while applying, as that's
usually less work than complaining, and verifying that it's been fixed in the
next (if any) version n days/weeks/months later.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
