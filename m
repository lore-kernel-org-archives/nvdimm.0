Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6A4891A1EC9
 for <linux-nvdimm@lists.01.org>; Mon, 14 Mar 2016 01:32:02 -0700 (PDT)
Date: Mon, 14 Mar 2016 09:31:41 +0100
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [ndctl PATCH v2] ndctl: Grab kernel version from utsname()
Message-ID: <20160314083141.GW16624@c203.arch.suse.de>
References: <1457685810-4103-1-git-send-email-jthumshirn@suse.de>
 <CAPcyv4hde7eGwyiFYWnybbrgxUBkGJGhZYFnFMx1xOYQPnPsvw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hde7eGwyiFYWnybbrgxUBkGJGhZYFnFMx1xOYQPnPsvw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 11, 2016 at 10:28:27AM -0800, Dan Williams wrote:
> On Fri, Mar 11, 2016 at 12:43 AM, Johannes Thumshirn <jthumshirn@suse.de>=
 wrote:
> > Grab the kernel version used for tests dynamically via utsname() instea=
d of
> > hardcoding the version of the build host.
> >
> > Otherwise tests will be skipped if the build host had a too old kernel
> > version.
> >
> > flodin:~ # ./ndctl test
> > __ndctl_test_attempt: skip test_libndctl:1950 requires: 4.2.0 current: =
4.1.0
> > test-libndctl: SKIP
> > __ndctl_test_attempt: skip test_dpa_alloc:300 requires: 4.2.0 current: =
4.1.0
> > test-dpa-alloc: SKIP
> > __ndctl_test_attempt: skip test_parent_uuid:230 requires: 4.3.0 current=
: 4.1.0
> > test-parent-uuid: SKIP
> > attempted: 3 skipped: 3
> >
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > ---
> >  test/core.c |   15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> >
> >  Changes to v1:
> >  Use utsname.release which is obviously correct.
> >  On my test system utsname.release =3D "4.4.4-default"
> >
> >  I can only imagine the sscanf() failing and on stack garbage in a, b, =
c being
> >  greater than KERNEL_VERSION(4, 3, 0).
> =

> Looks good to me, applied for v52.  I've pushed it out on the
> 'pending' branch.  It will move to 'master' after the v4.6-rc1 kernel
> is released.

Thanks. Though I'm still not too happy with the general case of version
checking in the tests at all. Actually it should check for the presence of a
feature and not when a feature was introduced in the mainline kernel. Some
distro kernels tend to be an rather old version with havily backported
features *cough* ours *cough*. I'll see if I can come up with something, ma=
ybe
for the 4.7 window.

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
