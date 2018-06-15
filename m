Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D706210E8D42
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jun 2018 09:08:18 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, contrib: Add helper scripts for new release
Date: Fri, 15 Jun 2018 16:08:07 +0000
Message-ID: <1529078885.4998.19.camel@intel.com>
References: <20180615081446.6624-1-vishal.l.verma@intel.com>
 <CAPcyv4grJKbx5M5oNVcPLsZ3KXDanc5EOW5oR3+wg8WAucXcNw@mail.gmail.com>
In-Reply-To: <CAPcyv4grJKbx5M5oNVcPLsZ3KXDanc5EOW5oR3+wg8WAucXcNw@mail.gmail.com>
Content-Language: en-US
Content-ID: <8BD06B65B7BE9B4DA461D0853EAB097F@intel.com>
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2018-06-15 at 07:58 -0700, Dan Williams wrote:
> On Fri, Jun 15, 2018 at 1:14 AM, Vishal Verma <vishal.l.verma@intel.com>
> wrote:
> > Add a couple of helper scripts to codify the release process.
> > First is do_abidiff: This builds RPMs for two different versions of
> > ndctl (specified as a git revision range, for example vXX.Y..HEAD). It
> > then uses abipkgdiff to determine whether the commits in that range
> > (collectively) introduced any compatibility breaking ABI changes.
> > Changing or removing a publicly exported function is considered a
> > breakage, where as adding new functions is acceptable.
> > 
> > Second is prepare-release.sh: Its primary purpose is to codify the
> > libtool version update. It does a variety of sanity checks to ensure we
> > didn't involuntarily bump the soname, or update the libtool version in
> > an unexpected way.
> > 
> > prepare-release.sh also calls do_abidiff to perform an abi check
> > between
> > the last bug-fix update and the new version about to be released.
> 
> Nice! Good idea.
> 
> > 
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  contrib/do_abidiff         |  73 ++++++++++++++
> >  contrib/prepare-release.sh | 201 +++++++++++++++++++++++++++++++++++++
> >  2 files changed, 274 insertions(+)
> >  create mode 100755 contrib/do_abidiff
> >  create mode 100755 contrib/prepare-release.sh
> > 
> > diff --git a/contrib/do_abidiff b/contrib/do_abidiff
> > new file mode 100755
> > index 0000000..9adc93a
> > --- /dev/null
> > +++ b/contrib/do_abidiff
> > @@ -0,0 +1,73 @@
> > +#!/bin/bash -e
> > +
> > +# WARNING: This will wipe ~/rpmbuild
> > +
> > +range="$*"
> > +old="${range%%..*}"
> > +new="${range##*..}"
> > +
> > +err()
> > +{
> > +       echo "$1"
> > +       exit 1
> > +}
> > +
> > +build_rpm()
> > +{
> > +       local cur=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
> > +       local ref="$1"
> > +
> > +       # setup rpmbuild env
> > +       rpmdev-wipetree && rpmdev-setuptree
> 
> Perhaps let's use mock here instead. In addition to including the
> ability clean the build tree it can also target rawhide rather than
> the current developer's Fedora version.
> 
> You would use "rpmbuild -bs" to create a source rpm and then hand that
> off to mock.

Agreed, I'm changing this to use fedpkg to perform the mock build. That
would be even more low impact/dependence on the developer environment, and
gets us as close as possible to Fedora's build environment.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
