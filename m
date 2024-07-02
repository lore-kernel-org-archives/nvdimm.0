Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10FC84D39
	for <nvdimm@lists.linux.dev>; Tue,  2 Jul 2024 08:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719910007; cv=none; b=qfk80pgAYQSaFL1gVdTz5z6ybZrIVr+KK6/AP+2ckS89rxx2YuTWLvqqA1n5WGweGtqtmKRpXZp9qb8cK2efKn448c/YNcpSplrrpMV0cjkQfxTUvZ9KAnnGcWqTn+CLP4h4qRzP18aTra5vesuFXEA3+3Xr2qDSKUFj+yKPFtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719910007; c=relaxed/simple;
	bh=ZiU59mxp9tbpVxyHLThXQoZtI+f4W4Sd8qQJuDibjd8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=McK0Cw+t3vxtO9SrGU67BoD2izwuJH40QHgWLdIdYoEAEfdG14sDC7y2zWtsyZW+zMXljMwg0NBa/VSh17w7eWXOhLzCy4LYH0wLM4T+BSHezc4FrDpNbHWCLqTkN3ne8iT1N5dQFLL7vdrNUvPSHcEbQb883p5w5ZwVDrZKKgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WCxMh29P6z6JBDC;
	Tue,  2 Jul 2024 16:46:08 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 7FF171400CA;
	Tue,  2 Jul 2024 16:46:43 +0800 (CST)
Received: from localhost (10.203.174.77) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 2 Jul
 2024 09:46:43 +0100
Date: Tue, 2 Jul 2024 09:46:42 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: "Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [BUG REPORT] cxl process in infinity loop
Message-ID: <20240702094642.00000fd8@Huawei.com>
In-Reply-To: <OSZPR01MB6453BC61D2FF4035F18084EF8DDC2@OSZPR01MB6453.jpnprd01.prod.outlook.com>
References: <OSZPR01MB6453BC61D2FF4035F18084EF8DDC2@OSZPR01MB6453.jpnprd01.prod.outlook.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Tue, 2 Jul 2024 00:30:06 +0000
"Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com> wrote:

> Hi, all
>=20
> When I did the cxl memory hot-plug test on QEMU, I accidentally connected=
=20
> two memdev to the same downstream port, the command like below:
>=20
> > -object memory-backend-ram,size=3D262144k,share=3Don,id=3Dvmem0 \
> > -object memory-backend-ram,size=3D262144k,share=3Don,id=3Dvmem1 \
> > -device pxb-cxl,bus_nr=3D12,bus=3Dpcie.0,id=3Dcxl.1 \
> > -device cxl-rp,port=3D0,bus=3Dcxl.1,id=3Droot_port0,chassis=3D0,slot=3D=
0 \
> > -device cxl-upstream,bus=3Droot_port0,id=3Dus0 \
> > -device cxl-downstream,port=3D0,bus=3Dus0,id=3Dswport00,chassis=3D0,slo=
t=3D5 \
> > -device cxl-downstream,port=3D0,bus=3Dus0,id=3Dswport01,chassis=3D0,slo=
t=3D7 \ =20
> same downstream port but has different slot!
>=20
> > -device cxl-type3,bus=3Dswport00,volatile-memdev=3Dvmem0,id=3Dcxl-vmem0=
 \
> > -device cxl-type3,bus=3Dswport01,volatile-memdev=3Dvmem1,id=3Dcxl-vmem1=
 \
> > -M cxl-fmw.0.targets.0=3Dcxl.1,cxl-fmw.0.size=3D64G,cxl-fmw.0.interleav=
e-granularity=3D4k \ =20
>=20
> There is no error occurred when vm start, but when I executed the =E2=80=
=9Ccxl list=E2=80=9D command to view
> the CXL objects info, the process can not end properly.

I'd be happy to look preventing this on QEMU side if you send one,
but in general there are are lots of ways to shoot yourself in the
foot with CXL and PCI device emulation in QEMU so I'm not going
to rush to solve this specific one.

Likewise, some hardening in kernel / userspace probably makes sense but
this is a non compliant switch so priority of a fix is probably fairly low.

Jonathan

>=20
> Then I used strace to trace the process, I found that the process is in i=
nfinity loop:
> # strace cxl list
> ......
> clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=3D0, tv_nsec=3D1000000}, NULL)=
 =3D 0
> openat(AT_FDCWD, "/sys/bus/cxl/flush", O_WRONLY|O_CLOEXEC) =3D 3
> write(3, "1\n\0", 3)                    =3D 3
> close(3)                                =3D 0
> access("/run/udev/queue", F_OK)         =3D 0
> clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=3D0, tv_nsec=3D1000000}, NULL)=
 =3D 0
> openat(AT_FDCWD, "/sys/bus/cxl/flush", O_WRONLY|O_CLOEXEC) =3D 3
> write(3, "1\n\0", 3)                    =3D 3
> close(3)                                =3D 0
> access("/run/udev/queue", F_OK)         =3D 0
> clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=3D0, tv_nsec=3D1000000}, NULL)=
 =3D 0
> openat(AT_FDCWD, "/sys/bus/cxl/flush", O_WRONLY|O_CLOEXEC) =3D 3
> write(3, "1\n\0", 3)                    =3D 3
> close(3)                                =3D 0
> access("/run/udev/queue", F_OK)         =3D 0
> clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=3D0, tv_nsec=3D1000000}, NULL)=
 =3D 0
> openat(AT_FDCWD, "/sys/bus/cxl/flush", O_WRONLY|O_CLOEXEC) =3D 3
> write(3, "1\n\0", 3)                    =3D 3
> close(3)                                =3D 0
> access("/run/udev/queue", F_OK)         =3D 0
> clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=3D0, tv_nsec=3D1000000}, NULL)=
 =3D 0
> openat(AT_FDCWD, "/sys/bus/cxl/flush", O_WRONLY|O_CLOEXEC) =3D 3
> write(3, "1\n\0", 3)                    =3D 3
> close(3)                                =3D 0
> access("/run/udev/queue", F_OK)         =3D 0
> clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=3D0, tv_nsec=3D1000000}, NULL)=
 =3D 0
> openat(AT_FDCWD, "/sys/bus/cxl/flush", O_WRONLY|O_CLOEXEC) =3D 3
> write(3, "1\n\0", 3)                    =3D 3
> close(3)                                =3D 0
> access("/run/udev/queue", F_OK)         =3D 0
> clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=3D0, tv_nsec=3D1000000}, NULL)=
 =3D 0
> openat(AT_FDCWD, "/sys/bus/cxl/flush", O_WRONLY|O_CLOEXEC) =3D 3
> write(3, "1\n\0", 3)                    =3D 3
> close(3)                                =3D 0
> access("/run/udev/queue", F_OK)         =3D 0
> clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=3D0, tv_nsec=3D1000000}, NULL)=
 =3D 0
> openat(AT_FDCWD, "/sys/bus/cxl/flush", O_WRONLY|O_CLOEXEC) =3D 3
> write(3, "1\n\0", 3)                    =3D 3
> close(3)                                =3D 0
> access("/run/udev/queue", F_OK)         =3D 0
>=20
> [Environment]:
> linux: V6.10-rc3
> QEMU: V9.0.0
> ndctl: v79
>=20
> I know this is because of the wrong use of the QEMU command, but I think =
we should=20
> be aware of this error in one of the QEMU, OS or ndctl side at least.
>=20
> Thanks
> Xingtao

