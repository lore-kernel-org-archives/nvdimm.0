Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F9F2C82
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 02:40:58 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id h63so750552pgc.12
        for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 18:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XY5RlfJ4wk969SAhdu0eeba/cRDcEGFX6BIC3EnLQt8=;
        b=u4emMr/x1DnGrylyXG/XED1B0JAzKJIqIDcJvC7Dltb93SI0bgLALNc/xx3fE/eqZ+
         JLZdSBXcBeUsE3gYFy2qkeo6t2y2XuFS7FedCduv1RHpO8vyWXlQcx11qWzGXljZ4Nta
         5OYO1lIxqTIseUFqkypGfAJj577OlmYBnt7dfkNQv9WXesT9Vr2pO7qsjUMO6hVcoGvW
         LWz11ROd5H62YcZRNEwDlvUMRryoYOk1DV1Dg4YBgp+MSllvRl7B5PMc3nehblVandHp
         KDygLbglHM1zSoblBzsW1nhsjCF5iPULo9A3DjLMb5w2hx0fDJrK0R8dTmPxHRAXcCgM
         L96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XY5RlfJ4wk969SAhdu0eeba/cRDcEGFX6BIC3EnLQt8=;
        b=WBq+VYfKgedNUh4bVhxAO2gCdtiTThkGM9Be1li2UdBd86wVqgGPZyQNj/dRxKZGsy
         vKwV+tpzMEVHR1ng/ZEeg14yKaEDviyI3UFi51HSPbM5ahRvmUMjI5tSHbEQ2KRKSd7p
         ymsJcsIFI6ehi8T2MHhh3wnhQy7d5pHemnuQZTfHwWpZeMeWhKd4McLlmapnYXzzGj+Q
         TEUxfcBwRTIA6bU+Kv2uy43JZczBHAdD7/Lruq6I55+NBCkr61BwMxew1Af4muiEjDqV
         pgFUTBMkMx011zbSKfMFo0A9JB8ibHwI0KpCbz2TfLvXW50+hWwuOc7Buqhxa/O5AfvF
         oLcw==
X-Gm-Message-State: AOAM5332HephOd2yNBNiv+xOUYRYfp5fPvgY0FHjxbyrXjWftdf3VIye
	lMoGQjp7HlRCLK/O+I0Ouhbtx2x/zPGVx5r6/jvMYA==
X-Google-Smtp-Source: ABdhPJzf7x9CNNO+bnTL7ccWPdJMGj5rcrJdH+gi4z67GahFamuGnCABtN5RCIhrCvjUMVb9BfOrAHDXXr0x3X1l1Pc=
X-Received: by 2002:a63:88c3:: with SMTP id l186mr1768633pgd.377.1637721658407;
 Tue, 23 Nov 2021 18:40:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-22-hch@lst.de>
In-Reply-To: <20211109083309.584081-22-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 18:40:47 -0800
Message-ID: <CAPcyv4hY4g82PrjMPO=1kiM5sL=3=yR66r6LeG8RS3Ha2k1eUw@mail.gmail.com>
Subject: Re: [PATCH 21/29] xfs: move dax device handling into xfs_{alloc,free}_buftarg
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hide the DAX device lookup from the xfs_super.c code.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

That's an interesting spelling of "Signed-off-by", but patch looks
good to me too. I would have expected a robot to complain about
missing sign-off?

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
