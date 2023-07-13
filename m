Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE6679D1
	for <nvdimm@lists.linux.dev>; Thu, 13 Jul 2023 08:23:11 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-ca4a6e11f55so367574276.1
        for <nvdimm@lists.linux.dev>; Thu, 13 Jul 2023 01:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689236590; x=1691828590;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dmUvvFe5/0RHDgOhcRqf73PLJ/xjj5ik+Mt9yz3hpVE=;
        b=JDjaxMNSCA2W0kv8QauUN8XGyZ37DEvH44KOJRlwppaz0znXSKXj+Qgcfdoq6EAXa4
         QLkRvTydaY6wacC+a5/60no89snaYyzToT1xWjTLc9LdU7NsY3GHXvY2cCCnfGeapMG1
         aMoKt4kFsQP6UvZTkEyJjIwLLv24UVO93sHO0jRGTEbFW4ml+l9mibdrohZQ3pRngmGk
         Jx8r492MtUrOHqZIyPIcLUM0bOzdBGX6yhtJHVq+Cc03uvzn6pBKDC3g9wfenQU//yC+
         7XObtu+QiwlXokKBOMBV0b8cKzrU5TCYy1nS0wrB9j8opf3aXU4c51q7yt9bxbJ1ZJBp
         ZS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689236590; x=1691828590;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dmUvvFe5/0RHDgOhcRqf73PLJ/xjj5ik+Mt9yz3hpVE=;
        b=GSGPlabZinpFMiNTRw9Kzfz1uSZ8z/yMnZNjs/ZZC/sqZHg+R3kEF+0lDZa83EYHnf
         hwlhqUsyGEfIbmbKv0l/v0zlauMOhdS+dNb8Cikj2+vEOVikJKKMj8SG9Q728YkSsfOT
         UWcFJPgJOh4+yYiaPIobwl2DXy3E7navRpGdm5Spa+uuE4ITUIAJrdJOM5kFuKLg8hAK
         BSZvIKPgliAlY4KT34YGwwbHyrBeVADEWOPk6S7WMkZp9yRc/ZLnwduCzrTB4dsjn3V4
         Arll62wzpbggfLuCAzzW+YDLhPrwHqaLuFtNLSMr+2xaTwAEJsaokGCMcUcA0exnmGNd
         3X4A==
X-Gm-Message-State: ABy/qLYypmqfbggAqjtlg4QwvAYyVcHSCTwqpy9biuhcA2y8LBUuLcKr
	rJiWsMvgKTePiSoezuY108eaEMzYrCAdkYGjixY=
X-Google-Smtp-Source: APBJJlEbHvkCZjLi15/lidg5v2R1Yh9AOdIR1j8W6aRCyJXeU1xYrlBOnMGufB+qGA9cE/p+Bndff1yvmURZvndbsdI=
X-Received: by 2002:a25:d1c1:0:b0:c1a:b0e2:e930 with SMTP id
 i184-20020a25d1c1000000b00c1ab0e2e930mr945563ybg.3.1689236590340; Thu, 13 Jul
 2023 01:23:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZJL3+E5P+Yw5jDKy@infradead.org> <20230625022633.2753877-1-houtao@huaweicloud.com>
 <CAM9Jb+hrspvxXi87buwkUmhHczaC6qian36OxcMkXx=6pseOrQ@mail.gmail.com>
In-Reply-To: <CAM9Jb+hrspvxXi87buwkUmhHczaC6qian36OxcMkXx=6pseOrQ@mail.gmail.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Thu, 13 Jul 2023 10:23:01 +0200
Message-ID: <CAM9Jb+g5rrvmw8xCcwe3REK4x=RymrcqQ8cZavwWoWu7BH+8wA@mail.gmail.com>
Subject: Re: [PATCH v3] virtio_pmem: add the missing REQ_OP_WRITE for flush bio
To: Hou Tao <houtao@huaweicloud.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux-foundation.org, houtao1@huawei.com, 
	Vishal Verma <vishal.l.verma@intel.com>, Chaitanya Kulkarni <chaitanyak@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

+Cc Vishal,

> > Fixes: b4a6bb3a67aa ("block: add a sanity check for non-write flush/fua bios")
> > Signed-off-by: Hou Tao <houtao1@huawei.com>
>
> With 6.3+ stable Cc, Feel free to add:

Hi Dan, Vishal,

Do you have any suggestion on this patch? Or can we queue this please?

Hi Hou,

Could you please send a new version with Cc stable or as per any
suggestions from maintainers.

Thanks,
Pankaj
