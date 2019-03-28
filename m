Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14F97211EB812
 for <linux-nvdimm@lists.01.org>; Thu, 28 Mar 2019 12:19:45 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id y84so16673636oia.12
 for <linux-nvdimm@lists.01.org>; Thu, 28 Mar 2019 12:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <155380002962.7924.11109542476291499729.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4j0jKPiYR7LFQzwbMZkieFn1G-7bJz85MUDcrf8BsSC0g@mail.gmail.com>
 <73b19eaf-ace5-632c-33a6-0db018ebe05e@intel.com>
In-Reply-To: <73b19eaf-ace5-632c-33a6-0db018ebe05e@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Mar 2019 12:19:33 -0700
Message-ID: <CAPcyv4ho=s5PSyDQ+kuz9h00jPcko+PaqLB294mPh+y2yucOKg@mail.gmail.com>
Subject: Re: [PATCH 1/3] ndctl: fix load-keys for user master-key
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 28, 2019 at 12:17 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
>
>
> On 3/28/19 12:11 PM, Dan Williams wrote:
> > On Thu, Mar 28, 2019 at 12:07 PM Dave Jiang <dave.jiang@intel.com> wrote:
> >>
> >> load-keys incorrectly assumes that all keys have TPM handles. TPM handle is
> >> only for trusted-keys. Fix in order to allow user master-key work.
> >
> > s/work/to operate/ ?
> >
> >>
> >> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >> ---
> >>  ndctl/load-keys.c |    6 ++----
> >>  1 file changed, 2 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/ndctl/load-keys.c b/ndctl/load-keys.c
> >> index 8e4998f2..19380152 100644
> >> --- a/ndctl/load-keys.c
> >> +++ b/ndctl/load-keys.c
> >> @@ -213,10 +213,8 @@ static int load_keys(struct loadkeys *lk_ctx, const char *keypath,
> >>
> >>         if (!tpmhandle) {
> >>                 rc = check_tpm_handle(lk_ctx);
> >> -               if (rc < 0) {
> >> -                       rc = -errno;
> >> -                       goto erropen;
> >> -               }
> >> +               if (rc < 0)
> >> +                       printf("No TPM handle discovered.\n");
> >
> > Please keep error messages on stderr.
>
> Actually this is info. At this point we do not have context as to if a
> trusted key or user key being loaded, and it could be we are using user
> master key or it could be TPM handle can't be found.

Ok, but it should still be stderr. ndctl tries to enforce only json on stdout.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
