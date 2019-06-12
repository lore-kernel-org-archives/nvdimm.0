Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 269C2211F9D6B
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jun 2019 12:04:24 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id s20so2178228otp.4
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jun 2019 12:04:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560364493.git.mchehab+samsung@kernel.org>
 <075d5879142ff1b7ad16f5eccf4759d35ca02fd4.1560364494.git.mchehab+samsung@kernel.org>
In-Reply-To: <075d5879142ff1b7ad16f5eccf4759d35ca02fd4.1560364494.git.mchehab+samsung@kernel.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Jun 2019 12:04:12 -0700
Message-ID: <CAPcyv4g08r6bK_SyTjzKFRM7=wpTQLdmHqRSGh7r-e9YD4tq5Q@mail.gmail.com>
Subject: Re: [PATCH v1 29/31] docs: nvdimm: convert to ReST
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Mauro,

On Wed, Jun 12, 2019 at 11:38 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Rename the mtd documentation files to ReST, add an

s/mtd/nvdimm/

> index for them and adjust in order to produce a nice html
> output via the Sphinx build system.
>
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.

Looks ok, but I was not able to apply this one in isolation to give it
a try. Am I missing some pre-reqs compared to v5.2-rc4?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
