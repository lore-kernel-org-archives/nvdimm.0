Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AB568
	for <nvdimm@lists.linux.dev>; Wed,  3 Nov 2021 00:49:24 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso138031pjb.2
        for <nvdimm@lists.linux.dev>; Tue, 02 Nov 2021 17:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kZZrLtjwjEJ3IPsG9yhz+Qsv7Mbcxqz9ceN0wVwrxJA=;
        b=JRgj/olnX5KG4c7O7Xm0Jry+oiIPPVRs0ttrw6gNfqqnI1KamWVto+1Pxon2fIWDB1
         x1F3THYxTFa5CE7AzpmpAplt8VFcFKfqy3d3MAGp0s5nJkBUy9JedsZ+4OS6KUAKM+vB
         DvCegoQKw1vFIw4wXLe3UECLM26Wd75Cn2MgSkM0NOQW/tEUxE7RV1jJdp+3GjtYuyB8
         qk4COR6f2KXYi8/R57t9nLZVLeQ2fx8WIoFzd2PpFjGLiu6nnZ/mrHGax9Rr3YH4SIxn
         s76DGqePmbOMyvjyajU4ySIeJgRloDb6/b5JkF/zEIEF+UPqSUTfuYb6YiGVu536BR06
         QRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kZZrLtjwjEJ3IPsG9yhz+Qsv7Mbcxqz9ceN0wVwrxJA=;
        b=bsRICtMsYtH0xEStDVMEDI0B9l4QJshBrDfnaPSNi+TIArMrdQkctFqI6SfNTdEkBD
         QeAthLGO8REKfhv70E45B4koYkXtolB9zdglt8XJlYxVLOBXqk2nxeJCNE894fB+lytC
         UGh/5IiKA7wT+8Et24fUnguEWW3cLbO6i63Z9V9G6E9bPNlLUlaD0zoVNTQQVvaKNS7H
         XEn+QxrYFzThLBycAW4bNo5InMuLv/o5gIQd1BdFz6SPGBW5bTCzqPs38tbKmLr7884i
         mHY4gzZ9m5vr+WiL0MPVJx2LfSFr8Wf51yR2ogz0dTVmHvh4DjnvD7ACG6hA9s1MQ/Im
         gPpg==
X-Gm-Message-State: AOAM533/fWAJa8eqSZCm27guyCtYOWGs9hWnLZQ7k5IOTPOqiz7qiGjL
	lcT7YAOxjuT9Jtdbn+bnEpHBRgpClSiYLmgSsNiJVA==
X-Google-Smtp-Source: ABdhPJwbP41jEB/HwdZ/jyTpqMsXVbZeJ+GyahtI6BJWNgrRKpi/yor5GNtI40x53AU7YBTd151lFNCU4w2eHv7w/mI=
X-Received: by 2002:a17:90b:3b88:: with SMTP id pc8mr10700972pjb.93.1635900563928;
 Tue, 02 Nov 2021 17:49:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211015235219.2191207-1-mcgrof@kernel.org> <20211015235219.2191207-7-mcgrof@kernel.org>
 <CAPcyv4j+xLT=5RUodHWgnPjNq6t5OcmX1oM2zK2ML0U+OS_16Q@mail.gmail.com> <YYHTejXKvsGoDlOa@bombadil.infradead.org>
In-Reply-To: <YYHTejXKvsGoDlOa@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Nov 2021 17:49:12 -0700
Message-ID: <CAPcyv4h1dqBm71OQ_A5Qv4agT3PhV7uoojmSB1pEpS-CXaWb5w@mail.gmail.com>
Subject: Re: [PATCH 06/13] nvdimm/blk: avoid calling del_gendisk() on early failures
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Geoff Levand <geoff@infradead.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, 
	Paul Mackerras <paulus@samba.org>, Jim Paris <jim@jtan.com>, Minchan Kim <minchan@kernel.org>, 
	Nitin Gupta <ngupta@vflare.org>, senozhatsky@chromium.org, 
	Richard Weinberger <richard@nod.at>, miquel.raynal@bootlin.com, vigneshr@ti.com, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-mtd@lists.infradead.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-nvme@lists.infradead.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 2, 2021 at 5:10 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Fri, Oct 15, 2021 at 05:13:48PM -0700, Dan Williams wrote:
> > On Fri, Oct 15, 2021 at 4:53 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > >
> > > If nd_integrity_init() fails we'd get del_gendisk() called,
> > > but that's not correct as we should only call that if we're
> > > done with device_add_disk(). Fix this by providing unwinding
> > > prior to the devm call being registered and moving the devm
> > > registration to the very end.
> > >
> > > This should fix calling del_gendisk() if nd_integrity_init()
> > > fails. I only spotted this issue through code inspection. It
> > > does not fix any real world bug.
> > >
> >
> > Just fyi, I'm preparing patches to delete this driver completely as it
> > is unused by any shipping platform. I hope to get that removal into
> > v5.16.
>
> Curious if are you going to nuking it on v5.16? Otherwise it would stand
> in the way of the last few patches to add __must_check for the final
> add_disk() error handling changes.

True, I don't think I can get it nuked in time, so you can add my
Reviewed-by for this one.
