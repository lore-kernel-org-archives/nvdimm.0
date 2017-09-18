Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 68E3221D046A3
 for <linux-nvdimm@lists.01.org>; Mon, 18 Sep 2017 00:44:14 -0700 (PDT)
Date: Mon, 18 Sep 2017 09:47:13 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Message-ID: <20170918074713.5lravsj234d5pbdj@linux-x5ow.site>
References: <CAPcyv4hGSLQS1GmTYtzMCBDDNNuK1nLRKme6e-Vpx8_pyaJwrg@mail.gmail.com>
 <20170913233438.GY10621@dastard>
 <CAPcyv4hYc5=44vyyL+_hW9qpq54izKMMEOEQq1yHHkZVv-MR0w@mail.gmail.com>
 <20170914004038.GZ10621@dastard>
 <CAPcyv4iNcnq9sJVLeju-3Ua+XYfTscOb9iiWDS5yB768WJTOXQ@mail.gmail.com>
 <x49a81xeakx.fsf@segfault.boston.devel.redhat.com>
 <20170914131638.qxbzeocvrkhjcjcu@linux-x5ow.site>
 <CAPcyv4j4GUjQBa7ePUGLuHjZcf3G+0suvc7r6wmgGM_G_L5Gcw@mail.gmail.com>
 <20170915091845.pmp3wer5lwx2xhjz@linux-x5ow.site>
 <CAA9_cmdrV13OgnRxpd0W9yYGBm4XP=fdTHDZvCBk4YR7gt8M5g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA9_cmdrV13OgnRxpd0W9yYGBm4XP=fdTHDZvCBk4YR7gt8M5g@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 15, 2017 at 10:39:05AM -0700, Dan Williams wrote:
> Yes, but what we're worried about in the libnvdimm/nfit_test case is
> internals behind sysfs interfaces. But point taken, we can at least
> use the presence of certain attributes to gate tests. However, it does
> mean we lose the tests for when an attribute is missing due to an
> incomplete backport.

Of cause, but all we loose is a group of testcases to be run and this can be
an indication of a bad backport as well, so I think this is quite helpful.

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
