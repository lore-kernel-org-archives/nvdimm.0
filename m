Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6A22C81
	for <nvdimm@lists.linux.dev>; Sat, 30 Oct 2021 17:03:47 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id i14so16358102ioa.13
        for <nvdimm@lists.linux.dev>; Sat, 30 Oct 2021 10:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=mxOtNLa1eAMR0wpGD1VMaJkJmBISmLqnmjVIAsRcHvc=;
        b=TxRznXHiVxPacqnwtNIIT0ht6nYzSE2RDLvhKozr3LBin/ehB9sdFZDpWWjj4OSd+b
         wNVCVAvLw46JGTiAgUNZvEmvOxN66IADWaxYxM1QrR9lkXlSakotxqRDVZM1H74gZzC3
         dptCLtGLLsAefANWtuy2n0rGMRlWfacf/IHiKhBgdqwAXaaJe6kpIkKpb32JNyUJDsPQ
         h2JfNkORS5+nxcLRKrwXOlVNT9+6p7ra3ZV/bu0Di5bdLiqfxKarFy4zEtd9fllr2oYp
         7Q6VyWuncWNiiodyabAkyjZysJUsC526HyMFP48mdzk4scwMLVB6FI1dgulKgRvL0IOy
         PuLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=mxOtNLa1eAMR0wpGD1VMaJkJmBISmLqnmjVIAsRcHvc=;
        b=Zvh3en93d/WsqXkYhIDU4D5Cdgcym0PELvUL7TeZVLlI1PqZVMC87ntgxjgi5LAWt0
         x9v5wGvXRWSxbfz7MzFlQetoLz90k1BTCzfSdV2paHpfbfiCVr6JhcqYE9TTGE8l8KOn
         5dmGB8399Mg7HhIaSeu+gCPWIZgnk5NxJlwRzf3X0OnLR1ymD0PPyaT9SUpIktc/K8in
         +QKfEEwCbbqmJTt7HRvcQdwU6z6I8cjI4AtzmWRsoIh9hmqH8AgdC2DErPywja8JPMbE
         CySMj0XiHHnT/+QBln6uP/7FasMmTbERBQOyMKnkyyv0d7bHhiZi+qlTtLMVKN05bL3I
         pcZg==
X-Gm-Message-State: AOAM533HHaf0mjDIar82QDYpgbCVo+ZEEQDrwO3EecFjk6ywSP5SCbmJ
	NDTzjqK6eEun9cN83elozTAEsA==
X-Google-Smtp-Source: ABdhPJzMkwx+8CSrFVSVUQuPKJKJNsEs+j3d0vp9XLDv6RRzhAFgLrCeu1vNWGVlfsmYjr2iZBeQpQ==
X-Received: by 2002:a05:6602:2a44:: with SMTP id k4mr13067137iov.56.1635613426348;
        Sat, 30 Oct 2021 10:03:46 -0700 (PDT)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id z26sm4948483ioe.9.2021.10.30.10.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 10:03:45 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: kbusch@kernel.org, dan.j.williams@intel.com, richard@nod.at, jim@jtan.com, vishal.l.verma@intel.com, dave.jiang@intel.com, miquel.raynal@bootlin.com, vigneshr@ti.com, ngupta@vflare.org, ira.weiny@intel.com, senozhatsky@chromium.org, hch@lst.de, paulus@samba.org, Luis Chamberlain <mcgrof@kernel.org>, sagi@grimberg.me, mpe@ellerman.id.au, minchan@kernel.org, geoff@infradead.org, benh@kernel.crashing.org
Cc: linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, nvdimm@lists.linux.dev, linux-block@vger.kernel.org
In-Reply-To: <20211015235219.2191207-1-mcgrof@kernel.org>
References: <20211015235219.2191207-1-mcgrof@kernel.org>
Subject: Re: (subset) [PATCH 00/13] block: add_disk() error handling stragglers
Message-Id: <163561342513.76453.10042066842818606438.b4-ty@kernel.dk>
Date: Sat, 30 Oct 2021 11:03:45 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 15 Oct 2021 16:52:06 -0700, Luis Chamberlain wrote:
> This patch set consists of al the straggler drivers for which we have
> have no patch reviews done for yet. I'd like to ask for folks to please
> consider chiming in, specially if you're the maintainer for the driver.
> Additionally if you can specify if you'll take the patch in yourself or
> if you want Jens to take it, that'd be great too.
> 
> Luis Chamberlain (13):
>   block/brd: add error handling support for add_disk()
>   nvme-multipath: add error handling support for add_disk()
>   nvdimm/btt: do not call del_gendisk() if not needed
>   nvdimm/btt: use goto error labels on btt_blk_init()
>   nvdimm/btt: add error handling support for add_disk()
>   nvdimm/blk: avoid calling del_gendisk() on early failures
>   nvdimm/blk: add error handling support for add_disk()
>   zram: add error handling support for add_disk()
>   z2ram: add error handling support for add_disk()
>   ps3disk: add error handling support for add_disk()
>   ps3vram: add error handling support for add_disk()
>   block/sunvdc: add error handling support for add_disk()
>   mtd/ubi/block: add error handling support for add_disk()
> 
> [...]

Applied, thanks!

[08/13] zram: add error handling support for add_disk()
        commit: 5e2e1cc4131cf4d21629c94331f2351b7dc8b87c
[10/13] ps3disk: add error handling support for add_disk()
        commit: ff4cbe0fcf5d749f76040f782f0618656cd23e33
[11/13] ps3vram: add error handling support for add_disk()
        commit: 3c30883acab1d20ecbd3c48dc12b147b51548742

Best regards,
-- 
Jens Axboe


