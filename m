Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C3FBC2118B7B5
 for <linux-nvdimm@lists.01.org>; Fri, 16 Nov 2018 11:13:27 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id a77so14594546oii.5
 for <linux-nvdimm@lists.01.org>; Fri, 16 Nov 2018 11:13:27 -0800 (PST)
MIME-Version: 1.0
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
In-Reply-To: <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Nov 2018 11:13:15 -0800
Message-ID: <CAPcyv4iSWMhNLeBGQsusgmQ99=duN88aNF8k1+BJn1ROAk=2OA@mail.gmail.com>
Subject: Re: [Ksummit-discuss] [RFC PATCH 3/3] libnvdimm, MAINTAINERS:
 Subsystem Profile
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
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: ksummit <ksummit-discuss@lists.linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 15, 2018 at 12:03 AM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> Hi Dan,
>
> On Thu, Nov 15, 2018 at 6:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > Document the basic policies of the libnvdimm subsystem and provide a
> > first example of a Subsystem Profile for others to duplicate and edit.
> >
> > Cc: Ross Zwisler <zwisler@kernel.org>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Thanks for your patch!
>
> > --- /dev/null
> > +++ b/Documentation/nvdimm/subsystem-profile.rst
>
> > +Trusted Reviewers
> > +-----------------
> > +Johannes Thumshirn
> > +Toshi Kani
> > +Jeff Moyer
> > +Robert Elliott
>
> Don't you want to add email addresses?

I do, but I had not cleared this designation with these folks ahead of
time. Will resolve that for v2.

> Only the first one is listed in MAINTAINERS.

Correct, the intent is that these individuals can be sought out for
advice when the maintainer may not have the bandwidth to engage with a
contributor on a given timeframe. These are individuals that can
provide a second opinion.

> > +Time Zone / Office Hours
> > +------------------------
> > +8:00am to 5:00pm Pacific Time Zone
>
> UTC-???
>
> People are not familiar with all time zones.

Yes, will fix.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
