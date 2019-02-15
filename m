Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F2B21202E530F
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 13:01:29 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH V2] ndctl: Generalized make-git-snapshot.sh
Date: Fri, 15 Feb 2019 21:01:27 +0000
Message-ID: <a5b6d79c68f3b08afe2ead303556b6dd578e78b7.camel@intel.com>
References: <20190215192117.28605-1-ira.weiny@intel.com>
 <20190215200614.30004-1-ira.weiny@intel.com>
In-Reply-To: <20190215200614.30004-1-ira.weiny@intel.com>
Content-Language: en-US
Content-ID: <22803A635FC2EB40ABDA70AE56C3905A@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Weiny, Ira" <ira.weiny@intel.com>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2019-02-15 at 12:06 -0800, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> make-git-snapshot.sh made an assumption of the git tree location.
> 
> Furthermore, it assumed the user has an rpmbuild environment directory
> structure set up.
> 
> Enhance the script to figure out where in what location it has been
> cloned and setup the rpmbuild tree if the user does not already
> have it.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes since V1
> 	use rpmdev-setuptree
> 
>  make-git-snapshot.sh | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/make-git-snapshot.sh b/make-git-snapshot.sh
> index 142419d623fe..513086b1f93d 100755
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

We should use the $() syntax for command substitution.
Also quote it - pushd "$(dirname "$0")"
And for setting REFDIR, no need to execute the pwd command - just use
the $PWD variable from the environment.

Additionally, $0 is not a reliable way to get the location of the
script. It is probably best to make an assumption that the script will
be run from the top level of an ndctl tree, and test for that instead of
trying to deduce where the script is being run from and trying to cd to
it.

We only really need the git-version script, and if we can test for its
presence, then we can relatively safely assume we're in the right
location. If it is not a git tree then we can leave it for git-archive
to complain. So something like:

	test -x "./git-version"

should suffice.

> +popd
> +
>  UPSTREAM=$REFDIR #TODO update once we have a public upstream
>  OUTDIR=$HOME/rpmbuild/SOURCES
>  
> +if [ ! -d $OUTDIR ]; then
> +	rpmdev-setuptree
> +fi
> +

There was some discussion around this a while back: [1] and [2]

But we had decided that rpmdev-setuptree was heavy handed in that it can
overwrite user configuration and we shouldn't use it. Instead in [2], we
added a test for the rpmdev tree to exist, and bail if it doesn't.

The one improvement I can see to this is:

if [ ! -d $OUTDIR ]; then
	mkdir -p $OUTDIR
fi

That way if components of OUTDIR are missing, we can make those
directories only, which is harmless.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-November/013378.html
[2]: https://lists.01.org/pipermail/linux-nvdimm/2017-November/013408.html

>  [ -n "$1" ] && HEAD="$1" || HEAD="HEAD"
>  
>  WORKDIR="$(mktemp -d --tmpdir "$NAME.XXXXXXXXXX")"
> @@ -14,7 +22,7 @@ trap 'rm -rf $WORKDIR' exit
>  [ -d "$REFDIR" ] && REFERENCE="--reference $REFDIR"
>  git clone $REFERENCE "$UPSTREAM" "$WORKDIR"
>  
> -VERSION=$(./git-version)
> +VERSION=$($REFDIR/git-version)
>  DIRNAME="ndctl-${VERSION}"
>  git archive --remote="$WORKDIR" --format=tar --prefix="$DIRNAME/" HEAD | gzip > $OUTDIR/"ndctl-${VERSION}.tar.gz"
>  

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
