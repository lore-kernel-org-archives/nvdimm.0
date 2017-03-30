Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E152221DFA901
 for <linux-nvdimm@lists.01.org>; Thu, 30 Mar 2017 01:47:04 -0700 (PDT)
Date: Thu, 30 Mar 2017 10:47:01 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] test: add fio test for device-dax
Message-ID: <20170330084701.GA4027@linux-x5ow.site>
References: <149067383236.19079.12786890634892425193.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49inmrua0c.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4i+q6iL9+fEUgL23Mb33Y7toCpXpeqh0rUgD+tcH3a2hg@mail.gmail.com>
 <x49r31fsunx.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jsJZih6t_hQ2Y3T8n0cGh79Kjf98WHfK0xoTVuifrTUQ@mail.gmail.com>
 <x49k277reoy.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4ia9hkL+DH5xrbmWPwoEsKWyEYBaQwbQoEfbSFZc4Xegg@mail.gmail.com>
 <x49efxfre00.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49efxfre00.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 29, 2017 at 05:04:31PM -0400, Jeff Moyer wrote:
> Well, the goal was to be somewhat smart about it, by not even trying to
> test things that aren't implemented or configured into the current
> kernel (such as device dax, for example).  Upon thinking about it
> further, I don't think that gets us very far.  However, that does raise
> a use case that is not distro-specific.  If you don't enable device dax,
> your test suite will still try to run those tests.  ;-)

I think I already suggested this some time ago, but again, can't we
make a syfs/debugfs/ioctl/whatever query to see what "features" are
available and check this instead of the kernel version in the test
suite? IIRC drm does similar things. Quoting from [1]:

"Have a clear way for userspace to figure out whether your new ioctl
or ioctl extension is supported on a given kernel. If you can't rely
on old kernels rejecting the new flags/modes or ioctls (since doing
that was botched in the past) then you need a driver feature flag or
revision number somewhere."

[1] http://blog.ffwll.ch/2013/11/botching-up-ioctls.html

Byte,
   Johannes

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
