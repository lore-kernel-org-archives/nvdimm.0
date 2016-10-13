Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0BE301A1E8D
 for <linux-nvdimm@lists.01.org>; Thu, 13 Oct 2016 12:09:51 -0700 (PDT)
Date: Thu, 13 Oct 2016 13:09:48 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] pmem: report error on clear poison failure
Message-ID: <20161013190948.GA26922@linux.intel.com>
References: <1476374061-9080-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4jdRhM8r1Ut4Ls4a4_PTroiXXZVcvruJ9TEj_SifenBCw@mail.gmail.com>
 <1476374787.20881.34.camel@hpe.com>
 <CAPcyv4jvi0N1qbUeEy5qvxp5uctv9sW4oNZLcO5Vt2TsuuQh-A@mail.gmail.com>
 <1476382494.20881.58.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1476382494.20881.58.camel@hpe.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 13, 2016 at 06:16:29PM +0000, Kani, Toshimitsu wrote:
> On Thu, 2016-10-13 at 10:22 -0700, Dan Williams wrote:
> > On Thu, Oct 13, 2016 at 9:08 AM, Kani, Toshimitsu <toshi.kani@hpe.com
> > > wrote:
> > > =

> > > On Thu, 2016-10-13 at 09:01 -0700, Dan Williams wrote:
> > > > =

> > > > On Thu, Oct 13, 2016 at 8:54 AM, Toshi Kani <toshi.kani@hpe.com>
> > > > wrote:
> > > > > =

> > > > > =

> > > > > ACPI Clear Uncorrectable Error DSM function may fail or may be
> > > > > unsupported on a platform.=A0=A0pmem_clear_poison() returns witho=
ut
> > > > > clearing badblocks in such cases, which leads to a silent data
> > > > > corruption.
> > > > > =

> > > > > Change pmem_do_bvec() and pmem_clear_poison() to return -EIO
> > > > > so that filesystem can log an error message.
> > > > =

> > > > What's the silent data corruption scenario?=A0=A0If the clear poison
> > > > fails I'm assuming that the poison will still be notified on the
> > > > next
> > > > read.
> > > =

> > > I agree that the data is eventually read, but there is no guranteed
> > > that when it is read soon enough, i.e. user might not access to the
> > > data for a long time.
> > =

> > ...but that's the same behavior for errors that we don't yet know
> > about.=A0=A0That said, we indeed know that the write failed.=A0=A0I'd f=
eel
> > better about this patch if the justification / impact was clearer in
> > the changelog, because "silent data corruption" is not the impact.
> =

> Agreed. =A0How about the following descritpion?
> =

> =3D=3D=3D
> ACPI Clear Uncorrectable Error DSM function may fail or may be
> unsupported on a platform.=A0=A0pmem_clear_poison() returns without
> clearing badblocks in such cases. =A0This failure is detected at
> the next read (-EIO).
> =

> This behavior can lead to an issue when user keeps writing but
> does not read immedicately. =A0For instance, flight recorder file
		immediately

> may be only read when it is necessary for troubleshooting.
> =

> Change pmem_do_bvec() and pmem_clear_poison() to return -EIO
> so that filesystem can log an error message on a write error.
> =3D=3D=3D
> =

> Thanks,
> -Toshi
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
