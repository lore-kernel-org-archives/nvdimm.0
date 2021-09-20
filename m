Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B5D72
	for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 23:09:25 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id 203so9798826pfy.13
        for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 16:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XOcqHHbkBDFlbtFdYBTqX2Q9Srh+sNAiutBC+Z8jfD0=;
        b=64MjeUkX5fnk7DBE/PjIi6uxragircvWmGgL8etQwvZ1l5WJ6TUfHYN8QzBi0QMGhg
         xqZyEl5Dpd2r5u1pSCCPkp0tDmdB6Bcffd1QK+VuxzeKViBhh2y7xkhFg8WiHhfETtlz
         JoSJhSEr2l9GFYgEtlLxCWUqyCPnqPKzXnAfF8SJEOeFKjb7+MDIADmh8d2PWgm7mtL9
         wLEi+1HHWrNx2K1TAAfZMH1Xro++PpHG48OZ7W9JCrU49xYLK1PXpVeULNgHdT7PPtMR
         A7NQNf3IDYSO1p1jogUxQVzP/eBQjVSETWV1KYu8bi7sgDLqo/8Oe2LwPZDHAj/PO6ZO
         /gDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XOcqHHbkBDFlbtFdYBTqX2Q9Srh+sNAiutBC+Z8jfD0=;
        b=Jg0UYa2N1be6KF/1BRQew3Tq3hLERdMCHTu3fRkrV5zKFkkyP0v37nrmlyrnrL2FNr
         jbgkLMZF022t110FAOg1Zj9A86YDIhoBJ6YWbtuLWJYBWdyBNOjlHQ079TU9YgZZKh4B
         r7JJknHsibcoY+25SsaRf5ySdVFZCG+/Cy/NGFeVRUN2tElHb1yntX0dvbS7GcrNa5r1
         v4HdjftKaFtsV3gYJ+SqcSBolkKbdHEOVxFM52NQX8JUfEFVGV9ZKNFgsjQzu072DY21
         8mkmSQs34wMy02peG9Ozvuw9bMNIipv1ORZ8NjClHZfpk76Y5nBrKN1yP6oCk55ZxKtO
         mkMA==
X-Gm-Message-State: AOAM530SoCBZ0WdQ/nzI49Gd+buzEd0IZRxno62+bpF5N16XY0ur3l2g
	OHomZTl7l0xuZYBzMH7OZCw0dfuiZS6B6rPgTD8+ig==
X-Google-Smtp-Source: ABdhPJxI9Od05DZ0snqOmMgrhp1sI5Y9wYEd+2t40IS3lfIxNj4bseBagecZBBXGVcs2qjrSGmhbjS2ZMrrrLLbeAEo=
X-Received: by 2002:aa7:9d84:0:b0:447:c2f4:4a39 with SMTP id
 f4-20020aa79d84000000b00447c2f44a39mr6015200pfq.86.1632179364747; Mon, 20 Sep
 2021 16:09:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210920072726.1159572-1-hch@lst.de> <20210920072726.1159572-2-hch@lst.de>
In-Reply-To: <20210920072726.1159572-2-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 20 Sep 2021 16:09:13 -0700
Message-ID: <CAPcyv4hVR9J6M+0-KcnmNeRywvF4CobyEtKA9repq9ivtKy77Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] nvdimm/pmem: fix creating the dax group
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, linux-block@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 20, 2021 at 12:29 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The recent block layer refactoring broke the way how the pmem driver
> abused device_add_disk.  Fix this by properly passing the attribute groups
> to device_add_disk.
>
> Fixes: 52b85909f85d ("block: fold register_disk into device_add_disk")

This also fixes the the way the pmem driver abused device_add_disk(),
so perhaps add:

Fixes: fef912bf860e ("block: genhd: add 'groups' argument to device_add_disk")

...as well. It's not a stable fix as this is only a cosmetic fixup
until the most recent refactoring turned it into a bug.

Either way, you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
