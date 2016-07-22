Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E496F1A1E07
 for <linux-nvdimm@lists.01.org>; Fri, 22 Jul 2016 01:15:21 -0700 (PDT)
Date: Fri, 22 Jul 2016 10:14:26 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] acpi, nfit: fix acpi_check_dsm() vs zero functions
 implemented
Message-ID: <20160722081426.ohcbyeld4ta4rzwa@c203.arch.suse.de>
References: <146679026571.24395.11569929364936343871.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160719171153.GA121461@tevye.fc.hp.com>
 <cfd9968d-9835-0ef1-fafd-54fd3b892d1c@hpe.com>
 <CAPcyv4gqmjMFveV+iE2NbvWnTb5kdy8w54VDgLYxeMJ5NJyzbw@mail.gmail.com>
 <CAPcyv4hbyq7MVQrTxYixo+fP7R=wV-Nt84NNfVJKrYWwUSJg=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hbyq7MVQrTxYixo+fP7R=wV-Nt84NNfVJKrYWwUSJg=Q@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Marvin Spinhirne <spin@hpe.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 19, 2016 at 01:01:16PM -0700, Dan Williams wrote:
> On Tue, Jul 19, 2016 at 11:52 AM, Dan Williams <dan.j.williams@intel.com>=
 wrote:
> > On Tue, Jul 19, 2016 at 11:50 AM, Linda Knippers <linda.knippers@hpe.co=
m> wrote:
> >> On 7/19/2016 1:11 PM, Jerry Hoemann wrote:
> [..]
> >>> As nfit_mem->family always equals NVDIMM_FAMILY_INTEL, no subsequent
> >>> DSM call will succeed for NVDIMM_FAMILY_HPE1 or any other
> >>> family.
> >>>
> >>> I don't have a fix as of yet, but wanted to make you aware of
> >>> the problem.
> >>
> >> Could we try the all known UUIDs looking for one that returns a non-ze=
ro
> >> value?
> >>
> >
> > Yes, that seems like the way forward, and also make not finding a DSM
> > family non-fatal.
> =

> Actually, all we need is that last bit...  Jerry, Xiao, can you try
> the attached patch on top for v4.7-rc6 to see if it works in both HPe
> and QEMU 2.6 environments respectively?
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

Hi Dan,

Somehow the mailinglist dropped the patch attachment and patchwork didn't
pick it up either.

As you have a Tested-by by Jerry and Xiao, can you appliy it to your git so
downstream distros can pick it up?

Thanks a lot,
	Johannes

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
