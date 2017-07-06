Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x22c.google.com (mail-yb0-x22c.google.com
 [IPv6:2607:f8b0:4002:c09::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 476E521C9E7C0
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 22:24:01 -0700 (PDT)
Received: by mail-yb0-x22c.google.com with SMTP id p207so542242yba.2
 for <linux-nvdimm@lists.01.org>; Wed, 05 Jul 2017 22:25:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170705231417.GA27667@anatevka.americas.hpqcorp.net>
References: <CAPcyv4gcpmmr9LdX3DBtdX_ncwoBmCdC7yVPpGdO6EP7N9NOKw@mail.gmail.com>
 <20170701195805.GA13259@anatevka.americas.hpqcorp.net>
 <CAPcyv4hAMHzi7OK-z-B9LpT83Q1evH2-B-NXUMB2ebtVbjOdsg@mail.gmail.com>
 <CAPcyv4hP0zuZ0bdcQ5R3K2p5CRfHKXMSC_ov1D4qGXsXAQen=A@mail.gmail.com>
 <20170701203813.GA13574@anatevka.americas.hpqcorp.net>
 <CAPcyv4iMNjea939-E8of0nuyze8nHMEOp3ecii8+Y3pyYE0Ecw@mail.gmail.com>
 <20170704200849.GA15713@anatevka.americas.hpqcorp.net>
 <CAPcyv4isR--WJVeVYngGnCGea8HbQzKozsDz4rn6XWGW5vv=OA@mail.gmail.com>
 <20170705162418.GA24924@anatevka.americas.hpqcorp.net>
 <CAPcyv4hXvMnarz0=H6tJsA7wv+DvKJH_A8dVtET3kj_xH5JjxQ@mail.gmail.com>
 <20170705231417.GA27667@anatevka.americas.hpqcorp.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 5 Jul 2017 22:25:39 -0700
Message-ID: <CAPcyv4jmq9O0ZxbVk_=c-DAoJ5wGwBUgJqA70T-Ke-8ABU3FDQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] libnvdimm, acpi, nfit: Add bus level dsm mask for
 pass thru.
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
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 5, 2017 at 4:14 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Wed, Jul 05, 2017 at 09:35:48AM -0700, Dan Williams wrote:
[..]
>> It was a mistake to use _DSM for common root-level functionality, and
>> we shouldn't double down on that mistake by allowing unfettered
>
> As to the moral aspects of ACPI's decision to standardiz the DSM for NVDIMM,
> I take no position on whether it was a good thing or a bad thing; but it
> is a thing.  We need to handle it.  I see no particular benefit to
> making our own lives more difficult.

We do handle everything we need to. Making future updates move at the
same pace as standard ACPI enabing is the goal as well as not adding
any momentum to continue abusing _DSM when we should be creating named
methods for bus-level generic functionality. As a maintainer of this
subsystem I'm fine with the burden of continuing to touch the code as
the specification evolves and that stance matches standard Linux
practice.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
