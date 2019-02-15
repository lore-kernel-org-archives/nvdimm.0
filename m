Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F379208AE37A
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 11:31:58 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id t7so2040202otk.8
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 11:31:57 -0800 (PST)
MIME-Version: 1.0
References: <20190215192117.28605-1-ira.weiny@intel.com>
In-Reply-To: <20190215192117.28605-1-ira.weiny@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Feb 2019 11:31:46 -0800
Message-ID: <CAPcyv4iMK4q7N5rhdDjcFu71pqCs0mbmQ5gUs+iZj5miis+diQ@mail.gmail.com>
Subject: Re: [PATCH] ndctl: Generalized make-git-snapshot.sh
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
To: "Weiny, Ira" <ira.weiny@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 15, 2019 at 11:21 AM <ira.weiny@intel.com> wrote:
>
> From: Ira Weiny <ira.weiny@intel.com>
>
> make-git-snapshot.sh made an assumption of the git tree location.
>
> Furthermore, it assumed the user has an rpmbuild environment directory
> structure set up.
>
> Enhance the script to figure out where in what location it has been
> cloned and create the rpmbuild directory if the user does not already
> have it.
>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  make-git-snapshot.sh | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/make-git-snapshot.sh b/make-git-snapshot.sh
> index 142419d623fe..26e29bd7953d 100755
> --- a/make-git-snapshot.sh
> +++ b/make-git-snapshot.sh
> @@ -2,10 +2,18 @@
>  set -e
>
>  NAME=ndctl
> -REFDIR="$HOME/git/ndctl"  # for faster cloning, if available
> +
> +pushd `dirname $0`
> +REFDIR=`pwd`
> +popd
> +
>  UPSTREAM=$REFDIR #TODO update once we have a public upstream
>  OUTDIR=$HOME/rpmbuild/SOURCES
>
> +if [ ! -d $OUTDIR ]; then
> +       mkdir -p $OUTDIR

Shouldn't this be rpmdev-setuptree?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
