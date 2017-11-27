Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6EE0E20359EA7
 for <linux-nvdimm@lists.01.org>; Mon, 27 Nov 2017 11:00:20 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] rpmbuild: ensure the rpmbuild working directories
 are present
Date: Mon, 27 Nov 2017 19:04:40 +0000
Message-ID: <1511809477.16069.1.camel@intel.com>
References: <20171122220019.16041-1-vishal.l.verma@intel.com>
 <CAPcyv4hzDj5gZxafo8a+fowsB1Rh_1w2p_deYiDDx=zdYwpfcw@mail.gmail.com>
 <1511388916.3866.26.camel@intel.com>
 <CAPcyv4jSc_wyEDUnqjof_1VNmWHn4ZWg3wwMqCv4OV-Ri+MUhQ@mail.gmail.com>
In-Reply-To: <CAPcyv4jSc_wyEDUnqjof_1VNmWHn4ZWg3wwMqCv4OV-Ri+MUhQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <A8943C970370FF45A616A2316B0F28BF@intel.com>
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


On Wed, 2017-11-22 at 15:49 -0800, Dan Williams wrote:
> On Wed, Nov 22, 2017 at 2:15 PM, Verma, Vishal L
> <vishal.l.verma@intel.com> wrote:
> > 
> > On Wed, 2017-11-22 at 14:13 -0800, Dan Williams wrote:
> > > On Wed, Nov 22, 2017 at 2:00 PM, Vishal Verma <vishal.l.verma@int
> > > el.c
> > > om> wrote:
> > > > The rpmbuild and make-git-snapshot assume that the various
> > > > ~/rpmbuild/*
> > > > directories are present. In case they weren't, git-archive
> > > > would
> > > > fail
> > > > with something like:
> > > > 
> > > >   /root/rpmbuild/SOURCES/ndctl-58.2.38.g8ad8f4c.tar.gz: No such
> > > > file or directory
> > > > 
> > > > Add a 'mkdir -p' to make sure these directories are present.
> > > > 
> > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > > ---
> > > >  rpmbuild.sh | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/rpmbuild.sh b/rpmbuild.sh
> > > > index 4535b46..1dd1709 100755
> > > > --- a/rpmbuild.sh
> > > > +++ b/rpmbuild.sh
> > > > @@ -1,5 +1,6 @@
> > > >  #!/bin/bash
> > > >  pushd $(dirname $0) >/dev/null
> > > > +mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
> > > 
> > > Hmm, I'd rather run rpmdev-setuptree than create this directories
> > > manually, and going further I'd rather just keep the assumption
> > > that
> > > rpmdev-setuptree has already been run before this script is run.
> > 
> > We could do a test -d ~/rpmbuild/SOURCES or so, and if not found,
> > then
> > run rpmdev-setuptree?
> > We know we are about to write to that path, so if it doesn't exist,
> > why
> > not create it?
> 
> Because we expect to build into an initialized rpmbuild tree, and if
> it's not initialized failing seems appropriate. That said, I'm ok
> with
> your "test and call rpmdev-setuptree" proposal.
> > 

Actually rpmdev-setuptree will overwrite any rpmmacros file, so maybe
it is best not to call it and risk changing users environments. I'll
send a patch to check for it though, and if not found, print an error
message and exit out.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
