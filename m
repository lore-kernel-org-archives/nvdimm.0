Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D1E2F21
	for <nvdimm@lists.linux.dev>; Fri,  4 Feb 2022 05:34:37 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id q132so4167727pgq.7
        for <nvdimm@lists.linux.dev>; Thu, 03 Feb 2022 21:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3aYp4Y6S+6Gb2kVa9/dfBS0YmJLNZ9g5MDY83trp3jE=;
        b=3uxIlPlxMjCMor3fUa5A1CVTOKqzwIs88e75GZ6lwMFIeSEuDYJQ+HhdiOSMvMZUC2
         el8NY8R7Q9+3swpx5TANATK4m3B46DtiHaJIy7ZzPYpTGGqeEnZr7PLssTl1cvpAcOZU
         nokKYUdj3Z7tk3YSujQ+QUROL/NmwF0Mm9NS6YpsBHvyMbu3IFFqUIrt+ZXYbm9WfUY3
         OqcFP+UX5+Fblg9IA+7D9UjfvmsRx7z63seKJWSPaFSowJKfc/i5nVZUIHAHSlP5QkVV
         AUKpbmFIPpD4NPvGvvu+ybsVNz7R3PudpeIms5A7qbXIfHObHTenOpzq85d5Tf96p99l
         LS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3aYp4Y6S+6Gb2kVa9/dfBS0YmJLNZ9g5MDY83trp3jE=;
        b=Yaxwl4nv2iEGjzZaoYGy521/06VQWSLmdUEepWmM2VawEJ4fKNPS0fIDxCV+miKzjQ
         q9wVUoHQ7Exiv2GkDDjwbdlfc7h/BV1vPNelQ6z3jn8n4uHO96ZCbTyHXtKm9YYCmyTh
         lF9X/3d6fDYhEGjq2737pCB89ki9J4juyuAkSNn8KsfrNsrjCNPyD2QdUi7MlkJPdwJM
         PqipViMJ0SItAEi1fs9yk5wzmrJGTRrig+lqpqfi3j89ZRaMzWNtODlzBdGfN8tXDW05
         nDcjVWUPZ5ImOeSmxUxEJZ/MuFJzlx0jjgkz2HZFUyEbTksia1COQfT3regTUK7pGpp7
         WcVw==
X-Gm-Message-State: AOAM530lZ12Pqy0e+5bTiSx7fxlyA8YqFPJ2tKYNz7wJFCYVMc1ja96Y
	3MBWGDkYu1lk3M/+h57qve8BuSedELOPffVeJwVmxw==
X-Google-Smtp-Source: ABdhPJxkwin78+MQJeCI7c5YXNEsK0mcEauKNshyhXHK8pXn7gbTrlWDvF68YcAOEJJFUIqSHpEVknWFvdBz/Brte1A=
X-Received: by 2002:a05:6a00:1312:: with SMTP id j18mr1391861pfu.61.1643952877343;
 Thu, 03 Feb 2022 21:34:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220128213150.1333552-1-jane.chu@oracle.com> <20220128213150.1333552-4-jane.chu@oracle.com>
In-Reply-To: <20220128213150.1333552-4-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Feb 2022 21:34:25 -0800
Message-ID: <CAPcyv4jw+meUy-DrLgqn_4kPCF2WAZrMJ8Nan4xCncr7-4Y0hw@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] dm: make dm aware of target's DAXDEV_RECOVERY capability
To: Jane Chu <jane.chu@oracle.com>
Cc: david <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	device-mapper development <dm-devel@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 28, 2022 at 1:32 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> If one of the MD raid participating target dax device supports
> DAXDEV_RECOVERY, then it'll be declared on the whole that the
> MD device is capable of DAXDEV_RECOVERY.
> And only when the recovery process reaches to the target driver,
> it becomes deterministic whether a certain dax address range
> maybe recovered, or not.
>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  drivers/md/dm-table.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index e43096cfe9e2..8af8a81b6172 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -844,6 +844,36 @@ static bool dm_table_supports_dax(struct dm_table *t,
>         return true;
>  }
>
> +/* Check whether device is capable of dax poison recovery */
> +static int device_poison_recovery_capable(struct dm_target *ti,
> +       struct dm_dev *dev, sector_t start, sector_t len, void *data)
> +{
> +       if (!dev->dax_dev)
> +               return false;
> +       return dax_recovery_capable(dev->dax_dev);

Hmm it's not clear to me that dax_recovery_capable is necessary. If a
dax_dev does not support recovery it can simply fail the
dax_direct_access() call with the DAX_RECOVERY flag set.

So all DM needs to worry about is passing the new @flags parameter
through the stack.
