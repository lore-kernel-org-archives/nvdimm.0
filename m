Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E763F1FB8
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 04:45:16 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-c01e1c0402cso1309759276.0
        for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 21:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688100315; x=1690692315;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jy+2wKbAO2OzvWqyWD+QWcNE+oPQupQFExebUvFAsfo=;
        b=ghKITAnwxQw7NSpKuygbhDmD94YR1hQb/uj1vFbMFql9/u2srmFuIb/W+cpESRyn2h
         RU2ekTuMlvo+X/7imkCNMwaY0eaVILkxILRPxdVXxIjMqlexjHp80UreyYCm+L9uA3jv
         ak3kNZVMP4GbGf0F5UUNXKlQ9m+gtUBvj4F8rHZ6y3ebA6SmdgKl/1RsW30IXqHugBvD
         o/RpcO0uAIXSUdfkh1vwPHohMbc6zkwAH9AMJsQnxlhGenXhlLObnnS9u7EPtXZHf3/f
         UlhW4mX2roxz4dKaPfR5lJG6Z947ZQD3gMOYAgvsp6sGFGRK80VHiEOY3Ihq7EMmNoos
         79dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688100315; x=1690692315;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jy+2wKbAO2OzvWqyWD+QWcNE+oPQupQFExebUvFAsfo=;
        b=hgloaTmYQYGvFK7wNqsNPqXTQQntAXzJeSG61rrRpTxGdQ4I6a9rNVTU4Osn/h29KS
         kpe2b6zz+1WR0G/33zTnxVONZWegtk3F7eEXcUt5Jc1CXNR6qxCBGhuqxP4dNU4/aYOf
         eoMV9B0iAljrfi3YSmEkeV/ANASaQCvS/WY+SGhUkUmFuVH0eg8d8Z0hNRTQbIzOev8N
         3qRot/kecwt32nbR+aEqogOjBHL+y4w83HmkVoR5IvYypO2TvRldMw9oQYbRuTrBvmyt
         yJvYQUrZ7COTBg/wRMGB5mpsXka9dv+h4t9J4VcaCDucu/CM3Fap9XBqAwLB0VZ+SCJc
         8DrA==
X-Gm-Message-State: ABy/qLaLXFD0H7YkRwIFPxUI0ymjF4jDjyg+QNe7orrF4YG7tjlp8dyn
	8CTNCGjeXuwmPxZWvVSEEi3oGmS6vjkz1ogZ/UM6c/eYN/M=
X-Google-Smtp-Source: APBJJlGjtUStSn0IYr/tNUDx8CYFb9y2ynomg5kQwyGnJPZ+JRYhx2RhsFRJ3+ShB+zXUszAflU79OvOlJyuT/eXags=
X-Received: by 2002:a25:a489:0:b0:c16:a8f7:7afd with SMTP id
 g9-20020a25a489000000b00c16a8f77afdmr1607987ybi.45.1688100315563; Thu, 29 Jun
 2023 21:45:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZJLpYMC8FgtZ0k2k@infradead.org> <20230621134340.878461-1-houtao@huaweicloud.com>
 <CAM9Jb+j8-DWdRMsXJNiHm_UK5Nx6L2=a2PnRL=m3sMyQz4cXLw@mail.gmail.com> <d484a89f-8aaf-c0ae-5c12-f9a87b62384c@huaweicloud.com>
In-Reply-To: <d484a89f-8aaf-c0ae-5c12-f9a87b62384c@huaweicloud.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Fri, 30 Jun 2023 06:45:03 +0200
Message-ID: <CAM9Jb+i6qGVNRMJHG_=_NLkrzcnjn=Sa=YZJsJeA3K19ib__Zw@mail.gmail.com>
Subject: Re: [PATCH v2] virtio_pmem: add the missing REQ_OP_WRITE for flush bio
To: Hou Tao <houtao@huaweicloud.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux-foundation.org, houtao1@huawei.com
Content-Type: text/plain; charset="UTF-8"

> > Yes, [0] needs to be completed. Curious to know if you guys using
> > virtio-pmem device?
> Sorry about missing the question. We are plan to use DAX to do page
> cache offload and now we are just do experiment with virtio-pmem and
> nd-pmem.

Sounds good. Thank you for answering!

Best regards,
Pankaj
