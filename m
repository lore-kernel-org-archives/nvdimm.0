Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 911572034C5FD
 for <linux-nvdimm@lists.01.org>; Wed, 22 Nov 2017 14:11:04 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] rpmbuild: ensure the rpmbuild working directories
 are present
Date: Wed, 22 Nov 2017 22:15:18 +0000
Message-ID: <1511388916.3866.26.camel@intel.com>
References: <20171122220019.16041-1-vishal.l.verma@intel.com>
 <CAPcyv4hzDj5gZxafo8a+fowsB1Rh_1w2p_deYiDDx=zdYwpfcw@mail.gmail.com>
In-Reply-To: <CAPcyv4hzDj5gZxafo8a+fowsB1Rh_1w2p_deYiDDx=zdYwpfcw@mail.gmail.com>
Content-Language: en-US
Content-ID: <57956CD21A4A224FB34E755ACAD52C92@intel.com>
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


On Wed, 2017-11-22 at 14:13 -0800, Dan Williams wrote:
> On Wed, Nov 22, 2017 at 2:00 PM, Vishal Verma <vishal.l.verma@intel.c
> om> wrote:
> > The rpmbuild and make-git-snapshot assume that the various
> > ~/rpmbuild/*
> > directories are present. In case they weren't, git-archive would
> > fail
> > with something like:
> > 
> >   /root/rpmbuild/SOURCES/ndctl-58.2.38.g8ad8f4c.tar.gz: No such
> > file or directory
> > 
> > Add a 'mkdir -p' to make sure these directories are present.
> > 
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  rpmbuild.sh | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/rpmbuild.sh b/rpmbuild.sh
> > index 4535b46..1dd1709 100755
> > --- a/rpmbuild.sh
> > +++ b/rpmbuild.sh
> > @@ -1,5 +1,6 @@
> >  #!/bin/bash
> >  pushd $(dirname $0) >/dev/null
> > +mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
> 
> Hmm, I'd rather run rpmdev-setuptree than create this directories
> manually, and going further I'd rather just keep the assumption that
> rpmdev-setuptree has already been run before this script is run.

We could do a test -d ~/rpmbuild/SOURCES or so, and if not found, then
run rpmdev-setuptree?
We know we are about to write to that path, so if it doesn't exist, why
not create it?

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
