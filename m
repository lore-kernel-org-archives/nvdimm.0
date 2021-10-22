Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61512C8B
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 15:44:09 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id s1so2944959plg.12
        for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 08:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iD/YdYWU0CibrUrNT2AHjd524fNyniaHzDz+a4Nr73I=;
        b=0P231w6Ya6SVWz0/xgd/baLTyoWwmKPsCCxX4cZneaql942u/6wi4RJfkEJ1WkQt7O
         7ftFeAD+cVcpIQ/Ej4JqtqDJ4au0y94b0Hxj+jJ0eNOTPgq9MAU5rbz/2wtN9/QbqpXF
         GYDkKo7pZPviDpMthPDr7IEkHYfCOF+ahRj9Hmhl8d81dVSf/klHN5vliDINeCl0rUX+
         iVt/tBiAzg8cy4vcHMVVyGXJ91OIQHY3qWRFOR2JxNq3GoekC2TNVw9P8WE4XMYY8N5v
         ISJGLd34fCPlWm56jbR2Skn8Cz3PpIoVlqslPi+nPI/Nrky1oAOB9Z+9rhbEu+OVC1+B
         rAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iD/YdYWU0CibrUrNT2AHjd524fNyniaHzDz+a4Nr73I=;
        b=n4MB8WkSRyAudQAmCvRJae/gp3Dv6wDQGQMC3RVXNOolIF0FLsA04Qp+bi3eDxqRhN
         cIDD0h+wlx2YvK4OsvaKkeus5UbmQjh3bVpOFepZjBAEtqzb9wn33Yktcf3NUaZtFXn0
         /1ce5gJUdKYqzbM3nMWRQANu5H9kdZtwxbu6DucPeJaTxVfUnnUu7ylsflbgmqX0JLVi
         I6iY1ZDFhz/bT47uqsM9sbKHI6AQe4/OBSCx4dTYhhFm2CwxAEh9WQl9iYEqQbmUI1Eb
         Juy3NbvBsn5s0XeaGk8NMdb4HBUNWtSJGCSVb4WNFIstwLrg2gr3JimO7RclrQrpoQN/
         35gQ==
X-Gm-Message-State: AOAM53138j8v32/jEZzdR5JYyMxDoTAldzEQjfFqslUfG3B0lC9Twq7/
	7sSWc1OmGg7FdUMyT9ZtHSENy8ubwpObEvlSXybLXA==
X-Google-Smtp-Source: ABdhPJwvGEiemHTU2PuYQrPBVLwNnk1G6dXjNp0/LHArCCIpY/aqRwNrqc0oa8rEc/+wcjTuGy7ilzYJj6grslSTWo8=
X-Received: by 2002:a17:90a:a085:: with SMTP id r5mr15376908pjp.8.1634917448922;
 Fri, 22 Oct 2021 08:44:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211019073641.2323410-1-hch@lst.de> <20211019073641.2323410-3-hch@lst.de>
 <YXFtwcAC0WyxIWIC@angband.pl> <20211022055515.GA21767@lst.de>
In-Reply-To: <20211022055515.GA21767@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Oct 2021 08:43:58 -0700
Message-ID: <CAPcyv4joX3K36ovKn2K95iDtW77jJwoAgAs5JSRMcETff=-brg@mail.gmail.com>
Subject: Re: [PATCH 2/2] memremap: remove support for external pgmap refcounts
To: Christoph Hellwig <hch@lst.de>
Cc: Adam Borowski <kilobyte@angband.pl>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Jens Axboe <axboe@kernel.dk>, 
	Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 21, 2021 at 10:55 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Oct 21, 2021 at 03:40:17PM +0200, Adam Borowski wrote:
> > This breaks at least drivers/pci/p2pdma.c:222
>
> Indeed.  I've updated this patch, but the fix we need to urgently
> get into 5.15-rc is the first one only anyway.
>
> nvdimm maintainers, can you please act on it ASAP?

Yes, I have been pulled in many directions this past week, but I do
plan to get this queued for v5.15-rc7.
