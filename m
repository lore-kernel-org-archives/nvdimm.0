Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D4829CA
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 03:51:24 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so1365211pjb.1
        for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 19:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uJJrE2V7YDKia68Ncdl0fsAelSVdGw1v9JUEXR7xY5Y=;
        b=vNWAOXzyAyZLL55qsyuCit1K8cMla9Q+I7a8HbLHArMfgpXCYh1wtjdFnUFWSDzn1/
         T1Hm88FkQaWO7xTh0mJLeCLeygQ9XisaZ/XdmwUyLak3fa4OobGb1BWM5ZwyXtbfybYZ
         AImH8X7vgDZd94f4gGyAHjFhglD+WoYohpNRn3ZnIE+uI745TpScjyc77ErLiPREiHK9
         9zQlfvf5/9sPOSgOLuvsV+WpFV/QM4YFfAdVMzyOtae7ikCAA2NGiOEOPGZF9XEqRun2
         JjRU5WwiL+LDDdZvrMhOHyatQOMmuQaQU9bgUORS8BfRoMg++/EVDk/zAuYjdunbyyUb
         o34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uJJrE2V7YDKia68Ncdl0fsAelSVdGw1v9JUEXR7xY5Y=;
        b=w3p9lz8nshQsWmNPPUDzqtzBs6Sde2eVVXr56Xnb6eIWKpScpBDds60M6VmHrLIG2K
         xFL55KvuVxw4tsfQ05iDNobX0bWLmhqSKTXyLZ2cX/HJ/8evy+++n9KcWTj/xCsxmn28
         URmo32HmPfUeDwSBefEtlzRKKWcwK0pcdO/CjDoZmTR/vt1spXMm5zUb0F35I9ZEYhyu
         A08LKEWDL62DUT3PmEkri/zi3OxalqKt3VrPtRCelWyFhytlYyIG2Bd5AR9GQhQH2+KO
         DFgo3TPre6WfR1tU9fONrEUlPxaymB7/4IONateCL2NLQ9MDWvFKg9Suzt7epV6zj3Ur
         EjPQ==
X-Gm-Message-State: AOAM531edJFt697AQDGyeHpqnzBDLd+tAkIFL9C+I0uiz/JZstCxen4L
	k4WCMCoYIz6htAHcGaHGzbw/paGJ3Q5UoGI9pxd7/A==
X-Google-Smtp-Source: ABdhPJzAHmbz7abbV3IfUPlG+M3Adum2An1EImXm+0nyzeG+6b50syE8SI9jQ3gftFqA5yglDnQ0v4N9/X3Fjpc01Ms=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr4029053pjb.93.1637725884625;
 Tue, 23 Nov 2021 19:51:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-29-hch@lst.de>
In-Reply-To: <20211109083309.584081-29-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 19:51:14 -0800
Message-ID: <CAPcyv4iV+PTdvV+Tq5j3nR6UWFQPTeuzQrZGdS24HdVehY_OaA@mail.gmail.com>
Subject: Re: [PATCH 28/29] iomap: build the block based code conditionally
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Only build the block based iomap code if CONFIG_BLOCK is set.  Currently
> that is always the case, but it will change soon.

Looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
