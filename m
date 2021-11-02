Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD9D2C85
	for <nvdimm@lists.linux.dev>; Tue,  2 Nov 2021 16:04:06 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id u33so7932837pfg.8
        for <nvdimm@lists.linux.dev>; Tue, 02 Nov 2021 09:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pqUtMw42srMAJfM2b3lzp/b+ILplHJlRcpIaRS/3TQM=;
        b=M1Jy4rAev2XNNrOaCWRPKKonIM70Nc4Pm5SPQkebmdl++tjn6a6C7m3mnLdNZFp0pr
         Dw88LtEJTtN1PUO++FTkdtdNtjTNQDnlwv2yLNTeMXrjP9ZyYAKGTMcL8r9RTRPBw3il
         4C97/+Sa7C2wkCTq6baD8je9LdaO98oiGYYt7spVrtyDRzBtQpt9dbnzUI85k/5rztRv
         YJjx1bNAw3Odr4BoA8nGSa8XDcp5bV9j8cNbaFaDoC0vNAdSZH4jYZcFSEHleUzrSlpk
         yxIbYa611I/q0MBtSK4EowjkBNpDUpLqBOxKzNjkyNInHvPRJou4mqsFW/Ul7RBz7G+C
         9qNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pqUtMw42srMAJfM2b3lzp/b+ILplHJlRcpIaRS/3TQM=;
        b=guZJCeYsW0pdXmJ5KYRrJG+nvXW+k3+VXJgx7Mv373eH3JnZUbOe7D8Sm8hi2a93nu
         o+D6CVR+l3JrrrLq7WS12btXaJOHVm5YoVnaPtvRuM+qRSfCaWQzQrIzumWyLtZjkXdZ
         B8ltiwaPyxNldTgBEot4+NtRPtlkAqrRtRThVPUyEU+Pl7Y696bNqKzTZsSLKVif+lKc
         7BFQEVj5FRXv9TK0BKq8qTXIWlpQjNl8iZez8+2KLMKqJLtqH1CsZeeIDS2g7ny6HiYQ
         rKcwFFAXhW2kO6vwyOImQXyyuqV9IzC4dXMHaLKYYbWJDzu3Z2ltk8UO/kBZMwKFbl9z
         r/dQ==
X-Gm-Message-State: AOAM530VpuDQT07HdfIqWJzyXISt2RFiDIYh9pkWsZ3LENksqTHaBUzY
	fNCCXi7ppKIr+YI5vbRGG/4a0K1VvxBfbgq11hW6vw==
X-Google-Smtp-Source: ABdhPJyi2jXIzQpJmrRalOBu2yRBUoqURsVK2whse/fQ0ZQUdF57+LmGNFNbptM0HlteOtS8dkMwnbU4y4A7thJeMNM=
X-Received: by 2002:a63:6302:: with SMTP id x2mr11074410pgb.5.1635869046166;
 Tue, 02 Nov 2021 09:04:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211021001059.438843-1-jane.chu@oracle.com> <YXFPfEGjoUaajjL4@infradead.org>
 <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com> <YXJN4s1HC/Y+KKg1@infradead.org>
 <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com> <YXj2lwrxRxHdr4hb@infradead.org>
In-Reply-To: <YXj2lwrxRxHdr4hb@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Nov 2021 09:03:55 -0700
Message-ID: <CAPcyv4hK18DetEf9+NcDqM5y07Vp-=nhysHJ3JSnKbS-ET2ppw@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with RWF_RECOVERY_DATA flag
To: Christoph Hellwig <hch@infradead.org>
Cc: Jane Chu <jane.chu@oracle.com>, "david@fromorbit.com" <david@fromorbit.com>, 
	"djwong@kernel.org" <djwong@kernel.org>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, 
	"dave.jiang@intel.com" <dave.jiang@intel.com>, "agk@redhat.com" <agk@redhat.com>, 
	"snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, 
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "willy@infradead.org" <willy@infradead.org>, 
	"vgoyal@redhat.com" <vgoyal@redhat.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 26, 2021 at 11:50 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Oct 22, 2021 at 08:52:55PM +0000, Jane Chu wrote:
> > Thanks - I try to be honest.  As far as I can tell, the argument
> > about the flag is a philosophical argument between two views.
> > One view assumes design based on perfect hardware, and media error
> > belongs to the category of brokenness. Another view sees media
> > error as a build-in hardware component and make design to include
> > dealing with such errors.
>
> No, I don't think so.  Bit errors do happen in all media, which is
> why devices are built to handle them.  It is just the Intel-style
> pmem interface to handle them which is completely broken.

No, any media can report checksum / parity errors. NVME also seems to
do a poor job with multi-bit ECC errors consumed from DRAM. There is
nothing "pmem" or "Intel" specific here.

> > errors in mind from start.  I guess I'm trying to articulate why
> > it is acceptable to include the RWF_DATA_RECOVERY flag to the
> > existing RWF_ flags. - this way, pwritev2 remain fast on fast path,
> > and its slow path (w/ error clearing) is faster than other alternative.
> > Other alternative being 1 system call to clear the poison, and
> > another system call to run the fast pwrite for recovery, what
> > happens if something happened in between?
>
> Well, my point is doing recovery from bit errors is by definition not
> the fast path.  Which is why I'd rather keep it away from the pmem
> read/write fast path, which also happens to be the (much more important)
> non-pmem read/write path.

I would expect this interface to be useful outside of pmem as a
"failfast" or "try harder to recover" flag for reading over media
errors.
