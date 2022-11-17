Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6360F23A2
	for <nvdimm@lists.linux.dev>; Thu, 17 Nov 2022 11:26:10 +0000 (UTC)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NCcx92D98z67bjw;
	Thu, 17 Nov 2022 19:23:41 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 12:26:07 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 11:26:06 +0000
Date: Thu, 17 Nov 2022 11:26:06 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v4 12/18] tools/testing/cxl: Add "passphrase secure
 erase" opcode support
Message-ID: <20221117112606.00000f17@Huawei.com>
In-Reply-To: <bbe4be20-5f2e-077f-009a-4ece6b1c9324@intel.com>
References: <166845791969.2496228.8357488385523295841.stgit@djiang5-desk3.ch.intel.com>
	<166845805415.2496228.732168029765896218.stgit@djiang5-desk3.ch.intel.com>
	<20221115110831.00001fa4@Huawei.com>
	<a8ed61db-9bf1-410c-b4e6-7042f48a67ff@intel.com>
	<14ae41bc-2d63-460b-5ac5-a4d94aa39982@intel.com>
	<20221116114335.00006a3d@Huawei.com>
	<bbe4be20-5f2e-077f-009a-4ece6b1c9324@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Wed, 16 Nov 2022 14:54:02 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> On 11/16/2022 3:43 AM, Jonathan Cameron wrote:
> > On Tue, 15 Nov 2022 10:01:53 -0700
> > Dave Jiang <dave.jiang@intel.com> wrote:
> >  =20
> >> On 11/15/2022 7:57 AM, Dave Jiang wrote: =20
> >>>
> >>>
> >>> On 11/15/2022 3:08 AM, Jonathan Cameron wrote: =20
> >>>> On Mon, 14 Nov 2022 13:34:14 -0700
> >>>> Dave Jiang <dave.jiang@intel.com> wrote:
> >>>>    =20
> >>>>> Add support to emulate a CXL mem device support the "passphrase sec=
ure
> >>>>> erase" operation.
> >>>>>
> >>>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com> =20
> >>>> The logic in here gives me a headache but I'm not sure it's correct
> >>>> yet...
> >>>>
> >>>> If you can figure out what is supposed to happen if this is called
> >>>> with Passphrase Type =3D=3D master before the master passphrase has =
been set
> >>>> then you are doing better than me.
> >>>>
> >>>> Unlike for the User passphrase, where the language " .. and the user
> >>>> passphrase
> >>>> is not currently set or is not supported by the device, this value is
> >>>> ignored."
> >>>> to me implies we wipe the device and clear the non existent user pass
> >>>> phrase,
> >>>> the not set master passphrase case isn't covered as far as I can see.
> >>>>
> >>>> The user passphrase question raises a futher question (see inline)
> >>>>
> >>>> Thoughts? =20
> >>>
> >>> Guess this is what happens when you bolt on master passphrase support
> >>> after defining the spec without its existence, and then move it to a
> >>> different spec and try to maintain compatibility between the two in
> >>> order to not fork the hardware/firmware....
> >>>
> >>> Should we treat the no passphrase set instance the same as sending a
> >>> Secure Erase (Opcode 4401h)? And then the only case left is no master
> >>> pass set but user pass is set.
> >>>
> >>> if (!master_pass_set && pass_type_master) {
> >>>   =A0=A0=A0=A0if (user_pass_set)
> >>>   =A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
> >>>   =A0=A0=A0=A0else
> >>>   =A0=A0=A0=A0=A0=A0=A0 secure_erase;
> >>> }
> >>>    =20
> >> This is the current change:
> >>
> >> +       switch (erase->type) {
> >> +       case CXL_PMEM_SEC_PASS_MASTER:
> >> +               if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_=
PASS_SET) {
> >> +                       if (memcmp(mdata->master_pass, erase->pass,
> >> +                                  NVDIMM_PASSPHRASE_LEN)) {
> >> +                               master_plimit_check(mdata);
> >> +                               cmd->return_code =3D CXL_MBOX_CMD_RC_P=
ASSPHRASE;
> >> +                               return -ENXIO;
> >> +                       }
> >> +                       mdata->master_limit =3D 0;
> >> +                       mdata->user_limit =3D 0;
> >> +                       mdata->security_state &=3D ~CXL_PMEM_SEC_STATE=
_USER_PASS_SET;
> >> +                       memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_=
LEN);
> >> +                       mdata->security_state &=3D ~CXL_PMEM_SEC_STATE=
_LOCKED; =20
> >  =20
> >> +               } else if (mdata->security_state & CXL_PMEM_SEC_STATE_=
USER_PASS_SET) {
> >> +                       return -EINVAL;
> >> +               } =20
>=20
> So while looking at 8.2.9.8.6.3 I stumbled on this line: "When the=20
> master passphrase is disabled, the device shall return Invalid Input for=
=20
> the Passphrase Secure Erase command with the master passphrase". I=20
> suppose the above would reduce to just else {} instead?

Good spot. Agreed, this one is just an else.  Definitely a case for a refer=
ence
to the spec though!

> And it probably=20
> wouldn't hurt to have the spec duplicate this line under the passphrase=20
> secure erase section as well.

Would be nice :)

