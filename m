Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A987F6D1B
	for <nvdimm@lists.linux.dev>; Thu, 19 Aug 2021 11:08:52 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id d11so7098124ioo.9
        for <nvdimm@lists.linux.dev>; Thu, 19 Aug 2021 04:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5rak3fos7+/+7h7oxO17MqDUA5qjL3XWZkwvkReF0p4=;
        b=OHLsMDhqZiUkxlIxWQWrnQ0vPEFDGV+Qfi3NDFwtEC/jLegKxbdQrCadH4coYAoc+I
         AE47cTjbxnCcwq/pixNnTQ9F4QbofzYetKX90Ry1PpN2FgCjcl24AdbRBCQdvoiEyAb6
         oY0NAJM4GEVNkbx74xdeblfnmv5czqzmX8bELPuqLgClEyWXUEOq5D1nwXA3BjZ9xRO6
         8oUupdU6u4iv/yl6TVJQMnIiPkfYLoKA+mijvS5VoC3czkzdGcOWHii6jS/k5/GAk5Rh
         TpkLKE7CzxSemul0PQfE+OHl1ufX+7rE3+/iXKPB/3VU+uuYhLzMwPBMWkchAQ9iTIaZ
         //hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5rak3fos7+/+7h7oxO17MqDUA5qjL3XWZkwvkReF0p4=;
        b=WpoWe/K66pMZqF0EmJDegxTz6bY4lLpnLVUbCNalPLElS2GuA2UTJhYY/z2gAA3cQI
         ZoavD6rDxNw7EuWSGTxYyzane7jPAzd/Uv3nSpwdY80kbXM+Ti9btIaIl3VYfcj1CqYj
         bq7WvC/Z7UgRrC6+lJVzJfdbM+SHsLLfl8h2hq1WR8P0+x8KFBU0cAoczC4O7KVscE6S
         POAfUyKKt5A4ZVWb1IJwvICaPI9LFFxlNtn1dO0FcWnm/dX51vrNbMGobgtAbDt1kY06
         +QMCVjo99v0mIss0YVib66KQJhsxMIHhUijNhE6y1WF0JGx8NRRHd3lAh8QrVbX5ABxr
         CyGw==
X-Gm-Message-State: AOAM5339nyCCl+njatZw4RoKFCZMftXc1RAfSIeisblB5tUXjEm6NGA3
	QDMOp73oB/k3CyZHPC5voPX86+kuKepCAkCcDNkEZeDU
X-Google-Smtp-Source: ABdhPJz6xWqiUu4Z2zPOpvT1RlG+UQj40lEmUZd29fWnZDOnjPiWwZG9co6zOHjENcevEoVjWZcfviDEU2335d+eel8=
X-Received: by 2002:a02:a50d:: with SMTP id e13mr12320170jam.124.1629371331798;
 Thu, 19 Aug 2021 04:08:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210726060855.108250-1-pankaj.gupta.linux@gmail.com>
In-Reply-To: <20210726060855.108250-1-pankaj.gupta.linux@gmail.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Thu, 19 Aug 2021 13:08:40 +0200
Message-ID: <CAM9Jb+jDU7anniT8eL5yUQw1t_MZzndw=n1LWJ5fWV5k871+wQ@mail.gmail.com>
Subject: Re: [RFC v2 0/2] virtio-pmem: Asynchronous flush
To: nvdimm@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, jmoyer@redhat.com, 
	David Hildenbrand <david@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Pankaj Gupta <pankaj.gupta@ionos.com>
Content-Type: text/plain; charset="UTF-8"

Gentle ping.

>
>  Jeff reported preflush order issue with the existing implementation
>  of virtio pmem preflush. Dan suggested[1] to implement asynchronous flush
>  for virtio pmem using work queue as done in md/RAID. This patch series
>  intends to solve the preflush ordering issue and also makes the flush
>  asynchronous for the submitting thread.
>
>  Submitting this patch series for review. Sorry, It took me long time to
>  come back to this due to some personal reasons.
>
>  RFC v1 -> RFC v2
>  - More testing and bug fix.
>
>  [1] https://marc.info/?l=linux-kernel&m=157446316409937&w=2
>
> Pankaj Gupta (2):
>   virtio-pmem: Async virtio-pmem flush
>   pmem: enable pmem_submit_bio for asynchronous flush
>
>  drivers/nvdimm/nd_virtio.c   | 72 ++++++++++++++++++++++++++++--------
>  drivers/nvdimm/pmem.c        | 17 ++++++---
>  drivers/nvdimm/virtio_pmem.c | 10 ++++-
>  drivers/nvdimm/virtio_pmem.h | 14 +++++++
>  4 files changed, 91 insertions(+), 22 deletions(-)
>
> --
> 2.25.1
>
