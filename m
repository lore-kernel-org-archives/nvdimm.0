Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39BFD210D93AB
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jun 2018 07:58:24 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id c15-v6so11314342otl.3
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jun 2018 07:58:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180615081446.6624-1-vishal.l.verma@intel.com>
References: <20180615081446.6624-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Jun 2018 07:58:22 -0700
Message-ID: <CAPcyv4grJKbx5M5oNVcPLsZ3KXDanc5EOW5oR3+wg8WAucXcNw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, contrib: Add helper scripts for new release
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 15, 2018 at 1:14 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Add a couple of helper scripts to codify the release process.
> First is do_abidiff: This builds RPMs for two different versions of
> ndctl (specified as a git revision range, for example vXX.Y..HEAD). It
> then uses abipkgdiff to determine whether the commits in that range
> (collectively) introduced any compatibility breaking ABI changes.
> Changing or removing a publicly exported function is considered a
> breakage, where as adding new functions is acceptable.
>
> Second is prepare-release.sh: Its primary purpose is to codify the
> libtool version update. It does a variety of sanity checks to ensure we
> didn't involuntarily bump the soname, or update the libtool version in
> an unexpected way.
>
> prepare-release.sh also calls do_abidiff to perform an abi check between
> the last bug-fix update and the new version about to be released.

Nice! Good idea.

>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  contrib/do_abidiff         |  73 ++++++++++++++
>  contrib/prepare-release.sh | 201 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 274 insertions(+)
>  create mode 100755 contrib/do_abidiff
>  create mode 100755 contrib/prepare-release.sh
>
> diff --git a/contrib/do_abidiff b/contrib/do_abidiff
> new file mode 100755
> index 0000000..9adc93a
> --- /dev/null
> +++ b/contrib/do_abidiff
> @@ -0,0 +1,73 @@
> +#!/bin/bash -e
> +
> +# WARNING: This will wipe ~/rpmbuild
> +
> +range="$*"
> +old="${range%%..*}"
> +new="${range##*..}"
> +
> +err()
> +{
> +       echo "$1"
> +       exit 1
> +}
> +
> +build_rpm()
> +{
> +       local cur=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
> +       local ref="$1"
> +
> +       # setup rpmbuild env
> +       rpmdev-wipetree && rpmdev-setuptree

Perhaps let's use mock here instead. In addition to including the
ability clean the build tree it can also target rawhide rather than
the current developer's Fedora version.

You would use "rpmbuild -bs" to create a source rpm and then hand that
off to mock.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
