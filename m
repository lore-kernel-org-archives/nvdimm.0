Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACBE3FC2
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 15:27:25 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id c4so6136392plh.7
        for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 08:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s+pZady9bZxuI5ZV217HLh19NePVUH4NtT4PhDASe8A=;
        b=mxA9ryU8JJCE6xg91cuNIqjrL1JDkONo6P8+DLklfSN2yE7omlUTGVGqGsV1LSrJxc
         u4r8m32maq75ln8QSnsVjt9XX5dmqle4XU1My+eIZsS0jOx+vYDBuXsJbjmri79tSozC
         LWc4QxAU/S3MEO/w8soRt9iUyt6bsc+zdf16d1u6kn3PvO2WLVhSEOlzuAnzSFLZhcfH
         B7xmSABvYCijcB2WMf1CsVQQjTsozoby0hS/2FmN81TbxQ2/AsTb9+zM7cG/0oG/6pPx
         LBPeMmPGI0E0s2HAI/mpmtk5cMbx6dWGUpQvnNfM89CcP9e/Z3/7W8Y34lCUC92JOBNm
         UWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s+pZady9bZxuI5ZV217HLh19NePVUH4NtT4PhDASe8A=;
        b=GDQFHPhUGi1sn5KAXFPyHcqqXuFiMphvPPDf3GPYPMwmSp+sIG4T/FBvJu7jhQHx0i
         x1MkMBuEpyUWaUKWcoq3XCgSAM34T3Qsyycmq5HKJs5JT2rIHkbrx/a4ole3G9tlN8Dc
         vcgmnVa80chE/aEkmzNMd+7c6JiG/gkvojCZIh5ayuZlwRpMdGae07KH0/EO8/0UMMPi
         JxChu+0ujaAmg92J+YalPdpKaRUtGawOdY+PkgZvfZY3aeAOGRDk4sbbTP1hRMJltlvN
         eWgRqmOog5xkPv4ivjjcdB261c44UK9fRO0s3izaUlwa0iBrsJJZ/wWph72ZV6sj3XYn
         XiuA==
X-Gm-Message-State: AOAM530dOb0MfyueOZtMxwvoDUCCK4/aQnqlWaETS+sOc/kVAFc4qrUd
	ZQeXLwug93asAttpy5a//vchmGXNOtvFXH0XNwnDLA==
X-Google-Smtp-Source: ABdhPJxF0RCYcUVUBwMvZeOpqalPa/B9+Q+bapkBeipJxdjltc3i6RXJVl+F7zMaJbsIi20VC25awiuka6Iizvicc98=
X-Received: by 2002:a17:90b:23d6:: with SMTP id md22mr4951556pjb.149.1629473245264;
 Fri, 20 Aug 2021 08:27:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-12-hch@lst.de>
 <CAPcyv4hbSYnOC6Pdi1QShRxGjBAteig7nN1h-5cEvsFDX9SuAQ@mail.gmail.com> <20210820041158.GA26417@lst.de>
In-Reply-To: <20210820041158.GA26417@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 08:27:14 -0700
Message-ID: <CAPcyv4iQgyPgQhjCwWv9JkA+kx18nRjOucVm+z79uw1zcAbhPg@mail.gmail.com>
Subject: Re: [PATCH 11/30] iomap: add the new iomap_iter model
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-btrfs <linux-btrfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 19, 2021 at 9:12 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Aug 19, 2021 at 02:25:52PM -0700, Dan Williams wrote:
> > Given most of the iomap_iter users don't care about srcmap, i.e. are
> > not COW cases, they are leaving srcmap zero initialized. Should the
> > IOMAP types be incremented by one so that there is no IOMAP_HOLE
> > confusion? In other words, fold something like this?
>
> A hole really means nothing to read from the source.  The existing code
> also relies on that.

Ok, I've since found iomap_iter_srcmap(). Sorry for the noise.
