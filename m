Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AFC9721290DDC
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jun 2019 18:57:08 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, test: handle backup_keys in security.sh
Date: Thu, 13 Jun 2019 01:57:03 +0000
Message-ID: <a5758bf2264ccbee42cbbb321f5376a31a349fb1.camel@intel.com>
References: <20190612230845.GA13679@alison-desk.jf.intel.com>
 <CAPcyv4iF5cDoNB4e3GF0_HJRbxn+VWk=5QKuEk4wBWWn66AUvA@mail.gmail.com>
 <af2106d6b8f6380f59c6e26ba272abc8da5a7a73.camel@intel.com>
 <20190613014715.GA16728@alison-desk.jf.intel.com>
In-Reply-To: <20190613014715.GA16728@alison-desk.jf.intel.com>
Content-Language: en-US
Content-ID: <CC8DC32E1AFDB54789DF7CEE43411592@intel.com>
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
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-06-12 at 18:47 -0700, Alison Schofield wrote:
> On Wed, Jun 12, 2019 at 04:26:16PM -0700, Verma, Vishal L wrote:
> > On Wed, 2019-06-12 at 16:20 -0700, Dan Williams wrote:
> > > On Wed, Jun 12, 2019 at 4:05 PM Alison Schofield
> > > <alison.schofield@intel.com> wrote:
> > > > Fix a typo in security.sh that causes a script failure
> > > > when an nvdimm-master.blob already exists and needs to
> > > > be backed up.
> > > > 
> > > > + setup_keys
> > > > + '[' '!' -d /etc/ndctl/keys ']'
> > > > + '[' -f /etc/ndctl/keys/nvdimm-master.blob ']'
> > > > + mv /etc/ndctl/keys/nvdimm-master.blob /etc/ndctl/keys/nvdimm-master.blob.bak
> > > > + 0=1
> > > > ./security.sh: line 39: 0=1: command not found
> > > > 
> > > > Fixes: ba35642d3815 ("ndctl: add a load-keys test in the security unit test")
> > > > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > > > ---
> > > >  test/security.sh | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/test/security.sh b/test/security.sh
> > > > index 8a36265..c86d2c6 100755
> > > > --- a/test/security.sh
> > > > +++ b/test/security.sh
> > > > @@ -36,11 +36,11 @@ setup_keys()
> > > > 
> > > >         if [ -f "$masterpath" ]; then
> > > >                 mv "$masterpath" "$masterpath.bak"
> > > > -               $backup_key=1
> > > > +               backup_key=1
> > > >         fi
> > > >         if [ -f "$keypath/tpm.handle" ]; then
> > > >                 mv "$keypath/tpm.handle" "$keypath/tmp.handle.bak"
> > > > -               $backup_handle=1
> > > > +               backup_handle=1
> > > >         fi
> > > 
> > > Looks obviously correct to me.
> > > 
> > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > 
> > > ...but that said, why is this test even bothering with the host's
> > > configuration? I think it should be using a test local directory that
> > > does not disturb the rest of the system, especially because the test
> > > is using nfit_test resources.
> 
> At first glance, it appears that the keys need to be in the
> {ndctl_keysdir}, aka, the official system location, for some
> of the ndctl commands to run. So, it's not as simple as just
> creating the key blob in a temp directory.
> 
> And, I don't even think that's the nfit_test resource you are
> referring to anyway. I'll keep a look out for how it can run
> cleaner, and make it off the ENABLE_DESTRUCTIVE list in the future.

Yes I think eventually we want the keys to be configurable on a more
fine-grained bases, and that would allow for other locations.

> 
> > > There's no guarantee that the script successfully reaches the
> > > post_cleanup() phase to restore the host configuration and could leave
> > > it broken. Unless / until we can fix up this test to not touch /etc I
> > > think it should be moved to the ENABLE_DESTRUCTIVE set of tests.
> > 
> > Hm, yes good point. I agree with moving it to destructive for now.
> Vishal, Do you need a patch that moves it to the naughty list?

I wouldn't say no to one!

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
