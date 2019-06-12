Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 201B021290DF2
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jun 2019 16:26:27 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, test: handle backup_keys in security.sh
Date: Wed, 12 Jun 2019 23:26:16 +0000
Message-ID: <af2106d6b8f6380f59c6e26ba272abc8da5a7a73.camel@intel.com>
References: <20190612230845.GA13679@alison-desk.jf.intel.com>
 <CAPcyv4iF5cDoNB4e3GF0_HJRbxn+VWk=5QKuEk4wBWWn66AUvA@mail.gmail.com>
In-Reply-To: <CAPcyv4iF5cDoNB4e3GF0_HJRbxn+VWk=5QKuEk4wBWWn66AUvA@mail.gmail.com>
Content-Language: en-US
Content-ID: <B614F307E1819C448703F3EEB5B7F310@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-06-12 at 16:20 -0700, Dan Williams wrote:
> On Wed, Jun 12, 2019 at 4:05 PM Alison Schofield
> <alison.schofield@intel.com> wrote:
> > Fix a typo in security.sh that causes a script failure
> > when an nvdimm-master.blob already exists and needs to
> > be backed up.
> > 
> > + setup_keys
> > + '[' '!' -d /etc/ndctl/keys ']'
> > + '[' -f /etc/ndctl/keys/nvdimm-master.blob ']'
> > + mv /etc/ndctl/keys/nvdimm-master.blob /etc/ndctl/keys/nvdimm-master.blob.bak
> > + 0=1
> > ./security.sh: line 39: 0=1: command not found
> > 
> > Fixes: ba35642d3815 ("ndctl: add a load-keys test in the security unit test")
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  test/security.sh | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/test/security.sh b/test/security.sh
> > index 8a36265..c86d2c6 100755
> > --- a/test/security.sh
> > +++ b/test/security.sh
> > @@ -36,11 +36,11 @@ setup_keys()
> > 
> >         if [ -f "$masterpath" ]; then
> >                 mv "$masterpath" "$masterpath.bak"
> > -               $backup_key=1
> > +               backup_key=1
> >         fi
> >         if [ -f "$keypath/tpm.handle" ]; then
> >                 mv "$keypath/tpm.handle" "$keypath/tmp.handle.bak"
> > -               $backup_handle=1
> > +               backup_handle=1
> >         fi
> 
> Looks obviously correct to me.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> ...but that said, why is this test even bothering with the host's
> configuration? I think it should be using a test local directory that
> does not disturb the rest of the system, especially because the test
> is using nfit_test resources.
> 
> There's no guarantee that the script successfully reaches the
> post_cleanup() phase to restore the host configuration and could leave
> it broken. Unless / until we can fix up this test to not touch /etc I
> think it should be moved to the ENABLE_DESTRUCTIVE set of tests.

Hm, yes good point. I agree with moving it to destructive for now.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
