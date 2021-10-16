Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99CF29CA
	for <nvdimm@lists.linux.dev>; Sat, 16 Oct 2021 00:13:57 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id 75so10004121pga.3
        for <nvdimm@lists.linux.dev>; Fri, 15 Oct 2021 17:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rQCqnCKj+Qob3RGhvKowF7vjQkMvz3jzVYQ6ojJDBgk=;
        b=22FCMxDjuptu5z2WXUhWAGeGxsQDD/V8j37BH7gzChQavhMTsYfwOs16+0368VAEwm
         H9Kn5GtjOlGOoLtQHyP63Q2TpGtOd+bYEeoJ7yrQrZF8Gd5SjSTBe4bjtPPHCkHVAMnX
         IKOrAb7pR6jb0J/r9z7kk4abkd4nzTZJqkNyspbONodFaBFVZGgHceRMhIUL1AnjE8EE
         QtZ+EolKR2dxl4bSkgWIlNfGf3FEfjjORJKFElmg1CgQAa4omqi87tX+bb0lzqw7atj/
         9H8nfrhpQOc6LGhupM+SVewu7XdQegTluU6pnHJSo4uAockAmkpsZzfTuVIRBEfs5F0h
         AY8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rQCqnCKj+Qob3RGhvKowF7vjQkMvz3jzVYQ6ojJDBgk=;
        b=HM5guwhz/9uSERGDiaHP5BWFJ5Lut2usUBUXkkficHj0mAj9uMx2o610kaDNTnxJXn
         DOMAAzoU4qO8+bq/k61g6kYU5djJoG/HKDxnzBe6g/bmcbEfVdRuwFECXX73NBqZgmuO
         ZemxiFtAdzD7spvSe+KXNgUX65pji8ntxrBTFnLedki/cIV9geJxB8D9ouZe0w5isl3z
         wJ9Jtia7OcJq+nC9nLDqfO+qS0HACLm5ZyC09jwwr+5U23/3OkwRTn8yArT+jggkI3E7
         PnYpJv5OL5YcjvMybB1I4br/nBndJDZwwRNsDgIm8ZoQ+pksHmZGLbQ6YFse+OnSn1bH
         mVrQ==
X-Gm-Message-State: AOAM530ywicMHjQOO91JJIQEzVooiLf+ZYzCKBOHqXQtvdDxFiUOAfm+
	98PjhCWSf9wAJDqInr5egU4kmZo1LtlVlfpfs+UpNg==
X-Google-Smtp-Source: ABdhPJyHjqiChiYGgEV/QjEsOo/jEjfBLMsWIS4VVM51yMBTI+afNI+/nTgDPsjRchZ2uu+6VeHhZ/gjMvW7ySA684s=
X-Received: by 2002:a63:6bc2:: with SMTP id g185mr6607076pgc.356.1634343237273;
 Fri, 15 Oct 2021 17:13:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211015235219.2191207-1-mcgrof@kernel.org> <20211015235219.2191207-7-mcgrof@kernel.org>
In-Reply-To: <20211015235219.2191207-7-mcgrof@kernel.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Oct 2021 17:13:48 -0700
Message-ID: <CAPcyv4j+xLT=5RUodHWgnPjNq6t5OcmX1oM2zK2ML0U+OS_16Q@mail.gmail.com>
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

On Fri, Oct 15, 2021 at 4:53 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> If nd_integrity_init() fails we'd get del_gendisk() called,
> but that's not correct as we should only call that if we're
> done with device_add_disk(). Fix this by providing unwinding
> prior to the devm call being registered and moving the devm
> registration to the very end.
>
> This should fix calling del_gendisk() if nd_integrity_init()
> fails. I only spotted this issue through code inspection. It
> does not fix any real world bug.
>

Just fyi, I'm preparing patches to delete this driver completely as it
is unused by any shipping platform. I hope to get that removal into
v5.16.
