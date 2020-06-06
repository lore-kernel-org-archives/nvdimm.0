Return-Path: <SRS0=hSOo=7T=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B537C433E2
	for <linux-nvdimm@archiver.kernel.org>; Sat,  6 Jun 2020 06:48:20 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D6356204EF
	for <linux-nvdimm@archiver.kernel.org>; Sat,  6 Jun 2020 06:48:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6356204EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id F289C1009C912;
	Fri,  5 Jun 2020 23:48:19 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=209.85.210.68; helo=mail-ot1-f68.google.com; envelope-from=rjwysocki@gmail.com; receiver=<UNKNOWN> 
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com [209.85.210.68])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 0C0D31009EA39
	for <linux-nvdimm@lists.01.org>; Fri,  5 Jun 2020 23:48:17 -0700 (PDT)
Received: by mail-ot1-f68.google.com with SMTP id h7so9499634otr.3
        for <linux-nvdimm@lists.01.org>; Fri, 05 Jun 2020 23:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+aQLNzslwbNr61yynEZEbahvlkcr5toggFOf8ArYr9g=;
        b=adov2y0tneJI0VvWvdRwAtrbjDmqQW+nlwxByhTRZOuLbMq4oL7xukFroSYjHOtQ4p
         QSEapHscc4MbKjYpx+KkCTLkpEAVHO4VBhIlWI09bng/B6PhAxWMGpfN66fHfgldek6d
         JZ+VxpJvXgYNJDEIE3sDOhNN7LWXpoYwJS3H4scHIO5Lrtwmq43xnFEiID67OopY094X
         MuisZfkDipyxg7YzKQwLzh78zuLXBXFoIyp1x9MvbO9vICITS45r9O+2VwOcpwdWF2h8
         pRwywJXqeaXfHvpQyn0rTDhvgzXAucaDtWExi0sUnfDTzcORWThkuLarjtRuzCBk19oo
         kRng==
X-Gm-Message-State: AOAM5339jXLd6nRQefjc9p0wFYIk73IqZrXEm6WPp8eq0sp3sACdw7xI
	dygb0aP3LdtcWZT27B++neicZ+5IB6RY8ff+Fd0=
X-Google-Smtp-Source: ABdhPJz65WaazHUQLYExUKsLF9v8Y9URApAU8lJ65W8OCHHvRpRP6ZlEV0lHXZ2r87+tcUaFkFy8iWSi7GfxwLBgGXM=
X-Received: by 2002:a9d:5185:: with SMTP id y5mr9787455otg.118.1591426096725;
 Fri, 05 Jun 2020 23:48:16 -0700 (PDT)
MIME-Version: 1.0
References: <158889473309.2292982.18007035454673387731.stgit@dwillia2-desk3.amr.corp.intel.com>
 <2643462.teTRrieJB7@kreacher> <CAHp75Ve8A373Cbw6RiKTtkhj9jsxZ9dBY8ELtntk0B=yXxOCUg@mail.gmail.com>
In-Reply-To: <CAHp75Ve8A373Cbw6RiKTtkhj9jsxZ9dBY8ELtntk0B=yXxOCUg@mail.gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Sat, 6 Jun 2020 08:48:05 +0200
Message-ID: <CAJZ5v0hpwOJfy_4c3O-TWHh=cd=qiOcb3JCyRoq-igsW+12ZvA@mail.gmail.com>
Subject: Re: [RFT][PATCH] ACPI: OSL: Use rwlock instead of RCU for memory management
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Message-ID-Hash: IEM2NAYBJ4XIHPUPG6V64N5RIQE5NTOC
X-Message-ID-Hash: IEM2NAYBJ4XIHPUPG6V64N5RIQE5NTOC
X-MailFrom: rjwysocki@gmail.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Stable <stable@vger.kernel.org>, Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>, James Morse <james.morse@arm.com>, Erik Kaneda <erik.kaneda@intel.com>, Myron Stowe <myron.stowe@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/IEM2NAYBJ4XIHPUPG6V64N5RIQE5NTOC/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 5, 2020 at 9:40 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Fri, Jun 5, 2020 at 5:11 PM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
> ...
>
> > +       if (!refcount) {
> > +               write_lock_irq(&acpi_ioremaps_list_lock);
> > +
> > +               list_del(&map->list);
> > +
> > +               write_unlock_irq(&acpi_ioremaps_list_lock);
> > +       }
> >         return refcount;
>
> It seems we can decrease indentation level at the same time:
>
>   if (refcount)
>     return refcount;
>
>  ...
>  return 0;

Right, but the patch will need to be dropped anyway I think.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
