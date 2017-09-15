Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8281121E74914
 for <linux-nvdimm@lists.01.org>; Fri, 15 Sep 2017 02:15:52 -0700 (PDT)
Date: Fri, 15 Sep 2017 11:18:45 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Message-ID: <20170915091845.pmp3wer5lwx2xhjz@linux-x5ow.site>
References: <20170913144215.GA12395@linux.intel.com>
 <20170913220108.GX10621@dastard>
 <CAPcyv4hGSLQS1GmTYtzMCBDDNNuK1nLRKme6e-Vpx8_pyaJwrg@mail.gmail.com>
 <20170913233438.GY10621@dastard>
 <CAPcyv4hYc5=44vyyL+_hW9qpq54izKMMEOEQq1yHHkZVv-MR0w@mail.gmail.com>
 <20170914004038.GZ10621@dastard>
 <CAPcyv4iNcnq9sJVLeju-3Ua+XYfTscOb9iiWDS5yB768WJTOXQ@mail.gmail.com>
 <x49a81xeakx.fsf@segfault.boston.devel.redhat.com>
 <20170914131638.qxbzeocvrkhjcjcu@linux-x5ow.site>
 <CAPcyv4j4GUjQBa7ePUGLuHjZcf3G+0suvc7r6wmgGM_G_L5Gcw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4j4GUjQBa7ePUGLuHjZcf3G+0suvc7r6wmgGM_G_L5Gcw@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 14, 2017 at 07:10:02AM -0700, Dan Williams wrote:
> What discouraged me from going that route in the past is the busy work
> of tracking / syncing these new debugfs feature gate flags across 2
> source repositories. If we want to stop depending on kernel version in
> the test suite over time I think the only sane way to manage that
> tight integration is to get ndctl into the kernel tree proper.
> =

> ...but please say a bit more about the actual pain points with the
> current environment variable approach.

This means the person which executes the test-suite has to know on which
feature level (upstream kernel version) the downstream kernel is, I can't
demand such knowledge from QA.

> You want to be able to have a debugfs directory that has something like:
> =

> /featureA
> /featureB
> /featureC
> /fixX
> /fixY
> /fixZ
> /quirkQ
> =

> ...where, depending on backport priorities, a subset of those may not
> exist? =


Yes, I thought of a bitmask in one (or two files but a file per feature is =
OK)
as well. The idea is borrowed from Daniel Vetter's "Bothing up ioctl()s" bl=
og
entry [1]:
"Have a clear way for userspace to figure out whether your new ioctl or ioc=
tl
extension is supported on a given kernel. If you can't rely on old kernels
rejecting the new flags/modes or ioctls (since doing that was botched in the
past) then you need a driver feature flag or revision number somewhere."

> Does having the test suite in the kernel tree help or hurt what
> you're trying to do?

Having the test suite in the kernel is problematic when you want to distrib=
ute
it to somewhere. I can only talk about my workflow here, but I build an rpm=
 on my
build server and then scp it to my test host. With the current test-suite I
have to bring the other modules over as well and install them before the
kernel rpm to have the linker wrapper trick working. That's OKish for
developer testing, but for QA (or even testing at partners or customers)
this gets cumbersome and I really want to have even end customers being able
to run the test-suite to verify their kernel is working properly.

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
