Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A032C9E
	for <nvdimm@lists.linux.dev>; Sun, 12 Dec 2021 15:03:13 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id f18-20020a17090aa79200b001ad9cb23022so11336796pjq.4
        for <nvdimm@lists.linux.dev>; Sun, 12 Dec 2021 07:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ndCqA56yDPdk4/U5zH+4CHcCyXDgYIZ2oi0MLXCjqSE=;
        b=lhO3UYFyJKrqzq5HPDfc+PFbsq6QQfW7AmBNbExvbtFXlq0wrjQecG2WRqAzp6e4AG
         dLqR+L0MONeWmNZKrCWbmSw7KsFBqjQk0a6JStD9bDnpx6T5Rf298y84DqrtyoiNln+j
         /nxi0T904eMzGulj/yucVxrxufrXlv7SPyx3OB+4L7NQnQPGsSQQIeP+cWrzCOBXdsdB
         9uR0OqjTM+0xenAf71ShyHD6/tIbAIQM7rMQSqR1TDFxRmDysjPBgtFNyHL48igzxdl/
         aA0JNL1H+gyAVZzrzpbutn6XyR9YQkl5t8TYUpejKIAviNSqCIACT31/viHV0LOGrf3g
         xFYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ndCqA56yDPdk4/U5zH+4CHcCyXDgYIZ2oi0MLXCjqSE=;
        b=XLobQFIf50uX0n/j05VqE6wA7wtNZVie9LojBF6urpH+/KcEVbvaq0/KQVLfAjvuVx
         TdAQ3zTu86A5i+Qc8rRavErydYa1IlDqBrcGJGJZEY+sBhdxkG+DXrfIIOeg/LGwP9+J
         cmF+zYg1q6XUjYP966OAsiAeCubc0PTL8IaEDlDiffnox5IeaBQH5KH4H72ViZrtMJu9
         BmXOKPb2KWK2XJESHra27Roln1v06/nEq8szsks7E214odECEa0BN5oqspKHObP7BYyA
         SSRDgEUp++IFEZjztM45c+UzTCr1raiogp+ZKovIZMryhxH4VhvgbyOS7Vi1c+G3g0eN
         NNOQ==
X-Gm-Message-State: AOAM530Qi/m4fv6Li4Jr2x9Nun4/RaWtxCheE64T9k/znTpLxt90HzTD
	0mdoGgo0kxl4eDMXp+WhxkFf0cvOsoc441ACEHARQw==
X-Google-Smtp-Source: ABdhPJzM6ThjE9fb1jBuOnaTRvStJ0J72a1wwy0FvBkYR9v9S0zmF+mqndMBqw+OLDevQiB5qKGoueX9OBCB41euCZc=
X-Received: by 2002:a17:902:6acb:b0:142:76c3:d35f with SMTP id
 i11-20020a1709026acb00b0014276c3d35fmr89560721plt.89.1639321392929; Sun, 12
 Dec 2021 07:03:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de> <20211209063828.18944-6-hch@lst.de>
In-Reply-To: <20211209063828.18944-6-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Dec 2021 07:03:02 -0800
Message-ID: <CAPcyv4gYXqbNRLkM4zJUq=sZuw4h_T+BSTXmESXc8juiWijKbQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] dax: always use _copy_mc_to_iter in dax_copy_to_iter
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Matthew Wilcox <willy@infradead.org>, device-mapper development <dm-devel@redhat.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 8, 2021 at 10:38 PM Christoph Hellwig <hch@lst.de> wrote:
>
> While using the MC-safe copy routines is rather pointless on a virtual device
> like virtiofs, it also isn't harmful at all.  So just use _copy_mc_to_iter
> unconditionally to simplify the code.

From a correctness perspective, yes, but from a performance perspective, see:

enable_copy_mc_fragile()

...on those platforms fast-string copy implementation is replaced with
a manual unrolled copy. So this will cause a performance regression on
those platforms.

How about let's keep this as is / still only use it for PMEM where end
users are already dealing with the performance difference across
platforms? I considered exporting an indicator of which backend
routine has been selected from arch/x86/lib/copy_mc.c, but it got
messy quickly so I fell back to just keeping the status quo.
