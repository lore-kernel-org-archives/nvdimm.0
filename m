Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A626EAD39
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 10:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683627514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=al2rA7jnDuJpMd22yzJ3comLCwGR0yij05VrQ+LZSgU=;
	b=gLSfOlStSRNhoiluZplZCUASaUnL4mcjUhqfAz9Y8NBgqmSM9ocrMq4+ZlYulC7KjAKnMl
	i1sdmUT+kQr8BS7+G3r4u5WFFFvzCKey3+wzgWF2DD7f+y64Skw1fuhqiHD8PPbyIi/bpx
	f5s0Pra3MhWmnWZLgxq/3Twfb+nhk3k=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-7BwdzEu-O6W29giBsFFpIQ-1; Tue, 09 May 2023 06:18:33 -0400
X-MC-Unique: 7BwdzEu-O6W29giBsFFpIQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-24e40246bb6so3098928a91.0
        for <nvdimm@lists.linux.dev>; Tue, 09 May 2023 03:18:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683627511; x=1686219511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=al2rA7jnDuJpMd22yzJ3comLCwGR0yij05VrQ+LZSgU=;
        b=g2tJeT//xCONnrNGjjE2B7VzeS+HeSCImWHkQ1O6wHJh3gSLtIVAnp+WT/I7ZQF9eu
         j+tohnSd57Q4guOoU8mZ0smVU7ni/uTmMLS60ELf6Gn9wNoXRZ83puR3f4QEGrfM+cOt
         IEIQ3gwN1m8QMkaFJSYJrHvPRGy8WAgUF8SR+316dbRPjeRF/k6TUl0iRhJBGgkP8VCE
         f6EkC086Fmf8QRllAlANG3kavQ7+cxYowFfbnAz66GJPdKMZtxSKBFWa2iKaWwTxqDp1
         N0RGWFYo0RFLpIu/7JZzevkZxOcSY0O0Zc4t08wDpUwP7GcYcAi1ry3DSbAQc997F9cD
         vDaw==
X-Gm-Message-State: AC+VfDxvc5OSqNpV0JOGZWuBdqa5ZNb/BTcRlJ1DYKV+8aibSD5ImZX7
	hM22SsOTxF7js/5t3fofLc/X7YVOPPdGTWiX+lHVugvF8yz1k7U7FJLH5UjXQnZhB44P+8QV8aw
	eITtnv5+a7fDgH0OJqBl49pyEEHGlSYwPxwCJKlWBnytzQg==
X-Received: by 2002:a17:90a:a60d:b0:24e:2021:b410 with SMTP id c13-20020a17090aa60d00b0024e2021b410mr13217161pjq.14.1683627511696;
        Tue, 09 May 2023 03:18:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6j2SdVTGAl89MkROySuAba3w2FaM+nQk4wALHUkugVZQqSgU6ESlVkC8R40sLHoPM6629Lrh3P0Bb23lCKz0E=
X-Received: by 2002:a17:90a:a60d:b0:24e:2021:b410 with SMTP id
 c13-20020a17090aa60d00b0024e2021b410mr13217151pjq.14.1683627511439; Tue, 09
 May 2023 03:18:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Yi Zhang <yi.zhang@redhat.com>
Date: Tue, 9 May 2023 18:18:20 +0800
Message-ID: <CAHj4cs94F0jXwcdLEi6bZ3n5PZcqCOxvd71fCsGyLq9NSrCPEw@mail.gmail.com>
Subject: =?UTF-8?B?W2J1ZyByZXBvcnRdIHRvb2xzL3Rlc3RpbmcvY3hsL3Rlc3QvbW9jay5jOjIyOjE6IGVycg==?=
	=?UTF-8?B?b3I6IGR1cGxpY2F0ZSDigJhzdGF0aWPigJkgd2hlbiBjb21waWxpbmcgdG9vbHMvdGVzdGluZy9jeGw=?=
To: Linux NVDIMM <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello
I found this compiling error in the latest linux tree, pls help check
it, thanks.

# make M=3Dtools/testing/cxl
  CC [M]  tools/testing/cxl/test/mock.o
tools/testing/cxl/test/mock.c:22:1: error: duplicate =E2=80=98static=E2=80=
=99
   22 | static DEFINE_SRCU(cxl_mock_srcu);
      | ^~~~~~
make[2]: *** [scripts/Makefile.build:252: tools/testing/cxl/test/mock.o] Er=
ror 1
make[1]: *** [scripts/Makefile.build:494: tools/testing/cxl/test] Error 2
make: *** [Makefile:2026: tools/testing/cxl] Error 2


--=20
Best Regards,
  Yi Zhang

