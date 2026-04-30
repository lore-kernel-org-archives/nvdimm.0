Received: from a8-18.smtp-out.amazonses.com (a8-18.smtp-out.amazonses.com [54.240.8.18])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC2731F9B4
	for <nvdimm@lists.linux.dev>; Thu, 30 Apr 2026 15:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777563254; cv=none; b=mK/t3dhM8XjQHdjNEXNWhbCnFj/ANiXV4Fsb//xujgW4+zsau7QvG1K7p2kFr2OeXaJp9wjhFOnWoIR7x3MugAqi7JNT+YlwCzuay7i8j3oY8Ox6lAHg3sLrcKsyh9RM03ZTZaoobt9be7Rn9OUxw4d/xeRaF8X+wGYxNfThyjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777563254; c=relaxed/simple;
	bh=Eb8iU+8/sK60Vn45ivLSPaUxIzXvwFUmC4JsmKYY1Z8=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=XYk9FFWj/yfcezzGGNSmyEWYQk1hj4SoUDia4iJ5+l2z/Q55V4z/9kcQZ7o12HOxwAwUQ7dfWbRpaN8rKeQnpJCmjqou9qs40aBNvFwlq6+suaw3EGMOXEKlnB2TvgX7REweNwdX7QHEd2DQKKIVZMTEUZU9wC6haSA9lf3qPa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=gEf8X0aD; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=L1C78IrN; arc=none smtp.client-ip=54.240.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="gEf8X0aD";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="L1C78IrN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1777563251;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=Eb8iU+8/sK60Vn45ivLSPaUxIzXvwFUmC4JsmKYY1Z8=;
	b=gEf8X0aD5MYjK+CiljVVi2+7G4n2ionvM8WHCTXN2p9gbsKOf9yHkG1gcsTWZryA
	tc249Ydq3LXUF9UFKf9PBRWp8kjUHWQ8nFbfvop6P+X3w0X0ekgxFJ0IA0r7LQT+in7
	fB2HrQrbT3iR/V2vkSg7q3Djl4sYC6tRfzFZzymw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1777563251;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=Eb8iU+8/sK60Vn45ivLSPaUxIzXvwFUmC4JsmKYY1Z8=;
	b=L1C78IrNXeMi2pLzRXkn4Cj6F24Yco+uEeblVuhtc2yO3o49Kbc+zFkw6rJb2uAs
	3gFCtWTaoJWnefsT4nBu51sDoAdqtoirobD8z+RDEkCR4iQlbuOrHRUPqksX1rrX6Yp
	cxCsJnr+c623NSI+eEZ8VCRTTZcjcARdr6RojoX4=
Subject: [PATCH V5 1/2] daxctl: Add support for famfs mode
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?John_Groves?= <jgroves@fastmail.com>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>, 
	=?UTF-8?Q?Alison_Schofield?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Jonathan_Cameron?= <Jonathan.Cameron@huawei.com>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40micron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?dev=2Esrinivasulu=40gmail=2Ecom?= <dev.srinivasulu@gmail.com>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2E?= =?UTF-8?Q?org?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2E?= =?UTF-8?Q?linux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40v?= =?UTF-8?Q?ger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Thu, 30 Apr 2026 15:34:11 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019ddf064477-8322b695-f2d8-481c-9fcd-8b16fc97ad4d-000000@email.amazonses.com>
References: 
 <0100019ddf064477-8322b695-f2d8-481c-9fcd-8b16fc97ad4d-000000@email.amazonses.com> 
 <20260430153405.84164-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc2LbJGsD/WGrZQ9G+pmhwKljdfw==
Thread-Topic: [PATCH V5 1/2] daxctl: Add support for famfs mode
X-Wm-Sent-Timestamp: 1777563250
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ddf06b207-eaf8cb8a-066e-4642-8947-effdb4848c20-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.04.30-54.240.8.18

From: John Groves <John@Groves.net>=0D=0A=0D=0APutting a daxdev in famfs =
mode means binding it to fsdev_dax.ko=0D=0A(drivers/dax/fsdev.c). Finding=
 a daxdev bound to fsdev_dax means=0D=0Ait is in famfs mode.=0D=0A=0D=0AA=
 test for this functionality is added in the next commit.=0D=0A=0D=0AWith=
 devdax, famfs, and system-ram modes, the previous logic that assumed=0D=0A=
'not in mode X means in mode Y' needed to get slightly more complicated.=0D=
=0A=0D=0AAdd explicit mode detection functions:=0D=0A- daxctl_dev_is_famf=
s_mode(): check if bound to fsdev_dax driver=0D=0A- daxctl_dev_is_devdax_=
mode(): check if bound to device_dax driver=0D=0ABoth delegate to a share=
d static helper daxctl_dev_bound_to_module() to=0D=0Aavoid duplicating th=
e driver-symlink lookup, as does the pre-existing=0D=0Adaxctl_dev_is_syst=
em_ram_capable().=0D=0A=0D=0AUpdate mode transition logic in device.c:=0D=
=0A- disable_devdax_device(): verify device is actually in devdax mode=0D=
=0A- disable_famfs_device(): verify device is actually in famfs mode=0D=0A=
- All reconfig_mode_*() functions explicitly check each mode=0D=0A- Handl=
e unrecognized mode with an error instead of wrong assumption=0D=0A=0D=0A=
Update json.c to report fsdev_dax-bound devices as 'famfs' mode.  An=0D=0A=
unbound device continues to be reported as 'devdax' (the legacy default=0D=
=0Awhen no driver is bound), to preserve existing behavior.=0D=0A=0D=0ASi=
gned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A daxctl/device.c=
                | 132 ++++++++++++++++++++++++++++++---=0D=0A daxctl/json=
=2Ec                  |  13 +++-=0D=0A daxctl/lib/libdaxctl-private.h |  =
 2 +=0D=0A daxctl/lib/libdaxctl.c         |  39 +++++++++-=0D=0A daxctl/l=
ib/libdaxctl.sym       |   7 ++=0D=0A daxctl/libdaxctl.h             |   =
3 +=0D=0A 6 files changed, 181 insertions(+), 15 deletions(-)=0D=0A=0D=0A=
diff --git a/daxctl/device.c b/daxctl/device.c=0D=0Aindex a4e36b1..003609=
e 100644=0D=0A--- a/daxctl/device.c=0D=0A+++ b/daxctl/device.c=0D=0A@@ -4=
2,6 +42,7 @@ enum dev_mode {=0D=0A =09DAXCTL_DEV_MODE_UNKNOWN,=0D=0A =09D=
AXCTL_DEV_MODE_DEVDAX,=0D=0A =09DAXCTL_DEV_MODE_RAM,=0D=0A+=09DAXCTL_DEV_=
MODE_FAMFS,=0D=0A };=0D=0A=20=0D=0A struct mapping {=0D=0A@@ -471,6 +472,=
13 @@ static const char *parse_device_options(int argc, const char **argv=
,=0D=0A =09=09=09=09=09"--no-online is incompatible with --mode=3Ddevdax\=
n");=0D=0A =09=09=09=09rc =3D  -EINVAL;=0D=0A =09=09=09}=0D=0A+=09=09} el=
se if (strcmp(param.mode, "famfs") =3D=3D 0) {=0D=0A+=09=09=09reconfig_mo=
de =3D DAXCTL_DEV_MODE_FAMFS;=0D=0A+=09=09=09if (param.no_online) {=0D=0A=
+=09=09=09=09fprintf(stderr,=0D=0A+=09=09=09=09=09"--no-online is incompa=
tible with --mode=3Dfamfs\n");=0D=0A+=09=09=09=09rc =3D  -EINVAL;=0D=0A+=09=
=09=09}=0D=0A =09=09}=0D=0A =09=09break;=0D=0A =09case ACTION_CREATE:=0D=0A=
@@ -696,8 +704,42 @@ static int disable_devdax_device(struct daxctl_dev *=
dev)=0D=0A =09int rc;=0D=0A=20=0D=0A =09if (mem) {=0D=0A-=09=09fprintf(st=
derr, "%s was already in system-ram mode\n",=0D=0A-=09=09=09devname);=0D=0A=
+=09=09fprintf(stderr, "%s is in system-ram mode\n", devname);=0D=0A+=09=09=
return 1;=0D=0A+=09}=0D=0A+=09if (daxctl_dev_is_famfs_mode(dev)) {=0D=0A+=
=09=09fprintf(stderr, "%s is in famfs mode\n", devname);=0D=0A+=09=09retu=
rn 1;=0D=0A+=09}=0D=0A+=09if (!daxctl_dev_is_devdax_mode(dev)) {=0D=0A+=09=
=09fprintf(stderr, "%s is not in devdax mode\n", devname);=0D=0A+=09=09re=
turn 1;=0D=0A+=09}=0D=0A+=09rc =3D daxctl_dev_disable(dev);=0D=0A+=09if (=
rc) {=0D=0A+=09=09fprintf(stderr, "%s: disable failed: %s\n",=0D=0A+=09=09=
=09daxctl_dev_get_devname(dev), strerror(-rc));=0D=0A+=09=09return rc;=0D=
=0A+=09}=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static int disable_famfs=
_device(struct daxctl_dev *dev)=0D=0A+{=0D=0A+=09struct daxctl_memory *me=
m =3D daxctl_dev_get_memory(dev);=0D=0A+=09const char *devname =3D daxctl=
_dev_get_devname(dev);=0D=0A+=09int rc;=0D=0A+=0D=0A+=09if (mem) {=0D=0A+=
=09=09fprintf(stderr, "%s is in system-ram mode\n", devname);=0D=0A+=09=09=
return 1;=0D=0A+=09}=0D=0A+=09if (daxctl_dev_is_devdax_mode(dev)) {=0D=0A=
+=09=09fprintf(stderr, "%s is in devdax mode\n", devname);=0D=0A+=09=09re=
turn 1;=0D=0A+=09}=0D=0A+=09if (!daxctl_dev_is_famfs_mode(dev)) {=0D=0A+=09=
=09fprintf(stderr, "%s is not in famfs mode\n", devname);=0D=0A =09=09ret=
urn 1;=0D=0A =09}=0D=0A =09rc =3D daxctl_dev_disable(dev);=0D=0A@@ -711,6=
 +753,7 @@ static int disable_devdax_device(struct daxctl_dev *dev)=0D=0A=
=20=0D=0A static int reconfig_mode_system_ram(struct daxctl_dev *dev)=0D=0A=
 {=0D=0A+=09struct daxctl_memory *mem =3D daxctl_dev_get_memory(dev);=0D=0A=
 =09const char *devname =3D daxctl_dev_get_devname(dev);=0D=0A =09int rc,=
 skip_enable =3D 0;=0D=0A=20=0D=0A@@ -724,11 +767,21 @@ static int reconf=
ig_mode_system_ram(struct daxctl_dev *dev)=0D=0A =09}=0D=0A=20=0D=0A =09i=
f (daxctl_dev_is_enabled(dev)) {=0D=0A-=09=09rc =3D disable_devdax_device=
(dev);=0D=0A-=09=09if (rc < 0)=0D=0A-=09=09=09return rc;=0D=0A-=09=09if (=
rc > 0)=0D=0A+=09=09if (mem) {=0D=0A+=09=09=09/* already in system-ram mo=
de */=0D=0A =09=09=09skip_enable =3D 1;=0D=0A+=09=09} else if (daxctl_dev=
_is_famfs_mode(dev)) {=0D=0A+=09=09=09rc =3D disable_famfs_device(dev);=0D=
=0A+=09=09=09if (rc)=0D=0A+=09=09=09=09return rc;=0D=0A+=09=09} else if (=
daxctl_dev_is_devdax_mode(dev)) {=0D=0A+=09=09=09rc =3D disable_devdax_de=
vice(dev);=0D=0A+=09=09=09if (rc)=0D=0A+=09=09=09=09return rc;=0D=0A+=09=09=
} else {=0D=0A+=09=09=09fprintf(stderr, "%s: unknown mode\n", devname);=0D=
=0A+=09=09=09return -EINVAL;=0D=0A+=09=09}=0D=0A =09}=0D=0A=20=0D=0A =09i=
f (!skip_enable) {=0D=0A@@ -750,7 +803,7 @@ static int disable_system_ram=
_device(struct daxctl_dev *dev)=0D=0A =09int rc;=0D=0A=20=0D=0A =09if (!m=
em) {=0D=0A-=09=09fprintf(stderr, "%s was already in devdax mode\n", devn=
ame);=0D=0A+=09=09fprintf(stderr, "%s is not in system-ram mode\n", devna=
me);=0D=0A =09=09return 1;=0D=0A =09}=0D=0A=20=0D=0A@@ -786,12 +839,31 @@=
 static int disable_system_ram_device(struct daxctl_dev *dev)=0D=0A=20=0D=
=0A static int reconfig_mode_devdax(struct daxctl_dev *dev)=0D=0A {=0D=0A=
+=09struct daxctl_memory *mem =3D daxctl_dev_get_memory(dev);=0D=0A+=09co=
nst char *devname =3D daxctl_dev_get_devname(dev);=0D=0A =09int rc;=0D=0A=
=20=0D=0A =09if (daxctl_dev_is_enabled(dev)) {=0D=0A-=09=09rc =3D disable=
_system_ram_device(dev);=0D=0A-=09=09if (rc)=0D=0A-=09=09=09return rc;=0D=
=0A+=09=09if (mem) {=0D=0A+=09=09=09rc =3D disable_system_ram_device(dev)=
;=0D=0A+=09=09=09if (rc)=0D=0A+=09=09=09=09return rc;=0D=0A+=09=09} else =
if (daxctl_dev_is_famfs_mode(dev)) {=0D=0A+=09=09=09rc =3D disable_famfs_=
device(dev);=0D=0A+=09=09=09if (rc)=0D=0A+=09=09=09=09return rc;=0D=0A+=09=
=09} else if (daxctl_dev_is_devdax_mode(dev)) {=0D=0A+=09=09=09/* already=
 in devdax mode, just re-enable */=0D=0A+=09=09=09rc =3D daxctl_dev_disab=
le(dev);=0D=0A+=09=09=09if (rc) {=0D=0A+=09=09=09=09fprintf(stderr, "%s: =
disable failed: %s\n",=0D=0A+=09=09=09=09=09devname, strerror(-rc));=0D=0A=
+=09=09=09=09return rc;=0D=0A+=09=09=09}=0D=0A+=09=09} else {=0D=0A+=09=09=
=09fprintf(stderr, "%s: unknown mode\n", devname);=0D=0A+=09=09=09return =
-EINVAL;=0D=0A+=09=09}=0D=0A =09}=0D=0A=20=0D=0A =09rc =3D daxctl_dev_ena=
ble_devdax(dev);=0D=0A@@ -801,6 +873,43 @@ static int reconfig_mode_devda=
x(struct daxctl_dev *dev)=0D=0A =09return 0;=0D=0A }=0D=0A=20=0D=0A+stati=
c int reconfig_mode_famfs(struct daxctl_dev *dev)=0D=0A+{=0D=0A+=09struct=
 daxctl_memory *mem =3D daxctl_dev_get_memory(dev);=0D=0A+=09const char *=
devname =3D daxctl_dev_get_devname(dev);=0D=0A+=09int rc;=0D=0A+=0D=0A+=09=
if (daxctl_dev_is_enabled(dev)) {=0D=0A+=09=09if (mem) {=0D=0A+=09=09=09f=
printf(stderr,=0D=0A+=09=09=09=09"%s is in system-ram mode; must be in de=
vdax mode to convert to famfs\n",=0D=0A+=09=09=09=09devname);=0D=0A+=09=09=
=09return -EINVAL;=0D=0A+=09=09} else if (daxctl_dev_is_famfs_mode(dev)) =
{=0D=0A+=09=09=09/* already in famfs mode, just re-enable */=0D=0A+=09=09=
=09rc =3D daxctl_dev_disable(dev);=0D=0A+=09=09=09if (rc) {=0D=0A+=09=09=09=
=09fprintf(stderr, "%s: disable failed: %s\n",=0D=0A+=09=09=09=09=09devna=
me, strerror(-rc));=0D=0A+=09=09=09=09return rc;=0D=0A+=09=09=09}=0D=0A+=09=
=09} else if (daxctl_dev_is_devdax_mode(dev)) {=0D=0A+=09=09=09rc =3D dis=
able_devdax_device(dev);=0D=0A+=09=09=09if (rc)=0D=0A+=09=09=09=09return =
rc;=0D=0A+=09=09} else {=0D=0A+=09=09=09fprintf(stderr, "%s: unknown mode=
\n", devname);=0D=0A+=09=09=09return -EINVAL;=0D=0A+=09=09}=0D=0A+=09}=0D=
=0A+=0D=0A+=09rc =3D daxctl_dev_enable_famfs(dev);=0D=0A+=09if (rc)=0D=0A=
+=09=09return rc;=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A static i=
nt do_create(struct daxctl_region *region, long long val,=0D=0A =09=09   =
  struct json_object **jdevs)=0D=0A {=0D=0A@@ -887,6 +996,9 @@ static int=
 do_reconfig(struct daxctl_dev *dev, enum dev_mode mode,=0D=0A =09case DA=
XCTL_DEV_MODE_DEVDAX:=0D=0A =09=09rc =3D reconfig_mode_devdax(dev);=0D=0A=
 =09=09break;=0D=0A+=09case DAXCTL_DEV_MODE_FAMFS:=0D=0A+=09=09rc =3D rec=
onfig_mode_famfs(dev);=0D=0A+=09=09break;=0D=0A =09default:=0D=0A =09=09f=
printf(stderr, "%s: unknown mode requested: %d\n",=0D=0A =09=09=09devname=
, mode);=0D=0Adiff --git a/daxctl/json.c b/daxctl/json.c=0D=0Aindex 3cbce=
9d..2a4b12c 100644=0D=0A--- a/daxctl/json.c=0D=0A+++ b/daxctl/json.c=0D=0A=
@@ -48,8 +48,19 @@ struct json_object *util_daxctl_dev_to_json(struct dax=
ctl_dev *dev,=0D=0A=20=0D=0A =09if (mem)=0D=0A =09=09jobj =3D json_object=
_new_string("system-ram");=0D=0A-=09else=0D=0A+=09else if (daxctl_dev_is_=
famfs_mode(dev))=0D=0A+=09=09jobj =3D json_object_new_string("famfs");=0D=
=0A+=09else if (daxctl_dev_is_devdax_mode(dev))=0D=0A =09=09jobj =3D json=
_object_new_string("devdax");=0D=0A+=09else {=0D=0A+=09=09/* Legacy condi=
tion; if a daxdev is not in any "mode", that=0D=0A+=09=09 * means no driv=
er is bound. We report that as a disabled=0D=0A+=09=09 * device in devdax=
 mode. (the disabled modifier is added later=0D=0A+=09=09 * in this funct=
ion if applicable)=0D=0A+=09=09 */=0D=0A+=09=09jobj =3D json_object_new_s=
tring("devdax");=0D=0A+=09}=0D=0A+=0D=0A =09if (jobj)=0D=0A =09=09json_ob=
ject_object_add(jdev, "mode", jobj);=0D=0A=20=0D=0Adiff --git a/daxctl/li=
b/libdaxctl-private.h b/daxctl/lib/libdaxctl-private.h=0D=0Aindex ae45311=
=2E.0bb73e8 100644=0D=0A--- a/daxctl/lib/libdaxctl-private.h=0D=0A+++ b/d=
axctl/lib/libdaxctl-private.h=0D=0A@@ -21,12 +21,14 @@ static const char =
*dax_subsystems[] =3D {=0D=0A enum daxctl_dev_mode {=0D=0A =09DAXCTL_DEV_=
MODE_DEVDAX =3D 0,=0D=0A =09DAXCTL_DEV_MODE_RAM,=0D=0A+=09DAXCTL_DEV_MODE=
_FAMFS,=0D=0A =09DAXCTL_DEV_MODE_END,=0D=0A };=0D=0A=20=0D=0A static cons=
t char *dax_modules[] =3D {=0D=0A =09[DAXCTL_DEV_MODE_DEVDAX] =3D "device=
_dax",=0D=0A =09[DAXCTL_DEV_MODE_RAM] =3D "kmem",=0D=0A+=09[DAXCTL_DEV_MO=
DE_FAMFS] =3D "fsdev_dax",=0D=0A };=0D=0A=20=0D=0A enum memory_op {=0D=0A=
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c=0D=0Aindex 0=
2ae7e5..33121dc 100644=0D=0A--- a/daxctl/lib/libdaxctl.c=0D=0A+++ b/daxct=
l/lib/libdaxctl.c=0D=0A@@ -385,13 +385,13 @@ static bool device_model_is_=
dax_bus(struct daxctl_dev *dev)=0D=0A =09return false;=0D=0A }=0D=0A=20=0D=
=0A-DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev =
*dev)=0D=0A+static int daxctl_dev_bound_to_module(struct daxctl_dev *dev,=
 const char *mod_name)=0D=0A {=0D=0A =09const char *devname =3D daxctl_de=
v_get_devname(dev);=0D=0A =09struct daxctl_ctx *ctx =3D daxctl_dev_get_ct=
x(dev);=0D=0A =09const char *mod_base;=0D=0A =09char *mod_path;=0D=0A-=09=
char path[200];=0D=0A+=09char path[PATH_MAX];=0D=0A =09const int len =3D =
sizeof(path);=0D=0A=20=0D=0A =09if (!device_model_is_dax_bus(dev))=0D=0A@=
@ -406,11 +406,13 @@ DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(s=
truct daxctl_dev *dev)=0D=0A =09}=0D=0A=20=0D=0A =09mod_path =3D realpath=
(path, NULL);=0D=0A-=09if (!mod_path)=0D=0A+=09if (!mod_path) {=0D=0A+=09=
=09dbg(ctx, "%s: realpath failed for driver link\n", devname);=0D=0A =09=09=
return false;=0D=0A+=09}=0D=0A=20=0D=0A =09mod_base =3D path_basename(mod=
_path);=0D=0A-=09if (strcmp(mod_base, dax_modules[DAXCTL_DEV_MODE_RAM]) =3D=
=3D 0) {=0D=0A+=09if (strcmp(mod_base, mod_name) =3D=3D 0) {=0D=0A =09=09=
free(mod_path);=0D=0A =09=09return true;=0D=0A =09}=0D=0A@@ -419,6 +421,3=
0 @@ DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev=
 *dev)=0D=0A =09return false;=0D=0A }=0D=0A=20=0D=0A+DAXCTL_EXPORT int da=
xctl_dev_is_system_ram_capable(struct daxctl_dev *dev)=0D=0A+{=0D=0A+=09r=
eturn daxctl_dev_bound_to_module(dev, dax_modules[DAXCTL_DEV_MODE_RAM]);=0D=
=0A+}=0D=0A+=0D=0A+/*=0D=0A+ * Check if device is currently in famfs mode=
 (bound to fsdev_dax driver).=0D=0A+ * Returns false for disabled devices=
: the DAX bus does not retain the previous=0D=0A+ * driver binding after =
unbind, so mode cannot be determined without a driver.=0D=0A+ */=0D=0A+DA=
XCTL_EXPORT int daxctl_dev_is_famfs_mode(struct daxctl_dev *dev)=0D=0A+{=0D=
=0A+=09return daxctl_dev_bound_to_module(dev, dax_modules[DAXCTL_DEV_MODE=
_FAMFS]);=0D=0A+}=0D=0A+=0D=0A+/*=0D=0A+ * Check if device is currently i=
n devdax mode (bound to device_dax driver).=0D=0A+ * Returns false for di=
sabled devices; see daxctl_dev_is_famfs_mode().=0D=0A+ */=0D=0A+DAXCTL_EX=
PORT int daxctl_dev_is_devdax_mode(struct daxctl_dev *dev)=0D=0A+{=0D=0A+=
=09return daxctl_dev_bound_to_module(dev, dax_modules[DAXCTL_DEV_MODE_DEV=
DAX]);=0D=0A+}=0D=0A+=0D=0A /*=0D=0A  * This checks for the device to be =
in system-ram mode, so calling=0D=0A  * daxctl_dev_get_memory() on a devd=
ax mode device will always return NULL.=0D=0A@@ -983,6 +1009,11 @@ DAXCTL=
_EXPORT int daxctl_dev_enable_ram(struct daxctl_dev *dev)=0D=0A =09return=
 daxctl_dev_enable(dev, DAXCTL_DEV_MODE_RAM);=0D=0A }=0D=0A=20=0D=0A+DAXC=
TL_EXPORT int daxctl_dev_enable_famfs(struct daxctl_dev *dev)=0D=0A+{=0D=0A=
+=09return daxctl_dev_enable(dev, DAXCTL_DEV_MODE_FAMFS);=0D=0A+}=0D=0A+=0D=
=0A DAXCTL_EXPORT int daxctl_dev_disable(struct daxctl_dev *dev)=0D=0A {=0D=
=0A =09const char *devname =3D daxctl_dev_get_devname(dev);=0D=0Adiff --g=
it a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym=0D=0Aindex 30988=
11..2a812c6 100644=0D=0A--- a/daxctl/lib/libdaxctl.sym=0D=0A+++ b/daxctl/=
lib/libdaxctl.sym=0D=0A@@ -104,3 +104,10 @@ LIBDAXCTL_10 {=0D=0A global:=0D=
=0A =09daxctl_dev_is_system_ram_capable;=0D=0A } LIBDAXCTL_9;=0D=0A+=0D=0A=
+LIBDAXCTL_11 {=0D=0A+global:=0D=0A+=09daxctl_dev_enable_famfs;=0D=0A+=09=
daxctl_dev_is_famfs_mode;=0D=0A+=09daxctl_dev_is_devdax_mode;=0D=0A+} LIB=
DAXCTL_10;=0D=0Adiff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h=0D=0A=
index 53c6bbd..84fcdb4 100644=0D=0A--- a/daxctl/libdaxctl.h=0D=0A+++ b/da=
xctl/libdaxctl.h=0D=0A@@ -72,12 +72,15 @@ int daxctl_dev_is_enabled(struc=
t daxctl_dev *dev);=0D=0A int daxctl_dev_disable(struct daxctl_dev *dev);=
=0D=0A int daxctl_dev_enable_devdax(struct daxctl_dev *dev);=0D=0A int da=
xctl_dev_enable_ram(struct daxctl_dev *dev);=0D=0A+int daxctl_dev_enable_=
famfs(struct daxctl_dev *dev);=0D=0A int daxctl_dev_get_target_node(struc=
t daxctl_dev *dev);=0D=0A int daxctl_dev_will_auto_online_memory(struct d=
axctl_dev *dev);=0D=0A int daxctl_dev_has_online_memory(struct daxctl_dev=
 *dev);=0D=0A=20=0D=0A struct daxctl_memory;=0D=0A int daxctl_dev_is_syst=
em_ram_capable(struct daxctl_dev *dev);=0D=0A+int daxctl_dev_is_famfs_mod=
e(struct daxctl_dev *dev);=0D=0A+int daxctl_dev_is_devdax_mode(struct dax=
ctl_dev *dev);=0D=0A struct daxctl_memory *daxctl_dev_get_memory(struct d=
axctl_dev *dev);=0D=0A struct daxctl_dev *daxctl_memory_get_dev(struct da=
xctl_memory *mem);=0D=0A const char *daxctl_memory_get_node_path(struct d=
axctl_memory *mem);=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
