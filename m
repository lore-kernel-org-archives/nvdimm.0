Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 990B021D2E649
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 15:42:21 -0700 (PDT)
Date: Tue, 29 Aug 2017 16:43:04 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 7/7] ndctl: auto initialize labels
Message-ID: <20170829224304.GA16374@omniknight.lm.intel.com>
References: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150403692821.8240.17921098591962254302.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1504042255.7034.1.camel@intel.com>
 <CAPcyv4jEGG8aRZOqJGJkuh=GfqFpsh1=BGchmjPXzS3b42vO7g@mail.gmail.com>
 <1504043431.7034.3.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1504043431.7034.3.camel@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 08/29, Verma, Vishal L wrote:
> On Tue, 2017-08-29 at 14:48 -0700, Dan Williams wrote:
> > On Tue, Aug 29, 2017 at 2:32 PM, Verma, Vishal L
> > <vishal.l.verma@intel.com> wrote:
> > > On Tue, 2017-08-29 at 13:02 -0700, Dan Williams wrote:
> > > > If we are reconfiguring an ND_DEVICE_NAMESPACE_IO namespace take
> > > > the
> > > > opportunity to potentially initialize labels. DIMM capacity that
> > > > is
> > > > not
> > > > aliased will surface as a label-less namespace by default. If
> > > > every
> > > > DIMM
> > > > in the interleave set supports labels we can switch a more dynamic
> > > > configuration, i.e. enable pmem sub-division.
> > > > =

> > > > The --no-autolabel option is added to disable this behavior if it
> > > > is
> > > > not
> > > > wanted.
> > > > =

> > > > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > ---
> > > > =A0Documentation/ndctl/ndctl-create-namespace.txt |=A0=A0=A0=A07 ++
> > > > =A0ndctl/namespace.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0|=A0=A0=A090
> > > > +++++++++++++++++++++++-
> > > > =A02 files changed, 95 insertions(+), 2 deletions(-)
> > > > =

> > > > diff --git a/Documentation/ndctl/ndctl-create-namespace.txt
> > > > b/Documentation/ndctl/ndctl-create-namespace.txt
> > > > index 85d1f8db792f..3844ff74a9f1 100644
> > > > --- a/Documentation/ndctl/ndctl-create-namespace.txt
> > > > +++ b/Documentation/ndctl/ndctl-create-namespace.txt
> > > > @@ -138,6 +138,13 @@ OPTIONS
> > > > =A0=A0=A0=A0=A0=A0active.=A0=A0Specifying --force causes the namesp=
ace to be
> > > > disabled
> > > > =A0=A0=A0=A0=A0=A0before reconfiguring.
> > > > =

> > > > +-L::
> > > > +--autolabel::
> > > =

> > > Shouldn't this be --no-autolabel
> > > =

> > > > +=A0=A0=A0=A0=A0When ndctl encounters a label-less namespace while
> > > > +=A0=A0=A0=A0=A0performing a reconfigure operation it will try to e=
nable
> > > > labels
> > > > +=A0=A0=A0=A0=A0for the region. This behavior can be suppressed with
> > > > +=A0=A0=A0=A0=A0"--no-autolabel".
> > > =

> > > And the text description matched to describe only the --no-autolabel
> > > option instead of describing both a positive and negative
> > =

> > I'm using a side effect of the way ndctl (and git) implement
> > OPT_BOOLEAN() options. They all automatically get a --no-<option>. So
> > "--autolabel" is the default.
> > =

> Ah cool, I didn't know OPT_BOOLEAN does that for you.
> Does the 'no' option then lack a short option? We'll end up providing a
> short option for the default case, but nothing for the override..
> =

> I'm also wondering if there will be any bash completion implications.
> I'll test whether the --no- option shows up automatically in --list-opts

Patch to special case --no-autolabel for completion:

8<----

>From f18c54d3260c3310d14aaa9aa589de4abc304bf1 Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 29 Aug 2017 16:38:36 -0600
Subject: [PATCH] ndctl, bash-completion: special case --no-autolabel for
 create-namespace

OPT_BOOLEAN provides a --no-* option automatically for all boolean
options, but the negative versions aren't listed in --list-opts.

Special case --no-autolabel since that is the only one where the
negative makes sense.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/contrib/ndctl b/contrib/ndctl
index 9410572..c7e3e7d 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -261,6 +261,17 @@ __ndctl_comp_non_option_args()
 	__ndctlcomp "$opts" "$cur"
 }
 =

+__ndctl_add_special_opts()
+{
+	local subcmd=3D$1
+
+	case $subcmd in
+	create-namespace)
+		opts=3D"$opts --no-autolabel"
+		;;
+	esac
+}
+
 __ndctl_prev_skip_opts ()
 {
 	local i cmd_ cmds_
@@ -354,6 +365,7 @@ __ndctl_main()
 		# List long option names
 		if [[ $cur =3D=3D --* ]];  then
 			opts=3D$($cmd $subcmd --list-opts)
+			__ndctl_add_special_opts "$subcmd"
 			__ndctlcomp "$opts" "$cur"
 			__ndctl_comp_options "$cur"
 		else
-- =

2.9.5



> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
