Received: from a11-17.smtp-out.amazonses.com (a11-17.smtp-out.amazonses.com [54.240.11.17])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676C3401A32
	for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 17:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779814954; cv=none; b=UvN2lpmiZTrW8LriBGyQ3kBpEs0FpIOaU5XakWidtmKZ3j/W7EA/+qiVJr7UGlaLR55tfDlB3tQlk36l9r3pIp0U7gZD1mxx/bmIUQaN97/yH7PiguSRk7IDJEGPvam/+Gb0K0BwADldN4ptbQ3bb4FAZz6sA6Jy/vhZxWYZhzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779814954; c=relaxed/simple;
	bh=7hye6rml7iBNe1zgxSQ48MDdzPeVNp6FlIRsVYvHLN8=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=NTO27HGHEmRManxdjnRq7ixN/iP9HRftPqpxXxEKV5kkwc+ssnz5iYSObnbUdJ1QVFFwl0QGJ7X9HZY7fJvq4vWuxrvdYOYtx14bawwsMBHpdqgthxDcxRYKpcL9BX1pORKZqq+prVHclEUNWryHxixhO8prRCFiaDbW4E/RJjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=irIStiMM; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=UgqkHcOQ; arc=none smtp.client-ip=54.240.11.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="irIStiMM";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="UgqkHcOQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779814951;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=7hye6rml7iBNe1zgxSQ48MDdzPeVNp6FlIRsVYvHLN8=;
	b=irIStiMMn9itfhi3PI6cqmDYTIJVt03pJYOp09o1ptJAp8vqk8p130fqJuzDJrpp
	J4Q7DO8i14b57nZ1AcygLbQigmuOgjTM075A/8jSw0BV9Kn6+hhi4Jjw7HocBrRGiq7
	Lt+dkNXYl5SQMxS3caAZUm6D90lRAoL2N9/hG7jc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779814951;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=7hye6rml7iBNe1zgxSQ48MDdzPeVNp6FlIRsVYvHLN8=;
	b=UgqkHcOQ7EB7PfdTc+gJxJpSSeC63xdNE1F5Il9O5ou+BVCQYWGqZrPkRhLD95UY
	SXQ3OzwLUQtORu4cwOCpEBWwGT/uENce8VyW2gYSxyrOToQNS5cFsNgtzu51GacZohL
	JSInSB+00TLsull8/eEgz9Ov4tycgzySXcHkyaFE=
Subject: [PATCH V6 1/2] daxctl: Add support for famfs mode
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
Date: Tue, 26 May 2026 17:02:31 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019e653c6c88-44f88088-8c87-4163-b88b-b3f3fc7aa726-000000@email.amazonses.com>
References: 
 <0100019e653c6c88-44f88088-8c87-4163-b88b-b3f3fc7aa726-000000@email.amazonses.com> 
 <20260526170224.56416-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc7TFcILV7h5r+TK67r8Gpp/8CFwAABOB9
Thread-Topic: [PATCH V6 1/2] daxctl: Add support for famfs mode
X-Wm-Sent-Timestamp: 1779814950
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e653ce9c6-c242810e-9298-4ae0-b215-c1ec728755bd-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.26-54.240.11.17

From: John Groves <John@Groves.net>=0D=0A=0D=0Afamfs is a shared, memory-=
mappable filesystem for disaggregated and=0D=0Afabric-attached memory suc=
h as CXL. Files map directly to dax memory=0D=0Awithout page-cache buffer=
ing, which lets multiple hosts share the same=0D=0Amemory through per-hos=
t file mappings. See https://famfs.org for more=0D=0Ainformation.=0D=0A=0D=
=0APutting a daxdev in famfs mode means binding it to fsdev_dax.ko=0D=0A(=
drivers/dax/fsdev.c). Finding a daxdev bound to fsdev_dax means=0D=0Ait i=
s in famfs mode.=0D=0A=0D=0AA test for this functionality is added in the=
 next commit.=0D=0A=0D=0AWith devdax, famfs, and system-ram modes, the pr=
evious logic that assumed=0D=0A'not in mode X means in mode Y' needed to =
get slightly more complicated.=0D=0A=0D=0AAdd explicit mode detection to =
libdaxctl:=0D=0A- daxctl_dev_is_famfs_mode(): check if bound to the fsdev=
_dax driver=0D=0A- daxctl_dev_is_devdax_mode(): check if bound to the dev=
ice_dax driver=0D=0A- daxctl_dev_is_system_ram_mode(): check if bound to =
the kmem driver=0D=0AAll three delegate to a shared static helper daxctl_=
dev_bound_to_module()=0D=0Ato avoid duplicating the driver-symlink lookup=
=2E=0D=0Adaxctl_dev_is_system_ram_mode() is the consistent name for the p=
re-existing=0D=0Adaxctl_dev_is_system_ram_capable(), which becomes a thin=
 compatibility=0D=0Awrapper so the existing ABI is preserved.=0D=0A=0D=0A=
Add daxctl_dev_get_mode(), which reports the current mode of a device=0D=0A=
(system-ram, devdax, famfs, or unknown) so callers can dispatch on a=0D=0A=
single value rather than chaining the predicates above. enum=0D=0Adaxctl_=
dev_mode moves to the public header and gains a=0D=0ADAXCTL_DEV_MODE_UNKN=
OWN sentinel, and daxctl_dev_get_mode() is exported.=0D=0A=0D=0AUpdate mo=
de transition logic in device.c:=0D=0A- the reconfig_mode_*() functions s=
witch on daxctl_dev_get_mode() rather=0D=0A  than repeating an if-else mo=
de chain=0D=0A- disable_devdax_device() and disable_famfs_device() collap=
se into a=0D=0A  single disable_mode_device(); the caller has already mat=
ched the mode=0D=0A- rename the local 'enum dev_mode' to 'enum reconfig_m=
ode' (RECONFIG_MODE_*)=0D=0A  so it no longer shares member names with en=
um daxctl_dev_mode=0D=0A- handle an unrecognized mode with an error inste=
ad of a wrong assumption=0D=0A=0D=0AWhile here, fix daxctl_dev_enable() t=
o range-check mode before using it to=0D=0Aindex the dax_modules[] array:=
 the mod_name lookup previously happened=0D=0Abefore the bounds check, al=
lowing an out-of-bounds read for a negative or=0D=0Aout-of-range mode. Th=
e lookup now runs only after mode is validated.=0D=0A=0D=0AUpdate json.c =
to report fsdev_dax-bound devices as 'famfs' mode. An=0D=0Aunbound device=
 continues to be reported as 'devdax' (the legacy default=0D=0Awhen no dr=
iver is bound), to preserve existing behavior.=0D=0A=0D=0ADocument the fa=
mfs mode in=0D=0ADocumentation/daxctl/daxctl-reconfigure-device.txt.=0D=0A=
=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A .../dax=
ctl/daxctl-reconfigure-device.txt      |  22 +++-=0D=0A daxctl/device.c  =
                             | 113 +++++++++++++-----=0D=0A daxctl/json.c=
                                 |  18 ++-=0D=0A daxctl/lib/libdaxctl-pri=
vate.h                |   9 +-=0D=0A daxctl/lib/libdaxctl.c              =
          |  73 +++++++++--=0D=0A daxctl/lib/libdaxctl.sym               =
       |   9 ++=0D=0A daxctl/libdaxctl.h                            |  14=
 +++=0D=0A 7 files changed, 215 insertions(+), 43 deletions(-)=0D=0A=0D=0A=
diff --git a/Documentation/daxctl/daxctl-reconfigure-device.txt b/Documen=
tation/daxctl/daxctl-reconfigure-device.txt=0D=0Aindex 09691d2..9c3922d 1=
00644=0D=0A--- a/Documentation/daxctl/daxctl-reconfigure-device.txt=0D=0A=
+++ b/Documentation/daxctl/daxctl-reconfigure-device.txt=0D=0A@@ -17,7 +1=
7,9 @@ DESCRIPTION=0D=0A=20=0D=0A Reconfigure the operational mode of a d=
ax device. This can be used to convert=0D=0A a regular 'devdax' mode devi=
ce to the 'system-ram' mode which arranges for the=0D=0A-dax range to be =
hot-plugged into the system as regular memory.=0D=0A+dax range to be hot-=
plugged into the system as regular memory. A 'devdax' mode=0D=0A+device c=
an also be converted to 'famfs' mode, which binds it to the fsdev_dax=0D=0A=
+driver for use by the famfs shared-memory filesystem (see https://famfs.=
org).=0D=0A=20=0D=0A NOTE: This is a destructive operation. Any data on t=
he dax device *will* be=0D=0A lost.=0D=0A@@ -127,6 +129,19 @@ EXAMPLES=0D=
=0A }=0D=0A ----=0D=0A=20=0D=0A+* Reconfigure dax0.0 (currently in devdax=
 mode) to famfs mode=0D=0A+----=0D=0A+# daxctl reconfigure-device --mode=3D=
famfs dax0.0=0D=0A+[=0D=0A+  {=0D=0A+    "chardev":"dax0.0",=0D=0A+    "s=
ize":16777216000,=0D=0A+    "target_node":2,=0D=0A+    "mode":"famfs"=0D=0A=
+  }=0D=0A+]=0D=0A+----=0D=0A+=0D=0A * Reconfigure all dax devices on reg=
ion0 to system-ram mode=0D=0A ----=0D=0A # daxctl reconfigure-device --mo=
de=3Dsystem-ram --region=3D0 all=0D=0A@@ -205,6 +220,11 @@ include::regio=
n-option.txt[]=0D=0A =09  kernel to support hot-unplugging 'kmem' based m=
emory. If this is not=0D=0A =09  available, a reboot is the only way to s=
witch back to 'devdax' mode.=0D=0A=20=0D=0A+=09- "famfs": bind the device=
 to the fsdev_dax driver for use by the famfs=0D=0A+=09  shared-memory fi=
lesystem (https://famfs.org). The device must=0D=0A+=09  currently be in =
"devdax" mode; converting directly from "system-ram"=0D=0A+=09  is reject=
ed.=0D=0A+=0D=0A -N::=0D=0A --no-online::=0D=0A =09By default, memory sec=
tions provided by system-ram devices will be=0D=0Adiff --git a/daxctl/dev=
ice.c b/daxctl/device.c=0D=0Aindex a4e36b1..47942f1 100644=0D=0A--- a/dax=
ctl/device.c=0D=0A+++ b/daxctl/device.c=0D=0A@@ -38,17 +38,18 @@ static s=
truct {=0D=0A =09bool verbose;=0D=0A } param;=0D=0A=20=0D=0A-enum dev_mod=
e {=0D=0A-=09DAXCTL_DEV_MODE_UNKNOWN,=0D=0A-=09DAXCTL_DEV_MODE_DEVDAX,=0D=
=0A-=09DAXCTL_DEV_MODE_RAM,=0D=0A+enum reconfig_mode {=0D=0A+=09RECONFIG_=
MODE_UNKNOWN,=0D=0A+=09RECONFIG_MODE_DEVDAX,=0D=0A+=09RECONFIG_MODE_RAM,=0D=
=0A+=09RECONFIG_MODE_FAMFS,=0D=0A };=0D=0A=20=0D=0A struct mapping {=0D=0A=
 =09unsigned long long start, end, pgoff;=0D=0A };=0D=0A=20=0D=0A-static =
enum dev_mode reconfig_mode =3D DAXCTL_DEV_MODE_UNKNOWN;=0D=0A+static enu=
m reconfig_mode reconfig_mode =3D RECONFIG_MODE_UNKNOWN;=0D=0A static lon=
g long align =3D -1;=0D=0A static long long size =3D -1;=0D=0A static uns=
igned long flags;=0D=0A@@ -463,13 +464,20 @@ static const char *parse_dev=
ice_options(int argc, const char **argv,=0D=0A =09=09=09if (param.align)=0D=
=0A =09=09=09=09align =3D __parse_size64(param.align, &units);=0D=0A =09=09=
} else if (strcmp(param.mode, "system-ram") =3D=3D 0) {=0D=0A-=09=09=09re=
config_mode =3D DAXCTL_DEV_MODE_RAM;=0D=0A+=09=09=09reconfig_mode =3D REC=
ONFIG_MODE_RAM;=0D=0A =09=09} else if (strcmp(param.mode, "devdax") =3D=3D=
 0) {=0D=0A-=09=09=09reconfig_mode =3D DAXCTL_DEV_MODE_DEVDAX;=0D=0A+=09=09=
=09reconfig_mode =3D RECONFIG_MODE_DEVDAX;=0D=0A =09=09=09if (param.no_on=
line) {=0D=0A =09=09=09=09fprintf(stderr,=0D=0A =09=09=09=09=09"--no-onli=
ne is incompatible with --mode=3Ddevdax\n");=0D=0A-=09=09=09=09rc =3D  -E=
INVAL;=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09}=0D=0A+=09=09} e=
lse if (strcmp(param.mode, "famfs") =3D=3D 0) {=0D=0A+=09=09=09reconfig_m=
ode =3D RECONFIG_MODE_FAMFS;=0D=0A+=09=09=09if (param.no_online) {=0D=0A+=
=09=09=09=09fprintf(stderr,=0D=0A+=09=09=09=09=09"--no-online is incompat=
ible with --mode=3Dfamfs\n");=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A =09=
=09=09}=0D=0A =09=09}=0D=0A =09=09break;=0D=0A@@ -689,17 +697,10 @@ stati=
c int dev_destroy(struct daxctl_dev *dev)=0D=0A =09return 0;=0D=0A }=0D=0A=
=20=0D=0A-static int disable_devdax_device(struct daxctl_dev *dev)=0D=0A+=
static int disable_mode_device(struct daxctl_dev *dev)=0D=0A {=0D=0A-=09s=
truct daxctl_memory *mem =3D daxctl_dev_get_memory(dev);=0D=0A-=09const c=
har *devname =3D daxctl_dev_get_devname(dev);=0D=0A =09int rc;=0D=0A=20=0D=
=0A-=09if (mem) {=0D=0A-=09=09fprintf(stderr, "%s was already in system-r=
am mode\n",=0D=0A-=09=09=09devname);=0D=0A-=09=09return 1;=0D=0A-=09}=0D=0A=
 =09rc =3D daxctl_dev_disable(dev);=0D=0A =09if (rc) {=0D=0A =09=09fprint=
f(stderr, "%s: disable failed: %s\n",=0D=0A@@ -724,11 +725,21 @@ static i=
nt reconfig_mode_system_ram(struct daxctl_dev *dev)=0D=0A =09}=0D=0A=20=0D=
=0A =09if (daxctl_dev_is_enabled(dev)) {=0D=0A-=09=09rc =3D disable_devda=
x_device(dev);=0D=0A-=09=09if (rc < 0)=0D=0A-=09=09=09return rc;=0D=0A-=09=
=09if (rc > 0)=0D=0A+=09=09switch (daxctl_dev_get_mode(dev)) {=0D=0A+=09=09=
case DAXCTL_DEV_MODE_RAM:=0D=0A+=09=09=09/* already in system-ram mode */=
=0D=0A =09=09=09skip_enable =3D 1;=0D=0A+=09=09=09break;=0D=0A+=09=09case=
 DAXCTL_DEV_MODE_FAMFS:=0D=0A+=09=09case DAXCTL_DEV_MODE_DEVDAX:=0D=0A+=09=
=09=09rc =3D disable_mode_device(dev);=0D=0A+=09=09=09if (rc)=0D=0A+=09=09=
=09=09return rc;=0D=0A+=09=09=09break;=0D=0A+=09=09default:=0D=0A+=09=09=09=
fprintf(stderr, "%s: unknown mode\n", devname);=0D=0A+=09=09=09return -EI=
NVAL;=0D=0A+=09=09}=0D=0A =09}=0D=0A=20=0D=0A =09if (!skip_enable) {=0D=0A=
@@ -750,7 +761,7 @@ static int disable_system_ram_device(struct daxctl_de=
v *dev)=0D=0A =09int rc;=0D=0A=20=0D=0A =09if (!mem) {=0D=0A-=09=09fprint=
f(stderr, "%s was already in devdax mode\n", devname);=0D=0A+=09=09fprint=
f(stderr, "%s is not in system-ram mode\n", devname);=0D=0A =09=09return =
1;=0D=0A =09}=0D=0A=20=0D=0A@@ -786,12 +797,26 @@ static int disable_syst=
em_ram_device(struct daxctl_dev *dev)=0D=0A=20=0D=0A static int reconfig_=
mode_devdax(struct daxctl_dev *dev)=0D=0A {=0D=0A+=09const char *devname =
=3D daxctl_dev_get_devname(dev);=0D=0A =09int rc;=0D=0A=20=0D=0A =09if (d=
axctl_dev_is_enabled(dev)) {=0D=0A-=09=09rc =3D disable_system_ram_device=
(dev);=0D=0A-=09=09if (rc)=0D=0A-=09=09=09return rc;=0D=0A+=09=09switch (=
daxctl_dev_get_mode(dev)) {=0D=0A+=09=09case DAXCTL_DEV_MODE_RAM:=0D=0A+=09=
=09=09rc =3D disable_system_ram_device(dev);=0D=0A+=09=09=09if (rc)=0D=0A=
+=09=09=09=09return rc;=0D=0A+=09=09=09break;=0D=0A+=09=09case DAXCTL_DEV=
_MODE_FAMFS:=0D=0A+=09=09case DAXCTL_DEV_MODE_DEVDAX:=0D=0A+=09=09=09rc =3D=
 disable_mode_device(dev);=0D=0A+=09=09=09if (rc)=0D=0A+=09=09=09=09retur=
n rc;=0D=0A+=09=09=09break;=0D=0A+=09=09default:=0D=0A+=09=09=09fprintf(s=
tderr, "%s: unknown mode\n", devname);=0D=0A+=09=09=09return -EINVAL;=0D=0A=
+=09=09}=0D=0A =09}=0D=0A=20=0D=0A =09rc =3D daxctl_dev_enable_devdax(dev=
);=0D=0A@@ -801,6 +826,37 @@ static int reconfig_mode_devdax(struct daxct=
l_dev *dev)=0D=0A =09return 0;=0D=0A }=0D=0A=20=0D=0A+static int reconfig=
_mode_famfs(struct daxctl_dev *dev)=0D=0A+{=0D=0A+=09const char *devname =
=3D daxctl_dev_get_devname(dev);=0D=0A+=09int rc;=0D=0A+=0D=0A+=09if (dax=
ctl_dev_is_enabled(dev)) {=0D=0A+=09=09switch (daxctl_dev_get_mode(dev)) =
{=0D=0A+=09=09case DAXCTL_DEV_MODE_RAM:=0D=0A+=09=09=09fprintf(stderr,=0D=
=0A+=09=09=09=09"%s is in system-ram mode; must be in devdax mode to conv=
ert to famfs\n",=0D=0A+=09=09=09=09devname);=0D=0A+=09=09=09return -EINVA=
L;=0D=0A+=09=09case DAXCTL_DEV_MODE_FAMFS:=0D=0A+=09=09case DAXCTL_DEV_MO=
DE_DEVDAX:=0D=0A+=09=09=09rc =3D disable_mode_device(dev);=0D=0A+=09=09=09=
if (rc)=0D=0A+=09=09=09=09return rc;=0D=0A+=09=09=09break;=0D=0A+=09=09de=
fault:=0D=0A+=09=09=09fprintf(stderr, "%s: unknown mode\n", devname);=0D=0A=
+=09=09=09return -EINVAL;=0D=0A+=09=09}=0D=0A+=09}=0D=0A+=0D=0A+=09rc =3D=
 daxctl_dev_enable_famfs(dev);=0D=0A+=09if (rc)=0D=0A+=09=09return rc;=0D=
=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A static int do_create(struct =
daxctl_region *region, long long val,=0D=0A =09=09     struct json_object=
 **jdevs)=0D=0A {=0D=0A@@ -862,7 +918,7 @@ static int do_create(struct da=
xctl_region *region, long long val,=0D=0A =09return 0;=0D=0A }=0D=0A=20=0D=
=0A-static int do_reconfig(struct daxctl_dev *dev, enum dev_mode mode,=0D=
=0A+static int do_reconfig(struct daxctl_dev *dev, enum reconfig_mode mod=
e,=0D=0A =09=09struct json_object **jdevs)=0D=0A {=0D=0A =09const char *d=
evname =3D daxctl_dev_get_devname(dev);=0D=0A@@ -881,12 +937,15 @@ static=
 int do_reconfig(struct daxctl_dev *dev, enum dev_mode mode,=0D=0A =09}=0D=
=0A=20=0D=0A =09switch (mode) {=0D=0A-=09case DAXCTL_DEV_MODE_RAM:=0D=0A+=
=09case RECONFIG_MODE_RAM:=0D=0A =09=09rc =3D reconfig_mode_system_ram(de=
v);=0D=0A =09=09break;=0D=0A-=09case DAXCTL_DEV_MODE_DEVDAX:=0D=0A+=09cas=
e RECONFIG_MODE_DEVDAX:=0D=0A =09=09rc =3D reconfig_mode_devdax(dev);=0D=0A=
 =09=09break;=0D=0A+=09case RECONFIG_MODE_FAMFS:=0D=0A+=09=09rc =3D recon=
fig_mode_famfs(dev);=0D=0A+=09=09break;=0D=0A =09default:=0D=0A =09=09fpr=
intf(stderr, "%s: unknown mode requested: %d\n",=0D=0A =09=09=09devname, =
mode);=0D=0Adiff --git a/daxctl/json.c b/daxctl/json.c=0D=0Aindex 3cbce9d=
=2E.8da91b1 100644=0D=0A--- a/daxctl/json.c=0D=0A+++ b/daxctl/json.c=0D=0A=
@@ -46,10 +46,24 @@ struct json_object *util_daxctl_dev_to_json(struct da=
xctl_dev *dev,=0D=0A =09=09=09json_object_object_add(jdev, "align", jobj)=
;=0D=0A =09}=0D=0A=20=0D=0A-=09if (mem)=0D=0A+=09switch (daxctl_dev_get_m=
ode(dev)) {=0D=0A+=09case DAXCTL_DEV_MODE_RAM:=0D=0A =09=09jobj =3D json_=
object_new_string("system-ram");=0D=0A-=09else=0D=0A+=09=09break;=0D=0A+=09=
case DAXCTL_DEV_MODE_FAMFS:=0D=0A+=09=09jobj =3D json_object_new_string("=
famfs");=0D=0A+=09=09break;=0D=0A+=09case DAXCTL_DEV_MODE_DEVDAX:=0D=0A+=09=
default:=0D=0A+=09=09/* A device bound to device_dax is in devdax mode. A=
 device with=0D=0A+=09=09 * no driver bound (DAXCTL_DEV_MODE_UNKNOWN) is =
reported as devdax=0D=0A+=09=09 * too, the legacy default (the disabled m=
odifier is added later=0D=0A+=09=09 * in this function if applicable).=0D=
=0A+=09=09 */=0D=0A =09=09jobj =3D json_object_new_string("devdax");=0D=0A=
+=09=09break;=0D=0A+=09}=0D=0A+=0D=0A =09if (jobj)=0D=0A =09=09json_objec=
t_object_add(jdev, "mode", jobj);=0D=0A=20=0D=0Adiff --git a/daxctl/lib/l=
ibdaxctl-private.h b/daxctl/lib/libdaxctl-private.h=0D=0Aindex ae45311..b=
902e3d 100644=0D=0A--- a/daxctl/lib/libdaxctl-private.h=0D=0A+++ b/daxctl=
/lib/libdaxctl-private.h=0D=0A@@ -5,6 +5,8 @@=0D=0A=20=0D=0A #include <li=
bkmod.h>=0D=0A=20=0D=0A+#include <daxctl/libdaxctl.h>=0D=0A+=0D=0A #defin=
e DAXCTL_EXPORT __attribute__ ((visibility("default")))=0D=0A=20=0D=0A en=
um dax_subsystem {=0D=0A@@ -18,15 +20,10 @@ static const char *dax_subsys=
tems[] =3D {=0D=0A =09[DAX_BUS] =3D "/sys/bus/dax/devices",=0D=0A };=0D=0A=
=20=0D=0A-enum daxctl_dev_mode {=0D=0A-=09DAXCTL_DEV_MODE_DEVDAX =3D 0,=0D=
=0A-=09DAXCTL_DEV_MODE_RAM,=0D=0A-=09DAXCTL_DEV_MODE_END,=0D=0A-};=0D=0A-=
=0D=0A static const char *dax_modules[] =3D {=0D=0A =09[DAXCTL_DEV_MODE_D=
EVDAX] =3D "device_dax",=0D=0A =09[DAXCTL_DEV_MODE_RAM] =3D "kmem",=0D=0A=
+=09[DAXCTL_DEV_MODE_FAMFS] =3D "fsdev_dax",=0D=0A };=0D=0A=20=0D=0A enum=
 memory_op {=0D=0Adiff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdax=
ctl.c=0D=0Aindex 02ae7e5..01b1915 100644=0D=0A--- a/daxctl/lib/libdaxctl.=
c=0D=0A+++ b/daxctl/lib/libdaxctl.c=0D=0A@@ -385,13 +385,19 @@ static boo=
l device_model_is_dax_bus(struct daxctl_dev *dev)=0D=0A =09return false;=0D=
=0A }=0D=0A=20=0D=0A-DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(s=
truct daxctl_dev *dev)=0D=0A+/*=0D=0A+ * Test whether @dev is bound to th=
e driver named @mod_name. Returns false for=0D=0A+ * a disabled (unbound)=
 device: the DAX bus does not retain the previous driver=0D=0A+ * binding=
 after unbind, so a device's mode cannot be determined without a=0D=0A+ *=
 bound driver.=0D=0A+ */=0D=0A+static int daxctl_dev_bound_to_module(stru=
ct daxctl_dev *dev, const char *mod_name)=0D=0A {=0D=0A =09const char *de=
vname =3D daxctl_dev_get_devname(dev);=0D=0A =09struct daxctl_ctx *ctx =3D=
 daxctl_dev_get_ctx(dev);=0D=0A =09const char *mod_base;=0D=0A =09char *m=
od_path;=0D=0A-=09char path[200];=0D=0A+=09char path[PATH_MAX];=0D=0A =09=
const int len =3D sizeof(path);=0D=0A=20=0D=0A =09if (!device_model_is_da=
x_bus(dev))=0D=0A@@ -406,11 +412,13 @@ DAXCTL_EXPORT int daxctl_dev_is_sy=
stem_ram_capable(struct daxctl_dev *dev)=0D=0A =09}=0D=0A=20=0D=0A =09mod=
_path =3D realpath(path, NULL);=0D=0A-=09if (!mod_path)=0D=0A+=09if (!mod=
_path) {=0D=0A+=09=09dbg(ctx, "%s: realpath failed for driver link\n", de=
vname);=0D=0A =09=09return false;=0D=0A+=09}=0D=0A=20=0D=0A =09mod_base =3D=
 path_basename(mod_path);=0D=0A-=09if (strcmp(mod_base, dax_modules[DAXCT=
L_DEV_MODE_RAM]) =3D=3D 0) {=0D=0A+=09if (strcmp(mod_base, mod_name) =3D=3D=
 0) {=0D=0A =09=09free(mod_path);=0D=0A =09=09return true;=0D=0A =09}=0D=0A=
@@ -419,6 +427,46 @@ DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(s=
truct daxctl_dev *dev)=0D=0A =09return false;=0D=0A }=0D=0A=20=0D=0A+DAXC=
TL_EXPORT int daxctl_dev_is_system_ram_mode(struct daxctl_dev *dev)=0D=0A=
+{=0D=0A+=09return daxctl_dev_bound_to_module(dev, dax_modules[DAXCTL_DEV=
_MODE_RAM]);=0D=0A+}=0D=0A+=0D=0A+/*=0D=0A+ * Compatibility alias for dax=
ctl_dev_is_system_ram_mode(), retained as part of=0D=0A+ * the public ABI=
 (LIBDAXCTL_10). Despite the name it tests the current driver=0D=0A+ * bi=
nding, not a capability.=0D=0A+ */=0D=0A+DAXCTL_EXPORT int daxctl_dev_is_=
system_ram_capable(struct daxctl_dev *dev)=0D=0A+{=0D=0A+=09return daxctl=
_dev_is_system_ram_mode(dev);=0D=0A+}=0D=0A+=0D=0A+DAXCTL_EXPORT int daxc=
tl_dev_is_famfs_mode(struct daxctl_dev *dev)=0D=0A+{=0D=0A+=09return daxc=
tl_dev_bound_to_module(dev, dax_modules[DAXCTL_DEV_MODE_FAMFS]);=0D=0A+}=0D=
=0A+=0D=0A+DAXCTL_EXPORT int daxctl_dev_is_devdax_mode(struct daxctl_dev =
*dev)=0D=0A+{=0D=0A+=09return daxctl_dev_bound_to_module(dev, dax_modules=
[DAXCTL_DEV_MODE_DEVDAX]);=0D=0A+}=0D=0A+=0D=0A+/*=0D=0A+ * Report the cu=
rrent mode of a device, determined from its bound driver.=0D=0A+ * A devi=
ce with no driver bound returns DAXCTL_DEV_MODE_UNKNOWN.=0D=0A+ */=0D=0A+=
DAXCTL_EXPORT enum daxctl_dev_mode daxctl_dev_get_mode(struct daxctl_dev =
*dev)=0D=0A+{=0D=0A+=09if (daxctl_dev_is_system_ram_mode(dev))=0D=0A+=09=09=
return DAXCTL_DEV_MODE_RAM;=0D=0A+=09if (daxctl_dev_is_famfs_mode(dev))=0D=
=0A+=09=09return DAXCTL_DEV_MODE_FAMFS;=0D=0A+=09if (daxctl_dev_is_devdax=
_mode(dev))=0D=0A+=09=09return DAXCTL_DEV_MODE_DEVDAX;=0D=0A+=09return DA=
XCTL_DEV_MODE_UNKNOWN;=0D=0A+}=0D=0A+=0D=0A /*=0D=0A  * This checks for t=
he device to be in system-ram mode, so calling=0D=0A  * daxctl_dev_get_me=
mory() on a devdax mode device will always return NULL.=0D=0A@@ -433,7 +4=
81,7 @@ static struct daxctl_memory *daxctl_dev_alloc_mem(struct daxctl_d=
ev *dev)=0D=0A =09char buf[SYSFS_ATTR_SIZE];=0D=0A =09int node_num;=0D=0A=
=20=0D=0A-=09if (!daxctl_dev_is_system_ram_capable(dev))=0D=0A+=09if (!da=
xctl_dev_is_system_ram_mode(dev))=0D=0A =09=09return NULL;=0D=0A=20=0D=0A=
 =09mem =3D calloc(1, sizeof(*mem));=0D=0A@@ -939,7 +987,7 @@ static int =
daxctl_dev_enable(struct daxctl_dev *dev, enum daxctl_dev_mode mode)=0D=0A=
 =09struct daxctl_region *region =3D daxctl_dev_get_region(dev);=0D=0A =09=
const char *devname =3D daxctl_dev_get_devname(dev);=0D=0A =09struct daxc=
tl_ctx *ctx =3D daxctl_dev_get_ctx(dev);=0D=0A-=09const char *mod_name =3D=
 dax_modules[mode];=0D=0A+=09const char *mod_name;=0D=0A =09int rc;=0D=0A=
=20=0D=0A =09if (!device_model_is_dax_bus(dev)) {=0D=0A@@ -951,7 +999,13 =
@@ static int daxctl_dev_enable(struct daxctl_dev *dev, enum daxctl_dev_m=
ode mode)=0D=0A =09if (daxctl_dev_is_enabled(dev))=0D=0A =09=09return 0;=0D=
=0A=20=0D=0A-=09if (mode >=3D DAXCTL_DEV_MODE_END || mod_name =3D=3D NULL=
) {=0D=0A+=09if (mode < 0 || mode >=3D DAXCTL_DEV_MODE_END) {=0D=0A+=09=09=
err(ctx, "%s: Invalid mode: %d\n", devname, mode);=0D=0A+=09=09return -EI=
NVAL;=0D=0A+=09}=0D=0A+=0D=0A+=09mod_name =3D dax_modules[mode];=0D=0A+=09=
if (mod_name =3D=3D NULL) {=0D=0A =09=09err(ctx, "%s: Invalid mode: %d\n"=
, devname, mode);=0D=0A =09=09return -EINVAL;=0D=0A =09}=0D=0A@@ -983,6 +=
1037,11 @@ DAXCTL_EXPORT int daxctl_dev_enable_ram(struct daxctl_dev *dev=
)=0D=0A =09return daxctl_dev_enable(dev, DAXCTL_DEV_MODE_RAM);=0D=0A }=0D=
=0A=20=0D=0A+DAXCTL_EXPORT int daxctl_dev_enable_famfs(struct daxctl_dev =
*dev)=0D=0A+{=0D=0A+=09return daxctl_dev_enable(dev, DAXCTL_DEV_MODE_FAMF=
S);=0D=0A+}=0D=0A+=0D=0A DAXCTL_EXPORT int daxctl_dev_disable(struct daxc=
tl_dev *dev)=0D=0A {=0D=0A =09const char *devname =3D daxctl_dev_get_devn=
ame(dev);=0D=0Adiff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxc=
tl.sym=0D=0Aindex 3098811..43dd60b 100644=0D=0A--- a/daxctl/lib/libdaxctl=
=2Esym=0D=0A+++ b/daxctl/lib/libdaxctl.sym=0D=0A@@ -104,3 +104,12 @@ LIBD=
AXCTL_10 {=0D=0A global:=0D=0A =09daxctl_dev_is_system_ram_capable;=0D=0A=
 } LIBDAXCTL_9;=0D=0A+=0D=0A+LIBDAXCTL_11 {=0D=0A+global:=0D=0A+=09daxctl=
_dev_enable_famfs;=0D=0A+=09daxctl_dev_is_famfs_mode;=0D=0A+=09daxctl_dev=
_is_devdax_mode;=0D=0A+=09daxctl_dev_get_mode;=0D=0A+=09daxctl_dev_is_sys=
tem_ram_mode;=0D=0A+} LIBDAXCTL_10;=0D=0Adiff --git a/daxctl/libdaxctl.h =
b/daxctl/libdaxctl.h=0D=0Aindex 53c6bbd..7ec159e 100644=0D=0A--- a/daxctl=
/libdaxctl.h=0D=0A+++ b/daxctl/libdaxctl.h=0D=0A@@ -72,12 +72,26 @@ int d=
axctl_dev_is_enabled(struct daxctl_dev *dev);=0D=0A int daxctl_dev_disabl=
e(struct daxctl_dev *dev);=0D=0A int daxctl_dev_enable_devdax(struct daxc=
tl_dev *dev);=0D=0A int daxctl_dev_enable_ram(struct daxctl_dev *dev);=0D=
=0A+int daxctl_dev_enable_famfs(struct daxctl_dev *dev);=0D=0A int daxctl=
_dev_get_target_node(struct daxctl_dev *dev);=0D=0A int daxctl_dev_will_a=
uto_online_memory(struct daxctl_dev *dev);=0D=0A int daxctl_dev_has_onlin=
e_memory(struct daxctl_dev *dev);=0D=0A=20=0D=0A struct daxctl_memory;=0D=
=0A+=0D=0A+enum daxctl_dev_mode {=0D=0A+=09DAXCTL_DEV_MODE_UNKNOWN =3D -1=
,=0D=0A+=09DAXCTL_DEV_MODE_DEVDAX =3D 0,=0D=0A+=09DAXCTL_DEV_MODE_RAM,=0D=
=0A+=09DAXCTL_DEV_MODE_FAMFS,=0D=0A+=09DAXCTL_DEV_MODE_END,=0D=0A+};=0D=0A=
+=0D=0A+int daxctl_dev_is_system_ram_mode(struct daxctl_dev *dev);=0D=0A =
int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev);=0D=0A+int d=
axctl_dev_is_famfs_mode(struct daxctl_dev *dev);=0D=0A+int daxctl_dev_is_=
devdax_mode(struct daxctl_dev *dev);=0D=0A+enum daxctl_dev_mode daxctl_de=
v_get_mode(struct daxctl_dev *dev);=0D=0A struct daxctl_memory *daxctl_de=
v_get_memory(struct daxctl_dev *dev);=0D=0A struct daxctl_dev *daxctl_mem=
ory_get_dev(struct daxctl_memory *mem);=0D=0A const char *daxctl_memory_g=
et_node_path(struct daxctl_memory *mem);=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A=
