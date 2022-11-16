Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8637C
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 11:43:39 +0000 (UTC)
Received: from frapeml100008.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NC1KF3QtNz68BcV;
	Wed, 16 Nov 2022 19:38:57 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml100008.china.huawei.com (7.182.85.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 12:43:36 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 16 Nov
 2022 11:43:36 +0000
Date: Wed, 16 Nov 2022 11:43:35 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v4 12/18] tools/testing/cxl: Add "passphrase secure
 erase" opcode support
Message-ID: <20221116114335.00006a3d@Huawei.com>
In-Reply-To: <14ae41bc-2d63-460b-5ac5-a4d94aa39982@intel.com>
References: <166845791969.2496228.8357488385523295841.stgit@djiang5-desk3.ch.intel.com>
	<166845805415.2496228.732168029765896218.stgit@djiang5-desk3.ch.intel.com>
	<20221115110831.00001fa4@Huawei.com>
	<a8ed61db-9bf1-410c-b4e6-7042f48a67ff@intel.com>
	<14ae41bc-2d63-460b-5ac5-a4d94aa39982@intel.com>
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
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Tue, 15 Nov 2022 10:01:53 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> On 11/15/2022 7:57 AM, Dave Jiang wrote:
> >=20
> >=20
> > On 11/15/2022 3:08 AM, Jonathan Cameron wrote: =20
> >> On Mon, 14 Nov 2022 13:34:14 -0700
> >> Dave Jiang <dave.jiang@intel.com> wrote:
> >> =20
> >>> Add support to emulate a CXL mem device support the "passphrase secure
> >>> erase" operation.
> >>>
> >>> Signed-off-by: Dave Jiang <dave.jiang@intel.com> =20
> >> The logic in here gives me a headache but I'm not sure it's correct=20
> >> yet...
> >>
> >> If you can figure out what is supposed to happen if this is called
> >> with Passphrase Type =3D=3D master before the master passphrase has be=
en set
> >> then you are doing better than me.
> >>
> >> Unlike for the User passphrase, where the language " .. and the user=20
> >> passphrase
> >> is not currently set or is not supported by the device, this value is=
=20
> >> ignored."
> >> to me implies we wipe the device and clear the non existent user pass=
=20
> >> phrase,
> >> the not set master passphrase case isn't covered as far as I can see.
> >>
> >> The user passphrase question raises a futher question (see inline)
> >>
> >> Thoughts? =20
> >=20
> > Guess this is what happens when you bolt on master passphrase support=20
> > after defining the spec without its existence, and then move it to a=20
> > different spec and try to maintain compatibility between the two in=20
> > order to not fork the hardware/firmware....
> >=20
> > Should we treat the no passphrase set instance the same as sending a=20
> > Secure Erase (Opcode 4401h)? And then the only case left is no master=20
> > pass set but user pass is set.
> >=20
> > if (!master_pass_set && pass_type_master) {
> >  =A0=A0=A0=A0if (user_pass_set)
> >  =A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
> >  =A0=A0=A0=A0else
> >  =A0=A0=A0=A0=A0=A0=A0 secure_erase;
> > }
> > =20
> This is the current change:
>=20
> +       switch (erase->type) {
> +       case CXL_PMEM_SEC_PASS_MASTER:
> +               if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PAS=
S_SET) {
> +                       if (memcmp(mdata->master_pass, erase->pass,
> +                                  NVDIMM_PASSPHRASE_LEN)) {
> +                               master_plimit_check(mdata);
> +                               cmd->return_code =3D CXL_MBOX_CMD_RC_PASS=
PHRASE;
> +                               return -ENXIO;
> +                       }
> +                       mdata->master_limit =3D 0;
> +                       mdata->user_limit =3D 0;
> +                       mdata->security_state &=3D ~CXL_PMEM_SEC_STATE_US=
ER_PASS_SET;
> +                       memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN=
);
> +                       mdata->security_state &=3D ~CXL_PMEM_SEC_STATE_LO=
CKED;

> +               } else if (mdata->security_state & CXL_PMEM_SEC_STATE_USE=
R_PASS_SET) {
> +                       return -EINVAL;
> +               }
I would add a comment here to say what we aren't faking.  The aim being to =
show that
in all the good paths this happens, even though we don't do the other stuff=
 in
some of them.

/* Scramble encryption keys so that data is effectively erased */

> +
> +               return 0;
> +       case CXL_PMEM_SEC_PASS_USER:
> +               if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_=
SET) {
> +                       if (memcmp(mdata->user_pass, erase->pass,
> +                                  NVDIMM_PASSPHRASE_LEN)) {
> +                               user_plimit_check(mdata);
> +                               cmd->return_code =3D CXL_MBOX_CMD_RC_PASS=
PHRASE;
> +                               return -ENXIO;
> +                       }
> +                       mdata->user_limit =3D 0;
> +                       mdata->security_state &=3D ~CXL_PMEM_SEC_STATE_US=
ER_PASS_SET;
> +                       memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN=
);
> +               }
> +

/* Scramble encryption keys so that data is effectively erased */
here as well for the same reason.

> +               return 0;
> +       default:
> +               fallthrough;

Might as well return -EINVAL; here and drop the below one.

Otherwise looks good to me.  We could sprinkle some comments in here to
hightlight why we have concluded it ought to behave like this.
If nothing else, I doubt either of us will remember when we look at this
code in more than a few days time ;)

Otherwise looks good to me.

Jonathan


> +       }
> +
> +       return -EINVAL;
>=20
>=20
>=20
> >>
> >> Other than that some suggestions inline but nothing functional, so up=
=20
> >> to you.
> >> Either way
> >>
> >> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> >> =20
> >>> ---
> >>> =A0 tools/testing/cxl/test/mem.c |=A0=A0 65=20
> >>> ++++++++++++++++++++++++++++++++++++++++++
> >>> =A0 1 file changed, 65 insertions(+)
> >>>
> >>> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/me=
m.c
> >>> index 90607597b9a4..fc28f7cc147a 100644
> >>> --- a/tools/testing/cxl/test/mem.c
> >>> +++ b/tools/testing/cxl/test/mem.c
> >>> @@ -362,6 +362,68 @@ static int mock_unlock_security(struct=20
> >>> cxl_dev_state *cxlds, struct cxl_mbox_cmd
> >>> =A0=A0=A0=A0=A0 return 0;
> >>> =A0 }
> >>> +static int mock_passphrase_secure_erase(struct cxl_dev_state *cxlds,
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct cxl=
_mbox_cmd *cmd)
> >>> +{
> >>> +=A0=A0=A0 struct cxl_mock_mem_pdata *mdata =3D dev_get_platdata(cxld=
s->dev);
> >>> +=A0=A0=A0 struct cxl_pass_erase *erase;
> >>> +
> >>> +=A0=A0=A0 if (cmd->size_in !=3D sizeof(*erase))
> >>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
> >>> +
> >>> +=A0=A0=A0 if (cmd->size_out !=3D 0)
> >>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
> >>> +
> >>> +=A0=A0=A0 erase =3D cmd->payload_in;
> >>> +=A0=A0=A0 if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN) {
> >>> +=A0=A0=A0=A0=A0=A0=A0 cmd->return_code =3D CXL_MBOX_CMD_RC_SECURITY;
> >>> +=A0=A0=A0=A0=A0=A0=A0 return -ENXIO;
> >>> +=A0=A0=A0 }
> >>> +
> >>> +=A0=A0=A0 if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT=
 &&
> >>> +=A0=A0=A0=A0=A0=A0=A0 erase->type =3D=3D CXL_PMEM_SEC_PASS_USER) {
> >>> +=A0=A0=A0=A0=A0=A0=A0 cmd->return_code =3D CXL_MBOX_CMD_RC_SECURITY;
> >>> +=A0=A0=A0=A0=A0=A0=A0 return -ENXIO;
> >>> +=A0=A0=A0 }
> >>> +
> >>> +=A0=A0=A0 if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PLIM=
IT &&
> >>> +=A0=A0=A0=A0=A0=A0=A0 erase->type =3D=3D CXL_PMEM_SEC_PASS_MASTER) {
> >>> +=A0=A0=A0=A0=A0=A0=A0 cmd->return_code =3D CXL_MBOX_CMD_RC_SECURITY;
> >>> +=A0=A0=A0=A0=A0=A0=A0 return -ENXIO;
> >>> +=A0=A0=A0 }
> >>> +
> >>> +=A0=A0=A0 if (erase->type =3D=3D CXL_PMEM_SEC_PASS_MASTER &&
> >>> +=A0=A0=A0=A0=A0=A0=A0 mdata->security_state & CXL_PMEM_SEC_STATE_MAS=
TER_PASS_SET) {
> >>> +=A0=A0=A0=A0=A0=A0=A0 if (memcmp(mdata->master_pass, erase->pass,=20
> >>> NVDIMM_PASSPHRASE_LEN)) {
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 master_plimit_check(mdata);
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cmd->return_code =3D CXL_MBOX_CMD_=
RC_PASSPHRASE;
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENXIO;
> >>> +=A0=A0=A0=A0=A0=A0=A0 }
> >>> +=A0=A0=A0=A0=A0=A0=A0 mdata->master_limit =3D 0;
> >>> +=A0=A0=A0=A0=A0=A0=A0 mdata->user_limit =3D 0;
> >>> +=A0=A0=A0=A0=A0=A0=A0 mdata->security_state &=3D ~CXL_PMEM_SEC_STATE=
_USER_PASS_SET;
> >>> +=A0=A0=A0=A0=A0=A0=A0 memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_=
LEN);
> >>> +=A0=A0=A0=A0=A0=A0=A0 mdata->security_state &=3D ~CXL_PMEM_SEC_STATE=
_LOCKED;
> >>> +=A0=A0=A0=A0=A0=A0=A0 return 0;
> >>> +=A0=A0=A0 } =20
> >> What to do if the masterpass phrase isn't set?
> >> Even if we return 0, I'd slightly prefer to see that done locally so=20
> >> refactor as
> >> =A0=A0=A0=A0if (erase->type =3D=3D CXL_PMEM_SEC_PASS_MASTER) {
> >> =A0=A0=A0=A0=A0=A0=A0 if (!(mdata->security_state &=20
> >> CXL_PMEM_SEC_STATATE_MASTER_PASS_SET)) {
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0; /* ? */
> >> =A0=A0=A0=A0=A0=A0=A0 if (memcmp)...
> >> =A0=A0=A0=A0} else { /* CXL_PMEM_SEC_PASS_USER */ //or make it a switc=
h.
> >> =20
> >>> +
> >>> +=A0=A0=A0 if (erase->type =3D=3D CXL_PMEM_SEC_PASS_USER &&
> >>> +=A0=A0=A0=A0=A0=A0=A0 mdata->security_state & CXL_PMEM_SEC_STATE_USE=
R_PASS_SET) { =20
> >>
> >> Given we aren't actually scrambling the encryption keys (as we don't=20
> >> have any ;)
> >> it doesn't make a functional difference, but to line up with the spec,=
=20
> >> I would
> >> consider changing this to explicitly have the path for no user=20
> >> passphrase set.
> >>
> >> =A0=A0=A0=A0if (erase->type =3D=3D CXL_PMEM_SEC_PASS_USER) {
> >> =A0=A0=A0=A0=A0=A0=A0 if (mdata->security_state & CXL_MEM_SEC_STATE_US=
ER_PASS_SET) {
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (memcmp(mdata->user_p=
ass, erase->pass,=20
> >> NVDIMM_PASSPHRASE_LEN)) {
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 user_plimit_check(mdata);
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cmd->return_code =3D CXL=
_MBOX_CMD_RC_PASSPHRASE;
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENXIO;
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> >>
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mdata->user_limit =3D 0;
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mdata->security_state &=3D ~CXL_PMEM=
_SEC_STATE_USER_PASS_SET;
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memset(mdata->user_pass, 0, NVDIMM_P=
ASSPHRASE_LEN);
> >> =A0=A0=A0=A0=A0=A0=A0 }
> >> =A0=A0=A0=A0=A0=A0=A0 /* Change encryption keys */
> >> =A0=A0=A0=A0=A0=A0=A0 return 0;
> >> =A0=A0=A0=A0}
> >> =20
> >>> +=A0=A0=A0=A0=A0=A0=A0 if (memcmp(mdata->user_pass, erase->pass,=20
> >>> NVDIMM_PASSPHRASE_LEN)) {
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 user_plimit_check(mdata);
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cmd->return_code =3D CXL_MBOX_CMD_=
RC_PASSPHRASE;
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENXIO;
> >>> +=A0=A0=A0=A0=A0=A0=A0 }
> >>> +
> >>> +=A0=A0=A0=A0=A0=A0=A0 mdata->user_limit =3D 0;
> >>> +=A0=A0=A0=A0=A0=A0=A0 mdata->security_state &=3D ~CXL_PMEM_SEC_STATE=
_USER_PASS_SET;
> >>> +=A0=A0=A0=A0=A0=A0=A0 memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_=
LEN);
> >>> +=A0=A0=A0=A0=A0=A0=A0 return 0;
> >>> +=A0=A0=A0 }
> >>> +
> >>> +=A0=A0=A0 return 0; =20
> >>
> >> With above changes you can never reach here.
> >> =20
> >>> +}
> >>> +
> >>> =A0 static int mock_get_lsa(struct cxl_dev_state *cxlds, struct=20
> >>> cxl_mbox_cmd *cmd)
> >>> =A0 {
> >>> =A0=A0=A0=A0=A0 struct cxl_mbox_get_lsa *get_lsa =3D cmd->payload_in;
> >>> @@ -470,6 +532,9 @@ static int cxl_mock_mbox_send(struct=20
> >>> cxl_dev_state *cxlds, struct cxl_mbox_cmd *
> >>> =A0=A0=A0=A0=A0 case CXL_MBOX_OP_UNLOCK:
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D mock_unlock_security(cxlds, cmd);
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
> >>> +=A0=A0=A0 case CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE:
> >>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D mock_passphrase_secure_erase(cxlds, cmd=
);
> >>> +=A0=A0=A0=A0=A0=A0=A0 break;
> >>> =A0=A0=A0=A0=A0 default:
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
> >>> =A0=A0=A0=A0=A0 }
> >>>
> >>> =20
> >> =20

