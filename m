Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F3C3F211DC085
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 15:51:56 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id w139so260927oie.9
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 15:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155000693912.348282.3054365378477074974.stgit@dwillia2-desk3.amr.corp.intel.com>
 <6862269bbf1048a4f5d009a041627d7c1a28e4aa.camel@intel.com>
In-Reply-To: <6862269bbf1048a4f5d009a041627d7c1a28e4aa.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Mar 2019 15:51:45 -0700
Message-ID: <CAPcyv4g_AVNcotkjezEBTiyv=F1fsH7mu5FrDG-9iGaMK09E=g@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/8] ndctl/dimm: Add --human support to read-labels
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 19, 2019 at 3:39 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
>
> On Tue, 2019-02-12 at 13:28 -0800, Dan Williams wrote:
> > Allow for easier comparisons between 'read-labels' output and list.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  ndctl/dimm.c |   18 +++++++++++-------
> >  1 file changed, 11 insertions(+), 7 deletions(-)
> >
> > diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> > index 292beebf9734..5ff730f42a45 100644
> > --- a/ndctl/dimm.c
> > +++ b/ndctl/dimm.c
> > @@ -50,6 +50,7 @@ static struct parameters {
> >       bool crypto_erase;
> >       bool overwrite;
> >       bool master_pass;
> > +     bool human;
>
> Should --human also imply --json? It doesn't make sense to have human
> for binary data, so it might be surprising if --human doesn't output
> json.
>
> Also I think this is missing the man page update to add --human (and
> that would be a good place to clarify the human/json behavior).
>

Agree with both.

> Looks good otherwise.

Will respin, thanks.
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
