Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B846263A0
	for <nvdimm@lists.linux.dev>; Thu, 13 Jul 2023 08:17:28 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-c5f98fc4237so359704276.2
        for <nvdimm@lists.linux.dev>; Thu, 13 Jul 2023 01:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689236247; x=1691828247;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=An/lgfGfphqbX1hL0oKKGBUnuYFAW5BJf6INYxK4Dxo=;
        b=fMaMqgzEJcFheU9cUMf4jHc+VgZuKRcayfupFiAAHVSZwN2eGuJ0iY9WSnRCT+k1aF
         rqGTZ7/bWxogAyhv6Ke0+0lk8P83qa3dmlrEhXp+npJV3hpadt87H3WJztjnolYYQMnK
         skmlT/ZvhgFN8CT/sINe/QIBki05k3+/sJa3RwYEIUWiB5z9bzvm1/qP0lO42C3//ReJ
         +Iq0t7xow5sWHz427kMkYiTIXxW2kq/M5kNJq760tMQ+czB85Mh1gd+wi2phmxP1X6C4
         qnBwE8MWo418C2GFTXXcm6dhOlNyhCLbOPJ4DtqBs8ZDiNa0g7kaHecEdGA8C/z0JjIa
         hP+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689236247; x=1691828247;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=An/lgfGfphqbX1hL0oKKGBUnuYFAW5BJf6INYxK4Dxo=;
        b=NrWg+rfOltoG66cnEUUlmYuDCiDAdgIyitOHcID8NaAeu3vLDyKGvV2UV9mCV5iWMf
         wJYjGCGLlUXQrWdCQn8m4/WVoR/1y0pcs2Xc/bYdT4JnUBxTED2ZlhObelEh2d6ypLlh
         LHVS5bdlaTrgMdr5lJOMHZsvjNBPJGA7+8CUamZ0+bxop3jd5Uvk0yx0aGsfOMpzHmWK
         BffaZYrWJKstALTZHoN5TZZnKfj9QeleDGj8eC/h2UCTGw9yiBMhSgNY3cu2UwiO4+IQ
         Ga6hCKXC1IyMR77zgDSM1uZurDZ1ApGoE4OsFpDl5g+j7kYP5Q60FlwJ49TBcdMJPpWu
         zJdg==
X-Gm-Message-State: ABy/qLZR/VAFzp0tL/MGmw8lAPFR817bHRsFTbwJOLtikIii7xoDRiMu
	tNbDNk553DXAMVGce0Xqbs82BL3O/+hNnBmfFSw=
X-Google-Smtp-Source: APBJJlEIV5MP79fSqL2cxlOxBR4Hvs8OKm8tFgJmSWtKz6UW7+XN4NUCM/wRKHTmCQ2+6zGY59R6Z268+NkTfzQy0Mw=
X-Received: by 2002:a25:f43:0:b0:c3d:25af:45ec with SMTP id
 64-20020a250f43000000b00c3d25af45ecmr686366ybp.41.1689236247458; Thu, 13 Jul
 2023 01:17:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZJL3+E5P+Yw5jDKy@infradead.org> <20230625022633.2753877-1-houtao@huaweicloud.com>
 <7f49a5ad-8b34-c00c-9270-8d782200c78c@nvidia.com>
In-Reply-To: <7f49a5ad-8b34-c00c-9270-8d782200c78c@nvidia.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Thu, 13 Jul 2023 10:17:18 +0200
Message-ID: <CAM9Jb+jpRCKHxykW5-obnkzhzyPoiZupVAMcb=dTq6h+ajRHFQ@mail.gmail.com>
Subject: Re: [PATCH v3] virtio_pmem: add the missing REQ_OP_WRITE for flush bio
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Hou Tao <houtao@huaweicloud.com>, Dan Williams <dan.j.williams@intel.com>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, 
	"houtao1@huawei.com" <houtao1@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

> I've failed to understand why we should wait for [0] ...

Sorry, missed to answer before. The optimization was to make the
virtio-pmem interface completely
asynchronous and coalesce the flush requests. As this uses the
asynchronous behavior of virtio bus
there is no stall of guest vCPU, so this optimization intends to solve below:

- Guest IO submitting thread can do other other operations till the
host flush completes.
- As all the guest flush work on one virtio-pmem device. If there is
single flush in queue all the subsequent flush would wait enabling
request coalescing.

Currently, its solved by splitting the bio request to parent & child.
But this results in preorder issue (As PREFLUSH happens after the
first fsync, because of the way how bio_submit() works). I think the
preflush order issue will still remain after this patch. But currently
this interface is broken in mainline. So, this patch fixes the issue.


Thanks,
Pankaj
