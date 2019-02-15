Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 726EB2194EB78
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 12:01:13 -0800 (PST)
Date: Fri, 15 Feb 2019 12:01:07 -0800
From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH] ndctl: Generalized make-git-snapshot.sh
Message-ID: <20190215200106.GA28940@iweiny-DESK2.sc.intel.com>
References: <20190215192117.28605-1-ira.weiny@intel.com>
 <CAPcyv4iMK4q7N5rhdDjcFu71pqCs0mbmQ5gUs+iZj5miis+diQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iMK4q7N5rhdDjcFu71pqCs0mbmQ5gUs+iZj5miis+diQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 15, 2019 at 11:31:46AM -0800, Dan Williams wrote:
> On Fri, Feb 15, 2019 at 11:21 AM <ira.weiny@intel.com> wrote:
> >
> > From: Ira Weiny <ira.weiny@intel.com>
> >
> > make-git-snapshot.sh made an assumption of the git tree location.
> >
> > Furthermore, it assumed the user has an rpmbuild environment directory
> > structure set up.
> >
> > Enhance the script to figure out where in what location it has been
> > cloned and create the rpmbuild directory if the user does not already
> > have it.
> >
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > ---
> >  make-git-snapshot.sh | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/make-git-snapshot.sh b/make-git-snapshot.sh
> > index 142419d623fe..26e29bd7953d 100755
> > --- a/make-git-snapshot.sh
> > +++ b/make-git-snapshot.sh
> > @@ -2,10 +2,18 @@
> >  set -e
> >
> >  NAME=ndctl
> > -REFDIR="$HOME/git/ndctl"  # for faster cloning, if available
> > +
> > +pushd `dirname $0`
> > +REFDIR=`pwd`
> > +popd
> > +
> >  UPSTREAM=$REFDIR #TODO update once we have a public upstream
> >  OUTDIR=$HOME/rpmbuild/SOURCES
> >
> > +if [ ! -d $OUTDIR ]; then
> > +       mkdir -p $OUTDIR
> 
> Shouldn't this be rpmdev-setuptree?

Sure looks like it...

I never knew about that command...

Ira

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
