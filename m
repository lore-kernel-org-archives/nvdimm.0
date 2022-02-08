Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EBE2F2C
	for <nvdimm@lists.linux.dev>; Tue,  8 Feb 2022 23:53:26 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id z13so1251781pfa.3
        for <nvdimm@lists.linux.dev>; Tue, 08 Feb 2022 15:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9yllLJXxvJNbb7TJ6F8GXcTe3gXNYnW6vmBXP6xHdmQ=;
        b=1TP2oV0hvpTVvUc38sU25Nq8P8dLloqnVrR1dLnL0k00RIz6cxvWF4JovZ1JHdh+Iq
         QjJ5AHaidFx9YmqNTrZ5h5qyJPKM/tziAB9DhO4YFzjPd5bpNTRb+YsjUwlfA7jtVsFK
         U7OdrJqAvGZ07hdSarMyxYyjKgkfa4xWh2cbsWw1St7pAb9nNM89cLwW6fNieqLKy8A0
         lEy6S237O1zyS6B6nOobWB1RoW/2FsR/vn8FET1ptCNsh08iwgcstMONTlv3sghEwQq4
         uOxijQbfhnxc35FRPR6EYrfjLYHOlXzLa9Vs6xBYs94IsyLrdPrgdUt8qrZhQDjGtN/K
         zJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9yllLJXxvJNbb7TJ6F8GXcTe3gXNYnW6vmBXP6xHdmQ=;
        b=O3oCfnQmVarz3TAYrkw7fehUc7X57j+GYidQYXD63YVoZmMD2BQgmlk3jpTvsqSFOV
         8mSIJhfQ2xR2kVVelddThGcVT6QHYO4+aU2/IgR75T7HcCHxT6JMUNabMTbW0f2a0OE8
         813ovbiccjk9QaNzVmxqJ/bW2V2E3uPiKSvOBA/tO/g1hHFUmB9LXtL6f4Eh77IoQCdT
         5TZrbF63Wc1lHddwmeN8jUGVeQOfxZOHwlL1Oy+C97kzpKdD6h8hsDD2lqZJvk03kf3k
         stEGsm2WoH9ChjsdlH5Z/4c295kTwD2UHWngTkBY5fq7V7R/wODvUTJlSS51+rtyl9G8
         vHXA==
X-Gm-Message-State: AOAM5323ZnUle6JPP5ZaKO4C1MA/Vm/DuGBGMvae5lssByKBsygZs7s3
	elp3TUB6Fg52hibsIh0CRM1KwCycyV5w87aEugl5ww==
X-Google-Smtp-Source: ABdhPJxeYY0PWIjCV0oL3qSXzPE/CqXZVnxQ/6hAd62TUxvblfYAlcQYEDEiHEyZHUJKW9dSv16xGL4Nt/VbJK9Vxe0=
X-Received: by 2002:a63:8849:: with SMTP id l70mr2640980pgd.437.1644364405842;
 Tue, 08 Feb 2022 15:53:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220207063249.1833066-1-hch@lst.de> <20220207063249.1833066-7-hch@lst.de>
 <CAPcyv4iYfnJN+5=0Gzw8gKpNCG3PJS1MEZxxoPwuojhU6XHNRA@mail.gmail.com>
In-Reply-To: <CAPcyv4iYfnJN+5=0Gzw8gKpNCG3PJS1MEZxxoPwuojhU6XHNRA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 Feb 2022 15:53:14 -0800
Message-ID: <CAPcyv4jfNa2BBuE7E0+8LO5VT9APS1eF3c4Rw99oKY6y+1re9w@mail.gmail.com>
Subject: Re: [PATCH 6/8] mm: don't include <linux/memremap.h> in <linux/mm.h>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Felix Kuehling <Felix.Kuehling@amd.com>, 
	Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>, 
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Alistair Popple <apopple@nvidia.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Ralph Campbell <rcampbell@nvidia.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, amd-gfx list <amd-gfx@lists.freedesktop.org>, 
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>, nouveau@lists.freedesktop.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 7, 2022 at 3:49 PM Dan Williams <dan.j.williams@intel.com> wrot=
e:
>
> On Sun, Feb 6, 2022 at 10:33 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Move the check for the actual pgmap types that need the free at refcoun=
t
> > one behavior into the out of line helper, and thus avoid the need to
> > pull memremap.h into mm.h.
>
> Looks good to me assuming the compile bots agree.
>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Yeah, same as Logan:

mm/memcontrol.c: In function =E2=80=98get_mctgt_type=E2=80=99:
mm/memcontrol.c:5724:29: error: implicit declaration of function
=E2=80=98is_device_private_page=E2=80=99; did you mean
=E2=80=98is_device_private_entry=E2=80=99? [-Werror=3Dimplicit-function-dec=
laration]
 5724 |                         if (is_device_private_page(page))
      |                             ^~~~~~~~~~~~~~~~~~~~~~
      |                             is_device_private_entry

...needs:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d1e97a54ae53..0ac7515c85f9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -62,6 +62,7 @@
 #include <linux/tracehook.h>
 #include <linux/psi.h>
 #include <linux/seq_buf.h>
+#include <linux/memremap.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
