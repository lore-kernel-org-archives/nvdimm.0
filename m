Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ED63C2B
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 17:55:13 +0000 (UTC)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-583a8596e2aso44709967b3.1
        for <nvdimm@lists.linux.dev>; Mon, 07 Aug 2023 10:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691430912; x=1692035712;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RlCzFKNj2PLZtrDRconO+Ncogzp7Fz5t1sVouGvRFAY=;
        b=hQ1WnTzUldedGB8lRCPKEoaeLuFvbD/k9u0mNXh3ly3gMJu7N8NVV21hA6n0junL6q
         oxiSmBRroH02OdBGgner9gFn990pIHTanAtRdWN80/lHbo8T9EfdCzwx4J1eqJCQ+O7a
         LH5yE5ftlwI7BywP/sXLvUeSBeQk/7PH3IoQ2q+ObmzBTd7JCl09N4qyvSfvIH/nBPVG
         +N4fVsEcaJ0YXx9I0CC3nal7/6T01FWzAZRFPV9og04b5OcHuZaZXJ7c6BtdRFmpJaUB
         PGfK0H/QKN9mD1KXLtfW9HNcodhKKra3lS75KalFMtOAXlMk7iB2HPRCdSvT6b9QZe1I
         Sicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691430912; x=1692035712;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RlCzFKNj2PLZtrDRconO+Ncogzp7Fz5t1sVouGvRFAY=;
        b=Lla64/eXM6U3IephYHVXLHbEu11x1nkt6aAK1YHN+mwzN4Ogf+RPXI8aX4wTpLbu2Y
         CYfWoog/5LNYKT8l9gG2D0jG0m2UugIGcL4ApQbsHl1hYcAGnPOpXECAA/QSn981Y/aJ
         79bEYgQf7WITF7k//HPwi/yUBT7QnewxqL+jlBFjhkRhpuEVdd/QayF9GeHixYH/VB5O
         7+xEI7VLs904EKn45EZUPKNNu3FOY16KBkkggJOxrAaFuQXaaY+9tII5x65VWArQ7LIj
         07300D0uws1z2p2xQUT6ST8bkNnK2KZAEySuBwtOiGRqvMZ+CnM5TdckqnVMeIFNmuuV
         cCTQ==
X-Gm-Message-State: AOJu0Yyg+nHo/EG2wRmZ3/Dzet8L08Aqu6EJbLCRblZX3ZKkWsmBwd77
	x10iNAD74ycPSURF8QiJsfueqKVNCHcOCFagQBE=
X-Google-Smtp-Source: AGHT+IF5Ce1yonD0nOwgvcdw9qjEnYMDbsCE0lJy3vYjGlNkX/3UOoq1uZ81RGlcEoSrEM0dk8SYv08ML3WTpFRyDrg=
X-Received: by 2002:a81:a045:0:b0:56d:2c60:2f84 with SMTP id
 x66-20020a81a045000000b0056d2c602f84mr8419886ywg.46.1691430912283; Mon, 07
 Aug 2023 10:55:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAM9Jb+g5rrvmw8xCcwe3REK4x=RymrcqQ8cZavwWoWu7BH+8wA@mail.gmail.com>
 <20230713135413.2946622-1-houtao@huaweicloud.com> <CAM9Jb+jjg_By+A2F+HVBsHCMsVz1AEVWbBPtLTRTfOmtFao5hA@mail.gmail.com>
 <47f9753353d07e3beb60b6254632d740682376f9.camel@intel.com> <bcd1a935-b6ce-3941-5315-197f6876379e@intel.com>
In-Reply-To: <bcd1a935-b6ce-3941-5315-197f6876379e@intel.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Mon, 7 Aug 2023 19:55:00 +0200
Message-ID: <CAM9Jb+jmjDOsJz=D7GEtah4xFamVHUFsruh4eW7VtO6A8yCZTw@mail.gmail.com>
Subject: Re: [PATCH v4] virtio_pmem: add the missing REQ_OP_WRITE for flush bio
To: Dave Jiang <dave.jiang@intel.com>
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>, 
	"houtao@huaweicloud.com" <houtao@huaweicloud.com>, "houtao1@huawei.com" <houtao1@huawei.com>, 
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, 
	"hch@infradead.org" <hch@infradead.org>, "Williams, Dan J" <dan.j.williams@intel.com>, 
	"axboe@kernel.dk" <axboe@kernel.dk>, "mst@redhat.com" <mst@redhat.com>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"kch@nvidia.com" <kch@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

> >> Gentle ping!
> >>
> >> Dan, Vishal for suggestion/review on this patch and request for merging.
> >> +Cc Michael for awareness, as virtio-pmem device is currently broken.
> >
> > Looks good to me,
> >
> > Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> >
> > Dave, will you queue this for 6.6.
>
> Looks like it's already queued:
> https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/commit/?h=libnvdimm-for-next&id=c1dbd8a849183b9c12d257ad3043ecec50db50b3

Thank you, Dave!

Best regards,
Pankaj
