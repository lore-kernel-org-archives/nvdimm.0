Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155622C81
	for <nvdimm@lists.linux.dev>; Sun, 31 Oct 2021 17:47:32 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so10929377pjb.0
        for <nvdimm@lists.linux.dev>; Sun, 31 Oct 2021 10:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7MuoEHjjO8VeJaVuFed8XWzS0lEfBBHPNJTbN9pP/Kk=;
        b=4tOJMdKFSRsgNH+AUIYaqm2kjoYMRFX1rF2DJJ+SkN3TxFcC6WFZTlfZ/p19kQbT9K
         3ucowaD3UjTRl1wxq0AhkO2grIrwJ1CUzZL9iaOW9qQruYwZiNTLyT8xPdcntcGZTnKO
         oHouSuIItcBdIuUQi3se1/cFTWoJaoIMfatJqvTJNtdVS5k8eQGd7+SN6PbVUPLsaGtZ
         l1ZNkN5xiSBdq4V2xHL4j3AS7JUzTTQy6aixWFwT8tGnH7btlFyMUA6OKqRZ3rOIuHsc
         1ZLLqjh17RQWY85HyaOON7GqX1MfrrlXjw7ctSAkgQItKO1cowEaIPOliTgHjuC8pBHM
         Mnbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7MuoEHjjO8VeJaVuFed8XWzS0lEfBBHPNJTbN9pP/Kk=;
        b=7IJswX5tBTB4K7dfhcuxT1BIuSwtdjwcJMBBoQdWvcAu2jMUMum0H8BlYasZhrazyC
         P9NxG+DVO20C72hZ3z28KTTtcTgbbgDSMd1GI7Tk/3K99h1gSCtWS0q6dr4DJQnou4V9
         XZ53KY7H5jOawzZyKYTrzJgJAMSIm1CuzXv1tUBVO2x2Z9ia7y900ybKfgVqdKHXkc8A
         o40B7HSij3qeohhk8217SSke5NbdeWEnRSMLgFCdZT2/V/cPfvaAqG3UZxvWjuLNgRF+
         Mx/OWHrrtUF580UFM9TJ8rXbJ7wlLKGEXoHOBFO/zQkuGwktKapqYN4NZry5UY4bqsP/
         SOyw==
X-Gm-Message-State: AOAM530dwVWuOrzLCwfhDlxASWUcJxGiZc3TjMyuY3aYCaYIErFPR2PY
	krM71C5rpYZdZckQ5/R1M/+Nf9OCoPGmy4lqA92UrA==
X-Google-Smtp-Source: ABdhPJyA7Laj0AUg2FKVlcU7XOrNA0zdW+Ju6E23SLHq82Op6ARxl3h9QltxEajuidxiYWqVOR7E35WaYaY6PyVeaf4=
X-Received: by 2002:a17:902:8a97:b0:13e:6e77:af59 with SMTP id
 p23-20020a1709028a9700b0013e6e77af59mr20648644plo.4.1635702452583; Sun, 31
 Oct 2021 10:47:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211015235219.2191207-1-mcgrof@kernel.org> <20211015235219.2191207-4-mcgrof@kernel.org>
In-Reply-To: <20211015235219.2191207-4-mcgrof@kernel.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 31 Oct 2021 10:47:22 -0700
Message-ID: <CAPcyv4gU0q=UhDhGoDjK1mwS8WNcWYUXgEb7Rd8Amqr1XFs6ow@mail.gmail.com>
Subject: Re: [PATCH 03/13] nvdimm/btt: do not call del_gendisk() if not needed
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

On Fri, Oct 15, 2021 at 4:53 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> We know we don't need del_gendisk() if we haven't added
> the disk, so just skip it. This should fix a bug on older
> kernels, as del_gendisk() became able to deal with
> disks not added only recently, after the patch titled
> "block: add flag for add_disk() completion notation".

Perhaps put this in:

    commit $abbrev_commit ("block: add flag for add_disk() completion notation")

...format, but I can't seem to find that commit?

If you're touching the changelog how about one that clarifies the
impact and drops "we"?

"del_gendisk() is not required if the disk has not been added. On
kernels prior to commit $abbrev_commit ("block: add flag for
add_disk() completion notation")
it is mandatory to not call del_gendisk() if the underlying device has
not been through device_add()."

Fixes: 41cd8b70c37a ("libnvdimm, btt: add support for blk integrity")

With that you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
