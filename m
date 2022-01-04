Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BCE2C80
	for <nvdimm@lists.linux.dev>; Tue,  4 Jan 2022 22:44:20 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id t123so33417260pfc.13
        for <nvdimm@lists.linux.dev>; Tue, 04 Jan 2022 14:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kNI0FNXnZ92A9rcSSuTMSZWtPK6rcwK+FpLRa43srmk=;
        b=fOsqdC5v/Ljnlv2FEIyia5PEUe1s+e+1DuDDfE7u5MaVA4dXKJQHiE1mRK5iYBVsUJ
         /oowxIHxSAdxALfYzQ8kGvygGPJuCKMOHtF6DiXbqMs/059LnQCgFzEDESiTPsFxFWNn
         7Xesjj8J0CJQX2rv/u96W/GJ5UgdA6Vcv8mkPCkFc6h66hCg6QsUbB+sYNaSz3UzdXUB
         lpIWK+oGnTNcmd+TytJ0U91J0Sv00HD75sq8eRh6giDzO8BfqgCduSAOWJzJitKNXhRW
         Yz6dvrh+hntEc7AjvBGIeEmebsxBEkSVtpsKzv/uaTDYZj1X2da7fQ7LGbcS1ECRAlNl
         1k1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kNI0FNXnZ92A9rcSSuTMSZWtPK6rcwK+FpLRa43srmk=;
        b=L2wTNxK/+9cTl/7VyzPviVRwPH/L4jVyVUx5gDHzQ07EWmCLjs2d/0PG09j5RM+JHE
         BIS22wbZDwzjQ/4kmoSj2YncpJLVcqCeI5mZ62m6dss9r3aNXH/11x5NHqpS2DDU/Gr9
         SnuMgR9XCEj99d6acDod/JuW/WU46ZZ063zOsD376TOtVEWbquHN21+BUOFQ/YOMrJQz
         aXaNLMmnWDGlrorYz80kPFoSkjYVUdOvn8MxhFzk+GtqXBtLICL7ROMd/V4xpEkTAsvS
         BCfHYJSXA6Nt7jrxXvnJjAX3P7+FMYexhwHME9ThtURTZ/J4Sa++Xy+P28gPnD/XKW/r
         58Ww==
X-Gm-Message-State: AOAM5331OVjtdEpOZnAJPPAW9c6BfqT7UMavQI/qbpk9e5lHRL5PT4oo
	i+/lvRGviz4Qs5Sy3PH6crmTQC21JDOCbS85XI/obw==
X-Google-Smtp-Source: ABdhPJyP9Z0MRBW2RS42p0axndXN+7aFakOWJ0+wGPrF9fRJBeJgr0Nw19jdOKV52TidJL0PgD7xQGTpsKPEnebLsUg=
X-Received: by 2002:a63:79c2:: with SMTP id u185mr876468pgc.74.1641336259609;
 Tue, 04 Jan 2022 14:44:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com> <20211226143439.3985960-2-ruansy.fnst@fujitsu.com>
In-Reply-To: <20211226143439.3985960-2-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 4 Jan 2022 14:44:08 -0800
Message-ID: <CAPcyv4gkxuFRGh57nYrpS8mXo+5j-7=KGNn-gULgLGthZQPo2g@mail.gmail.com>
Subject: Re: [PATCH v9 01/10] dax: Use percpu rwsem for dax_{read,write}_lock()
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, Dec 26, 2021 at 6:35 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> In order to introduce dax holder registration, we need a write lock for
> dax.

As far as I can see, no, a write lock is not needed while the holder
is being registered.

The synchronization that is needed is to make sure that the device
stays live over the registration event, and that any in-flight holder
operations are flushed before the device transitions from live to
dead, and that in turn relates to the live state of the pgmap.

The dax device cannot switch from live to dead without first flushing
all readers, so holding dax_read_lock() over the register holder event
should be sufficient. If you are worried about 2 or more potential
holders colliding at registration time, I would expect that's already
prevented by block device exclusive holder synchronization, but you
could also use cmpxchg and a single pointer to a 'struct dax_holder {
void *holder_data, struct dax_holder_operations *holder_ops }'. If you
are worried about memory_failure triggering while the filesystem is
shutting down it can do a synchronize_srcu(&dax_srcu) if it really
needs to ensure that the notify path is idle after removing the holder
registration.

...are there any cases remaining not covered by the above suggestions?
